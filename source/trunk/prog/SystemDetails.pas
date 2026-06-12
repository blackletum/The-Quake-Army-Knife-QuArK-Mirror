(**************************************************************************
QuArK -- Quake Army Knife -- 3D game editor
Copyright (C) QuArK Development Team

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

https://quark.sourceforge.io/ - Contact information in AUTHORS.TXT
**************************************************************************)
unit SystemDetails;

{.$DEFINE MeasureCPUFrequency} //This seems like an awful waste of CPU cycles!
{.$DEFINE LogSensitiveInformation} //Decker: we're not interested in Machine-/Username. We're not Login-Crackers!
{$DEFINE CPUNameLookup}
{$DEFINE DetectWine}
{$DEFINE DetectReactOS}

 {-------------------}

{$INCLUDE DelphiCompat.inc}

interface

uses DelphiCompat, SysUtils, StrUtils, Windows, Classes;

procedure LogSystemDetails;
procedure WarnDriverBugs;

type
  TPlatformType = (osWin95Comp, osWinNTComp);

function GetPlatformType: TPlatformType;
function CheckWindows98And2000: Boolean;
function CheckWindowsMEAnd2000: Boolean;

implementation

uses Math, Forms, DateUtils, {$IFDEF CompiledWithDelphi2}ShellObj, OLE2, {$ELSE}ShlObj, ActiveX, {$ENDIF}
  ComCtrls, Registry, Registry2, Logging, QkExceptions, QConsts, Platform;

type
  TDelphi = class(TPersistent)
  private
    FCompiler: String;
    FCompileDate: TDateTime;
    FEndianess: TEndian;
    FCompilerVersionMajor, FCompilerVersionMinor: Byte;
    FRTLVersionMajor, FRTLVersionMinor: Byte;
    FTrialEdition: Boolean;
  public
    procedure GetInfo;
    procedure Report(var sl: TStringList);
  published
    property Compiler: String read FCompiler stored false;
    property CompileDate: TDateTime read FCompileDate stored false;
    property Endianess: TEndian read FEndianess stored false;
    property CompilerVersionMajor: Byte read FCompilerVersionMajor stored false;
    property CompilerVersionMinor: Byte read FCompilerVersionMinor stored false;
    property RTLVersionMajor: Byte read FRTLVersionMajor stored false;
    property RTLVersionMinor: Byte read FRTLVersionMinor stored false;
    property TrialEdition: Boolean read FTrialEdition stored false;
  end;

  TCPU = class(TPersistent)
  private
    FCPUIDLevel, FCPUIDExtLevel: UInt32;
    FName,
    FVendor,
    FSubModel,
    FBrand: String;
    FModel,
    FCount,
    FStepping,
    FFamily,
    FType: Cardinal;
    {$IFDEF MeasureCPUFrequency}
    FFreq: Cardinal;
    {$ENDIF}
    FVendorNo: Integer;
    FHasCPUID, FHasRDTSC: Boolean;
    function CPUIDExists: Boolean;
    function GetCPUType: Cardinal;
    {$IFDEF MeasureCPUFrequency}
    function GetCPUFreqEx: Extended;
    {$ENDIF}
    function GetSubModel: String;
  public
    procedure GetInfo;
    procedure Report(var sl: TStringList);
  published
    property HasCPUID: Boolean read FHasCPUID stored false;
    property HasRDTSC: Boolean read FHasRDTSC stored false;
    property CPUIDLevel: UInt32 read FCPUIDLevel stored false;
    property CPUIDExtLevel: UInt32 read FCPUIDExtLevel stored false;
    property Count: Cardinal read FCount stored false;
    property Vendor: String read FVendor stored false;
    property Name: String read FName stored false;
    {$IFDEF MeasureCPUFrequency}
    property Freq: Cardinal read FFreq stored false;
    {$ENDIF}
    property Family: Cardinal read FFamily stored false;
    property Stepping: Cardinal read FStepping stored false;
    property Model: Cardinal read FModel stored false;
    property Typ: Cardinal read FType stored false;
    property SubModel: String read FSubModel stored false;
    property Brand: String read FBrand stored false;
  end;

  TMemory = class(TPersistent)
  private
    {$IFDEF WIN16}
    FMemAvail: Longint;
    FMaxAvail: Longint;
    FGDIRes: Word;
    FUserRes: Word;
    FSystemRes: Word;
    {$ELSE}
    FMemoryLoad: DWORD;
    FPhysicalTotal, FPhysicalFree: DWORDLONG;
    FPageFileTotal, FPageFileFree: DWORDLONG;
    FVirtualTotal, FVirtualFree: DWORDLONG;
    FPageSize: DWORD;
    FMinAppAddress, FMaxAppAddress: Cardinal; //Actually, pointer, but can't publish a pointer as a property.
    FAllocGranularity: DWORD;
    FGlobalGDIObjects, FGlobalUSERObjects: DWORD;
    {$ENDIF}
  public
    procedure GetInfo;
    procedure Report(var sl: TStringList);
  published
    {$IFDEF WIN16}
    property MemAvailable: Longint read FMemAvail stored false;
    property MaxAvailable: Longint read FMaxAvail stored false;
    property SystemRes: Word read FSystemRes stored false;
    property GDIRes: Word read FGDIRes stored false;
    property UserRes: Word read FUserRes stored false;
    {$ELSE}
    property MemoryLoad: DWORD read FMemoryLoad stored false;
    property PhysicalTotal: DWORDLONG read FPhysicalTotal stored false;
    property PhysicalFree: DWORDLONG read FPhysicalFree stored false;
    property PageFileTotal: DWORDLONG read FPageFileTotal stored false;
    property PageFileFree: DWORDLONG read FPageFileFree stored false;
    property VirtualTotal: DWORDLONG read FVirtualTotal stored false;
    property VirtualFree: DWORDLONG read FVirtualFree stored false;
    property PageSize: DWORD read FPageSize stored false;
    property MinAppAddress: Cardinal read FMinAppAddress stored false;
    property MaxAppAddress: Cardinal read FMaxAppAddress stored false;
    property AllocGranularity: DWORD read FAllocGranularity stored false;
    property GlobalGDIObjects: DWORD read FGlobalGDIObjects stored false;
    property GlobalUSERObjects: DWORD read FGlobalUSERObjects stored false;
    {$ENDIF}
  end;

  TOperatingSystem = class(TPersistent)
  private
    {$IFDEF DetectWine}
    FWineVersion, FWineBuildID, FWineSysName, FWineRelease: String;
    {$ENDIF}
    FExtended: Boolean; //This platform supports OSVersionInfoEx
    FBuildNumber: DWORD; //SysUtils.Win32BuildNumber has the wrong datatype!
    FMajorVersion: DWORD; //SysUtils.Win32MajorVersion has the wrong datatype!
    FMinorVersion: DWORD; //SysUtils.Win32MinorVersion has the wrong datatype!
    FPlatform: string; //SysUtils.Win32Platform
    FCSD: string; //SysUtils.Win32CSDVersion
    FServicePackMajor: WORD;
    FServicePackMinor: WORD;
    FSuiteMask: WORD;
    FProductType: Byte;
    {$IFDEF WIN32}
    FWow64: Boolean;
    {$ENDIF}
    FArchitecture: WORD;
    {$IFDEF DetectReactOS}
    FVersion: String;
    FBuildLab: String;
    FReactOSVersion: String;
    {$ENDIF}
    //FVersionNumber: String;
    FPlusVersionNumber: String;
    FType: String;
    FEditionID: String;
    FDisplayVersion: String;
    FReleaseId: String;
    {$IFDEF LogSensitiveInformation}
    FSerialNumber: String;
    FRegUser: String;
    FRegOrg: String;
    FInstallDate: DWORD;
    FInstallTime: QWORD;
    {$ENDIF}
    FComCtlVersion: Integer;
    FEnv: TStrings;
    FDirs: TStrings;
    procedure GetEnvironment;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl: TStringList);
  published
    {$IFDEF DetectWine}
    property WineVersion: String read FWineVersion stored false;
    property WineBuildID: String read FWineBuildID stored false;
    property WineSysName: String read FWineSysName stored false;
    property WineRelease: String read FWineRelease stored false;
    {$ENDIF}
    property Extended: boolean read FExtended stored false;
    property MajorVersion: DWORD read FMajorVersion stored false;
    property MinorVersion: DWORD read FMinorVersion stored false;
    property BuildNumber: DWORD read FBuildNumber stored false;
    property Platform: string read FPlatform stored false;
    property CSD: string read FCSD stored false;
    property ServicePackMajor: WORD read FServicePackMajor stored false;
    property ServicePackMinor: WORD read FServicePackMinor stored false;
    property SuiteMask: WORD read FSuiteMask stored false;
    property ProductType: Byte read FProductType stored false;
    {$IFDEF WIN32}
    property Wow64: Boolean read FWow64 stored false;
    {$ENDIF}
    property Architecture: WORD read FArchitecture stored false;
    {$IFDEF DetectReactOS}
    property Version: String read FVersion stored false;
    property BuildLab: String read FBuildLab stored false;
    property ReactOSVersion: String read FReactOSVersion stored false;
    {$ENDIF}
    //property VersionNumber: String read FVersionNumber stored false;
    property PlusVersionNumber: String read FPlusVersionNumber stored false;
    property Typ: String read FType stored false;
    property EditionID: String read FEditionID stored false;
    property DisplayVersion: String read FDisplayVersion stored false;
    property ReleaseId: String read FReleaseId stored false;
    {$IFDEF LogSensitiveInformation}
    property SerialNumber: String read FSerialNumber stored false;
    property RegisteredUser: String read FRegUser stored false;
    property RegisteredOrg: String read FRegOrg stored false;
    property InstallDate: DWORD read FInstallDate stored false;
    property InstallTime: QWORD read FInstallTime stored false;
    {$ENDIF}
    property ComCtlVersion: Integer read FComCtlVersion stored false;
    property Environment: TStrings read FEnv stored false;
    property Directories: TStrings read FDirs stored False;
  end;

  {$IFDEF LogSensitiveInformation}
  TWorkstation = class(TPersistent)
  private
    FName: String;
    FUser: String;
    FFirmware: String;
    FSystemUpTime: {$ifdef Delphi2007orNewerCompiler}UInt64{$else}Int64{$endif}; //UInt64 is known to be broken before Delphi 2007, even if present. Borland also uses Int64 instead in ActiveX.pas //in ms
    FBIOSExtendedInfo: String;
    FBIOSCopyright: String;
    FBIOSName: String;
    FBIOSDate: String;
    FKeyboardType: Integer;
    FKeyboardSubtype: Integer;
    FKeyboardNFunctionKeys: Integer;
    //FScrollLock: Boolean;
    //FNumLock: Boolean;
    //FCapsLock: Boolean;
  public
    procedure GetInfo;
    procedure Report(var sl: TStringList);
  published
    property Name: String read FName stored false;
    property User: String read FUser stored false;
    property Firmware: String read FFirmware stored false;
    property SystemUpTime: {$ifdef Delphi2007orNewerCompiler}UInt64{$else}Int64{$endif} read FSystemUpTime stored false;
    property BIOSCopyright: String read FBIOSCopyright stored false;
    property BIOSDate: String read FBIOSDate stored false;
    property BIOSExtendedInfo: String read FBIOSExtendedInfo stored false;
    property BIOSName: String read FBIOSName stored false;
    property KeyboardType: Integer read FKeyboardType stored false;
    property KeyboardSubtype: Integer read FKeyboardSubtype stored false;
    property KeyboardNFunctionKeys: Integer read FKeyboardNFunctionKeys stored false;
    //property CapsLock: Boolean read FCapsLock stored false;
    //property NumLock: Boolean read FNumLock stored false;
    //property ScrollLock: Boolean read FScrollLock stored false;
  end;
  {$ENDIF}

  TCurveCap = (ccCircles,ccPieWedges,ccChords,ccEllipses,ccWideBorders,ccStyledBorders,
               ccWideStyledBorders,ccInteriors,ccRoundedRects);
  TLineCap = (lcPolylines,lcMarkers,lcMultipleMarkers,lcWideLines,lcStyledLines,
               lcWideStyledLines,lcInteriors);
  TPolygonCap = (pcAltFillPolygons,pcRectangles,pcWindingFillPolygons,pcSingleScanlines,
                 pcWideBorders,pcStyledBorders,pcWideStyledBorders,pcInteriors);
  TRasterCap = (rcRequiresBanding,rcTranserBitmaps,rcBitmaps64K,rcSetGetDIBits,
                rcSetDIBitsToDevice,rcFloodfills,rcWindows2xFeatures,rcPaletteBased,
                rcScaling,rcStretchBlt,rcStretchDIBits);
  TTextCap = (tcCharOutPrec,tcStrokeOutPrec,tcStrokeClipPrec,tcCharRotation90,
              tcCharRotationAny,tcScaleIndependent,tcDoubledCharScaling,tcIntMultiScaling,
              tcAnyMultiExactScaling,tcDoubleWeightChars,tcItalics,tcUnderlines,
              tcStrikeouts,tcRasterFonts,tcVectorFonts,tcNoScrollUsingBlts);
  TShadeBlendCap = (sbConstAlpha,sbGradRect,sbGradTri,sbPixelAlpha,sbPremultAlpha);
  TColorMgmtCap = (cmCMYKColor,cmDeviceICM,cmGammaRamp);

  TCurveCaps = set of TCurveCap;
  TLineCaps = set of TLineCap;
  TPolygonCaps = set of TPolygonCap;
  TRasterCaps = set of TRasterCap;
  TTextCaps = set of TTextCap;
  TShadeBlendCaps = set of TShadeBlendCap;
  TColorMgmtCaps = set of TColorMgmtCap;

  TDisplay = class(TPersistent)
  private
    FVertRes: Integer;
    FColorDepth: Integer;
    FHorzRes: Integer;
    FPixelDiagonal: Integer;
    FPixelHeight: Integer;
    FVertSize: Integer;
    FPixelWidth: Integer;
    FHorzSize: Integer;
    FTechnology: String;
    FCurveCaps: TCurveCaps;
    FLineCaps: TLineCaps;
    FPolygonCaps: TPolygonCaps;
    FRasterCaps: TRasterCaps;
    FTextCaps: TTextCaps;
    FShadeBlendCaps: TShadeBlendCaps;
    FColorMgmtCaps: TColorMgmtCaps;
    FMemory: TStrings;
    FChipset: TStrings;
    FDevices: TStrings;
    FAdapter: TStrings;
    FDAC: TStrings;
    FProvider: TStrings;
    FDriverDate: TStrings;
    FDriverVersion: TStrings;
    FAcc: TStrings;
    FModes: TStrings;
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl: TStringList);
  published
    property Adapter: TStrings read FAdapter stored false;
    property Devices: TStrings read FDevices stored false;
    property Accelerator: TStrings read FAcc stored false;
    property DAC: TStrings read FDAC stored false;
    property Chipset: TStrings read FChipset stored false;
    property Memory: TStrings read FMemory stored false;
    property Provider: TStrings read FProvider stored false;
    property DriverDate: TStrings read FDriverDate stored false;
    property DriverVersion: TStrings read FDriverVersion stored false;
    property HorzRes: Integer read FHorzRes stored false;
    property VertRes: Integer read FVertRes stored false;
    property ColorDepth: Integer read FColorDepth stored false;
    property Technology: String read FTechnology stored false;
//    property HorzSize: Integer read FHorzSize stored false;
//    property VertSize: Integer read FVertSize stored false;
    property PixelWidth: Integer read FPixelWidth stored false;
    property PixelHeight: Integer read FPixelHeight stored false;
    property PixelDiagonal: Integer read FPixelDiagonal stored false;
    property RasterCaps: TRasterCaps read FRasterCaps stored false;
    property CurveCaps: TCurveCaps read FCurveCaps stored false;
    property LineCaps: TLineCaps read FLineCaps stored false;
    property PolygonCaps: TPolygonCaps read FPolygonCaps stored false;
    property TextCaps: TTextCaps read FTextCaps stored false;
    property ShadeBlendCaps: TShadeBlendCaps read FShadeBlendCaps stored false;
    property ColorMgmtCaps: TColorMgmtCaps read FColorMgmtCaps stored false;
    property Modes: TStrings read FModes stored False;
  end;

  TDirectX = class(TPersistent)
  private
    FVersion: String;
    FDirect3D: TStrings;
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl: TStringList);
  published
    property Version: String read FVersion stored false;
    property Direct3D: TStrings read FDirect3D stored false;
  end;

  {$IFDEF Delphi4orNewerCompiler}
     TLargInt = _LARGE_INTEGER;
  {$ELSE}
     TLargInt = TLargeInteger;
  {$ENDIF}

  TVendorStr = array[0..11] of AnsiChar;
  TFeatureFlags = record
    EBX: UInt32;
    ECX: UInt32;
    EDX: UInt32;
  end;
  TBrandStr = array[0..47] of AnsiChar;

var
  WindowsPlatformCompatibility: TPlatformType;
  DriverBugs: TStringList;

{$IFDEF DetectWine}
var
  //Detect Wine and retrieve its version information
  wine_get_version: function(): {const} PChar; cdecl;
  wine_get_build_id: function(): {const} PChar; cdecl;
  wine_get_host_version: procedure(const sysname: PPChar; const release: PPChar); cdecl;
{$ENDIF}

{$IFDEF CPUNameLookup}
{$INCLUDE GetCPUName.inc}
{$ENDIF}

function FormatBytes(const Number: Integer) : String; overload;
begin
  Result:=formatfloat('#,##',Number);
  if Length(Result)=0 then
    Result:='0';
end;

function FormatBytes(const Number: Int64) : String; overload;
begin
  Result:=formatfloat('#,##',Number);
  if Length(Result)=0 then
    Result:='0';
end;

{$IFDEF Delphi2007orNewerCompiler}
function FormatBytes(const Number: UInt64) : String; overload;
begin
  Result:=formatfloat('#,##',Number);
  if Length(Result)=0 then
    Result:='0';
end;
{$ENDIF}

{ TDelphi }

procedure TDelphi.GetInfo;
var
  Version: Word;
begin
  Log(LOG_VERBOSE, 'Starting gathering Delphi information...');

  FCompiler:=QuArKUsedCompiler;
  FCompileDate:=QuArKCompileDate;
  FEndianess:=PlatformEndian;

  Version:=GetCompilerVersion();
  FCompilerVersionMajor:=Hi(Version);
  FCompilerVersionMinor:=Lo(Version);
  Version:=GetRTLVersion();
  FRTLVersionMajor:=Hi(Version);
  FRTLVersionMinor:=Lo(Version);

  FTrialEdition:={$IFDEF TRIAL_EDITION}True{$ELSE}False{$ENDIF};
end;

procedure TDelphi.Report(var sl: TStringList);
{$IFDEF Delphi7orNewerCompiler}
var
  DateFormat: TFormatSettings;
{$ENDIF}
begin
  {$IFDEF Delphi7orNewerCompiler}
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, DateFormat);
  {$ENDIF}

  with sl do
  begin
    if TrialEdition then
      add(format('Used compiler: %s (Trial edition)', [Compiler]))
    else
      add(format('Used compiler: %s', [Compiler]));
    add(format('Compiler version: %d.%d', [CompilerVersionMajor, CompilerVersionMinor]));
    add(format('RTL version: %d.%d', [RTLVersionMajor, RTLVersionMinor]));
    add(format('Compiled on %s', [DateToStr(QuArKCompileDate{$IFDEF Delphi7orNewerCompiler}, DateFormat{$ENDIF})]));
    if Endianess = Big then
      add('Endianness: Big')
    else if Endianess = Little then
      add('Endianness: Little')
    else
      add('Endianness: Unhandled endianness!');
  end;
end;

{ TCPU }

const
  ID_Bit = $200000;   // EFLAGS ID bit
  TSC_Bit = $10;      // TimeStamp Counter EDX Feature Flag bit

  CPUVendorIDs: array[0..15] of AnsiString = ('GenuineIntel',
                                              'UMC UMC UMC',
                                              'AuthenticAMD',
                                              'CyrixInstead',
                                              'NexGenDriven',
                                              'CentaurHauls',
                                              'RiseRiseRise',
                                              'SiS SiS SiS',
                                              'GenuineTMx86',
                                              'Geode by NSC',
                                              'VIA VIA VIA ',
                                              'AMDisbetter!',
                                              'TransmetaCPU',
                                              'Vortex86 SoC',
                                              'HygonGenuine',
                                              'GenuineIotel'); //Bug in processors such as the Xeon E3-1231 v3.

  CPUVendors: array[0..15] of AnsiString = ('Intel',
                                            'UMC',
                                            'AMD',
                                            'Cyrix',
                                            'NexGen',
                                            'CentaurHauls',
                                            'Rise Technology',
                                            'SiS',
                                            'Transmeta',
                                            'National Semiconductor',
                                            'VIA',
                                            'AMD',
                                            'Transmeta',
                                            'Vortex',
                                            'Hygon',
                                            'Intel');

procedure GetCPUIDLevelAndVendor(var Level: UInt32; var VendorStr: TVendorStr); assembler;
asm
	{$IFDEF CPUX86}
	//Save registers that need to be preserved
	PUSH esi
	PUSH edi
	//PUSH eax //scratch
	PUSH ebx
	//PUSH ecx //scratch
	//PUSH edx //scratch

	//Store output variables in safe places
	MOV esi, Level
	MOV edi, VendorStr //Put this EDI, because we're going to use STOSB to write to it

	//Call the CPUID command
	MOV eax, 0h     //Function 0h: Vendor-ID and Largest Standard Function
	{$IFDEF Delphi6orNewerCompiler}
	CPUID
	{$ELSE}
	DB 0Fh,0a2h     //Execute CPUID
	{$ENDIF}
	MOV [esi], eax  //Store Level

	//Save the first 4 bytes
	MOV  eax,ebx   //need CPUID EBX-value to be in EAX
	XCHG ebx,ecx   //save ECX result in EBX
	MOV  ecx,4     //loop 4 times
	@1:
	STOSB          //save 1 byte from EAX
	SHR  eax,8     //shift to the next byte
	LOOP @1

	//Save the middle 4 bytes
	MOV  eax,edx   //need CPUID EDX-value to be in EAX
	MOV  ecx,4     //loop 4 times
	@2:
	STOSB          //save 1 byte from EAX
	SHR  eax,8     //shift to the next byte
	LOOP @2

	//Save the last 4 bytes
	MOV  eax,ebx   //need CPUID ECX-value to be in EAX (note: it's stored in EBX now)
	MOV  ecx,4     //loop 4 times
	@3:
	STOSB          //save 1 byte from EAX
	SHR  eax,8     //shift to the next byte
	LOOP @3

	//Restore registers
	//POP edx
	//POP ecx
	POP ebx
	//POP eax
	POP edi
	POP esi
	{$ELSE}
	{$IFDEF CPUX64}
	//Save registers that need to be preserved
	PUSH rsi
	PUSH rdi
	//PUSH rax //scratch
	PUSH rbx
	//PUSH rcx //scratch
	//PUSH rdx //scratch

	//Store output variables in safe places
	MOV rsi, Level
	MOV rdi, VendorStr //Put this RDI, because we're going to use STOSB to write to it

	//Call the CPUID command
	MOV rax, 0h     //Function 0h: Vendor-ID and Largest Standard Function
	{$IFDEF Delphi6orNewerCompiler}
	CPUID
	{$ELSE}
	DB 0Fh,0a2h     //Execute CPUID
	{$ENDIF}
	MOV [rsi], rax  //Store Level

	//Save the first 4 bytes
	MOV  rax,rbx   //need CPUID RBX-value to be in RAX
	XCHG rbx,rcx   //save RCX result
	MOV  rcx,4     //loop 4 times
	@1:
	STOSB          //save 1 byte from RAX
	SHR  rax,8     //shift to the next byte
	LOOP @1

	//Save the middle 4 bytes
	MOV  rax,rdx   //need CPUID RDX-value to be in RAX
	MOV  rcx,4     //loop 4 times
	@2:
	STOSB          //save 1 byte from RAX
	SHR  rax,8     //shift to the next byte
	LOOP @2

	//Save the last 4 bytes
	MOV  rax,rbx   //need CPUID RCX-value to be in EAX (note: it's stored in RBX now)
	MOV  rcx,4     //loop 4 times
	@3:
	STOSB          //save 1 byte from RAX
	SHR  rax,8     //shift to the next byte
	LOOP @3

	//Restore registers
	//POP rdx
	//POP rcx
	POP rbx
	//POP rax
	POP rdi
	POP rsi
	{$ELSE}
	{$Message Error 'Unsupported CPU architecture!'}
	{$ENDIF}
	{$ENDIF}
end;

procedure GetCPUIDSignatureAndFeatureFlags(var Signature: UInt32; var FeatureFlags: TFeatureFlags); assembler;
asm
	{$IFDEF CPUX86}
	//Save registers that need to be preserved
	PUSH esi
	PUSH edi
	//PUSH eax //scratch
	PUSH ebx
	//PUSH ecx //scratch
	//PUSH edx //scratch

	//Store output variables in safe places
	MOV esi, Signature
	MOV edi, FeatureFlags

	//Call the CPUID command
	MOV eax, 1h     //Function 1h: Feature Information
	{$IFDEF Delphi6orNewerCompiler}
	CPUID
	{$ELSE}
	DB 0Fh,0a2h     //Execute CPUID
	{$ENDIF}
	MOV [esi], eax  //Store Signature
	MOV TFeatureFlags(edi).&EBX, ebx  //Store FeatureFlags EBX
	MOV TFeatureFlags(edi).&ECX, ecx  //Store FeatureFlags ECX
	MOV TFeatureFlags(edi).&EDX, edx  //Store FeatureFlags EDX

	//Restore registers
	//POP edx
	//POP ecx
	POP ebx
	//POP eax
	POP edi
	POP esi
	{$ELSE}
	{$IFDEF CPUX64}
	//Save registers that need to be preserved
	PUSH rsi
	PUSH rdi
	//PUSH rax //scratch
	PUSH rbx
	//PUSH rcx //scratch
	//PUSH rdx //scratch

	//Store output variables in safe places
	MOV rsi, Signature
	MOV rdi, FeatureFlags

	//Call the CPUID command
	MOV rax, 1h     //Function 1h: Feature Information
	{$IFDEF Delphi6orNewerCompiler}
	CPUID
	{$ELSE}
	DB 0Fh,0a2h     //Execute CPUID
	{$ENDIF}
	MOV [rsi], eax  //Store Signature from lower 32-bit in RAX
	MOV TFeatureFlags(rdi).&EBX, ebx  //Store FeatureFlags from lower 32-bit in RBX
	MOV TFeatureFlags(rdi).&ECX, ecx  //Store FeatureFlags from lower 32-bit in RCX
	MOV TFeatureFlags(rdi).&EDX, edx  //Store FeatureFlags from lower 32-bit in RDX

	//Restore registers
	//POP rdx
	//POP rcx
	POP rbx
	//POP rax
	POP rdi
	POP rsi
	{$ELSE}
	{$Message Error 'Unsupported CPU architecture!'}
	{$ENDIF}
	{$ENDIF}
end;

procedure GetCPUIDExtLevelAndVendor(var ExtLevel: UInt32); assembler;
asm
	{$IFDEF CPUX86}
	//Save registers that need to be preserved
	PUSH esi
	//PUSH eax //scratch
	PUSH ebx
	//PUSH ecx //scratch
	//PUSH edx //scratch

	//Store output variables in safe places
	MOV esi, ExtLevel

	//Call the CPUID command
	MOV eax, 80000000h     //Function 80000000h: Largest Extended Function
	{$IFDEF Delphi6orNewerCompiler}
	CPUID
	{$ELSE}
	DB 0Fh,0a2h     //Execute CPUID
	{$ENDIF}
	MOV [esi], eax  //Store ExtLevel

	//Restore registers
	//POP edx
	//POP ecx
	POP ebx
	//POP eax
	POP esi
	{$ELSE}
	{$IFDEF CPUX64}
	//Save registers that need to be preserved
	PUSH rsi
	//PUSH rax //scratch
	PUSH rbx
	//PUSH rcx //scratch
	//PUSH rdx //scratch

	//Store output variables in safe places
	MOV rsi, ExtLevel

	//Call the CPUID command
	MOV rax, 80000000h     //Function 80000000h: Largest Extended Function
	{$IFDEF Delphi6orNewerCompiler}
	CPUID
	{$ELSE}
	DB 0Fh,0a2h     //Execute CPUID
	{$ENDIF}
	MOV [rsi], eax  //Store ExtLevel (only copy lower 32 bits)

	//Restore registers
	//POP rdx
	//POP rcx
	POP rbx
	//POP rax
	POP rsi
	{$ELSE}
	{$Message Error 'Unsupported CPU architecture!'}
	{$ENDIF}
	{$ENDIF}
end;

procedure GetCPUIDBrand(var BrandStr: TBrandStr); assembler;
asm
	{$IFDEF CPUX86}
	//Save registers that need to be preserved
	PUSH esi
	PUSH edi
	//PUSH eax //scratch
	PUSH ebx
	//PUSH ecx //scratch
	//PUSH edx //scratch

	//Store output variables in safe places
	MOV edi, BrandStr //Put this EDI, because we're going to use STOSB to write to it

	//Call the CPUID command
	MOV eax, 80000002h     //Function 80000002h: Processor Brand String
	{$IFDEF Delphi6orNewerCompiler}
	CPUID
	{$ELSE}
	DB 0Fh,0a2h     //Execute CPUID
	{$ENDIF}

	//Save the first 4 bytes
	MOV esi,ecx   //save ECX result in ESI
	MOV ecx,4     //loop 4 times
	@1:
	STOSB         //save 1 byte from EAX
	SHR eax,8     //shift to the next byte
	LOOP @1

	//Save the second 4 bytes
	MOV eax,ebx   //need CPUID EBX-value to be in EAX
	MOV ecx,4     //loop 4 times
	@2:
	STOSB         //save 1 byte from EAX
	SHR eax,8     //shift to the next byte
	LOOP @2

	//Save the third 4 bytes
	MOV eax,esi   //need CPUID ESI-value to be in EAX (note: it's stored in ESI now)
	MOV ecx,4     //loop 4 times
	@3:
	STOSB         //save 1 byte from EAX
	SHR eax,8     //shift to the next byte
	LOOP @3

	//Save the last 4 bytes
	MOV eax,edx   //need CPUID EDX-value to be in EAX
	MOV ecx,4     //loop 4 times
	@4:
	STOSB         //save 1 byte from EAX
	SHR eax,8     //shift to the next byte
	LOOP @4

	//Call the CPUID command
	MOV eax, 80000003h     //Function 80000003h: Processor Brand String (continued)
	{$IFDEF Delphi6orNewerCompiler}
	CPUID
	{$ELSE}
	DB 0Fh,0a2h     //Execute CPUID
	{$ENDIF}

	//Save the first 4 bytes
	MOV esi,ecx   //save ECX result in ESI
	MOV ecx,4     //loop 4 times
	@5:
	STOSB         //save 1 byte from EAX
	SHR eax,8     //shift to the next byte
	LOOP @5

	//Save the second 4 bytes
	MOV eax,ebx   //need CPUID EBX-value to be in EAX
	MOV ecx,4     //loop 4 times
	@6:
	STOSB         //save 1 byte from EAX
	SHR eax,8     //shift to the next byte
	LOOP @6

	//Save the third 4 bytes
	MOV eax,esi   //need CPUID ESI-value to be in EAX (note: it's stored in ESI now)
	MOV ecx,4     //loop 4 times
	@7:
	STOSB         //save 1 byte from EAX
	SHR eax,8     //shift to the next byte
	LOOP @7

	//Save the last 4 bytes
	MOV eax,edx   //need CPUID EDX-value to be in EAX
	MOV ecx,4     //loop 4 times
	@8:
	STOSB         //save 1 byte from EAX
	SHR eax,8     //shift to the next byte
	LOOP @8

	//Call the CPUID command
	MOV eax, 80000004h     //Function 80000004h: Processor Brand String (continued)
	{$IFDEF Delphi6orNewerCompiler}
	CPUID
	{$ELSE}
	DB 0Fh,0a2h     //Execute CPUID
	{$ENDIF}

	//Save the first 4 bytes
	MOV esi,ecx   //save ECX result in ESI
	MOV ecx,4     //loop 4 times
	@9:
	STOSB         //save 1 byte from EAX
	SHR eax,8     //shift to the next byte
	LOOP @9

	//Save the second 4 bytes
	MOV eax,ebx   //need CPUID EBX-value to be in EAX
	MOV ecx,4     //loop 4 times
	@10:
	STOSB         //save 1 byte from EAX
	SHR eax,8     //shift to the next byte
	LOOP @10

	//Save the third 4 bytes
	MOV eax,esi   //need CPUID ESI-value to be in EAX (note: it's stored in ESI now)
	MOV ecx,4     //loop 4 times
	@11:
	STOSB         //save 1 byte from EAX
	SHR eax,8     //shift to the next byte
	LOOP @11

	//Save the last 4 bytes
	MOV eax,edx   //need CPUID EDX-value to be in EAX
	MOV ecx,4     //loop 4 times
	@12:
	STOSB         //save 1 byte from EAX
	SHR eax,8     //shift to the next byte
	LOOP @12

	//Restore registers
	//POP edx
	//POP ecx
	POP ebx
	//POP eax
	POP edi
	POP esi
	{$ELSE}
	{$IFDEF CPUX64}
	//Save registers that need to be preserved
	PUSH rsi
	PUSH rdi
	//PUSH rax //scratch
	PUSH rbx
	//PUSH rcx //scratch
	//PUSH rdx //scratch

	//Store output variables in safe places
	MOV rdi, BrandStr //Put this RDI, because we're going to use STOSB to write to it

	//Call the CPUID command
	MOV rax, 80000002h     //Function 80000002h: Processor Brand String
	{$IFDEF Delphi6orNewerCompiler}
	CPUID
	{$ELSE}
	DB 0Fh,0a2h     //Execute CPUID
	{$ENDIF}

	//Save the first 4 bytes
	MOV rsi,rcx   //save RCX result in RSI
	MOV rcx,4     //loop 4 times
	@1:
	STOSB         //save 1 byte from RAX
	SHR rax,8     //shift to the next byte
	LOOP @1

	//Save the second 4 bytes
	MOV rax,rbx   //need CPUID RBX-value to be in RAX
	MOV rcx,4     //loop 4 times
	@2:
	STOSB         //save 1 byte from RAX
	SHR rax,8     //shift to the next byte
	LOOP @2

	//Save the third 4 bytes
	MOV rax,rsi   //need CPUID RSI-value to be in RAX (note: it's stored in RSI now)
	MOV rcx,4     //loop 4 times
	@3:
	STOSB         //save 1 byte from RAX
	SHR rax,8     //shift to the next byte
	LOOP @3

	//Save the last 4 bytes
	MOV rax,rdx   //need CPUID RDX-value to be in RAX
	MOV rcx,4     //loop 4 times
	@4:
	STOSB         //save 1 byte from RAX
	SHR rax,8     //shift to the next byte
	LOOP @4

	//Call the CPUID command
	MOV rax, 80000003h     //Function 80000003h: Processor Brand String (continued)
	{$IFDEF Delphi6orNewerCompiler}
	CPUID
	{$ELSE}
	DB 0Fh,0a2h     //Execute CPUID
	{$ENDIF}

	//Save the first 4 bytes
	MOV rsi,rcx   //save RCX result in RSI
	MOV rcx,4     //loop 4 times
	@5:
	STOSB         //save 1 byte from RAX
	SHR rax,8     //shift to the next byte
	LOOP @5

	//Save the second 4 bytes
	MOV rax,rbx   //need CPUID RBX-value to be in RAX
	MOV rcx,4     //loop 4 times
	@6:
	STOSB         //save 1 byte from RAX
	SHR rax,8     //shift to the next byte
	LOOP @6

	//Save the third 4 bytes
	MOV rax,rsi   //need CPUID RSI-value to be in RAX (note: it's stored in RSI now)
	MOV rcx,4     //loop 4 times
	@7:
	STOSB         //save 1 byte from RAX
	SHR rax,8     //shift to the next byte
	LOOP @7

	//Save the last 4 bytes
	MOV rax,rdx   //need CPUID RDX-value to be in RAX
	MOV rcx,4     //loop 4 times
	@8:
	STOSB         //save 1 byte from RAX
	SHR rax,8     //shift to the next byte
	LOOP @8

	//Call the CPUID command
	MOV rax, 80000004h     //Function 80000004h: Processor Brand String (continued)
	{$IFDEF Delphi6orNewerCompiler}
	CPUID
	{$ELSE}
	DB 0Fh,0a2h     //Execute CPUID
	{$ENDIF}

	//Save the first 4 bytes
	MOV rsi,rcx   //save RCX result in RSI
	MOV rcx,4     //loop 4 times
	@9:
	STOSB         //save 1 byte from RAX
	SHR rax,8     //shift to the next byte
	LOOP @9

	//Save the second 4 bytes
	MOV rax,rbx   //need CPUID RBX-value to be in RAX
	MOV rcx,4     //loop 4 times
	@10:
	STOSB         //save 1 byte from RAX
	SHR rax,8     //shift to the next byte
	LOOP @10

	//Save the third 4 bytes
	MOV rax,rsi   //need CPUID RSI-value to be in RAX (note: it's stored in RSI now)
	MOV rcx,4     //loop 4 times
	@11:
	STOSB         //save 1 byte from RAX
	SHR rax,8     //shift to the next byte
	LOOP @11

	//Save the last 4 bytes
	MOV rax,rdx   //need CPUID RDX-value to be in RAX
	MOV rcx,4     //loop 4 times
	@12:
	STOSB         //save 1 byte from RAX
	SHR rax,8     //shift to the next byte
	LOOP @12

	//Restore registers
	//POP rdx
	//POP rcx
	POP rbx
	//POP rax
	POP rdi
	POP rsi
	{$ELSE}
	{$Message Error 'Unsupported CPU architecture!'}
	{$ENDIF}
	{$ENDIF}
end;

 { ----------------- }

//Based on: Intel Processor Identification and the CPUID Instruction, Application Note 485, May 2012
{$IFDEF CPUX86}
function TCPU.GetCPUType: Cardinal; assembler;
asm
{$IFDEF CPU16BITS}
  // Intel 8086 processor check
  // Bits 12-15 of the FLAGS register are always set on the 8086 processor.
@check_8086:
  pushf                   // push original FLAGS
  pop ax                  // get original FLAGS
  mov     cx, ax          // save original FLAGS
  and     ax, 0FFFh       // clear bits 12-15 in FLAGS
  push    ax              // save new FLAGS value on stack
  popf                    // replace current FLAGS value
  pushf                   // get new FLAGS
  pop     ax              // store new FLAGS in AX
  and     ax, 0F000h      // if bits 12-15 are set, then
  cmp     ax, 0F000h      //  processor is an 8086/8088
  mov     Result, 0       // turn on 8086/8088 flag
  jne     check_80286     // go check for 80286
  push    sp              // double check with push sp
  pop     dx              // if value pushed was different
  cmp     dx, sp          // means it's really an 8086
  jne     end_cpu_type    // jump if processor is 8086/8088
  mov     ax, 10h         // indicate unknown processor
  jmp     @exit

  // Intel 286 processor check
  // Bits 12-15 of the FLAGS register are always clear on the Intel 286 processor in real-address mode.
@check_80286:
  smsw    ax             // save machine status word
  and     ax, 1          // isolate PE bit of MSW
  mov     _v86_flag, al  // save PE bit to indicate V86
  or      cx, 0F000h     // try to set bits 12-15
  push    cx             // save new FLAGS value on stack
  popf                   // replace current FLAGS value
  pushf                  // get new FLAGS
  pop     ax             // store new FLAGS in AX
  and     ax, 0F000h     // if bits 12-15 are clear
  mov     ax, 2          // processor=80286, turn on 80286 flag
  jz      @exit          // jump if processor is 80286
{$ENDIF}

  // Intel386 processor check
  // The AC bit, bit #18, is a new bit introduced in the EFLAGS register on the Intel486 processor to generate alignment faults.
  // This bit cannot be set on the Intel386 processor.
@check_80386:
  pushfd               // push original EFLAGS
  pop     eax          // get original EFLAGS
  mov     ecx, eax     // save original EFLAGS
  xor     eax, 40000h  // flip AC bit in EFLAGS
  push    eax          // save new EFLAGS value on stack
  popfd                // replace current EFLAGS value
  pushfd               // get new EFLAGS
  pop     eax          // store new EFLAGS in EAX
  xor     eax, ecx     // can't toggle AC bit processor=80386
  mov     eax, 3       // turn on 80386 processor flag
  jz      @exit        // jump if 80386 processor
  push    ecx
  popfd                // restore AC bit in EFLAGS first

  // Intel486 processor check
@check_80486:
  mov     eax, 4  // turn on 80486 processor flag
  je      @exit   // processor=80486
@exit:
end;
{$ELSE}
{$IFDEF CPUX64}
function TCPU.GetCPUType: Cardinal;
begin
  Result:=$f;
end;
{$ELSE}
{$Message Error 'Unsupported CPU architecture!'}
{$ENDIF}
{$ENDIF}

function TCPU.CPUIDExists: Boolean; assembler; register;
asm
	{$IFDEF CPUX86}
	PUSHFD               //direct access to flags not possible, only via stack
	POP     EAX          //flags to EAX
	MOV     EDX,EAX      //save current flags
	XOR     EAX,ID_BIT   //not ID bit
	PUSH    EAX          //onto stack
	POPFD                //from stack to flags, with not ID bit
	PUSHFD               //back to stack
	POP     EAX          //get back to EAX
	XOR     EAX,EDX      //check if ID bit affected
	JZ      @exit        //no, CPUID not available
	MOV     AL,True      //Result=True
	{$ELSE}
	{$IFDEF CPUX64}
	PUSHFQ               //direct access to flags not possible, only via stack
	POP     RAX          //flags to EAX
	MOV     RDX,RAX      //save current flags
	XOR     RAX,ID_BIT   //not ID bit
	PUSH    RAX          //onto stack
	POPFQ                //from stack to flags, with not ID bit
	PUSHFQ               //back to stack
	POP     RAX          //get back to EAX
	XOR     RAX,RDX      //check if ID bit affected
	JZ      @exit        //no, CPUID not available
	MOV     AL,True      //Result=True
	{$ELSE}
	{$Message Error 'Unsupported CPU architecture!'}
	{$ENDIF}
	{$ENDIF}
@exit:
end;

{$IFDEF MeasureCPUFrequency}
//FIXME: On multi-core machines, it may cause weird issues due to time differences between cores.
//FIXME: Also, the RDTSC is not a SERIALIZING instruction, meaning it may get shifted around due to out-of-order execution!
function GetTimeStamp: TLargInt; assembler; register;
asm
	{$IFDEF CPUX86}
	//Save registers that need to be preserved
	PUSH esi
	//PUSH eax //scratch
	//PUSH edx //scratch

	//Store output variables in safe places
	MOV esi, eax

	//Call the RDTSC command
	{$IFDEF Delphi6orNewerCompiler}
	RDTSC
	{$ELSE}
	DW $310F   //Call RDTSC
	{$ENDIF}
	MOV TLargInt(esi).&LowPart, eax
	MOV TLargInt(esi).&HighPart, edx

	//Restore registers
	//POP edx
	//POP eax
	POP esi
	{$ELSE}
	{$IFDEF CPUX64}
	//Save registers that need to be preserved
	PUSH rsi
	//PUSH rax //scratch
	//PUSH rdx //scratch

	//Store output variables in safe places
	MOV rsi, rax

	//Call the RDTSC command
	DW $310F   //Call RDTSC
	MOV TLargInt(rsi).&LowPart, rax
	MOV TLargInt(rsi).&HighPart, rdx

	//Restore registers
	//POP rdx
	//POP rax
	POP rsi
	{$ELSE}
	{$Message Error 'Unsupported CPU architecture!'}
	{$ENDIF}
	{$ENDIF}
end;

function TCPU.GetCPUFreqEx: extended;
const
  Iterations = 1;
var
  Freq, PerfCount, Target: TLargeInteger;
  StartTime, EndTime, Elapsed: TLargInt;

  procedure StartTimer;
  begin
    StartTime:=GetTimeStamp;
    EndTime.QuadPart:=0;
    Elapsed.QuadPart:=0;
  end;

  procedure StopTimer;
  begin
    EndTime:=GetTimeStamp;
    Elapsed.QuadPart:=(EndTime.QuadPart-StartTime.QuadPart);
  end;

begin
  Result:=0;
  if not QueryPerformanceFrequency(Freq) then
    exit;
  QueryPerformanceCounter(PerfCount);
  {$IFDEF Delphi4orNewerCompiler}
  Target:=PerfCount+(Freq*Iterations);
  {$ELSE}
  Target.QuadPart:=PerfCount.QuadPart+(Freq.QuadPart*Iterations);
  {$ENDIF}
  StartTimer;
  repeat
    QueryPerformanceCounter(PerfCount);
  {$IFDEF Delphi4orNewerCompiler}
  until (PerfCount>=Target);
  {$ELSE}
  until (PerfCount.QuadPart>=Target.QuadPart);
  {$ENDIF}
  StopTimer;
  Result:=Elapsed.QuadPart/Iterations;
  Result:=Result/1E6; //Hz to MHz
end;
{$ENDIF}

function TCPU.GetSubModel :string;
begin
  case Typ of
    3: result:='Reserved';
    2: result:='Secondary';
    1: result:='OverDrive';
    0: result:='Primary';
    else
      result:='Not Detected!';
  end;
end;

procedure TCPU.GetInfo;
var
  I, J: Integer;
  CPUIDVendor: TVendorStr;
  CPUIDSignature: UInt32;
  CPUIDFeatureFlags: TFeatureFlags;
  ExtendedModel: Byte;
  ExtendedFamily: Byte;
  CPUIDBrand: TBrandStr;
  CPUIDBrand_TMP: AnsiString;
begin
  Log(LOG_VERBOSE, 'Starting gathering CPU information...');
  FCount:=CPUCount;
  FHasCPUID:=CPUIDExists;
  if FHasCPUID then
  begin
    GetCPUIDLevelAndVendor(FCPUIDLevel, CPUIDVendor);
    if CPUIDLevel >= 1 then
    begin
      //FIXME: Modern Delphi's have System.GetCPUID. Switch to using that?
      GetCPUIDSignatureAndFeatureFlags(CPUIDSignature, CPUIDFeatureFlags);
      FHasRDTSC:=(CPUIDFeatureFlags.EDX and TSC_Bit) = TSC_Bit;
      FStepping:=(CPUIDSignature and $f);
      FModel:=(CPUIDSignature shr 4) and $f;
      FFamily:=(CPUIDSignature shr 8) and $f;
      FType:=(CPUIDSignature shr 12) and $7;
      if Family = 6 then
      begin
        //Use Extended Family and Extended Model field
        ExtendedModel:=(CPUIDSignature shr 16) and $f;
        //ExtendedFamily:=(CPUID.EAX shr 20 and $ff);
        FModel:=Model + (ExtendedModel shl 4);
      end
      else if Family = 15 then
      begin
        //Use Extended Family and Extended Model field
        ExtendedModel:=(CPUIDSignature shr 16) and $f;
        ExtendedFamily:=(CPUIDSignature shr 20) and $ff;
        FModel:=Model + (ExtendedModel shl 4);
        FFamily:=Family + ExtendedFamily;
      end;

      Log(LOG_VERBOSE, 'Getting CPU vendor information...');
      FVendorNo:=-1;
      for i:=Low(CPUVendorIDs) to High(CPUVendorIDs) do
      begin
        if CPUVendorIDs[i]=CPUIDVendor then
        begin
          FVendor:=CPUVendors[i];
          FVendorNo:=i;
          break;
        end;
      end;
      {$IFDEF CPUNameLookup}
      FName:=GetCPUName(FFamily, FVendorNo, FModel);
      {$ENDIF}
      FSubModel:=GetSubModel;

      GetCPUIDExtLevelAndVendor(FCPUIDExtLevel);
      if FCPUIDExtLevel > $80000000 then
        FCPUIDExtLevel := FCPUIDExtLevel - $80000000
      else
        //Not implemented
        FCPUIDExtLevel := 0;
      if FCPUIDExtLevel > 4 then
      begin
        Log(LOG_VERBOSE, 'Getting CPU brand information...');
        GetCPUIDBrand(CPUIDBrand);
        i:=Low(CPUIDBrand);
        while i <= High(CPUIDBrand) do
        begin
          if CPUIDBrand[i] <> ' ' then
            break;
          Inc(i);
        end;
        j:=High(CPUIDBrand);
        if CPUIDBrand[j] = #0 then
          Dec(j);
        while j >= Low(CPUIDBrand) do
        begin
          if CPUIDBrand[j] <> ' ' then
            break;
          Dec(j);
        end;
        SetString(CPUIDBrand_TMP, PAnsiChar(@(CPUIDBrand[i])), j-i+1);

        if CPUIDBrand_TMP = 'Intel(R) ore(TM) i5-1245U' then //Bug in the Core i5-1245U CPU
            CPUIDBrand_TMP := 'Intel(R) Core(TM) i5-1245U';

        FBrand:=CPUIDBrand_TMP;
      end;
    end;
  end
  else
  begin
    FFamily:=GetCPUType;
    FVendor:='Intel';
    if Family=$f then
      FName:='compatible'
    else
      FName:=Format('80%d86 or compatible', [Family]);
  end;
  {$IFDEF MeasureCPUFrequency}
  if HasRDTSC then
    Freq:=Round(GetCPUFreqEx)
  else
    raise Exception.Create('RDTSC fallback not implemented!'); //FIXME: !
  {$ENDIF}
end;

procedure TCPU.Report(var sl: TStringList);
begin
  with sl do
  begin
    {$IFDEF CPUNameLookup}
    add(format('%d x %s %s',[self.Count,Vendor,Name]));
    {$ELSE}
    add(format('%d x %s CPU',[self.Count,Vendor]));
    {$ENDIF}
    if HasCPUID then
    begin
      if Brand <> '' then
        add(format('Brand: %s',[Brand]));
      add(format('Submodel: %s',[Submodel]));
      add(format('Model ID: Family %d  Model %d  Stepping %d',[Family,Model,Stepping]));
      add(format('CPUID Level: Level %d',[CPUIDLevel]));
      add(format('CPUID Extended Level: Level %d',[CPUIDExtLevel]));
    end
    else
      add(format('Model ID: Family %d',[Family]));
    {$IFDEF MeasureCPUFrequency}
    add(format('Clock: %d MHz',[Freq]));
    {$ENDIF}
    if GetSystemMetrics(SM_SLOWMACHINE) <> 0 then
      add('OS marks this as a low-end (slow) processor.');
  end;
end;

{ TOperatingSystem }

constructor TOperatingSystem.Create;
begin
  inherited;
  FEnv:=TStringList.Create;
  FDirs:=TStringList.Create;
end;

destructor TOperatingSystem.Destroy;
begin
  FEnv.Free;
  FDirs.Free;
  inherited;
end;

procedure TOperatingSystem.GetEnvironment;
var
  b :pchar;
  s :pchar;
begin
  Log(LOG_VERBOSE, 'Gathering environment information...');
  FEnv.Clear;
  b:=GetEnvironmentStrings;
  if b=nil then Exit;
  try
    s:=b;
    while True do
    begin
      if StrLen(s)=0 then
        break;
      FEnv.Add(s);
      Inc(s, StrLen(s) + 1);
    end;
  finally
    FreeEnvironmentStrings(b);
  end;
end;

function GetSpecialFolder(Handle: Hwnd; nFolder: Integer): string;
var
  PIDL: PItemIDList;
  Path: LPTSTR;
  err: HResult;
  AMalloc: IMalloc;
begin
  Result:='';

  err:=SHGetMalloc(AMalloc);
  if not SUCCEEDED(err) then
  begin
    Log(LOG_WARNING, 'Failed to get special folder %d: %s (SHGetMalloc)', [nFolder, SysErrorMessage(err)]);
    Exit;
  end;
  err:=SHGetSpecialFolderLocation(Handle, nFolder, PIDL);
  if not SUCCEEDED(err) then
  begin
    Log(LOG_WARNING, 'Failed to get special folder %d: %s', [nFolder, SysErrorMessage(err)]);
    Exit;
  end;
  try
    Path:=StrAlloc(MAX_PATH);
    try
      if SHGetPathFromIDList(PIDL, Path) then
        Result:=StrPas(Path);
    finally
      StrDispose(Path);
    end;
  finally
    AMalloc.Free(PIDL);
  end;
end;

procedure TOperatingSystem.GetInfo;
var
  SI: TSystemInfo;
  OS: TOSVersionInfoEx;
  {$IFDEF WIN32}
  pProcessMachine, pNativeMachine: USHORT;
  bIsWow64: BOOL;
  {$ENDIF}
  p{$IFDEF DetectWine}, p2{$ENDIF}: pchar;
  n: DWORD;
  WinH: HWND;
  s: string;
  bdata: PByte;
  dummy: Integer;
  rkOSInfo: string;
  {$IFDEF DetectReactOS}rvVersionName, {$ENDIF}(*rvVersionNumber, *)rvType: string;
  {$IFDEF DetectWine}
  h: HMODULE;
  {$ENDIF}
  {$IFDEF LogSensitiveInformation}
  rvInstallDate: string;
  {$ENDIF}
const
  rkOSInfo95 = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\Windows\CurrentVersion';
  rkOSInfoNT = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\Windows NT\CurrentVersion';
  {$IFDEF DetectReactOS}
  rvVersionName95 = 'Version';
  rvVersionNameNT = 'ProductName';
  {$ENDIF}
  //rvVersionNumber95 = 'VersionNumber';
  //rvVersionNumberNT = 'CurrentVersion';
  //rvProductType95 = 'ProductType'; //Overlaps with TOSVersionInfoEx.wProductType
  //rvProductTypeNT = 'SoftwareType'; //Overlaps with TOSVersionInfoEx.wProductType
  rvType95 = 'InstallType';
  rvTypeNT = 'CurrentType';
  rvInstallDate95 = 'FirstInstallDateTime';
  rvInstallDateNT = 'InstallDate';
  rvInstallTime = 'InstallTime'; //Only on Win10+
  rvPlusVersionNumber = 'Plus! VersionNumber'; //Only on Win9x
  //rvBuild = 'CurrentBuild'; //Only on WinNT //Obsolete
  //rvBuildNumber = 'CurrentBuildNumber'; //Only on WinNT //Overlaps with TOSVersionInfo.dwBuildNumber
  //rvCompositionEditionID = 'CompositionEditionID'; //Only on WinVista+
  rvEditionID = 'EditionID'; //Only on WinVista+
  //rvEditionSubManufacturer = 'EditionSubManufacturer'; //Only on WinVista+
  //rvEditionSubstring = 'EditionSubstring'; //Only on WinVista+
  //rvEditionSubVersion = 'EditionSubVersion'; //Only on WinVista+
  rvDisplayVersion = 'DisplayVersion'; //Only on Win10+
  rvReleaseId = 'ReleaseId'; //Only on Win10+
  {$IFDEF LogSensitiveInformation}
  rvRegOrg = 'RegisteredOrganization';
  rvRegOwn = 'RegisteredOwner';
  rvProductID = 'ProductId';
  {$ENDIF}

  cUserProfile = 'USERPROFILE';
  cUserProfileReg = {HKEY_CURRENT_USER\}'SOFTWARE\Microsoft\Windows\CurrentVersion\ProfileList';
  cUserProfileRec = {HKEY_CURRENT_USER\}'SOFTWARE\Microsoft\Windows\CurrentVersion\ProfileReconciliation';
  cProfileDir = 'ProfileDirectory';
begin
  Log(LOG_VERBOSE, 'Starting gathering OS information...');
  FDirs.Clear;

  {$IFDEF DetectWine}
  //Detect Wine and retrieve its version information
  h := GetModuleHandle('ntdll.dll');
  if h <> 0 then
  begin
    wine_get_version := GetProcAddress(h, 'wine_get_version');
    if Assigned(wine_get_version) then
    begin
      p := wine_get_version();
      if p <> nil then
        FWineVersion := StrPas(p);
    end;
    wine_get_build_id := GetProcAddress(h, 'wine_get_build_id');
    if Assigned(wine_get_build_id) then
    begin
      p := wine_get_build_id();
      if p <> nil then
        FWineBuildID := StrPas(p);
    end;
    wine_get_host_version := GetProcAddress(h, 'wine_get_host_version');
    if Assigned(wine_get_build_id) then
    begin
      wine_get_host_version(@p, @p2);
      if p <> nil then
        FWineSysName := StrPas(p);
      if p2 <> nil then
        FWineRelease := StrPas(p2);
    end;
  end;
  {$ENDIF}

  ZeroMemory(@SI,SizeOf(SI));
  if DelayFunc_GetNativeSystemInfo then
    GetNativeSystemInfo(SI)
  else
    GetSystemInfo(SI);
  FArchitecture:=SI.wProcessorArchitecture;

  //See: https://docs.microsoft.com/en-us/windows/win32/api/winnt/ns-winnt-osversioninfoexa
  ZeroMemory(@OS,SizeOf(OS));
  if CheckWin32Version(5, 0) then //Windows 2000
  begin
    FExtended:=True;
    OS.dwOSVersionInfoSize:=SizeOf(TOSVersionInfoEx);
  end
  else
  begin
    FExtended:=False;
    OS.dwOSVersionInfoSize:=SizeOf(TOSVersionInfo);
  end;
  if not GetVersionEx(POSVersionInfo(@OS)^) then
    raise Exception.Create('Unable to retrieve system details. Call to GetVersionEx failed!');

  FMajorVersion:=OS.dwMajorVersion;
  FMinorVersion:=OS.dwMinorVersion;
  FBuildNumber:=OS.dwBuildNumber;
  if FExtended then
  begin
    FServicePackMajor:=OS.wServicePackMajor;
    FServicePackMinor:=OS.wServicePackMinor;
    FSuiteMask:=OS.wSuiteMask;
    FProductType:=OS.wProductType;
  end
  else
  begin
    FServicePackMajor:=0;
    FServicePackMinor:=0;
    FSuiteMask:=0;
    FProductType:=0;
    //See: http://msdn.microsoft.com/en-us/library/ms724833.aspx
  end;

  {$IFDEF WIN32}
  if DelayFunc_IsWow64Process2 then
  begin
    if IsWow64Process2(GetCurrentProcess(), pProcessMachine, pNativeMachine) = false then
    begin
      FWow64:=False;
      Log(LOG_WARNING, 'Failed to determine Wow64 status!');
      LogWindowsError(GetLastError(), 'TOperatingSystem.GetInfo: IsWow64Process2(pProcessMachine)');
    end
    else
      if pProcessMachine=IMAGE_FILE_MACHINE_UNKNOWN then
        FWow64:=False
      else
        FWow64:=True;
      //FIXME: Do something with pNativeMachine too? Otherwise, just NULL it in the IsWow64Process2-call!
  end
  else
  begin
    if DelayFunc_IsWow64Process then
    begin
      if IsWow64Process(GetCurrentProcess(), bIsWow64) = false then
      begin
        FWow64:=False;
        Log(LOG_WARNING, 'Failed to determine Wow64 status!');
        LogWindowsError(GetLastError(), 'TOperatingSystem.GetInfo: IsWow64Process(bIsWow64)');
      end
      else
        if bIsWow64 then
          FWow64:=True
        else
          FWow64:=False;
    end
    else
      FWow64:=False;
  end;
  {$ENDIF}

  case OS.dwPlatformId of
    VER_PLATFORM_WIN32s:
     begin
      FPlatform:='Windows 32s';
      WindowsPlatformCompatibility:=osWin95Comp;
     end;
    VER_PLATFORM_WIN32_WINDOWS:
      case MajorVersion of
      4:
       begin
        case MinorVersion of
        0:
         FPlatform:='Windows 95';
        10:
         FPlatform:='Windows 98';
        90:
         FPlatform:='Windows ME';
        else
         FPlatform:='Unknown (Probably OK)';
        end;
        WindowsPlatformCompatibility:=osWin95Comp;
       end;
      else
       begin
        if MajorVersion>4 then
          FPlatform:='Unknown (Probably OK)'
        else
          FPlatform:='Unknown';
       end;
       WindowsPlatformCompatibility:=osWin95Comp;
      end;
    VER_PLATFORM_WIN32_NT:
      case MajorVersion of
      (*3:
       begin
        case MinorVersion of
        1:
         FPlatform:='Windows NT 3.1';
        5:
         FPlatform:='Windows NT 3.5';
        51:
         FPlatform:='Windows NT 3.51';
        else
         FPlatform:='Windows NT 3?';
        end;
        WindowsPlatformCompatibility:=osWinNTComp;
       end;*)
      4:
       begin
        case MinorVersion of
        0:
         FPlatform:='Windows NT 4';
        else
         FPlatform:='Windows NT 4?';
        end;
        WindowsPlatformCompatibility:=osWinNTComp;
       end;
      5:
       begin
        case MinorVersion of
        0:
         FPlatform:='Windows 2000';
        1:
         begin
          if GetSystemMetrics(SM_TABLETPC) <> 0 then
           FPlatform:='Windows XP Tablet PC'
          else if GetSystemMetrics(SM_MEDIACENTER) <> 0 then
           FPlatform:='Windows XP, Media Center Edition'
          else if GetSystemMetrics(SM_STARTER) <> 0 then
           FPlatform:='Windows XP Starter Edition'
          else
           FPlatform:='Windows XP';
         end;
        2:
         begin
          if GetSystemMetrics(SM_SERVERR2) <> 0 then
           FPlatform:='Windows Server 2003 R2'
          else if OS.wProductType = VER_NT_WORKSTATION then
           begin
            if GetSystemMetrics(SM_TABLETPC) <> 0 then
             FPlatform:='Windows XP Tablet PC 64-bit'
            else if GetSystemMetrics(SM_MEDIACENTER) <> 0 then
             FPlatform:='Windows XP, Media Center Edition 64-bit'
            else if GetSystemMetrics(SM_STARTER) <> 0 then
             FPlatform:='Windows XP Starter Edition 64-bit'
            else
             FPlatform:='Windows XP 64-bit';
           end
          else
           FPlatform:='Windows Server 2003';
         end;
        else
         FPlatform:='Windows NT 5?';
        end;
        WindowsPlatformCompatibility:=osWinNTComp;
       end;
      6:
       begin
        case MinorVersion of
        0:
         begin
          if OS.wProductType = VER_NT_WORKSTATION then
           begin
            if GetSystemMetrics(SM_STARTER) <> 0 then
             FPlatform:='Windows Vista Starter'
            else
             FPlatform:='Windows Vista';
           end
          else
           FPlatform:='Windows Server 2008'; //or Windows Longhorn
         end;
        1:
         begin
          if OS.wProductType = VER_NT_WORKSTATION then
           begin
            if GetSystemMetrics(SM_STARTER) <> 0 then
             FPlatform:='Windows 7 Starter Edition'
            else
             FPlatform:='Windows 7';
           end
          else
           FPlatform:='Windows Server 2008 R2';
         end;
        2:
         begin
          if OS.wProductType = VER_NT_WORKSTATION then
           FPlatform:='Windows 8'
          else
           FPlatform:='Windows Server 2012';
         end;
        3:
         begin
          if OS.wProductType = VER_NT_WORKSTATION then
           FPlatform:='Windows 8.1'
          else
           FPlatform:='Windows Server 2012 R2';
         end;
        else
         FPlatform:='Windows NT 6?';
        end;
        WindowsPlatformCompatibility:=osWinNTComp;
       end;
      10:
       begin
        case MinorVersion of
        0:
         begin
          if OS.wProductType = VER_NT_WORKSTATION then
           begin
            if BuildNumber < 22000 then
             FPlatform:='Windows 10'
            else
             FPlatform:='Windows 11';
           end
          else
           begin
            if ReleaseId = '1607' then
             FPlatform:='Windows Server 2016'
            else if ReleaseId = '1809' then
             FPlatform:='Windows Server 2019'
            else if ReleaseId = '2009' then
             FPlatform:='Windows Server 2022'
            else
             FPlatform:='Windows Server 2016?';
           end;
         end
        else
         FPlatform:='Windows NT 11?';
        end;
        WindowsPlatformCompatibility:=osWinNTComp;
       end;
      else
       begin
        if MajorVersion>6 then
        begin
          FPlatform:='Windows NT?';
          WindowsPlatformCompatibility:=osWinNTComp;
        end
        else
        begin
          FPlatform:='Windows?';
          WindowsPlatformCompatibility:=osWin95Comp;
        end;
       end;
      end;
    else
      raise Exception.Create('Unknown Windows platform detected!');
  end;
  case WindowsPlatformCompatibility of
  osWin95Comp:
   begin
    rkOSInfo:=rkOSInfo95;
    {$IFDEF DetectReactOS}
    rvVersionName:=rvVersionName95;
    {$ENDIF}
    //rvVersionNumber:=rvVersionNumber95;
    rvType:=rvType95;
    {$IFDEF LogSensitiveInformation}
    rvInstallDate:=rvInstallDate95;
    {$ENDIF}
   end;
  osWinNTComp:
   begin
    rkOSInfo:=rkOSInfoNT;
    {$IFDEF DetectReactOS}
    rvVersionName:=rvVersionNameNT;
    {$ENDIF}
    //rvVersionNumber:=rvVersionNumberNT;
    rvType:=rvTypeNT;
    {$IFDEF LogSensitiveInformation}
    rvInstallDate:=rvInstallDateNT;
    {$ENDIF}
   end;
  {$IFDEF DEBUG}
  else
    raise Exception.Create('Unsupported Windows platform!');
  {$ENDIF}
  end;
  FCSD:=StrPas(OS.szCSDVersion);
  {$IFDEF DetectReactOS}
  FVersion:='';
  FBuildLab:='';
  FReactOSVersion:='';
  {$ENDIF}
  //FVersionNumber:='';
  FType:='';
  FPlusVersionNumber:='';
  FEditionID:='';
  FDisplayVersion:='';
  FReleaseId:='';
  {$IFDEF LogSensitiveInformation}
  FRegUser:='';
  FRegOrg:='';
  FSerialNumber:='';
  FInstallDate:=0;
  FInstallTime:=0;
  {$ENDIF}
  FComCtlVersion:=GetComCtlVersion;
  with TRegistry2.Create(KEY_READ) do
  begin
    rootkey:=HKEY_LOCAL_MACHINE;
    if OpenKey(rkOSInfo,false) then
    begin
      {$IFDEF DetectReactOS}
      if ValueExists(rvVersionName) then
        FVersion:=ReadString(rvVersionName);
      if ValueExists('BuildLab') then
        FBuildLab:=ReadString('BuildLab');
      {$ENDIF}
      (*if ValueExists(rvVersionNumber) then
        FVersionNumber:=ReadString(rvVersionNumber);*)
      if ValueExists(rvType) then
      begin
        if WindowsPlatformCompatibility=osWin95Comp then
        begin
          GetMem(bdata, 2);
          try
            dummy:=2;
            if TryReadBinaryData(rvType,bdata^,dummy) then
              case PWord(bdata)^ of
                $0: FType := 'Compact';
                $1: FType := 'Typical';
                $2: FType := 'Portable';
                $3: FType := 'Custom';
                else
                  FType:=IntToStr(PWord(bdata)^);
                end;
          finally
            FreeMem(bdata);
          end;
        end
        else
          FType:=ReadString(rvType);
      end;
      if ValueExists(rvPlusVersionNumber) then
        FPlusVersionNumber:=ReadString(rvPlusVersionNumber);
      if ValueExists(rvEditionID) then
        FEditionID:=ReadString(rvEditionID);
      if ValueExists(rvDisplayVersion) then
        FDisplayVersion:=ReadString(rvDisplayVersion);
      if ValueExists(rvReleaseId) then
        FReleaseId:=ReadString(rvReleaseId);
      {$IFDEF LogSensitiveInformation}
      if ValueExists(rvRegOrg) then
        FRegOrg:=ReadString(rvRegOrg);
      if ValueExists(rvRegOwn) then
        FRegUser:=ReadString(rvRegOwn);
      if ValueExists(rvProductID) then
        FSerialNumber:=ReadString(rvProductID);
      if ValueExists(rvInstallDate) then
      begin
        if WindowsPlatformCompatibility=osWin95Comp then
        begin
          GetMem(bdata, 4);
          try
            dummy:=4;
            if TryReadBinaryData(rvInstallDate,bdata^,dummy) then
              FInstallDate:=PDWORD(bdata)^;
          finally
            FreeMem(bdata);
          end;
        end
        else
          FInstallDate:=ReadDWORD(rvInstallDate);
      end;
      if ValueExists(rvInstallTime) then
        FInstallTime:=ReadQWORD(rvInstallTime);
      {$ENDIF}
      FDirs.Add('CommonFiles='  +ReadString('CommonFilesDir'));
      FDirs.Add('ProgramFiles=' +ReadString('ProgramFilesDir'));
      FDirs.Add('Device='       +ReadString('DevicePath'));
      FDirs.Add('OtherDevice='  +ReadString('OtherDevicePath'));
      FDirs.Add('Media='        +ReadString('MediaPath'));
      FDirs.Add('Config='       +ReadString('ConfigPath'));
      FDirs.Add('Wallpaper='    +ReadString('WallPaperDir'));
      CloseKey;
    end;
    Free;
  end;

  p:=StrAlloc(MAX_PATH+2); //Largest size of the calls below
  try
    n:=MAX_PATH; //Documented to prefer MAX_PATH.
    GetWindowsDirectory(p,n);
    FDirs.Add('Windows='+StrPas(p));

    n:=MAX_PATH+2;
    GetSystemDirectory(p,n);
    FDirs.Add('System='+StrPas(p));

    n:=MAX_PATH+2; //GetTempPath can return MAX_PATH+1, and that's not including the null-terminator.
    GetTempPath(n,p);
    FDirs.Add('Temp='+StrPas(p));
  finally
    StrDispose(p);
  end;

  WinH:=GetDesktopWindow;
  FDirs.Add('AppData='          +GetSpecialFolder(WinH,CSIDL_APPDATA));
  FDirs.Add('CommonDesktopDir=' +GetSpecialFolder(WinH,CSIDL_COMMON_DESKTOPDIRECTORY));
  FDirs.Add('CommonAltStartUp=' +GetSpecialFolder(WinH,CSIDL_COMMON_ALTSTARTUP));
  FDirs.Add('RecycleBin='       +GetSpecialFolder(WinH,CSIDL_BITBUCKET));
  FDirs.Add('CommonPrograms='   +GetSpecialFolder(WinH,CSIDL_COMMON_PROGRAMS));
  FDirs.Add('CommonStartMenu='  +GetSpecialFolder(WinH,CSIDL_COMMON_STARTMENU));
  FDirs.Add('CommonStartup='    +GetSpecialFolder(WinH,CSIDL_COMMON_STARTUP));
  FDirs.Add('CommonFavorites='  +GetSpecialFolder(WinH,CSIDL_COMMON_FAVORITES));
  FDirs.Add('Cookies='          +GetSpecialFolder(WinH,CSIDL_COOKIES));
  FDirs.Add('Controls='         +GetSpecialFolder(WinH,CSIDL_CONTROLS));
  FDirs.Add('Desktop='          +GetSpecialFolder(WinH,CSIDL_DESKTOP));
  FDirs.Add('DesktopDir='       +GetSpecialFolder(WinH,CSIDL_DESKTOPDIRECTORY));
  FDirs.Add('Favorites='        +GetSpecialFolder(WinH,CSIDL_FAVORITES));
  FDirs.Add('Drives='           +GetSpecialFolder(WinH,CSIDL_DRIVES));
  FDirs.Add('Fonts='            +GetSpecialFolder(WinH,CSIDL_FONTS));
  FDirs.Add('History='          +GetSpecialFolder(WinH,CSIDL_HISTORY));
  FDirs.Add('Internet='         +GetSpecialFolder(WinH,CSIDL_INTERNET));
  FDirs.Add('InternetCache='    +GetSpecialFolder(WinH,CSIDL_INTERNET_CACHE));
  FDirs.Add('NetWork='          +GetSpecialFolder(WinH,CSIDL_NETWORK));
  FDirs.Add('NetHood='          +GetSpecialFolder(WinH,CSIDL_NETHOOD));
  FDirs.Add('MyDocuments='      +GetSpecialFolder(WinH,CSIDL_PERSONAL));
  FDirs.Add('PrintHood='        +GetSpecialFolder(WinH,CSIDL_PRINTHOOD));
  FDirs.Add('Printers='         +GetSpecialFolder(WinH,CSIDL_PRINTERS));
  FDirs.Add('Programs='         +GetSpecialFolder(WinH,CSIDL_PROGRAMS));
  FDirs.Add('Recent='           +GetSpecialFolder(WinH,CSIDL_RECENT));
  FDirs.Add('SendTo='           +GetSpecialFolder(WinH,CSIDL_SENDTO));
  FDirs.Add('StartMenu='        +GetSpecialFolder(WinH,CSIDL_STARTMENU));
  FDirs.Add('StartUp='          +GetSpecialFolder(WinH,CSIDL_STARTUP));
  FDirs.Add('Templates='        +GetSpecialFolder(WinH,CSIDL_TEMPLATES));
  s:=ReverseString(FDirs.Values['Desktop']);
  s:=ReverseString(Copy(s,Pos(PathDelim,s)+1,MaxInt));
  FDirs.Add('Profile='+s);
  GetEnvironment;

  {$IFDEF DetectReactOS}
  //This seems to be the current method: https://github.com/reactos/reactos/blob/master/base/shell/cmd/ver.c
  if Version = 'ReactOS' then
    FReactOSVersion:=BuildLab
  else //older fallback
  begin
    //Based on: https://reactos.org/forum/viewtopic.php?p=11684&sid=dbf3bf9a6fce746515d8d090f6b1f366#p11684
    dummy:=StrLen(OS.szCSDVersion) + SizeOf(Char);
    if dummy < SizeOf(OS.szCSDVersion) then
    begin
      p:=@OS.szCSDVersion[0];
      Inc(p, dummy);
      FReactOSVersion:=StrPas(p);
    end;
  end;
  {$ENDIF}
end;

procedure TOperatingSystem.Report(var sl: TStringList);
var
  S: String;
{$IFDEF LogSensitiveInformation}
{$IFDEF Delphi7orNewerCompiler}
  DateFormat: TFormatSettings;
{$ENDIF}
{$ENDIF}
begin
  with sl do
  begin
    add('Platform: ' + Platform);
    case Architecture of
    PROCESSOR_ARCHITECTURE_INTEL: S:='Intel x86';
    PROCESSOR_ARCHITECTURE_MIPS: S:='MIPS';
    PROCESSOR_ARCHITECTURE_ALPHA: S:='DEC Alpha';
    PROCESSOR_ARCHITECTURE_PPC: S:='IBM PowerPC';
    PROCESSOR_ARCHITECTURE_SHX: S:='Hitachi SuperH';
    PROCESSOR_ARCHITECTURE_ARM: S:='ARM';
    PROCESSOR_ARCHITECTURE_IA64: S:='Intel Itanium';
    PROCESSOR_ARCHITECTURE_ALPHA64: S:='DEC Alpha64';
    PROCESSOR_ARCHITECTURE_MSIL: S:='Microsoft Intermediate Language';
    PROCESSOR_ARCHITECTURE_AMD64: S:='AMD64';
    PROCESSOR_ARCHITECTURE_IA32_ON_WIN64: S:='WoW64'; //'x86 emulation on AMD64'
    PROCESSOR_ARCHITECTURE_NEUTRAL: S:='Neutral';
    PROCESSOR_ARCHITECTURE_ARM64: S:='ARM64';
    PROCESSOR_ARCHITECTURE_ARM32_ON_WIN64: S:='ARM32 emulation on AMD64';
    PROCESSOR_ARCHITECTURE_IA32_ON_ARM64: S:='x86 emulation on ARM64';
    PROCESSOR_ARCHITECTURE_UNKNOWN: S:='Unknown';
    else S:='Unknown';
    end;
    add('Architecture: ' + S);

    if Length(EditionID)<>0 then
    begin
      if Length(DisplayVersion)<>0 then
        S:=format('%s %s %s', [EditionID, DisplayVersion, Typ])
      else
        S:=format('%s %s', [EditionID, Typ]);
      add('Edition: ' + S);
    end;

    add(format('Version: %d.%d.%d', [MajorVersion, MinorVersion, BuildNumber]));

    if Length(PlusVersionNumber)<>0 then
      add(format('Plus! Version: %s', [PlusVersionNumber]));

    if Extended then
    begin
      if ServicePackMinor<>0 then
        S:=format('%d.%d', [ServicePackMajor, ServicePackMinor])
      else
        S:=format('%d', [ServicePackMajor]);
      add('Service Pack: ' + S);

      if (SuiteMask and VER_SUITE_SMALLBUSINESS) <> 0 then
        add('Installed suite feature: Microsoft Small Business Server');
      if (SuiteMask and VER_SUITE_ENTERPRISE) <> 0 then
        add('Installed suite feature: Enterprise, Enterprise Edition, or Advanced Server');
      if (SuiteMask and VER_SUITE_BACKOFFICE) <> 0 then
        add('Installed suite feature: Microsoft BackOffice components');
      if (SuiteMask and VER_SUITE_COMMUNICATIONS) <> 0 then
        add('Installed suite feature: Microsoft Office Communications Server');
      if (SuiteMask and VER_SUITE_TERMINAL) <> 0 then
        add('Installed suite feature: Terminal Services');
      if (SuiteMask and VER_SUITE_SMALLBUSINESS_RESTRICTED) <> 0 then
        add('Installed suite feature: Microsoft Small Business Serves (restricted)');
      if (SuiteMask and VER_SUITE_EMBEDDEDNT) <> 0 then
        add('Installed suite feature: Windows XP Embedded');
      if (SuiteMask and VER_SUITE_DATACENTER) <> 0 then
        add('Installed suite feature: Datacenter, Datacenter Edition, or Datacenter Server');
      if (SuiteMask and VER_SUITE_SINGLEUSERTS) <> 0 then
        add('Installed suite feature: Remote Desktop (single user)');
      if (SuiteMask and VER_SUITE_PERSONAL) <> 0 then
        add('Installed suite feature: Home Premium, Home Basic, or Home Edition');
      if (SuiteMask and VER_SUITE_BLADE) <> 0 then
        add('Installed suite feature: Web Edition');
      if (SuiteMask and VER_SUITE_EMBEDDED_RESTRICTED) <> 0 then
        add('Installed suite feature: Embedded (restricted)');
      if (SuiteMask and VER_SUITE_SECURITY_APPLIANCE) <> 0 then
        add('Installed suite feature: Security Appliance');
      if (SuiteMask and VER_SUITE_STORAGE_SERVER) <> 0 then
        add('Installed suite feature: Windows Storage Server');
      if (SuiteMask and VER_SUITE_COMPUTE_SERVER) <> 0 then
        add('Installed suite feature: Compute Cluster Edition');
      if (SuiteMask and VER_SUITE_WH_SERVER) <> 0 then
        add('Installed suite feature: Windows Home Server');
      if (SuiteMask and VER_SUITE_MULTIUSERTS) <> 0 then
        add('Installed suite feature: AppServer mode');

      case ProductType of
        0: S:='Unknown'; //Nothing set
        VER_NT_WORKSTATION: S:='Workstation';
        VER_NT_DOMAIN_CONTROLLER: S:='Domain Controller';
        VER_NT_SERVER: S:='Server';
        else S:='Unknown';
        add('Type: ' + S);
      end;
    end;

    {$IFDEF DetectReactOS}
    if ReactOSVersion<>'' then
      add(format('React OS version: %s', [ReactOSVersion]));
    {$ENDIF}

    {$IFDEF DetectWine}
    if WineVersion<>'' then
      add(format('Wine version: %s (%s) on %s %s', [WineVersion, WineBuildID, WineSysName, WineRelease]));
    {$ENDIF}

    {$IFDEF LogSensitiveInformation}
    add(format('Registered to person: %s', [RegisteredUser]));
    add(format('Registered to company: %s', [RegisteredOrg]));
    add(format('Serial: %s', [SerialNumber]));
    {$IFDEF Delphi7orNewerCompiler}
    GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, DateFormat);
    {$ENDIF}
    if InstallTime<>0 then
      S:=DateTimeToStr(Win64ToDateTime(InstallTime){$IFDEF Delphi7orNewerCompiler}, DateFormat{$ENDIF})
    else
      S:=DateTimeToStr(UnixToDateTime(InstallDate){$IFDEF Delphi7orNewerCompiler}, DateFormat{$ENDIF});
    add('Installed on: ' + S);
    {$ENDIF}

    if ComCtlVersion < ComCtlVersionIE3 then
      S:='Pre-IE 3.0'
    else if ComCtlVersion < ComCtlVersionIE4 then
      S:='IE 3.0'
    else if ComCtlVersion < ComCtlVersionIE401 then
      S:='IE 4.0'
    else if ComCtlVersion < ComCtlVersionIE5 then
      S:='IE 4.01'
    else if ComCtlVersion < ComCtlVersionIE501 then
      S:='IE 5.0'
    else if ComCtlVersion < ComCtlVersionIE6 then
      S:='IE 5.01'
    else
      S:='IE 6.0';
    add(format('Common Controls version: %s (%d)', [S, ComCtlVersion]));

    {$IFDEF WIN32}
    if Wow64 then
      add('Running under Wow64');
    {$ENDIF}
  end;
end;

{ TMemory }

procedure TMemory.GetInfo;
var
  SI: TSystemInfo;
  MS: TMemoryStatus;
  MSEX: TMemoryStatusEx;
begin
  Log(LOG_VERBOSE, 'Starting gathering memory information...');

  {$IFDEF WIN16}
  FMemAvail:=MemAvail;
  FMaxAvail:=MaxAvail;
  FSystemRes:=GetFreeSystemResources(gfsr_SystemResources);
  FGDIRes:=GetFreeSystemResources(gfsr_GDIResources);
  FUserRes:=GetFreeSystemResources(gfsr_UserResources);
  {$ELSE}
  if DelayFunc_GlobalMemoryStatusEx then
  begin
    ZeroMemory(@MSEX,SizeOf(MSEX));
    MSEX.dwLength:=SizeOf(MSEX);
    if GlobalMemoryStatusEx(MSEX) = false then
    begin
      Log(LOG_WARNING, 'Failed to retrieve memory status!');
      LogWindowsError(GetLastError(), 'TMemory.GetInfo: GlobalMemoryStatusEx(TMemoryStatusEx)');
    end;
    FMemoryLoad:=MSEX.dwMemoryLoad;
    FPhysicalTotal:=MSEX.ullTotalPhys;
    FPhysicalFree:=MSEX.ullAvailPhys;
    FVirtualTotal:=MSEX.ullTotalVirtual;
    FVirtualFree:=MSEX.ullAvailVirtual;
    FPageFileTotal:=MSEX.ullTotalPageFile;
    FPageFileFree:=MSEX.ullAvailPageFile;
  end
  else
  begin
    ZeroMemory(@MS,SizeOf(MS));
    MS.dwLength:=SizeOf(MS);
    GlobalMemoryStatus(MS);
    FMemoryLoad:=MS.dwMemoryLoad;
    FPhysicalTotal:=MS.dwTotalPhys;
    FPhysicalFree:=MS.dwAvailPhys;
    FVirtualTotal:=MS.dwTotalVirtual;
    FVirtualFree:=MS.dwAvailVirtual;
    FPageFileTotal:=MS.dwTotalPageFile;
    FPageFileFree:=MS.dwAvailPageFile;
  end;

  ZeroMemory(@SI,SizeOf(SI));
  if DelayFunc_GetNativeSystemInfo then
    GetNativeSystemInfo(SI)
  else
    GetSystemInfo(SI);
  FPageSize:=SI.dwPageSize;
  FMinAppAddress:=Cardinal(SI.lpMinimumApplicationAddress);
  FMaxAppAddress:=Cardinal(SI.lpMaximumApplicationAddress);
  FAllocGranularity:=SI.dwAllocationGranularity;

  if CheckWin32Version(6, 2) then //Windows 7
  begin
    FGlobalGDIObjects:=DelphiCompat.GetGuiResources(GR_GLOBAL, GR_GDIOBJECTS);
    FGlobalUSERObjects:=DelphiCompat.GetGuiResources(GR_GLOBAL, GR_USEROBJECTS);
  end
  else
  begin
    FGlobalGDIObjects:=0;
    FGlobalUSERObjects:=0;
  end;
  {$ENDIF}
end;

procedure TMemory.Report(var sl: TStringList);
begin
  with sl do
  begin
    {$IFDEF WIN16}
    add(format('Available Memory total: %s Bytes', [FormatBytes(MemAvailable)]));
    add(format('Maximum Memory total: %s Bytes', [FormatBytes(MaxAvailable)]));
    {$IFDEF DEBUG}
    add(format('System Resources free: %u%%', [SystemRes]));
    add(format('GDI Resources free: %u%%', [GDIRes]));
    add(format('User Resources free: %u%%' , [UserRes]));
    {$ENDIF}
    {$ELSE}
    //add(format('Memory load: %u%%', [MemoryLoad]));
    add(format('Physical Memory total: %s Bytes', [FormatBytes(PhysicalTotal)]));
    add(format('Physical Memory free: %s Bytes', [FormatBytes(PhysicalFree)]));
    {$IFDEF DEBUG}
    add(format('Virtual Memory total: %s Bytes', [FormatBytes(VirtualTotal)]));
    {$ENDIF}
    add(format('Virtual Memory free: %s Bytes', [FormatBytes(VirtualFree)]));
    {$IFDEF DEBUG}
    add(format('Page File total: %s Bytes', [FormatBytes(PageFileTotal)]));
    add(format('Page File free: %s Bytes', [FormatBytes(PageFileFree)]));
    {$ENDIF}
    //add(format('Memory Page size: %u Bytes', [PageSize]));
    //add(format('Lowest memory address: 0x%x', [MinAppAddress]));
    //add(format('Highest memory address: 0x%x', [MaxAppAddress]));
    //add(format('Allocation granularity: %u Bytes', [AllocGranularity]));
    {$IFDEF DEBUG}
    if GlobalGDIObjects<>0 then
      add(format('Global GDI objects: %u', [GlobalGDIObjects]));
    if GlobalUSERObjects<>0 then
      add(format('Global USER objects: %u', [GlobalUSERObjects]));
    {$ENDIF}
    {$ENDIF}
  end;
end;

{ TWorkstation }

{$IFDEF LogSensitiveInformation}
function GetSystemUpTime: {$ifdef Delphi2007orNewerCompiler}UInt64{$else}Int64{$endif};
begin
  if DelayFunc_GetTickCount64 then
    Result:=GetTickCount64
  else
    Result:=GetTickCount;
end;

function GetMachine: string;
var
  n: dword;
const
  rkMachine = {HKEY_LOCAL_MACHINE\}'SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName';
  rvMachine = 'ComputerName';
begin
  n:=MAX_COMPUTERNAME_LENGTH+1;
  SetLength(Result, n);
  if GetComputerName(PChar(Result), n) then
    SetLength(Result, n)
  else
  begin
    //Fallback: read it from the Registry directly.
    with TRegistry2.Create(KEY_READ) do
    begin
      rootkey:=HKEY_LOCAL_MACHINE;
      if OpenKey(rkMachine, false) then
      begin
        if ValueExists(rvMachine) then
          Result:=ReadString(rvMachine);
        CloseKey;
      end;
      free;
    end;
  end;
end;

function GetUser: string;
var
  n: dword;
begin
  n:=UNLEN+1; //Include room for the 0-terminating character
  SetLength(Result, n);
  if GetUserName(PChar(Result), n) then
    SetLength(Result, n-1); //Cut off the 0-terminating character
end;

function GetFirmware: string;
var
  FirmwareType: _FIRMWARE_TYPE;
begin
  if not DelayFunc_GetFirmwareType then
  begin
    //Windows XP and lower only support BIOS.
    Result:='BIOS';
    Exit;
  end;
  GetFirmwareType(FirmwareType);
  case FirmwareType of
    FirmwareTypeUnknown:
      Result:='Unknown';
    FirmwareTypeBios:
      Result:='BIOS';
    FirmwareTypeUefi:
      Result:='UEFI';
    else
      Result:='Unknown'; //FIXME: Log?
  end;
end;

procedure TWorkstation.GetInfo;
var
  bdata: PByte;
  dummy: Integer;
  //KeyState: TKeyBoardState;
const
  bdatasize = 255;

  cBIOSName = $FE061;
  cBIOSDate = $FFFF5;
  cBIOSExtInfo = $FEC71;
  cBIOSCopyright = $FE091;

  rkBIOS = {HKEY_LOCAL_MACHINE\}'HARDWARE\DESCRIPTION\System';
  rvBiosDate = 'SystemBiosDate';
  rvBiosID = 'Identifier';
  rvBiosVersion = 'SystemBiosVersion';
  // Video BIOS info is available only under NT
  //rvVideoBiosDate = 'VideoBiosDate';
  //rvVideoBiosVersion = 'VideoBiosVersion';
begin
  Log(LOG_VERBOSE, 'Starting gathering workstation information...');
  FSystemUpTime:=GetSystemUpTime;
  FName:=GetMachine;
  FUser:=GetUser;
  FFirmware:=GetFirmware;
  if WindowsPlatformCompatibility=osWinNTComp then
  begin
    with TRegistry2.Create(KEY_READ) do
    begin
      rootkey:=HKEY_LOCAL_MACHINE;
      if OpenKey(rkBIOS,false) then
      begin
        if ValueExists(rvBIOSID) then
          FBiosName:=ReadString(rvBIOSID);
        if ValueExists(rvBIOSVersion) then
        begin
          //Is actually a REG_MULTI_SZ, but Delphi doesn't support that.
          GetMem(bdata, (bdatasize + 1) * SizeOf(Char)); //Note: One larger for null-terminator
          try
            FillChar(bdata^, bdatasize + 1,0);
            dummy:=bdatasize * SizeOf(Char);
            if TryReadBinaryData(rvBIOSVersion,bdata^,dummy) then
              FBIOSCopyright:=StrPas(PChar(bdata));
          finally
            FreeMem(bdata);
          end;
        end;
        if ValueExists(rvBIOSDate) then
          FBIOSDate:=ReadString(rvBIOSDate);
        CloseKey;
      end;
      free;
    end;
  end
  else
  begin
    FBIOSName:=string(pchar(ptr(cBIOSName)));
    FBIOSDate:=string(pchar(ptr(cBIOSDate)));
    FBIOSCopyright:=string(pchar(ptr(cBIOSCopyright)));
    FBIOSExtendedInfo:=string(pchar(ptr(cBIOSExtInfo)));
  end;
  FKeyboardType:=GetKeyboardType(0);
  FKeyboardSubtype:=GetKeyboardType(1);
  FKeyboardNFunctionKeys:=GetKeyboardType(2);
  //GetKeyboardState(KeyState);
  //FCapsLock:=(KeyState[VK_CAPITAL] and $1)=1;
  //FNumLock:=(KeyState[VK_NUMLOCK] and $1)=1;
  //FScrollLock:=(KeyState[VK_SCROLL] and $1)=1;
end;

procedure TWorkstation.Report(var sl: TStringList);
var
  Uptime: TDateTime;
begin
  //To convert the uptime from milliseconds to something we can use in FormatDateTime,
  //we have to work-around the following limitations:
  //- There is no MSecsToDateTime, so we have to go through TTimeStamp first.
  //- MSecsToTimeStamp only takes signed integers.
  //- TimeStampToDateTime doesn't allow Date to be zero.
  //- TDateTime is counting from 12/31/1899, but we want relative time.
  Uptime:=TimeStampToDateTime(MSecsToTimeStamp(SystemUpTime + MSecsPerDay));
  with sl do
  begin
    add('Name: '+Name);
    add('User: '+User);
    add('Firmware: '+Firmware);
    add(format('System Up Time: %d day(s) %s', [Trunc(Uptime) + DateDelta - 1, FormatDateTime('h:nn:ss.zzz', Uptime)]));
    add('BIOS: '+BIOSName);
    add('BIOS date: '+BIOSDate);
    add('BIOS copyright: '+BIOSCopyright);
    add('BIOS info: '+BIOSExtendedInfo);
    case KeyboardType of
     $4: add('Keyboard type: Enhanced 101- or 102-key keyboards (and compatibles)');
     $7: add('Keyboard type: Japanese Keyboard');
     $8: add('Keyboard type: Korean Keyboard');
     $51: add('Keyboard type: Unknown type or HID keyboard');
    else
     add('Keyboard type: Unknown');
    end;
    add(format('Keyboard subtype: %d', [KeyboardSubtype]));
    add(format('Keyboard functions keys: %d', [KeyboardNFunctionKeys]));
    //if CapsLock then
    //  add('Keyboard capslock: On')
    //else
    //  add('Keyboard numlock: Off');
    //if NumLock then
    //  add('Keyboard numlock: On')
    //else
    //  add('Keyboard capslock: Off');
    //if ScrollLock then
    //  add('Keyboard scrolllock: On')
    //else
    //  add('Keyboard scrolllock: Off');
  end;
end;
{$ENDIF}

{ TDisplay }

function GetStringOrBinary(RegKey: TRegistry2; const ValueName, RootKeyName: String) : String;
var
  bdata :pchar;
  keytype :TRegDataType;

const
  bdatasize = 255;

  function GetStrFromBuf(Buffer :pchar) :string;
  var
    i,j :integer;
  begin
    result:='';
    j:=0;
    i:=0;
    repeat
      if buffer[i]<>#0 then
      begin
        result:=result+buffer[i];
        j:=0;
      end
      else
        Inc(j);
      Inc(i);
    until j>1;
  end;
begin
  if not RegKey.ValueExists(ValueName) then
  begin
    Result:='Unknown';
    exit;
  end;

  keytype:=RegKey.GetDataType(ValueName);
  if keytype = rdString then
  begin
    Result:=RegKey.ReadString(ValueName);
    exit;
  end;

  Log(LOG_WARNING, 'The datatype of Registry key %s is incorrect (recoverable)!', [RootKeyName+'\'+RegKey.CurrentPath+'\'+ValueName]); //Note: Can't put in dictionary; no Python loaded yet!
  DriverBugs.Add(RootKeyName+'\'+RegKey.CurrentPath+'\'+ValueName);
  if keytype = rdBinary then
  begin
    bdata:=stralloc(bdatasize+1); //Note: One larger for null-terminator
    try
      FillChar(bdata^,bdatasize+1,0);
      RegKey.readbinarydata(ValueName,bdata^,bdatasize*SizeOf(Char));
      Result:=getstrfrombuf(pchar(bdata));
    finally
      strdispose(bdata);
    end;
  end
  else
  begin
    Log(LOG_WARNING, 'The datatype of Registry key %s is incorrect (unrecoverable)!', [ValueName]); //Note: Can't put in dictionary; no Python loaded yet!
    Result:='Unknown';
  end;
end;

function GetClassDevices(const AStartKey,AClassName,AValueName :string; var AResult :TStrings) :string;
var
  i,j :integer;
  reg :TRegistry2;
  sl :TStringList;
  s,rclass :string;
const
  rvClass = 'Class';
  rvLink = 'Link';
begin
  Result:='';
  AResult.Clear;
  reg:=TRegistry2.Create(KEY_READ);
  with reg do
  begin
    RootKey:=HKEY_LOCAL_MACHINE;
    if OpenKey(AStartKey,false) then
    begin
      sl:=TStringList.Create;
      try
        GetKeyNames(sl);
        CloseKey;
        for i:=0 to sl.Count-1 do
        begin
          if OpenKey(AStartKey+'\'+sl[i],false) then
          begin
            if ValueExists(rvClass) then
            begin
              rclass:=UpperCase(ReadString(rvClass));
              if rclass=UpperCase(AClassName) then
              begin
                if WindowsPlatformCompatibility=osWin95Comp then
                begin
                  s:=UpperCase(ReadString(rvLink));
                  CloseKey;
                  if not OpenKey(AStartKey+'\'+s,False) then
                    Exit;
                end
                else
                  s:=sl[i];
                Result:=AStartKey+'\'+s;
                GetKeyNames(sl);
                CloseKey;
                for j:=0 to sl.count-1 do
                begin
                  if OpenKey(AStartKey+'\'+s+'\'+sl[j],false) then
                  begin
                    if ValueExists(AValueName) then
                      AResult.Add(GetStringOrBinary(reg, AValueName, 'HKEY_LOCAL_MACHINE'));
                    CloseKey;
                  end;
                end;
                Break;
              end;
            end;
            CloseKey;
          end;
        end;
      finally
        sl.free;
      end;
    end;
    free;
  end;
end;

procedure TDisplay.GetInfo;
var
  rk :string;
  idata :DWORD;
  qdata :QWORD;
  sl :tstringlist;
  i :integer;
  j :DWORD;
  reg :TRegistry2;
  DevMode :TDevMode;
  MaxDev :DWORD;
  Found: Boolean;
  l_hdc: HDC;
  ClassKey, S: string;
const
  rkVideoHardware = {HKEY_LOCAL_MACHINE\}'HARDWARE\DEVICEMAP\VIDEO';
  rvVideoKey1 = '\Device\Video';
  rvVideoKey2 = '\\Device\\Video';
  rvHardware = 'HardwareInformation';
  rvHWVideo = 'AdapterString';
  //rvHWBios = 'BiosString';
  rvHWChip = 'ChipType';
  rvHWDAC = 'DacType';
  rvHWMem = 'MemorySize';
  rvHWMemQW = 'qwMemorySize';
  rvProvider = 'ProviderName';
  rvDriverDate = 'DriverDate';
  rvDriverVersion = 'DriverVersion';
  rvDevDesc = 'Device Description';

  rvVideoClass = 'Display';

  rkClassInfo = 'INFO';
  rvCIVideo = 'DriverDesc';
  rvCIDAC = 'DACType';
  rvCIChip = 'ChipType';
  rvCIMem = 'VideoMemory';
  rvCIRev = 'Revision';

  rv3DClass = '3D Accelerators';

  DescValue = 'DriverDesc';
begin
  Log(LOG_VERBOSE, 'Starting gathering of DISPLAY system information...');
  l_hdc := GetDC(0); //FIXME: This only retrieves the primary monitor!
  if l_hdc = 0 then
    raise Exception.Create('Unable to get DC of entire screen');
  try

    FHorzRes:=GetDeviceCaps(l_hdc,windows.HORZRES);
    FVertRes:=GetDeviceCaps(l_hdc,windows.VERTRES);
    FColorDepth:=GetDeviceCaps(l_hdc,BITSPIXEL);

    case GetDeviceCaps(l_hdc,windows.TECHNOLOGY) of
      DT_PLOTTER:    FTechnology:='Vector Plotter';
      DT_RASDISPLAY: FTechnology:='Raster Display';
      DT_RASPRINTER: FTechnology:='Raster Printer';
      DT_RASCAMERA:  FTechnology:='Raster Camera';
      DT_CHARSTREAM: FTechnology:='Character Stream';
      DT_METAFILE:   FTechnology:='Metafile';
      DT_DISPFILE:   FTechnology:='Display File';
    end;

    FHorzSize:=GetDeviceCaps(l_hdc,HORZSIZE);
    FVertSize:=GetDeviceCaps(l_hdc,VERTSIZE);
    FPixelWidth:=GetDeviceCaps(l_hdc,ASPECTX);
    FPixelHeight:=GetDeviceCaps(l_hdc,ASPECTY);
    FPixelDiagonal:=GetDeviceCaps(l_hdc,ASPECTXY);

    FCurveCaps:=[];
    I:=GetDeviceCaps(l_hdc,windows.CURVECAPS);
    if I<>CC_NONE then
    begin
      if (I and CC_CIRCLES)=CC_CIRCLES then
        FCurveCaps:=FCurveCaps+[ccCircles];
      if (I and CC_PIE)=CC_PIE then
        FCurveCaps:=FCurveCaps+[ccPieWedges];
      if (I and CC_CHORD)=CC_CHORD then
        FCurveCaps:=FCurveCaps+[ccChords];
      if (I and CC_ELLIPSES)=CC_ELLIPSES then
        FCurveCaps:=FCurveCaps+[ccEllipses];
      if (I and CC_WIDE)=CC_WIDE then
        FCurveCaps:=FCurveCaps+[ccWideBorders];
      if (I and CC_STYLED)=CC_STYLED then
        FCurveCaps:=FCurveCaps+[ccStyledBorders];
      if (I and CC_WIDESTYLED)=CC_WIDESTYLED then
        FCurveCaps:=FCurveCaps+[ccWideStyledBorders];
      if (I and CC_INTERIORS)=CC_INTERIORS then
        FCurveCaps:=FCurveCaps+[ccInteriors];
      if (I and CC_ROUNDRECT)=CC_ROUNDRECT then
        FCurveCaps:=FCurveCaps+[ccRoundedRects];
    end;

    FLineCaps:=[];
    I:=GetDeviceCaps(l_hdc,windows.LINECAPS);
    if I<>LC_NONE then
    begin
      if (I and LC_POLYLINE)=LC_POLYLINE then
        FLineCaps:=FLineCaps+[lcPolylines];
      if (I and LC_MARKER)=LC_MARKER then
        FLineCaps:=FLineCaps+[lcMarkers];
      if (I and LC_POLYMARKER)=LC_POLYMARKER then
        FLineCaps:=FLineCaps+[lcMultipleMarkers];
      if (I and LC_WIDE)=LC_WIDE then
        FLineCaps:=FLineCaps+[lcWideLines];
      if (I and LC_STYLED)=LC_STYLED then
        FLineCaps:=FLineCaps+[lcStyledLines];
      if (I and LC_WIDESTYLED)=LC_WIDESTYLED then
        FLineCaps:=FLineCaps+[lcWideStyledLines];
      if (I and LC_INTERIORS)=LC_INTERIORS then
        FLineCaps:=FLineCaps+[lcInteriors];
    end;

    FPolygonCaps:=[];
    I:=GetDeviceCaps(l_hdc,POLYGONALCAPS);
    if I<>PC_NONE then
    begin
      if (I and PC_POLYGON)=PC_POLYGON then
        FPolygonCaps:=FPolygonCaps+[pcAltFillPolygons];
      if (I and PC_RECTANGLE)=PC_RECTANGLE then
        FPolygonCaps:=FPolygonCaps+[pcRectangles];
      if (I and PC_WINDPOLYGON)=PC_WINDPOLYGON then
        FPolygonCaps:=FPolygonCaps+[pcWindingFillPolygons];
      if (I and PC_SCANLINE)=PC_SCANLINE then
        FPolygonCaps:=FPolygonCaps+[pcSingleScanlines];
      if (I and PC_WIDE)=PC_WIDE then
        FPolygonCaps:=FPolygonCaps+[pcWideBorders];
      if (I and PC_STYLED)=PC_STYLED then
        FPolygonCaps:=FPolygonCaps+[pcStyledBorders];
      if (I and PC_WIDESTYLED)=PC_WIDESTYLED then
        FPolygonCaps:=FPolygonCaps+[pcWideStyledBorders];
      if (I and PC_INTERIORS)=PC_INTERIORS then
        FPolygonCaps:=FPolygonCaps+[pcInteriors];
    end;

    FRasterCaps:=[];
    I:=GetDeviceCaps(l_hdc,windows.RASTERCAPS);
    if (I and RC_BANDING)=RC_BANDING then
      FRasterCaps:=FRasterCaps+[rcRequiresBanding];
    if (I and RC_BITBLT)=RC_BITBLT then
      FRasterCaps:=FRasterCaps+[rcTranserBitmaps];
    if (I and RC_BITMAP64)=RC_BITMAP64 then
      FRasterCaps:=FRasterCaps+[rcBitmaps64K];
    if (I and RC_DI_BITMAP)=RC_DI_BITMAP then
      FRasterCaps:=FRasterCaps+[rcSetGetDIBits];
    if (I and RC_DIBTODEV)=RC_DIBTODEV then
      FRasterCaps:=FRasterCaps+[rcSetDIBitsToDevice];
    if (I and RC_FLOODFILL)=RC_FLOODFILL then
      FRasterCaps:=FRasterCaps+[rcFloodfills];
    if (I and RC_GDI20_OUTPUT)=RC_GDI20_OUTPUT then
      FRasterCaps:=FRasterCaps+[rcWindows2xFeatures];
    if (I and RC_PALETTE)=RC_PALETTE then
      FRasterCaps:=FRasterCaps+[rcPaletteBased];
    if (I and RC_SCALING)=RC_SCALING then
      FRasterCaps:=FRasterCaps+[rcScaling];
    if (I and RC_STRETCHBLT)=RC_STRETCHBLT then
      FRasterCaps:=FRasterCaps+[rcStretchBlt];
    if (I and RC_STRETCHDIB)=RC_STRETCHDIB then
      FRasterCaps:=FRasterCaps+[rcStretchDIBits];

    FTextCaps:=[];
    I:=GetDeviceCaps(l_hdc,windows.TEXTCAPS);
    if (I and TC_OP_CHARACTER)=TC_OP_CHARACTER then
      FTextCaps:=FTextCaps+[tcCharOutPrec];
    if (I and TC_OP_STROKE)=TC_OP_STROKE then
      FTextCaps:=FTextCaps+[tcStrokeOutPrec];
    if (I and TC_CP_STROKE)=TC_CP_STROKE then
      FTextCaps:=FTextCaps+[tcStrokeClipPrec];
    if (I and TC_CR_90)=TC_CR_90 then
      FTextCaps:=FTextCaps+[tcCharRotation90];
    if (I and TC_CR_ANY)=TC_CR_ANY then
      FTextCaps:=FTextCaps+[tcCharRotationAny];
    if (I and TC_SF_X_YINDEP)=TC_SF_X_YINDEP then
      FTextCaps:=FTextCaps+[tcScaleIndependent];
    if (I and TC_SA_DOUBLE)=TC_SA_DOUBLE then
      FTextCaps:=FTextCaps+[tcDoubledCharScaling];
    if (I and TC_SA_INTEGER)=TC_SA_INTEGER then
      FTextCaps:=FTextCaps+[tcIntMultiScaling];
    if (I and TC_SA_CONTIN)=TC_SA_CONTIN then
      FTextCaps:=FTextCaps+[tcAnyMultiExactScaling];
    if (I and TC_EA_DOUBLE)=TC_EA_DOUBLE then
      FTextCaps:=FTextCaps+[tcDoubleWeightChars];
    if (I and TC_IA_ABLE)=TC_IA_ABLE then
      FTextCaps:=FTextCaps+[tcItalics];
    if (I and TC_UA_ABLE)=TC_UA_ABLE then
      FTextCaps:=FTextCaps+[tcUnderlines];
    if (I and TC_SO_ABLE)=TC_SO_ABLE then
      FTextCaps:=FTextCaps+[tcStrikeouts];
    if (I and TC_RA_ABLE)=TC_RA_ABLE then
      FTextCaps:=FTextCaps+[tcRasterFonts];
    if (I and TC_VA_ABLE)=TC_VA_ABLE then
      FTextCaps:=FTextCaps+[tcVectorFonts];
    if (I and TC_SCROLLBLT)=TC_SCROLLBLT then
      FTextCaps:=FTextCaps+[tcNoScrollUsingBlts];

    FShadeBlendCaps:=[];
    if CheckWindows98And2000 then
    begin
      I:=GetDeviceCaps(l_hdc,windows.SHADEBLENDCAPS);
      if I<>SB_NONE then
      begin
        if (I and SB_CONST_ALPHA)=SB_CONST_ALPHA then
          FShadeBlendCaps:=FShadeBlendCaps+[sbConstAlpha];
        if (I and SB_PIXEL_ALPHA)=SB_PIXEL_ALPHA then
          FShadeBlendCaps:=FShadeBlendCaps+[sbPixelAlpha];
        if (I and SB_PREMULT_ALPHA)=SB_PREMULT_ALPHA then
          FShadeBlendCaps:=FShadeBlendCaps+[sbPremultAlpha];
        if (I and SB_GRAD_RECT)=SB_GRAD_RECT then
          FShadeBlendCaps:=FShadeBlendCaps+[sbGradRect];
        if (I and SB_GRAD_TRI)=SB_GRAD_TRI then
          FShadeBlendCaps:=FShadeBlendCaps+[sbGradTri];
      end;
    end;

    FColorMgmtCaps:=[];
    if CheckWin32Version(5, 0) then //Windows 2000
    begin
      I:=GetDeviceCaps(l_hdc,{windows.}DelphiCompat.COLORMGMTCAPS);
      if I<>CM_NONE then
      begin
        if (I and CM_CMYK_COLOR)=CM_CMYK_COLOR then
          FColorMgmtCaps:=FColorMgmtCaps+[cmCMYKColor];
        if (I and CM_DEVICE_ICM)=CM_DEVICE_ICM then
          FColorMgmtCaps:=FColorMgmtCaps+[cmDeviceICM];
        if (I and CM_GAMMA_RAMP)=CM_GAMMA_RAMP then
          FColorMgmtCaps:=FColorMgmtCaps+[cmGammaRamp];
      end;
    end;
  finally
    ReleaseDC(0, l_hdc);
  end;

  if WindowsPlatformCompatibility=osWinNTComp then
    ClassKey:='SYSTEM\CurrentControlSet\Control\Class'
  else
    ClassKey:='SYSTEM\CurrentControlSet\Services\Class';

  FAdapter.Clear;
  FDevices.Clear;
  FDAC.Clear;
  FChipset.Clear;
  FMemory.Clear;
  FProvider.Clear;
  FDriverDate.Clear;
  FDriverVersion.Clear;
  Log(LOG_VERBOSE, 'Gathering of display driver information...');
  rk:=GetClassDevices(ClassKey,rvVideoClass,DescValue,FDevices);
  Found:=False;

  //Something went wrong!
  if rk='' then
    Exit;

  Log(LOG_VERBOSE, 'Enumerating of display driver information...');
  sl:=TStringList.Create;
  try
    reg:=TRegistry2.Create(KEY_READ);
    with reg do
    begin
      RootKey:=HKEY_LOCAL_MACHINE;
      if OpenKey(rk,false) then
      begin
        GetKeyNames(sl);
        CloseKey;
        for i:=0 to sl.count-1 do
        begin
          if OpenKey(rk+'\'+sl[i]+'\'+rkClassInfo,false) then
          begin
            Found:=True;

            if ValueExists(rvCIDAC) then
              FDAC.Add(ReadString(rvCIDAC))
            else
              FDAC.Add('Unknown');

            if ValueExists(rvCIChip) then
            begin
              FChipset.Add(ReadString(rvCIChip));
              if ValueExists(rvCIRev) then
                FChipset[FChipset.Count-1]:=FChipset[FChipset.Count-1]+' Rev '+ReadString(rvCIRev);
            end
            else
              FChipset.Add('Unknown');

            if ValueExists(rvCIMem) then
              FMemory.Add(FormatBytes(readinteger(rvCIMem)))
            else
              FMemory.Add('Unknown');

            CloseKey;
          end;
        end;
      end;

      if not Found then
      begin
        MaxDev:=0;
        if OpenKey(rkVideoHardware,false) then
        begin
          TryReadDWORD('MaxObjectNumber', MaxDev); //FIXME: Make a const? Also, do we need to read "ObjectNumberList"? --> https://github.com/mdaniel/virtualbox-org-svn-vbox-trunk/blob/master/src/VBox/Additions/common/VBoxControl/VBoxControl.cpp
          CloseKey;
        end;

        for i:=0 to MaxDev do
        begin
          if OpenKey(rkVideoHardware,false) then
          begin
            if not TryReadString(rvVideoKey1+IntToStr(i), rk) then
              if not TryReadString(rvVideoKey2+IntToStr(i), rk) then
                rk:='';
            CloseKey;

            if rk<>'' then
            begin
              rk:=copy(rk,pos('MACHINE\',UpperCase(rk))+8,MaxInt);
              if OpenKey(rk,false) then
              begin
                S:=GetStringOrBinary(reg, rvHardware+'.'+rvHWVideo, 'HKEY_LOCAL_MACHINE');
                if S='Unknown' then
                  TryReadString(rvDevDesc, S);
                FAdapter.Add(S);
                FDAC.Add(GetStringOrBinary(reg, rvHardware+'.'+rvHWDAC, 'HKEY_LOCAL_MACHINE'));
                FChipset.Add(GetStringOrBinary(reg, rvHardware+'.'+rvHWChip, 'HKEY_LOCAL_MACHINE'));

                if ValueExists(rvHardware+'.'+rvHWMemQW) then
                begin
                  idata:=GetRawDataType(rvHardware+'.'+rvHWMemQW);
                  case idata of
                    REG_QWORD:
                    begin
                      qdata:=ReadQWORD(rvHardware+'.'+rvHWMemQW);
                    end;
                    REG_BINARY:
                    begin
                      //Some broken NVidia drivers use BINARY
                      readbinarydata(rvHardware+'.'+rvHWMemQW,idata,8);
                      qdata:=idata;
                    end;
                    else
                    begin
                      Log(LOG_WARNING, 'Could not retrieve Video Hardware Memory size!');
                      qdata:=0;
                    end;
                  end;
                  FMemory.Add(FormatBytes(qdata));
                end
                else if ValueExists(rvHardware+'.'+rvHWMem) then
                begin
                  idata:=GetRawDataType(rvHardware+'.'+rvHWMem);
                  case idata of
                    REG_QWORD:
                    begin
                      //Very modern systems use REG_QWORD (possible from Windows 2000 upwards)
                      qdata:=ReadQWORD(rvHardware+'.'+rvHWMem);
                    end;
                    REG_DWORD:
                    begin
                      //Modern systems use REG_DWORD
                      idata:=ReadDWORD(rvHardware+'.'+rvHWMem);
                      qdata:=idata;
                    end;
                    REG_BINARY:
                    begin
                      //Older systems use REG_BINARY
                      readbinarydata(rvHardware+'.'+rvHWMem,idata,4);
                      qdata:=idata;
                    end;
                    else
                    begin
                      Log(LOG_WARNING, 'Could not retrieve Video Hardware Memory size!');
                      qdata:=0;
                    end;
                  end;
                  FMemory.Add(FormatBytes(qdata));
                end
                else
                  FMemory.Add('Unknown');

                if ValueExists(rvProvider) then
                  FProvider.Add(ReadString(rvProvider))
                else
                  FProvider.Add('Unknown');

                if ValueExists(rvDriverDate) then
                  FDriverDate.Add(ReadString(rvDriverDate))
                else
                  FDriverDate.Add('Unknown');

                if ValueExists(rvDriverVersion) then
                  FDriverVersion.Add(ReadString(rvDriverVersion))
                else
                  FDriverVersion.Add('Unknown');

                CloseKey;
              end;
            end;
          end;
        end;
      end;
      free;
    end;
  finally
    sl.free;
  end;

  Log(LOG_VERBOSE, 'Gathering of 3D accelerator information...');
  FAcc.Clear;
  GetClassDevices(ClassKey,rv3DClass,DescValue,FAcc);

  Log(LOG_VERBOSE, 'Gathering of display modes information...');
  FModes.Clear;
  j:=0;
  ZeroMemory(@DevMode,SizeOf(DevMode));
  DevMode.dmSize:=sizeof(DevMode);
  while EnumDisplaySettings(nil,j,DevMode) do
  begin
    with Devmode do
    begin
      FModes.Add(Format('%d x %d - %d bit - %d Hz',[dmPelsWidth,dmPelsHeight,dmBitsPerPel,dmDisplayFrequency]));
      Inc(j);
    end;
  end;
end;

constructor TDisplay.Create;
begin
  inherited;
  FAdapter:=TStringList.Create;
  FDevices:=TStringList.Create;
  FModes:=TStringList.Create;
  FAcc:=TStringList.Create;
  FDAc:=TStringList.Create;
  FChipset:=TStringList.Create;
  FMemory:=TStringList.Create;
  FProvider:=TStringList.Create;
  FDriverDate:=TStringList.Create;
  FDriverVersion:=TStringList.Create;
end;

destructor TDisplay.Destroy;
begin
  FAdapter.Free;
  FDevices.Free;
  FModes.Free;
  FAcc.Free;
  FDAc.Free;
  FChipset.Free;
  FMemory.Free;
  FProvider.Free;
  FDriverDate.Free;
  FDriverVersion.Free;
  inherited;
end;

procedure TDisplay.Report(var sl: TStringList);
var
  i :integer;
begin
  with sl do
  begin
    for i:=0 to Devices.count-1 do
    begin
      add(format('[Device %d] %s', [i+1,Devices[i]]));
    end;
    for i:=0 to Adapter.count-1 do
    begin
      add(format('[Adapter %d] %s', [i+1,Adapter[i]]));
      add('    Chipset: '   +Chipset[i]);
      add('    DAC: '       +DAC[i]);
      add('    Memory: '    +Memory[i] + ' Bytes');
      add('    Provider: '       +Provider[i]);
      add('    Driver date: '    +DriverDate[i]);
      add('    Driver version: ' +DriverVersion[i]);
    end;
    (*for i:=0 to Accelerator.count-1 do
    begin
      add(format('[Accelerator %d] %s', [i+1,Accelerator[i]]));
    end;*)
    (*for i:=0 to Modes.Count-1 do
    begin
      add(format('[Mode %d] %s', [i+1,Modes[i]]));
    end;*)
  end;
end;

{ TDirectX }

constructor TDirectX.Create;
begin
  inherited;
  FDirect3D:=TStringlist.Create;
end;

destructor TDirectX.Destroy;
begin
  FDirect3D.Free;
  inherited;
end;

procedure TDirectX.GetInfo;
var
  bdata: PArithByte;
  sl: TStringList;
  i: Integer;
const
  rkDirectX = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\DirectX';
  rvDXVersion = 'Version';
  rvDXInstalledVersion = 'InstalledVersion';
  rkDirect3D = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\Direct3D\Drivers';
  rkDirectPlay = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\DirectPlay\Services';
  rkDirectMusic = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\DirectMusic\SoftwareSynths';
  rvDesc = 'Description';
begin
  Log(LOG_VERBOSE, 'Starting gathering of DirectX system information...');
  with TRegistry2.Create(KEY_READ) do
  begin
    rootkey:=HKEY_LOCAL_MACHINE;
    if OpenKey(rkDirectX,false) then
    begin
      FVersion:=ReadString(rvDXVersion);
      if FVersion='' then
      begin
        if ValueExists(rvDXInstalledVersion) then
        begin
          GetMem(bdata, 8);
          try
            try
              readbinarydata(rvDXInstalledVersion,bdata^,8);
            except
              ZeroMemory(bdata, 8);
            end;
            FVersion:=uinttostr(SwapEndian32(PDWORD(bdata)^))+'.'+uinttostr(SwapEndian32((PDWORD(bdata+4))^));
          finally
            FreeMem(bdata);
          end;
        end;
      end;
      CloseKey;
    end;
    FDirect3D.Clear;
    sl:=TStringList.Create;
    try
      if OpenKey(rkDirect3D,false) then
      begin
        GetKeyNames(sl);
        CloseKey;
        for i:=0 to sl.count-1 do
          if OpenKey(rkDirect3D+'\'+sl[i],false) then
          begin
            if ValueExists(rvDesc) then
              FDirect3D.Add(ReadString(rvDesc));
            CloseKey;
          end;
      end;
    finally
      sl.free;
    end;
    free;
  end;
end;

procedure TDirectX.Report(var sl: TStringList);
begin
  with sl do
  begin
    if Version<>'' then
    begin
      add('Installed version: '+Version);
      addstrings(Direct3D);
    end
    else
      add('Not installed.');
  end;
end;

// ---

Procedure GetDelphiDetails(var s: TStringlist);
var
  c: TDelphi;
begin
  c:=TDelphi.Create;
  try
    c.getInfo;
    c.report(s);
  finally
    c.free;
  end;
end;

Procedure GetCPUDetails(var s: TStringlist);
var
  c: TCPU;
begin
  c:=TCPU.Create;
  try
    c.getInfo;
    c.report(s);
  finally
    c.free;
  end;
end;

Procedure GetDisplayDetails(var s: TStringlist);
var
  c: TDisplay;
begin
  c:=TDisplay.Create;
  try
    c.getInfo;
    c.report(s);
  finally
    c.free;
  end;
end;

Procedure GetDirectXDetails(var s: TStringlist);
var
  c: TDirectX;
begin
  c:=TDirectX.Create;
  try
    c.getInfo;
    c.report(s);
  finally
    c.free;
  end;
end;

Procedure GetMemoryDetails(var s: TStringlist);
var
  c: TMemory;
begin
  c:=TMemory.Create;
  try
    c.getInfo;
    c.report(s);
  finally
    c.free;
  end;
end;

{$IFDEF LogSensitiveInformation}
Procedure GetWorkStationDetails(var s: TStringlist);
var
  c: TWorkStation;
begin
  c:=TWorkStation.Create;
  try
    c.getInfo;
    c.report(s);
  finally
    c.free;
  end;
end;
{$ENDIF}

Procedure GetOperatingSystemDetails(var s: TStringlist);
var
  c: TOperatingSystem;
begin
  c:=TOperatingSystem.Create;
  try
    c.getInfo;
    c.report(s);
  finally
    c.free;
  end;
end;

// ---

procedure LogSystemDetails;
var
  s: TStringlist;
  i: Integer;
begin
  Log(LOG_INFO, 'Now logging system details...');
  s:=TStringList.Create;
  try
    s.add('COMPILER:');
    GetDelphiDetails(s);
    s.add('');
    {$IFDEF DEBUG}
    s.add('PROCESS:');
    s.add(format('Process ID: %u', [Windows.GetCurrentProcessId()]));
    s.add(format('Main instance handle: %u', [System.MainInstance]));
    s.add(format('Main thread ID: %u', [System.MainThreadID]));
    s.add(format('Image base address: 0x%p', [Pointer(GetModuleHandle(Nil))]));
    s.add('');
    {$ENDIF}
    s.add('CPU:');
    GetCPUDetails(s);
    s.add('');
    s.add('MEMORY:');
    GetMemoryDetails(s);
    s.add('');
    s.add('OS:');
    GetOperatingSystemDetails(s);
    {$IFDEF LogSensitiveInformation}
    s.add('');
    s.add('MACHINE:');
    GetWorkStationDetails(s);
    {$ENDIF}
    s.add('');
    s.add('VIDEO:');
    GetDisplayDetails(s);
    s.add('');
    s.add('DIRECTX:');
    GetDirectxDetails(s);
    for i:=0 to s.count-1 do
      Log(LOG_SYS, s.strings[i]);
  finally
    s.free;
  end;
end;

procedure WarnDriverBugs;
var
  S: String;
  i: Integer;
begin
  if DriverBugs.Count <> 0 then
  begin
    //Note: Can't put in dictionary; no Python loaded yet!
    S:='Registry corruption detected! One or more driver entries are corrupt. QuArK will continue to run, but some graphical options may be disabled.';
    S:=S+sLineBreak+sLineBreak+'The most probable cause is either registry corruption, or a bad driver. Please contact your video card manufacturer for a corrected driver.';
    S:=S+sLineBreak+sLineBreak+'The following bad keys were found:'+sLineBreak;
    for i:=0 to DriverBugs.Count-1 do
      S:=S+DriverBugs[i]+sLineBreak;
    S:=S+sLineBreak+'This may be caused by a known bad AMD Graphics driver, that gives its "DriverDesc" registry key the wrong data-type (REG_BINARY instead of REG_SZ).'+sLineBreak;
    S:=S+'There are also Intel HD graphics and VMWare drivers that contain the same bug, but with the "HardwareInformation" registry keys.'+sLineBreak;
    S:=S+'For more information, see: https://quark.sourceforge.io/forums/index.php?topic=1064'+sLineBreak+sLineBreak;
    S:=S+'You can disable this check by unchecking Configuration > Startup > Check for bugs.';
    Application.MessageBox(PChar(S), 'QuArK', MB_ICONWARNING or MB_OK);
  end;
end;

function GetPlatformType: TPlatformType;
begin
  Result:=WindowsPlatformCompatibility;
end;

function CheckWindows98And2000: Boolean;
begin
  {$IFNDEF Delphi10_1orNewerCompiler}
  Result:=False;
  {$ENDIF}
  case WindowsPlatformCompatibility of
  osWin95Comp:
    Result:=CheckWin32Version(4, 10); //Windows 98
  osWinNTComp:
    Result:=CheckWin32Version(5, 0); //Windows 2000
  {$IFDEF DEBUG}
  else
    raise Exception.Create('Unsupported Windows platform!');
  {$ENDIF}
  end;
end;

function CheckWindowsMEAnd2000: Boolean;
begin
  {$IFNDEF Delphi10_1orNewerCompiler}
  Result:=False;
  {$ENDIF}
  case WindowsPlatformCompatibility of
  osWin95Comp:
    Result:=CheckWin32Version(4, 90); //Windows ME
  osWinNTComp:
    Result:=CheckWin32Version(5, 0); //Windows 2000
  {$IFDEF DEBUG}
  else
    raise Exception.Create('Unsupported Windows platform!');
  {$ENDIF}
  end;
end;

initialization
begin
  DriverBugs:=TStringList.Create;
end;

finalization
begin
  DriverBugs.Free;
  //DriverBugs:=nil;
end;

end.
