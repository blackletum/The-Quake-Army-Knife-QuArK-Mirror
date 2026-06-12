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
unit DelphiCompat;

{$INCLUDE DelphiCompat.inc}

interface

uses Classes, SysUtils, {$IFDEF Delphi6orNewerCompiler}Types, StrUtils, {$ENDIF}Windows;

//
//   Defines
//

//Note: There's a lot of defines in DelphiVer.inc, so they can get included.

{$IFDEF MSWINDOWS}
  {$IFDEF Delphi2010orNewerCompiler}
    //Delphi 2010 and higher supports delayed loading on Windows.
    {$DEFINE DELAYEDLOADING}
  {$ENDIF}
{$ENDIF}

//
//   Types
//

type
{$ifndef Delphi2orNewerCompiler}
  Cardinal = Word;
  AnsiChar = Char;
  PAnsiChar = PChar;
  AnsiString = String;

  TDateTime = type Double;
{$endif}

{$ifndef Delphi3orNewerCompiler}
  TCustomForm = TForm;
{$endif}

{$ifndef Delphi4orNewerCompiler}
  Int64 = Comp;
  PInt64 = ^Int64;
  LongWord = DWORD;
  PLongWord = ^LongWord;

  TSysCharSet = set of Char;
{$endif}

{$ifndef Delphi6orNewerCompiler}
  //Exist in Delphi 3-, but only in Windows.pas
  PByte = ^Byte;
  PInteger = ^Integer;
  PSingle = ^Single;
  PDouble = ^Double;

  //Exists in Delphi 3-, but only in grids.pas
  PPointer = ^Pointer;

  //Exists in Delphi 5, but only in ibexternals.pas
  PPChar               = ^PChar;

  TIntegerDynArray      = array of Integer;
  {$EXTERNALSYM TIntegerDynArray}
  TCardinalDynArray     = array of Cardinal;
  {$EXTERNALSYM TCardinalDynArray}
  TWordDynArray         = array of Word;
  {$EXTERNALSYM TWordDynArray}
  TSmallIntDynArray     = array of SmallInt;
  {$EXTERNALSYM TSmallIntDynArray}
  TByteDynArray         = array of Byte;
  {$EXTERNALSYM TByteDynArray}
  TShortIntDynArray     = array of ShortInt;
  {$EXTERNALSYM TShortIntDynArray}
  TInt64DynArray        = array of Int64;
  {$EXTERNALSYM TInt64DynArray}
  TLongWordDynArray     = array of LongWord;
  {$EXTERNALSYM TLongWordDynArray}
  TSingleDynArray       = array of Single;
  {$EXTERNALSYM TSingleDynArray}
  TDoubleDynArray       = array of Double;
  {$EXTERNALSYM TDoubleDynArray}
  TBooleanDynArray      = array of Boolean;
  {$EXTERNALSYM TBooleanDynArray}
  TStringDynArray       = array of string;
  {$EXTERNALSYM TStringDynArray}
  TWideStringDynArray   = array of WideString;
  {$EXTERNALSYM TWideStringDynArray}
{$endif}

{$ifndef Delphi2007orNewerCompiler}
  //UInt64 is known to be broken before Delphi 2007, even though since Delphi 7 the compiler recognizes it, so we have to re-define UInt64 to make it work.
  UInt64 = Int64; //Unfortunately, there's no other way. Borland also uses Int64 in ActiveX.pas, so let's do that.
{$endif}

{$ifndef Delphi2009orNewerCompiler}
//NativeInt and NativeUInt are not suitable before Delphi 2009, so let's supply our own.
//More information:
//  https://stackoverflow.com/questions/24507704/difference-between-longint-and-integer-longword-and-cardinal
//  https://stackoverflow.com/questions/7630781/delphi-2007-and-xe2-using-nativeint
//  https://blog.dummzeuch.de/2018/09/08/nativeint-nativeuint-type-in-various-delphi-versions/
//Note that Delphi 2009 has a compiler bug with NativeUInt (http://qc.embarcadero.com/wc/qcmain.aspx?d=71292),
//so we supply a proper NativeUInt for Delphi 2009 as well.
{$IFDEF CPU64BITS}
  NativeInt = Int64; //Integer is 32-bit on 64-bit platforms, so it cannot be used.
{$ELSE}
  NativeInt = Integer;
{$ENDIF}
  PNativeInt = ^NativeInt;

  Int8   = ShortInt;
  Int16  = SmallInt;
  Int32  = Integer;
  UInt8  = Byte;
  UInt16 = Word;
  UInt32 = Cardinal;
{$endif}

{$ifndef Delphi2010orNewerCompiler}
{$IFDEF CPU64BITS}
  NativeUInt = UInt64; //Cardinal is 32-bit on 64-bit platforms, so it cannot be used.
{$ELSE}
  NativeUInt = Cardinal;
{$ENDIF}

  PNativeUInt = ^NativeUInt;
{$endif}

{$ifndef DelphiXE2orNewerCompiler}
  IntPtr  = NativeInt;
  UIntPtr = NativeUInt;
{$endif}

{$ifndef DelphiXE8orNewerCompiler}
{$IFDEF MSWINDOWS}
  FixedInt = LongInt;
  FixedUInt = LongWord;
{$ENDIF}
{$IFDEF POSIX}
  FixedInt = Integer;
  FixedUInt = Cardinal;
{$ENDIF}
  PFixedInt = ^FixedInt;
  PFixedUInt = ^FixedUInt;
  {$EXTERNALSYM FixedInt}
  {$EXTERNALSYM FixedUInt}
{$endif}

{$ifndef Delphi11orNewerCompiler} //FIXME: Missing in Delphi XE2, but existing in Delphi 11.3!
  Float32 = Single;
  Float64 = Double;

  TEndian = (Big, Little);

  TUInt64DynArray       = array of UInt64;
  {$EXTERNALSYM TUInt64DynArray}
{$endif}

  //To support pointer arithmetic, we need a custom datatype, because support for it has changed throughout the years.
  //https://helloacm.com/pointer-arithmetic-in-delphi/
  //Using naming convection suggested by: https://stackoverflow.com/questions/38371432/how-to-handle-pbyte-pointer-operations-in-d5-d7-operator-not-applicable-to-this#comment64189614_38372378
{$ifdef Delphi2009orNewerCompiler}
  ArithByte = Byte;
  PArithByte = PByte;
{$else}
  ArithByte = AnsiChar;
  PArithByte = PAnsiChar;
{$endif}

{$ifndef Delphi10_1orNewerCompiler}
  TBufferedFileStream = TFileStream;
{$endif}

  //Delphi is making the mistake of locking their Unicode implementation to UTF-16; we're better than that.
{$IFDEF UNICODE}
  UnicodeChar = WideChar;
  PUnicodeChar = ^WideChar;
{$ENDIF}

  TMemoryStreamWithCapacity = class(TMemoryStream)
  public
    property Capacity;
  end;

{$ifdef MSWINDOWS}
{$ifndef Delphi2010orNewerCompiler}
  PLPCTSTR = ^LPCTSTR;
  {$EXTERNALSYM PLPCTSTR}
  PLPTSTR = ^LPTSTR;
  {$EXTERNALSYM PLPTSTR}
{$endif}

{$ifndef Delphi2010orNewerCompiler}
  LPBYTE = PByte;
  {$EXTERNALSYM LPBYTE}
{$endif}

  QWORD = UInt64;
  {$EXTERNALSYM QWORD}
  PQWORD = ^QWORD;
  {$EXTERNALSYM PQWORD}
  LPQWORD = PQWORD;
  {$EXTERNALSYM LPQWORD}

{$ifndef Delphi2010orNewerCompiler}
  USHORT = Word;
  {$EXTERNALSYM USHORT}
{$endif}
{$ifndef Delphi11orNewerCompiler} //FIXME: Missing in Delphi XE2, but existing in Delphi 11.3!
  PUSHORT = ^USHORT;
  {$EXTERNALSYM PUSHORT}
{$endif}

{$ifndef Delphi2007orNewerCompiler}
  INT_PTR = Integer;
  {$EXTERNALSYM INT_PTR}
  LONG_PTR = NativeInt;
  {$EXTERNALSYM LONG_PTR}
  UINT_PTR = Cardinal;
  {$EXTERNALSYM UINT_PTR}
  ULONG_PTR = NativeUInt;
  {$EXTERNALSYM ULONG_PTR}

  DWORD_PTR = ULONG_PTR;
  {$EXTERNALSYM DWORD_PTR}
{$endif}
{$ifndef Delphi2010orNewerCompiler}
  HANDLE_PTR = type NativeUInt;
  {$EXTERNALSYM HANDLE_PTR}
{$endif}

{$ifndef DelphiXE2orNewerCompiler} //Note: While Delphi 2010-XE do define these, they are in DXTypes, and that file contains a lot of other interfering definitions, so we can't use that.
  SIZE_T = ULONG_PTR;
  {$EXTERNALSYM SIZE_T}
  SSIZE_T = LONG_PTR;
  {$EXTERNALSYM SSIZE_T}
{$endif}

{$ifndef Delphi2orNewerCompiler}
  LONGLONG = Int64;
  {$EXTERNALSYM LONGLONG}
{$endif}
  PLONGLONG = ^LONGLONG;
  {$EXTERNALSYM PLONGLONG}

{$ifndef Delphi2009orNewerCompiler}
  DWORDLONG = UInt64;
  {$EXTERNALSYM DWORDLONG}
{$endif}
  PDWORDLONG = ^DWORDLONG;
  {$EXTERNALSYM PDWORDLONG}
  LPDWORDLONG = PDWORDLONG;
  {$EXTERNALSYM LPDWORDLONG}

{$ifndef Delphi2007orNewerCompiler}
  ULONGLONG = UInt64;
  {$EXTERNALSYM ULONGLONG}
{$endif}
  PULONGLONG = ^ULONGLONG;
  {$EXTERNALSYM PULONGLONG}

  SCODE = HRESULT;

{$ifndef Delphi2009orNewerCompiler}
  PMemoryStatusEx = ^TMemoryStatusEx;
  _MEMORYSTATUSEX = record
    dwLength: DWORD;
    dwMemoryLoad: DWORD;
    ullTotalPhys: DWORDLONG;
    ullAvailPhys: DWORDLONG;
    ullTotalPageFile: DWORDLONG;
    ullAvailPageFile: DWORDLONG;
    ullTotalVirtual: DWORDLONG;
    ullAvailVirtual: DWORDLONG;
    ullAvailExtendedVirtual: DWORDLONG;
  end;
  {$EXTERNALSYM _MEMORYSTATUSEX}
  TMemoryStatusEx = _MEMORYSTATUSEX;
  MEMORYSTATUSEX = _MEMORYSTATUSEX;
  {$EXTERNALSYM MEMORYSTATUSEX}
{$endif}
{$ifndef Delphi2010orNewerCompiler}
  POSVersionInfoExA = ^TOSVersionInfoExA;
  POSVersionInfoExW = ^TOSVersionInfoExW;
  POSVersionInfoEx = POSVersionInfoExA;
  _OSVERSIONINFOEXA = record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array[0..127] of AnsiChar; { Maintenance string for PSS usage }
    wServicePackMajor: WORD;
    wServicePackMinor: WORD;
    wSuiteMask: WORD;
    wProductType: Byte;
    wReserved: Byte;
  end;
  {$EXTERNALSYM _OSVERSIONINFOEXA}
  _OSVERSIONINFOEXW = record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array[0..127] of WideChar; { Maintenance string for PSS usage }
    wServicePackMajor: WORD;
    wServicePackMinor: WORD;
    wSuiteMask: WORD;
    wProductType: Byte;
    wReserved: Byte;
  end;
  {$EXTERNALSYM _OSVERSIONINFOEXW}
  TOSVersionInfoExA = _OSVERSIONINFOEXA;
  TOSVersionInfoExW = _OSVERSIONINFOEXW;
  {$IFDEF UNICODE}
  TOSVersionInfoEx = TOSVersionInfoExW;
  {$ELSE}
  TOSVersionInfoEx = TOSVersionInfoExA;
  {$ENDIF}

// shell restriction values, parameter for SHRestricted()
  RESTRICTIONS = Int32; //Really: enum
  {$EXTERNALSYM RESTRICTIONS}
  TRestrictions = RESTRICTIONS;
{$endif}

{$ifndef Delphi11orNewerCompiler}
  PProcessMitigationStrictHandleCheckPolicy = ^TProcessMitigationStrictHandleCheckPolicy;
  _PROCESS_MITIGATION_STRICT_HANDLE_CHECK_POLICY = record
    Flags: DWORD;
  end;
  {$EXTERNALSYM _PROCESS_MITIGATION_STRICT_HANDLE_CHECK_POLICY}
  TProcessMitigationStrictHandleCheckPolicy = _PROCESS_MITIGATION_STRICT_HANDLE_CHECK_POLICY;
  PROCESS_MITIGATION_STRICT_HANDLE_CHECK_POLICY = _PROCESS_MITIGATION_STRICT_HANDLE_CHECK_POLICY;
  {$EXTERNALSYM PROCESS_MITIGATION_STRICT_HANDLE_CHECK_POLICY}

  _PROCESS_MITIGATION_POLICY = (
    ProcessDEPPolicy,
    ProcessASLRPolicy,
    ProcessDynamicCodePolicy,
    ProcessStrictHandleCheckPolicy,
    ProcessSystemCallDisablePolicy,
    ProcessMitigationOptionsMask,
    ProcessExtensionPointDisablePolicy,
    ProcessControlFlowGuardPolicy,
    ProcessSignaturePolicy,
    ProcessFontDisablePolicy,
    ProcessImageLoadPolicy,
    MaxProcessMitigationPolicy
  );
  {$EXTERNALSYM _PROCESS_MITIGATION_POLICY}
  PROCESS_MITIGATION_POLICY = _PROCESS_MITIGATION_POLICY;
  {$EXTERNALSYM PROCESS_MITIGATION_POLICY}
  PPROCESS_MITIGATION_POLICY = ^_PROCESS_MITIGATION_POLICY;
  {$EXTERNALSYM PPROCESS_MITIGATION_POLICY}
  TProcessMitigationPolicy = _PROCESS_MITIGATION_POLICY;
  PProcessMitigationPolicy = ^TProcessMitigationPolicy;
{$endif}

  _FIRMWARE_TYPE = Int32; //Really: enum
  {$EXTERNALSYM _FIRMWARE_TYPE}
  PFIRMWARE_TYPE = ^_FIRMWARE_TYPE;
  {$EXTERNALSYM PFIRMWARE_TYPE}
{$endif}

//
//   Consts
//

const
{$ifndef Delphi6orNewerCompiler}
  //Exists in system.pas, but not published.
  reInvalidCast       = 10;

  //Note: Delphi 5- doesn't support 64-bit file access.
  soBeginning = soFromBeginning;
  soCurrent = soFromCurrent;
  soEnd = soFromEnd;

  PathDelim  = {$IFDEF MSWINDOWS} '\'; {$ELSE} '/'; {$ENDIF}
  DriveDelim = {$IFDEF MSWINDOWS} ':'; {$ELSE} '';  {$ENDIF}
  PathSep    = {$IFDEF MSWINDOWS} ';'; {$ELSE} ':'; {$ENDIF}
  sLineBreak = {$IFDEF LINUX} #10 {$ENDIF} {$IFDEF MSWINDOWS} #13#10 {$ENDIF};

  { Days between TDateTime basis (12/31/1899) and Unix time_t basis (1/1/1970) }
  UnixDateDelta = 25569;
{$endif}

{$ifndef Delphi11orNewerCompiler} //FIXME: Missing in Delphi XE2, but existing in Delphi 11.3!
  PlatformEndian: TEndian = {$IFDEF BIGENDIAN}Big{$ELSE}Little{$ENDIF};
{$endif}

  { Days between TDateTime basis (12/31/1899) and Windows 64-bit timestamp basis (1/1/1601) }
  Win64DateDelta = -109207;

{$ifdef MSWINDOWS}
{$ifndef Delphi1orNewerCompiler}
  {$EXTERNALSYM SM_SLOWMACHINE}
  SM_SLOWMACHINE = 73;
{$endif}
{$ifndef Delphi3orNewerCompiler}
  DUPLICATE_CLOSE_SOURCE     = $00000001;
  DUPLICATE_SAME_ACCESS      = $00000002;
  MAILSLOT_NO_MESSAGE                 = LongWord(-1);
  MAILSLOT_WAIT_FOREVER               = LongWord(-1);
{$endif}
{$ifndef Delphi4orNewerCompiler}
  {$EXTERNALSYM GR_GDIOBJECTS}
  GR_GDIOBJECTS = 0;    { Count of GDI objects }
  {$EXTERNALSYM GR_USEROBJECTS}
  GR_USEROBJECTS = 1;    { Count of USER objects }

  ComCtlVersionIE3 = $00040046;
  ComCtlVersionIE4 = $00040047;
  ComCtlVersionIE401 = $00040048;
{$endif}
{$ifndef Delphi5orNewerCompiler}
  ComCtlVersionIE5 = $00050050;
{$endif}
{$ifndef Delphi7orNewerCompiler}
  //These exist in Delphi 6-, but only in the MultiMon unit.
  {$EXTERNALSYM SM_CXVIRTUALSCREEN}
  SM_CXVIRTUALSCREEN = 78;
  {$EXTERNALSYM SM_CYVIRTUALSCREEN}
  SM_CYVIRTUALSCREEN = 79;

  {$EXTERNALSYM BIF_NEWDIALOGSTYLE}
  BIF_NEWDIALOGSTYLE     = $0040;
  {$EXTERNALSYM BIF_BROWSEINCLUDEURLS}
  BIF_BROWSEINCLUDEURLS  = $0080;

  {$EXTERNALSYM BIF_SHAREABLE}
  BIF_SHAREABLE          = $8000;

  ComCtlVersionIE501 = $00050051;
  ComCtlVersionIE6 = $00060000;
{$endif}
{$ifndef Delphi2005orNewerCompiler}
  {$EXTERNALSYM SM_CMONITORS}
  SM_CMONITORS = 80;
  {$EXTERNALSYM SM_SAMEDISPLAYFORMAT}
  SM_SAMEDISPLAYFORMAT = 81;
  {$EXTERNALSYM SM_IMMENABLED}
  SM_IMMENABLED = 82;
  {$EXTERNALSYM SM_CXFOCUSBORDER}
  SM_CXFOCUSBORDER = 83;
  {$EXTERNALSYM SM_CYFOCUSBORDER}
  SM_CYFOCUSBORDER = 84;
{$endif}
{$ifndef Delphi2006orNewerCompiler}
  IMAGE_FILE_LARGE_ADDRESS_AWARE           = $0020;  { App can handle >2gb addresses }
  {$EXTERNALSYM IMAGE_FILE_LARGE_ADDRESS_AWARE}
{$endif}
{$ifndef Delphi2007orNewerCompiler}
  {$EXTERNALSYM SM_REMOTESESSION}
  SM_REMOTESESSION = $1000;

  {$EXTERNALSYM DWM_EC_DISABLECOMPOSITION}
  DWM_EC_DISABLECOMPOSITION         = 0;
  {$EXTERNALSYM DWM_EC_ENABLECOMPOSITION}
  DWM_EC_ENABLECOMPOSITION          = 1;
{$endif}
{$ifndef Delphi2009orNewerCompiler}
  {$EXTERNALSYM SM_TABLETPC}
  SM_TABLETPC = 86;
  {$EXTERNALSYM SM_MEDIACENTER}
  SM_MEDIACENTER = $87;
  {$EXTERNALSYM SM_SHUTTINGDOWN}
  SM_SHUTTINGDOWN = $2000;
  {$EXTERNALSYM SM_REMOTECONTROL}
  SM_REMOTECONTROL = $2001;
{$endif}
{$ifndef Delphi2010orNewerCompiler}
  {$EXTERNALSYM GR_GDIOBJECTS_PEAK}
  GR_GDIOBJECTS_PEAK = 2;
  {$EXTERNALSYM GR_USEROBJECTS_PEAK}
  GR_USEROBJECTS_PEAK = 4;
  {$EXTERNALSYM GR_GLOBAL}
  GR_GLOBAL = THandle(-2);

  {$EXTERNALSYM SM_STARTER}
  SM_STARTER = 88;
  {$EXTERNALSYM SM_SERVERR2}
  SM_SERVERR2 = 89;

  REST_NONE                        = $00000000;
  {$EXTERNALSYM REST_NONE}
  REST_NORUN                       = $00000001;
  {$EXTERNALSYM REST_NORUN}
  REST_NOCLOSE                     = $00000002;
  {$EXTERNALSYM REST_NOCLOSE}
  REST_NOSAVESET                   = $00000004;
  {$EXTERNALSYM REST_NOSAVESET}
  REST_NOFILEMENU                  = $00000008;
  {$EXTERNALSYM REST_NOFILEMENU}
  REST_NOSETFOLDERS                = $00000010;
  {$EXTERNALSYM REST_NOSETFOLDERS}
  REST_NOSETTASKBAR                = $00000020;
  {$EXTERNALSYM REST_NOSETTASKBAR}
  REST_NODESKTOP                   = $00000040;
  {$EXTERNALSYM REST_NODESKTOP}
  REST_NOFIND                      = $00000080;
  {$EXTERNALSYM REST_NOFIND}
  REST_NODRIVES                    = $00000100;
  {$EXTERNALSYM REST_NODRIVES}
  REST_NODRIVEAUTORUN              = $00000200;
  {$EXTERNALSYM REST_NODRIVEAUTORUN}
  REST_NODRIVETYPEAUTORUN          = $00000400;
  {$EXTERNALSYM REST_NODRIVETYPEAUTORUN}
  REST_NONETHOOD                   = $00000800;
  {$EXTERNALSYM REST_NONETHOOD}
  REST_STARTBANNER                 = $00001000;
  {$EXTERNALSYM REST_STARTBANNER}
  REST_RESTRICTRUN                 = $00002000;
  {$EXTERNALSYM REST_RESTRICTRUN}
  REST_NOPRINTERTABS               = $00004000;
  {$EXTERNALSYM REST_NOPRINTERTABS}
  REST_NOPRINTERDELETE             = $00008000;
  {$EXTERNALSYM REST_NOPRINTERDELETE}
  REST_NOPRINTERADD                = $00010000;
  {$EXTERNALSYM REST_NOPRINTERADD}
  REST_NOSTARTMENUSUBFOLDERS       = $00020000;
  {$EXTERNALSYM REST_NOSTARTMENUSUBFOLDERS}
  REST_MYDOCSONNET                 = $00040000;
  {$EXTERNALSYM REST_MYDOCSONNET}
  REST_NOEXITTODOS                 = $00080000;
  {$EXTERNALSYM REST_NOEXITTODOS}
  REST_ENFORCESHELLEXTSECURITY     = $00100000;
  {$EXTERNALSYM REST_ENFORCESHELLEXTSECURITY}
  REST_LINKRESOLVEIGNORELINKINFO   = $00200000;
  {$EXTERNALSYM REST_LINKRESOLVEIGNORELINKINFO}
  REST_NOCOMMONGROUPS              = $00400000;
  {$EXTERNALSYM REST_NOCOMMONGROUPS}
  REST_SEPARATEDESKTOPPROCESS      = $00800000;
  {$EXTERNALSYM REST_SEPARATEDESKTOPPROCESS}
  REST_NOWEB                       = $01000000;
  {$EXTERNALSYM REST_NOWEB}
  REST_NOTRAYCONTEXTMENU           = $02000000;
  {$EXTERNALSYM REST_NOTRAYCONTEXTMENU}
  REST_NOVIEWCONTEXTMENU           = $04000000;
  {$EXTERNALSYM REST_NOVIEWCONTEXTMENU}
  REST_NONETCONNECTDISCONNECT      = $08000000;
  {$EXTERNALSYM REST_NONETCONNECTDISCONNECT}
  REST_STARTMENULOGOFF             = $10000000;
  {$EXTERNALSYM REST_STARTMENULOGOFF}
  REST_NOSETTINGSASSIST            = $20000000;
  {$EXTERNALSYM REST_NOSETTINGSASSIST}
  REST_NOINTERNETICON              = $40000001;
  {$EXTERNALSYM REST_NOINTERNETICON}
  REST_NORECENTDOCSHISTORY         = $40000002;
  {$EXTERNALSYM REST_NORECENTDOCSHISTORY}
  REST_NORECENTDOCSMENU            = $40000003;
  {$EXTERNALSYM REST_NORECENTDOCSMENU}
  REST_NOACTIVEDESKTOP             = $40000004;
  {$EXTERNALSYM REST_NOACTIVEDESKTOP}
  REST_NOACTIVEDESKTOPCHANGES      = $40000005;
  {$EXTERNALSYM REST_NOACTIVEDESKTOPCHANGES}
  REST_NOFAVORITESMENU             = $40000006;
  {$EXTERNALSYM REST_NOFAVORITESMENU}
  REST_CLEARRECENTDOCSONEXIT       = $40000007;
  {$EXTERNALSYM REST_CLEARRECENTDOCSONEXIT}
  REST_CLASSICSHELL                = $40000008;
  {$EXTERNALSYM REST_CLASSICSHELL}
  REST_NOCUSTOMIZEWEBVIEW          = $40000009;
  {$EXTERNALSYM REST_NOCUSTOMIZEWEBVIEW}
  REST_NOHTMLWALLPAPER             = $40000010;
  {$EXTERNALSYM REST_NOHTMLWALLPAPER}
  REST_NOCHANGINGWALLPAPER         = $40000011;
  {$EXTERNALSYM REST_NOCHANGINGWALLPAPER}
  REST_NODESKCOMP                  = $40000012;
  {$EXTERNALSYM REST_NODESKCOMP}
  REST_NOADDDESKCOMP               = $40000013;
  {$EXTERNALSYM REST_NOADDDESKCOMP}
  REST_NODELDESKCOMP               = $40000014;
  {$EXTERNALSYM REST_NODELDESKCOMP}
  REST_NOCLOSEDESKCOMP             = $40000015;
  {$EXTERNALSYM REST_NOCLOSEDESKCOMP}
  REST_NOCLOSE_DRAGDROPBAND        = $40000016;     // Disable Close and Drag & Drop on ALL Bands
  {$EXTERNALSYM REST_NOCLOSE_DRAGDROPBAND}
  REST_NOMOVINGBAND                = $40000017;     // Disable Moving ALL Bands
  {$EXTERNALSYM REST_NOMOVINGBAND}
  REST_NOEDITDESKCOMP              = $40000018;
  {$EXTERNALSYM REST_NOEDITDESKCOMP}
  REST_NORESOLVESEARCH             = $40000019;
  {$EXTERNALSYM REST_NORESOLVESEARCH}
  REST_NORESOLVETRACK              = $4000001A;
  {$EXTERNALSYM REST_NORESOLVETRACK}
  REST_FORCECOPYACLWITHFILE        = $4000001B;
  {$EXTERNALSYM REST_FORCECOPYACLWITHFILE}
  REST_NOLOGO3CHANNELNOTIFY        = $4000001C;
  {$EXTERNALSYM REST_NOLOGO3CHANNELNOTIFY}
  REST_NOFORGETSOFTWAREUPDATE      = $4000001D;
  {$EXTERNALSYM REST_NOFORGETSOFTWAREUPDATE}
  REST_NOSETACTIVEDESKTOP          = $4000001E;     // No Active desktop on Settings Menu
  {$EXTERNALSYM REST_NOSETACTIVEDESKTOP}
  REST_NOUPDATEWINDOWS             = $4000001F;     // No Windows Update on Settings Menu
  {$EXTERNALSYM REST_NOUPDATEWINDOWS}
  REST_NOCHANGESTARMENU            = $40000020;     // No Context menu or Drag and Drop on Start menu
  {$EXTERNALSYM REST_NOCHANGESTARMENU}
  REST_NOFOLDEROPTIONS             = $40000021;     // No Folder Options on Settings Menu
  {$EXTERNALSYM REST_NOFOLDEROPTIONS}
  REST_HASFINDCOMPUTERS            = $40000022;     // Show Start/Search/Computers
  {$EXTERNALSYM REST_HASFINDCOMPUTERS}
  REST_INTELLIMENUS                = $40000023;
  {$EXTERNALSYM REST_INTELLIMENUS}
  REST_RUNDLGMEMCHECKBOX           = $40000024;
  {$EXTERNALSYM REST_RUNDLGMEMCHECKBOX}
  REST_ARP_ShowPostSetup           = $40000025;     // ARP: Show Post-Setup page
  {$EXTERNALSYM REST_ARP_ShowPostSetup}
  REST_NOCSC                       = $40000026;     // Disable the ClientSide caching on SM
  {$EXTERNALSYM REST_NOCSC}
  REST_NOCONTROLPANEL              = $40000027;     // Remove the Control Panel only from SM|Settings
  {$EXTERNALSYM REST_NOCONTROLPANEL}
  REST_ENUMWORKGROUP               = $40000028;     // Enumerate workgroup in root of nethood
  {$EXTERNALSYM REST_ENUMWORKGROUP}
  REST_ARP_NOARP                   = $40000029;     // ARP: Don't Allow ARP to come up at all
  {$EXTERNALSYM REST_ARP_NOARP}
  REST_ARP_NOREMOVEPAGE            = $4000002A;     // ARP: Don't allow Remove page
  {$EXTERNALSYM REST_ARP_NOREMOVEPAGE}
  REST_ARP_NOADDPAGE               = $4000002B;     // ARP: Don't allow Add page
  {$EXTERNALSYM REST_ARP_NOADDPAGE}
  REST_ARP_NOWINSETUPPAGE          = $4000002C;     // ARP: Don't allow opt components page
  {$EXTERNALSYM REST_ARP_NOWINSETUPPAGE}
  REST_GREYMSIADS                  = $4000002D;      // SM: Allow the greying of Darwin Ads in SM
  {$EXTERNALSYM REST_GREYMSIADS}
  REST_NOCHANGEMAPPEDDRIVELABEL    = $4000002E;     // Don't enable the UI which allows users to rename mapped drive labels
  {$EXTERNALSYM REST_NOCHANGEMAPPEDDRIVELABEL}
  REST_NOCHANGEMAPPEDDRIVECOMMENT  = $4000002F;     // Don't enable the UI which allows users to change mapped drive comments
  {$EXTERNALSYM REST_NOCHANGEMAPPEDDRIVECOMMENT}
  REST_MaxRecentDocs               = $40000030;
  {$EXTERNALSYM REST_MaxRecentDocs}
  REST_NONETWORKCONNECTIONS        = $40000031;     // No Start Menu | Settings |Network Connections
  {$EXTERNALSYM REST_NONETWORKCONNECTIONS}
  REST_FORCESTARTMENULOGOFF        = $40000032;     // Force logoff on the Start Menu
  {$EXTERNALSYM REST_FORCESTARTMENULOGOFF}
  REST_NOWEBVIEW                   = $40000033;     // Disable Web View
  {$EXTERNALSYM REST_NOWEBVIEW}
  REST_NOCUSTOMIZETHISFOLDER       = $40000034;     // Disable Customize This Folder
  {$EXTERNALSYM REST_NOCUSTOMIZETHISFOLDER}
  REST_NOENCRYPTION                = $40000035;     // Don't allow file encryption
  {$EXTERNALSYM REST_NOENCRYPTION}
//  Do NOT use me                     0x40000036,
  REST_DONTSHOWSUPERHIDDEN         = $40000037;     // don't show super hidden files
  {$EXTERNALSYM REST_DONTSHOWSUPERHIDDEN}
  REST_NOSHELLSEARCHBUTTON         = $40000038;
  {$EXTERNALSYM REST_NOSHELLSEARCHBUTTON}
  REST_NOHARDWARETAB               = $40000039;     // No Hardware tab on Drives or in control panel
  {$EXTERNALSYM REST_NOHARDWARETAB}
  REST_NORUNASINSTALLPROMPT        = $4000003A;     // Don't bring up "Run As" prompt for install programs
  {$EXTERNALSYM REST_NORUNASINSTALLPROMPT}
  REST_PROMPTRUNASINSTALLNETPATH   = $4000003B;     // Force the  "Run As" prompt for install programs on unc/network shares
  {$EXTERNALSYM REST_PROMPTRUNASINSTALLNETPATH}
  REST_NOMANAGEMYCOMPUTERVERB      = $4000003C;     // No Manage verb on My Computer
  {$EXTERNALSYM REST_NOMANAGEMYCOMPUTERVERB}
//  Do NOT use me                     0x4000003D,
  REST_DISALLOWRUN                 = $4000003E;     // don't allow certain apps to be run
  {$EXTERNALSYM REST_DISALLOWRUN}
  REST_NOWELCOMESCREEN             = $4000003F;     // don't allow the welcome screen to be displayed.
  {$EXTERNALSYM REST_NOWELCOMESCREEN}
  REST_RESTRICTCPL                 = $40000040;     // only allow certain cpls to be run
  {$EXTERNALSYM REST_RESTRICTCPL}
  REST_DISALLOWCPL                 = $40000041;     // don't allow certain cpls to be run
  {$EXTERNALSYM REST_DISALLOWCPL}
  REST_NOSMBALLOONTIP              = $40000042;     // No Start Menu Balloon Tip
  {$EXTERNALSYM REST_NOSMBALLOONTIP}
  REST_NOSMHELP                    = $40000043;     // No Help on the Start Menu
  {$EXTERNALSYM REST_NOSMHELP}
  REST_NOWINKEYS                   = $40000044;     // No Windows-X Hot keys
  {$EXTERNALSYM REST_NOWINKEYS}
  REST_NOENCRYPTONMOVE             = $40000045;     // Don't automatically try to encrypt files that are moved to encryped directories
  {$EXTERNALSYM REST_NOENCRYPTONMOVE}
  REST_NOLOCALMACHINERUN           = $40000046;     // ignore HKLM\sw\ms\win\cv\Run and all of it's sub keys
  {$EXTERNALSYM REST_NOLOCALMACHINERUN}
  REST_NOCURRENTUSERRUN            = $40000047;     // ignore HKCU\sw\ms\win\cv\Run and all of it's sub keys
  {$EXTERNALSYM REST_NOCURRENTUSERRUN}
  REST_NOLOCALMACHINERUNONCE       = $40000048;     // ignore HKLM\sw\ms\win\cv\RunOnce and all of it's sub keys
  {$EXTERNALSYM REST_NOLOCALMACHINERUNONCE}
  REST_NOCURRENTUSERRUNONCE        = $40000049;     // ignore HKCU\sw\ms\win\cv\RunOnce and all of it's sub keys
  {$EXTERNALSYM REST_NOCURRENTUSERRUNONCE}
  REST_FORCEACTIVEDESKTOPON        = $4000004A;     // Force ActiveDesktop to be turned ON all the time.
  {$EXTERNALSYM REST_FORCEACTIVEDESKTOPON}
//  Do NOT use me                     0x4000004B,
  REST_NOVIEWONDRIVE               = $4000004C;     // disallows CreateViewObject() on specified drives (CFSFolder only)
  {$EXTERNALSYM REST_NOVIEWONDRIVE}
  REST_NONETCRAWL                  = $4000004D;     // disables the crawling of the WNet namespace.
  {$EXTERNALSYM REST_NONETCRAWL}
  REST_NOSHAREDDOCUMENTS           = $4000004E;     // don't auto share the Shared Documents/create link
  {$EXTERNALSYM REST_NOSHAREDDOCUMENTS}
  REST_NOSMMYDOCS                  = $4000004F;     // Don't show the My Documents item on the Start Menu.
  {$EXTERNALSYM REST_NOSMMYDOCS}
  REST_NOSMMYPICS                  = $40000050;     // Don't show the My Pictures item on the Start Menu
  {$EXTERNALSYM REST_NOSMMYPICS}
  REST_ALLOWBITBUCKDRIVES          = $40000051;     // Bit mask indicating which which drives have bit bucket support
  {$EXTERNALSYM REST_ALLOWBITBUCKDRIVES}
  REST_NONLEGACYSHELLMODE          = $40000052;     // new consumer shell modes
  {$EXTERNALSYM REST_NONLEGACYSHELLMODE}
  REST_NOCONTROLPANELBARRICADE     = $40000053;     // The webview barricade in Control Panel
  {$EXTERNALSYM REST_NOCONTROLPANELBARRICADE}
  REST_NOSTARTPAGE                 = $40000054;     // Whistler Start Page on desktop.
  {$EXTERNALSYM REST_NOSTARTPAGE}
  REST_NOAUTOTRAYNOTIFY            = $40000055;     // Whistler auto-tray notify feature
  {$EXTERNALSYM REST_NOAUTOTRAYNOTIFY}
  REST_NOTASKGROUPING              = $40000056;     // Whistler taskbar button grouping feature
  {$EXTERNALSYM REST_NOTASKGROUPING}
  REST_NOCDBURNING                 = $40000057;     // whistler cd burning feature
  {$EXTERNALSYM REST_NOCDBURNING}
  REST_MYCOMPNOPROP                = $40000058;     // disables Properties on My Computer's context menu
  {$EXTERNALSYM REST_MYCOMPNOPROP}
  REST_MYDOCSNOPROP                = $40000059;     // disables Properties on My Documents' context menu
  {$EXTERNALSYM REST_MYDOCSNOPROP}
  REST_NOSTARTPANEL                = $4000005A;     // Windows start panel (New start menu) for Whistler.
  {$EXTERNALSYM REST_NOSTARTPANEL}
  REST_NODISPLAYAPPEARANCEPAGE     = $4000005B;     // disable Themes and Appearance tabs in the Display Control Panel.
  {$EXTERNALSYM REST_NODISPLAYAPPEARANCEPAGE}
  REST_NOTHEMESTAB                 = $4000005C;     // disable the Themes tab in the Display Control Panel.
  {$EXTERNALSYM REST_NOTHEMESTAB}
  REST_NOVISUALSTYLECHOICE         = $4000005D;     // disable the visual style drop down in the Appearance tab of the Display Control Panel.
  {$EXTERNALSYM REST_NOVISUALSTYLECHOICE}
  REST_NOSIZECHOICE                = $4000005E;     // disable the size drop down in the Appearance tab of the Display Control Panel.
  {$EXTERNALSYM REST_NOSIZECHOICE}
  REST_NOCOLORCHOICE               = $4000005F;     // disable the color drop down in the Appearance tab of the Display Control Panel.
  {$EXTERNALSYM REST_NOCOLORCHOICE}
  REST_SETVISUALSTYLE              = $40000060;     // Load the specified file as the visual style.
  {$EXTERNALSYM REST_SETVISUALSTYLE}
  REST_STARTRUNNOHOMEPATH          = $40000061;     // dont use the %HOMEPATH% env var for the Start-Run dialog
  {$EXTERNALSYM REST_STARTRUNNOHOMEPATH}
  REST_NOUSERNAMEINSTARTPANEL      = $40000062;     // don't show the username is the startpanel.
  {$EXTERNALSYM REST_NOUSERNAMEINSTARTPANEL}
  REST_NOMYCOMPUTERICON            = $40000063;     // don't show my computer anywhere, hide its contents
  {$EXTERNALSYM REST_NOMYCOMPUTERICON}
  REST_NOSMNETWORKPLACES           = $40000064;     // don't show network places in startpanel.
  {$EXTERNALSYM REST_NOSMNETWORKPLACES}
  REST_NOSMPINNEDLIST              = $40000065;     // don't show the pinned list in startpanel.
  {$EXTERNALSYM REST_NOSMPINNEDLIST}
  REST_NOSMMYMUSIC                 = $40000066;     // don't show MyMusic folder in startpanel
  {$EXTERNALSYM REST_NOSMMYMUSIC}
  REST_NOSMEJECTPC                 = $40000067;     // don't show "Undoc PC" command in startmenu
  {$EXTERNALSYM REST_NOSMEJECTPC}
  REST_NOSMMOREPROGRAMS            = $40000068;     // don't show "More Programs" button in StartPanel.
  {$EXTERNALSYM REST_NOSMMOREPROGRAMS}
  REST_NOSMMFUPROGRAMS             = $40000069;     // don't show the MFU programs list in StartPanel.
  {$EXTERNALSYM REST_NOSMMFUPROGRAMS}
  REST_NOTRAYITEMSDISPLAY          = $4000006A;     // disables the display of the system tray
  {$EXTERNALSYM REST_NOTRAYITEMSDISPLAY}
  REST_NOTOOLBARSONTASKBAR         = $4000006B;     // disables toolbar display on the taskbar
  {$EXTERNALSYM REST_NOTOOLBARSONTASKBAR}
  REST_NOSMCONFIGUREPROGRAMS       = $4000006F;     // No Configure Programs on Settings Menu
  {$EXTERNALSYM REST_NOSMCONFIGUREPROGRAMS}
  REST_HIDECLOCK                   = $40000070;     // don't show the clock
  {$EXTERNALSYM REST_HIDECLOCK}
  REST_NOLOWDISKSPACECHECKS        = $40000071;     // disable the low disk space checking
  {$EXTERNALSYM REST_NOLOWDISKSPACECHECKS}
  REST_NOENTIRENETWORK             = $40000072;     // removes the "Entire Network" link (i.e. from "My Network Places")
  {$EXTERNALSYM REST_NOENTIRENETWORK}
  REST_NODESKTOPCLEANUP            = $40000073;     // disable the desktop cleanup wizard
  {$EXTERNALSYM REST_NODESKTOPCLEANUP}
  REST_BITBUCKNUKEONDELETE         = $40000074;     // disables recycling of files
  {$EXTERNALSYM REST_BITBUCKNUKEONDELETE}
  REST_BITBUCKCONFIRMDELETE        = $40000075;     // always show the delete confirmation dialog when deleting files
  {$EXTERNALSYM REST_BITBUCKCONFIRMDELETE}
  REST_BITBUCKNOPROP               = $40000076;     // disables Properties on Recycle Bin's context menu
  {$EXTERNALSYM REST_BITBUCKNOPROP}
  REST_NODISPBACKGROUND            = $40000077;     // disables the Desktop tab in the Display CPL
  {$EXTERNALSYM REST_NODISPBACKGROUND}
  REST_NODISPSCREENSAVEPG          = $40000078;     // disables the Screen Saver tab in the Display CPL
  {$EXTERNALSYM REST_NODISPSCREENSAVEPG}
  REST_NODISPSETTINGSPG            = $40000079;     // disables the Settings tab in the Display CPL
  {$EXTERNALSYM REST_NODISPSETTINGSPG}
  REST_NODISPSCREENSAVEPREVIEW     = $4000007A;     // disables the screen saver on the Screen Saver tab in the Display CPL
  {$EXTERNALSYM REST_NODISPSCREENSAVEPREVIEW}
  REST_NODISPLAYCPL                = $4000007B;     // disables the Display CPL
  {$EXTERNALSYM REST_NODISPLAYCPL}
  REST_HIDERUNASVERB               = $4000007C;     // hides the "Run As..." context menu item
  {$EXTERNALSYM REST_HIDERUNASVERB}
  REST_NOTHUMBNAILCACHE            = $4000007D;     // disables use of the thumbnail cache
  {$EXTERNALSYM REST_NOTHUMBNAILCACHE}
  REST_NOSTRCMPLOGICAL             = $4000007E;     // dont use StrCmpLogical() instead use default CompareString()
  {$EXTERNALSYM REST_NOSTRCMPLOGICAL}
  REST_NOPUBLISHWIZARD             = $4000007F;     // disables publishing wizard (WPW)
  {$EXTERNALSYM REST_NOPUBLISHWIZARD}
  REST_NOONLINEPRINTSWIZARD        = $40000080;     // disables online prints wizard (OPW)
  {$EXTERNALSYM REST_NOONLINEPRINTSWIZARD}
  REST_NOWEBSERVICES               = $40000081;     // disables the web specified services for both OPW and WPW
  {$EXTERNALSYM REST_NOWEBSERVICES}
  REST_ALLOWUNHASHEDWEBVIEW        = $40000082;     // allow the user to be promted to accept web view templates that don't already have an md5 hash in the registry
  {$EXTERNALSYM REST_ALLOWUNHASHEDWEBVIEW}
  REST_ALLOWLEGACYWEBVIEW          = $40000083;     // allow legacy webview template to be shown.
  {$EXTERNALSYM REST_ALLOWLEGACYWEBVIEW}
  REST_REVERTWEBVIEWSECURITY       = $40000084;     // disable added webview security measures (revert to w2k functionality).
  {$EXTERNALSYM REST_REVERTWEBVIEWSECURITY}
  REST_INHERITCONSOLEHANDLES       = $40000086;     // ShellExec() will check for the current process and target process being console processes to inherit handles
  {$EXTERNALSYM REST_INHERITCONSOLEHANDLES}
  REST_SORTMAXITEMCOUNT            = $40000087;     // Do not sort views with more items than this key. Useful for viewing big amount of files in one folder.
  {$EXTERNALSYM REST_SORTMAXITEMCOUNT}
  REST_NOREMOTERECURSIVEEVENTS     = $40000089;     // Dont register network change events recursively to avoid network traffic
  {$EXTERNALSYM REST_NOREMOTERECURSIVEEVENTS}
  REST_NOREMOTECHANGENOTIFY        = $40000091;     // Do not notify for remote changy notifies
  {$EXTERNALSYM REST_NOREMOTECHANGENOTIFY}
  REST_NOSIMPLENETIDLIST           = $40000092;     // No simple network IDLists
  {$EXTERNALSYM REST_NOSIMPLENETIDLIST}
  REST_NOENUMENTIRENETWORK         = $40000093;     // Don't enumerate entire network if we happen to get to it (in conjunction with REST_NOENTIRENETWORK)
  {$EXTERNALSYM REST_NOENUMENTIRENETWORK}
  REST_NODETAILSTHUMBNAILONNETWORK = $40000094;     // Disable Thumbnail for Network files in DUI Details pane
  {$EXTERNALSYM REST_NODETAILSTHUMBNAILONNETWORK}
  REST_NOINTERNETOPENWITH          = $40000095;     // dont allow looking on the internet for file associations
  {$EXTERNALSYM REST_NOINTERNETOPENWITH}
  REST_DONTRETRYBADNETNAME         = $4000009B;     // In Network Places: if provider returns ERROR_BAD_NET_NAME, give up
  {$EXTERNALSYM REST_DONTRETRYBADNETNAME}
  REST_ALLOWFILECLSIDJUNCTIONS     = $4000009C;     // re-enable legacy support for file.{guid} junctions in FileSystem Folder
  {$EXTERNALSYM REST_ALLOWFILECLSIDJUNCTIONS}
  REST_NOUPNPINSTALL               = $4000009D;     // disable "install UPnP" task in My Net Places
  {$EXTERNALSYM REST_NOUPNPINSTALL}
  REST_ARP_DONTGROUPPATCHES        = $400000AC;     // List individual patches in Add/Remove Programs
  {$EXTERNALSYM REST_ARP_DONTGROUPPATCHES}
  REST_ARP_NOCHOOSEPROGRAMSPAGE    = $400000AD;     // Choose programs page
  {$EXTERNALSYM REST_ARP_NOCHOOSEPROGRAMSPAGE}

  REST_NODISCONNECT                = $41000001;     // No Disconnect option in Start menu
  {$EXTERNALSYM REST_NODISCONNECT}
  REST_NOSECURITY                  = $41000002;     // No Security option in start menu
  {$EXTERNALSYM REST_NOSECURITY}
  REST_NOFILEASSOCIATE             = $41000003;     // Do not allow user to change file association
  {$EXTERNALSYM REST_NOFILEASSOCIATE}
  REST_ALLOWCOMMENTTOGGLE          = $41000004;     // Allow the user to toggle the positions of the Comment and the Computer Name
  {$EXTERNALSYM REST_ALLOWCOMMENTTOGGLE}
  REST_USEDESKTOPINICACHE          = $41000005;     // Cache desktop.ini entries from network folders
  {$EXTERNALSYM REST_USEDESKTOPINICACHE}
{$endif}
{$ifndef DelphiXE2orNewerCompiler}
  VER_SERVER_NT                       = $80000000;
  {$EXTERNALSYM VER_SERVER_NT}
  VER_WORKSTATION_NT                  = $40000000;
  {$EXTERNALSYM VER_WORKSTATION_NT}
  VER_SUITE_SMALLBUSINESS             = $00000001;
  {$EXTERNALSYM VER_SUITE_SMALLBUSINESS}
  VER_SUITE_ENTERPRISE                = $00000002;
  {$EXTERNALSYM VER_SUITE_ENTERPRISE}
  VER_SUITE_BACKOFFICE                = $00000004;
  {$EXTERNALSYM VER_SUITE_BACKOFFICE}
  VER_SUITE_COMMUNICATIONS            = $00000008;
  {$EXTERNALSYM VER_SUITE_COMMUNICATIONS}
  VER_SUITE_TERMINAL                  = $00000010;
  {$EXTERNALSYM VER_SUITE_TERMINAL}
  VER_SUITE_SMALLBUSINESS_RESTRICTED  = $00000020;
  {$EXTERNALSYM VER_SUITE_SMALLBUSINESS_RESTRICTED}
  VER_SUITE_EMBEDDEDNT                = $00000040;
  {$EXTERNALSYM VER_SUITE_EMBEDDEDNT}
  VER_SUITE_DATACENTER                = $00000080;
  {$EXTERNALSYM VER_SUITE_DATACENTER}
  VER_SUITE_SINGLEUSERTS              = $00000100;
  {$EXTERNALSYM VER_SUITE_SINGLEUSERTS}
  VER_SUITE_PERSONAL                  = $00000200;
  {$EXTERNALSYM VER_SUITE_PERSONAL}
  VER_SUITE_BLADE                     = $00000400;
  {$EXTERNALSYM VER_SUITE_BLADE}
  VER_SUITE_EMBEDDED_RESTRICTED       = $00000800;
  {$EXTERNALSYM VER_SUITE_EMBEDDED_RESTRICTED}
  VER_SUITE_SECURITY_APPLIANCE        = $00001000;
  {$EXTERNALSYM VER_SUITE_SECURITY_APPLIANCE}
  VER_SUITE_STORAGE_SERVER            = $00002000;
  {$EXTERNALSYM VER_SUITE_STORAGE_SERVER}
  VER_SUITE_COMPUTE_SERVER            = $00004000;
  {$EXTERNALSYM VER_SUITE_COMPUTE_SERVER}
  VER_SUITE_WH_SERVER                 = $00008000;
  {$EXTERNALSYM VER_SUITE_WH_SERVER}

  VER_NT_WORKSTATION = $0000001;
  {$EXTERNALSYM VER_NT_WORKSTATION}
  VER_NT_DOMAIN_CONTROLLER = $0000002;
  {$EXTERNALSYM VER_NT_DOMAIN_CONTROLLER}
  VER_NT_SERVER = $0000003;
  {$EXTERNALSYM VER_NT_SERVER}

  PROCESSOR_INTEL_386     = 386;
  {$EXTERNALSYM PROCESSOR_INTEL_386}
  PROCESSOR_INTEL_486     = 486;
  {$EXTERNALSYM PROCESSOR_INTEL_486}
  PROCESSOR_INTEL_PENTIUM = 586;
  {$EXTERNALSYM PROCESSOR_INTEL_PENTIUM}
  PROCESSOR_INTEL_IA64    = 2200;
  {$EXTERNALSYM PROCESSOR_INTEL_IA64}
  PROCESSOR_AMD_X8664     = 8664;
  {$EXTERNALSYM PROCESSOR_AMD_X8664}
  PROCESSOR_MIPS_R4000    = 4000;    // incl R4101 & R3910 for Windows CE
  {$EXTERNALSYM PROCESSOR_MIPS_R4000}
  PROCESSOR_ALPHA_21064   = 21064;
  {$EXTERNALSYM PROCESSOR_ALPHA_21064}
  PROCESSOR_PPC_601       = 601;
  {$EXTERNALSYM PROCESSOR_PPC_601}
  PROCESSOR_PPC_603       = 603;
  {$EXTERNALSYM PROCESSOR_PPC_603}
  PROCESSOR_PPC_604       = 604;
  {$EXTERNALSYM PROCESSOR_PPC_604}
  PROCESSOR_PPC_620       = 620;
  {$EXTERNALSYM PROCESSOR_PPC_620}
  PROCESSOR_HITACHI_SH3   = 10003;   // Windows CE
  {$EXTERNALSYM PROCESSOR_HITACHI_SH3}
  PROCESSOR_HITACHI_SH3E  = 10004;   // Windows CE
  {$EXTERNALSYM PROCESSOR_HITACHI_SH3E}
  PROCESSOR_HITACHI_SH4   = 10005;   // Windows CE
  {$EXTERNALSYM PROCESSOR_HITACHI_SH4}
  PROCESSOR_MOTOROLA_821  = 821;     // Windows CE
  {$EXTERNALSYM PROCESSOR_MOTOROLA_821}
  PROCESSOR_SHx_SH3       = 103;     // Windows CE
  {$EXTERNALSYM PROCESSOR_SHx_SH3}
  PROCESSOR_SHx_SH4       = 104;     // Windows CE
  {$EXTERNALSYM PROCESSOR_SHx_SH4}
  PROCESSOR_STRONGARM     = 2577;    // Windows CE - 0xA11
  {$EXTERNALSYM PROCESSOR_STRONGARM}
  PROCESSOR_ARM720        = 1824;    // Windows CE - 0x720
  {$EXTERNALSYM PROCESSOR_ARM720}
  PROCESSOR_ARM820        = 2080;    // Windows CE - 0x820
  {$EXTERNALSYM PROCESSOR_ARM820}
  PROCESSOR_ARM920        = 2336;    // Windows CE - 0x920
  {$EXTERNALSYM PROCESSOR_ARM920}
  PROCESSOR_ARM_7TDMI     = 70001;   // Windows CE
  {$EXTERNALSYM PROCESSOR_ARM_7TDMI}
  PROCESSOR_OPTIL         = $494f;   // MSIL
  {$EXTERNALSYM PROCESSOR_OPTIL}
  //PROCESSOR_ARM = Reserved;

  PROCESSOR_ARCHITECTURE_INTEL           (*: WORD*) = 0;  //x86
  {$EXTERNALSYM PROCESSOR_ARCHITECTURE_INTEL}
  PROCESSOR_ARCHITECTURE_MIPS            (*: WORD*) = 1;
  {$EXTERNALSYM PROCESSOR_ARCHITECTURE_MIPS}
  PROCESSOR_ARCHITECTURE_ALPHA           (*: WORD*) = 2;
  {$EXTERNALSYM PROCESSOR_ARCHITECTURE_ALPHA}
  PROCESSOR_ARCHITECTURE_PPC             (*: WORD*) = 3;
  {$EXTERNALSYM PROCESSOR_ARCHITECTURE_PPC}
  PROCESSOR_ARCHITECTURE_SHX             (*: WORD*) = 4;
  {$EXTERNALSYM PROCESSOR_ARCHITECTURE_SHX}
  PROCESSOR_ARCHITECTURE_ARM             (*: WORD*) = 5; //ARM
  {$EXTERNALSYM PROCESSOR_ARCHITECTURE_ARM}
  PROCESSOR_ARCHITECTURE_IA64            (*: WORD*) = 6; //Intel Itanium Processor Family (IPF)
  {$EXTERNALSYM PROCESSOR_ARCHITECTURE_IA64}
  PROCESSOR_ARCHITECTURE_ALPHA64         (*: WORD*) = 7;
  {$EXTERNALSYM PROCESSOR_ARCHITECTURE_ALPHA64}
  PROCESSOR_ARCHITECTURE_MSIL            (*: WORD*) = 8;
  {$EXTERNALSYM PROCESSOR_ARCHITECTURE_MSIL}
  PROCESSOR_ARCHITECTURE_AMD64           (*: WORD*) = 9; //x64 (AMD or Intel)
  {$EXTERNALSYM PROCESSOR_ARCHITECTURE_AMD64}
  PROCESSOR_ARCHITECTURE_IA32_ON_WIN64   (*: WORD*) = 10;
  {$EXTERNALSYM PROCESSOR_ARCHITECTURE_IA32_ON_WIN64}

  PROCESSOR_ARCHITECTURE_UNKNOWN(*: WORD*) = $FFFF; //Unknown architecture.
  {$EXTERNALSYM PROCESSOR_ARCHITECTURE_UNKNOWN}

  {$EXTERNALSYM COLORMGMTCAPS}
  COLORMGMTCAPS = 121;   { Color Management caps                 }
{$else} //Note: this is a special case! There is a conflicting COLORMGMTCAPS defined by Delphi with an incompatible type, so let's always use this one explicitly
  COLORMGMTCAPS = Windows.COLORMGMTCAPS;
{$endif}
{$ifndef Delphi11orNewerCompiler} //FIXME: Missing in Delphi XE2, but existing in Delphi 11.3!
  //Added in Windows 2000
  REG_QWORD = 11;
  {$EXTERNALSYM REG_QWORD}
  REG_QWORD_LITTLE_ENDIAN = 11;
  {$EXTERNALSYM REG_QWORD_LITTLE_ENDIAN}

  VER_SUITE_MULTIUSERTS               = $00020000;
  {$EXTERNALSYM VER_SUITE_MULTIUSERTS}
{$endif}

  IMAGE_DLLCHARACTERISTICS_DYNAMIC_BASE = $0040;
  IMAGE_DLLCHARACTERISTICS_NX_COMPAT = $0100;

  UOI_TIMERPROC_EXCEPTION_SUPPRESSION(*: DWORD*) = 7;

  INVALID_SET_FILE_POINTER = DWORD(-1);

  UNLEN = 256; // Maximum user name length, in characters (not bytes), excluding terminating 0-characters.

  { Color Management Capabilities }

  {$EXTERNALSYM CM_NONE}
  CM_NONE       = 0;     { ICM not supported          }
  {$EXTERNALSYM CM_DEVICE_ICM}
  CM_DEVICE_ICM = 1;     { Can perform ICM on either the device driver or the device itself }
  {$EXTERNALSYM CM_GAMMA_RAMP}
  CM_GAMMA_RAMP = 2;     { Supports GetDeviceGammaRamp and SetDeviceGammaRamp }
  {$EXTERNALSYM CM_CMYK_COLOR}
  CM_CMYK_COLOR = 4;     { Accepts CMYK color space ICC color profile }

  PROCESSOR_ARCHITECTURE_NEUTRAL         (*: WORD*) = 11;
  {$EXTERNALSYM PROCESSOR_ARCHITECTURE_NEUTRAL}
  PROCESSOR_ARCHITECTURE_ARM64           (*: WORD*) = 12;
  {$EXTERNALSYM PROCESSOR_ARCHITECTURE_ARM64}
  PROCESSOR_ARCHITECTURE_ARM32_ON_WIN64  (*: WORD*) = 13;
  {$EXTERNALSYM PROCESSOR_ARCHITECTURE_ARM32_ON_WIN64}
  PROCESSOR_ARCHITECTURE_IA32_ON_ARM64   (*: WORD*) = 14;
  {$EXTERNALSYM PROCESSOR_ARCHITECTURE_IA32_ON_ARM64}

  //A missing old alias for VER_SUITE_BLADE
  VER_SUITE_SERVERAPPLIANCE            = VER_SUITE_BLADE;
  {$EXTERNALSYM VER_SUITE_SERVERAPPLIANCE}

  //_FIRMWARE_TYPE:
  FirmwareTypeUnknown = 0;
  FirmwareTypeBios = 1;
  FirmwareTypeUefi = 2;
  FirmwareTypeMax = 3;

  PROCESS_CALLBACK_FILTER_ENABLED = $1;
{$endif}

//
//   Functions
//

{$ifndef Delphi2orNewerCompiler}
{ CompareMem performs a binary compare of Length bytes of memory referenced
  by P1 to that of P2.  CompareMem returns True if the memory referenced by
  P1 is identical to that of P2. }
function CompareMem(P1, P2: Pointer; Length: Integer): Boolean; assembler;

function WideLowerCaseFileName(const S: WideString): WideString;
function WideCompareFileName(const S1, S2: WideString): Integer;
{$endif}

{$ifndef Delphi3orNewerCompiler}
{ IsPathDelimiter returns True if the character at byte S[Index]
  is a PathDelimiter ('\' or '/'), and it is not a MBCS lead or trail byte. }
function IsPathDelimiter(const S: string; Index: Integer): Boolean;

procedure RaiseLastWin32Error;
{$endif}

{$ifndef Delphi4orNewerCompiler}
function GetComCtlVersion: Integer;
{$endif}

{$ifndef Delphi5orNewerCompiler}
{ SameText compares S1 to S2, without case-sensitivity. Returns true if
  S1 and S2 are the equal, that is, if CompareText would return 0. SameText
  has the same 8-bit limitations as CompareText }
function SameText(const S1, S2: string): Boolean;

{ AnsiSameStr compares S1 to S2, with case-sensitivity. The compare
  operation is controlled by the current Windows locale. The return value
  is True if AnsiCompareStr would have returned 0. }
function AnsiSameStr(const S1, S2: string): Boolean;

{ AnsiSameText compares S1 to S2, without case-sensitivity. The compare
  operation is controlled by the current Windows locale. The return value
  is True if AnsiCompareText would have returned 0. }
function AnsiSameText(const S1, S2: string): Boolean;

{ FreeAndNil frees the given TObject instance and sets the variable reference
  to nil.  Be careful to only pass TObjects to this routine. }
procedure FreeAndNil(var Obj);
{$endif}

{$ifndef Delphi6orNewerCompiler}
//Exists in system.pas, but not published.
procedure Error(errorCode: Byte);

const
  RaiseLastOSError: procedure = RaiseLastWin32Error;

//Exists in SysUtils, but is not published.
procedure DivMod(Dividend: Integer; Divisor: Word; var Result, Remainder: Word);

{ IncludeTrailingPathDelimiter returns the path with a PathDelimiter
  ('/' or '\') at the end.  This function is MBCS enabled. }
function IncludeTrailingPathDelimiter(const S: string): string;

{ ExcludeTrailingPathDelimiter returns the path without a PathDelimiter
  ('\' or '/') at the end.  This function is MBCS enabled. }
function ExcludeTrailingPathDelimiter(const S: string): string;

function SameFileName(const S1, S2: string): Boolean;

function TryStrToInt(const S: string; out Value: Integer): Boolean;
function TryStrToInt64(const S: string; out Value: Int64): Boolean;

function StrToFloatDef(const S: String; const Default: Extended) : Extended;

function BoolToStr(B: Boolean; UseBoolStrs: Boolean = False): string;

function AnsiContainsText(const AText, ASubText: string): Boolean;
function AnsiStartsText(const ASubText, AText: string): Boolean;
function AnsiEndsText(const ASubText, AText: string): Boolean;

function AnsiContainsStr(const AText, ASubText: string): Boolean;
function AnsiStartsStr(const ASubText, AText: string): Boolean;
function AnsiEndsStr(const ASubText, AText: string): Boolean;

{ Returns the reverse of a specified string. }
function ReverseString(const AText: string): string;

function LeftStr(Const Str: String; Size: Word): String;
function RightStr(Const Str: String; Size: Word): String;
function MidStr(Const Str: String; From, Size: Word): String;

function UnixToDateTime(const AValue: Int64): TDateTime;
{$endif}

{$ifndef Delphi7orNewerCompiler}
{ PosEx searches for SubStr in S and returns the index position of
  SubStr if found and 0 otherwise.  If Offset is not given then the result is
  the same as calling Pos.  If Offset is specified and > 1 then the search
  starts at position Offset within S.  If Offset is larger than Length(S)
  then PosEx returns 0.  By default, Offset equals 1. }
function PosEx(const SubStr, S: string; Offset: Cardinal = 1): Integer;

function GetFileVersion(const AFileName: string): Cardinal;

//This is supposed to be a member function.
function TStrings_ValueFromIndex_Get(const ss: TStrings; Index: Integer): string;
{$endif}

{$ifndef Delphi2005orNewerCompiler}
function ContainsText(const AText, ASubText: string): Boolean;
function StartsText(const ASubText, AText: string): Boolean;
function EndsText(const ASubText, AText: string): Boolean;

function ContainsStr(const AText, ASubText: string): Boolean;
function StartsStr(const ASubText, AText: string): Boolean;
function EndsStr(const ASubText, AText: string): Boolean;
{$endif}

{$ifndef Delphi2009orNewerCompiler}
function UIntToStr(Value: Cardinal): string; overload;
function UIntToStr(Value: UInt64): string; overload;

function CharInSet(C: AnsiChar; const CharSet: TSysCharSet): Boolean; overload;{$IFDEF Delphi2005orNewerCompiler} inline;{$ENDIF}
{$ifndef Delphi2orNewerCompiler}
function CharInSet(C: WideChar; const CharSet: TSysCharSet): Boolean; overload;{$IFDEF Delphi2005orNewerCompiler} inline;{$ENDIF}
{$endif}
{$endif}

{$IFDEF UNICODE}
(*function CharInSet(C: UnicodeChar; const CharSet: TSysCharSet): Boolean; overload;{$IFDEF Delphi2005orNewerCompiler} inline;{$ENDIF}*)
{$ENDIF}

{$ifndef DelphiXEorNewerCompiler}
function SplitString(const S, Delimiters: string): TStringDynArray;
{$endif}

{$ifndef DelphiXE6orNewerCompiler} //FIXME: Not sure about the version of Delphi these were added
function StrToUInt(const S: string): Cardinal;
function StrToUIntDef(const S: string; Default: Cardinal): Cardinal;
function TryStrToUInt(const S: string; out Value: Cardinal): Boolean;
{$endif}

{$ifndef Delphi12orNewerCompiler}
function GetCompilerVersion: Word;
function GetRTLVersion: Word;

function CanUseDoubleBuffering: Boolean;
{$endif}

//These functions don't exist at all in Delphi:
function LastPos(const SubStr: String; const S: String): Integer;

function DateTimeToWin64(const AValue: TDateTime): QWORD;
function Win64ToDateTime(const AValue: QWORD): TDateTime;

function CompareFileName(const S1, S2: string): Integer;
procedure CleanupFileName(var S: String);

{$IFDEF UNICODE}
function UnicodeLowerCaseFileName(const S: UnicodeString): string;
function UnicodeCompareFileName(const S1, S2: UnicodeString): Integer;
{$ENDIF}

{$ifndef Delphi2009orNewerCompiler}
var
  CPUCount: Integer;
{$endif}

{$ifdef MSWINDOWS}
{$ifndef Delphi5orNewerCompiler}
function SafeLoadLibrary(const FileName: string; ErrorMode: UINT = SEM_NOOPENFILEERRORBOX): HMODULE;
{$endif}

{$ifndef Delphi6orNewerCompiler}
{$define ExtraFunc_CheckWin32Version}
{$endif}
{$ifdef CompiledWithDelphi6}
{$IF not Defined(CheckWin32Version)} //This was added in Delphi 6 Update Pack 2.
{$define ExtraFunc_CheckWin32Version}
{$IFEND}
{$endif}
{$ifdef ExtraFunc_CheckWin32Version}
function CheckWin32Version(AMajor: Integer; AMinor: Integer = 0): Boolean;
{$endif}

{$ifdef DELAYEDLOADING}
{.$ifndef Delphi4orNewerCompiler}
//While this exists in Delphi4+, it will be loaded on startup. On systems before Windows 2000 this will crash,
//because GetGuiResources doesn't exist there. So we HAVE to use our delayed loading implementation!
function GetGuiResources(hProcess: THandle; uiFlags: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetGuiResources}
function GetGuiResources(hProcess: THandle; uiFlags: DWORD): DWORD; stdcall; external 'user32.DLL' name 'GetGuiResources' delayed;
{.$endif}
{$ifndef Delphi2007orNewerCompiler}
function DwmEnableComposition(uCompositionAction: UINT): HResult; stdcall;
{$EXTERNALSYM DwmEnableComposition}
function DwmEnableComposition(uCompositionAction: UINT): HResult; external 'DWMAPI.DLL' name 'DwmEnableComposition' delayed;

//function DwmIsCompositionEnabled(out pfEnabled: BOOL): HResult; stdcall;
//{$EXTERNALSYM DwmIsCompositionEnabled}
//function DwmIsCompositionEnabled(out pfEnabled: BOOL): HResult; external 'DWMAPI.DLL' name 'DwmIsCompositionEnabled' delayed;
{$endif}

{$ifndef Delphi2009orNewerCompiler}
function GlobalMemoryStatusEx(var lpBuffer : TMEMORYSTATUSEX): BOOL; stdcall;
{$EXTERNALSYM GlobalMemoryStatusEx}
function GlobalMemoryStatusEx; external kernel32 name 'GlobalMemoryStatusEx' delayed;

function GetTickCount64: ULONGLONG; stdcall;
{$EXTERNALSYM GetTickCount64}
function GetTickCount64; external kernel32 name 'GetTickCount64' delayed;
{$endif}

{$ifndef Delphi2010orNewerCompiler}
procedure GetNativeSystemInfo(var lpSystemInformation: TSystemInfo); stdcall;
{$EXTERNALSYM GetNativeSystemInfo}
procedure GetNativeSystemInfo; external kernel32 name 'GetNativeSystemInfo' delayed;

function SetDllDirectory(lpPathName: LPCWSTR): BOOL; stdcall;
{$EXTERNALSYM SetDllDirectory}
function SetDllDirectoryA(lpPathName: LPCSTR): BOOL; stdcall;
{$EXTERNALSYM SetDllDirectoryA}
function SetDllDirectoryW(lpPathName: LPCWSTR): BOOL; stdcall;
{$EXTERNALSYM SetDllDirectoryW}
function SetDllDirectory; external kernel32 name {$IFDEF UNICODE}'SetDllDirectoryW'{$ELSE}'SetDllDirectoryA'{$ENDIF} delayed;
function SetDllDirectoryA; external kernel32 name 'SetDllDirectoryA' delayed;
function SetDllDirectoryW; external kernel32 name 'SetDllDirectoryW' delayed;

function SHRestricted(rest: RESTRICTIONS): DWORD; stdcall;
{$EXTERNALSYM SHRestricted}
function SHRestricted; external 'shell32.dll' name 'SHRestricted' delayed;
{$endif}

{$ifndef DelphiXE2orNewerCompiler}
function GetErrorMode(): UINT; stdcall;
{$EXTERNALSYM GetErrorMode}
function GetErrorMode; external kernel32 name 'GetErrorMode' delayed;

function IsWow64Process(hProcess: THandle; Wow64Process: PBOOL): BOOL; overload; stdcall;
function IsWow64Process(hProcess: THandle; var Wow64Process: BOOL): BOOL; overload; stdcall;
{$EXTERNALSYM IsWow64Process}
function IsWow64Process(hProcess: THandle; Wow64Process: PBOOL): BOOL; external kernel32 name 'IsWow64Process' delayed;
function IsWow64Process(hProcess: THandle; var Wow64Process: BOOL): BOOL; external kernel32 name 'IsWow64Process' delayed;
{$endif}

{$ifndef Delphi11orNewerCompiler} //FIXME: Not sure, but missing in XE2, but exist in 11.3
function GetProcessMitigationPolicy(hProcess: THandle; MitigationPolicy: TProcessMitigationPolicy; lpBuffer: Pointer; dwLength: SIZE_T): BOOL; stdcall;
{$EXTERNALSYM GetProcessMitigationPolicy}
function GetProcessMitigationPolicy; external kernel32 name 'GetProcessMitigationPolicy' delayed;

function SetProcessMitigationPolicy(MitigationPolicy: TProcessMitigationPolicy; lpBuffer: Pointer; dwLength: SIZE_T): BOOL; stdcall;
{$EXTERNALSYM SetProcessMitigationPolicy}
function SetProcessMitigationPolicy; external kernel32 name 'SetProcessMitigationPolicy' delayed;
{$endif}

{.$ifndef DelphiXXorNewerCompiler}
function IsWow64Process2(hProcess: THandle; pProcessMachine: PUSHORT; pNativeMachine: PUSHORT): BOOL; overload; stdcall;
function IsWow64Process2(hProcess: THandle; var pProcessMachine: USHORT; var pNativeMachine: USHORT): BOOL; overload; stdcall;
{$EXTERNALSYM IsWow64Process2}
function IsWow64Process2(hProcess: THandle; pProcessMachine: PUSHORT; pNativeMachine: PUSHORT): BOOL; external kernel32 name 'IsWow64Process2' delayed;
function IsWow64Process2(hProcess: THandle; var pProcessMachine: USHORT; var pNativeMachine: USHORT): BOOL; external kernel32 name 'IsWow64Process2' delayed;

function GetFirmwareType(FirmwareType: PFIRMWARE_TYPE): BOOL; overload; stdcall;
function GetFirmwareType(var FirmwareType: _FIRMWARE_TYPE): BOOL; overload; stdcall;
{$EXTERNALSYM GetFirmwareType}
function GetFirmwareType(FirmwareType: PFIRMWARE_TYPE): BOOL; external kernel32 name 'GetFirmwareType' delayed;
function GetFirmwareType(var FirmwareType: _FIRMWARE_TYPE): BOOL; external kernel32 name 'GetFirmwareType' delayed;

function GetProcessUserModeExceptionPolicy(dwFlags: LPDWORD): BOOL; stdcall;
{$EXTERNALSYM GetProcessUserModeExceptionPolicy}
function GetProcessUserModeExceptionPolicy; external kernel32 name 'GetProcessUserModeExceptionPolicy' delayed;

function SetProcessUserModeExceptionPolicy(dwFlags: DWORD): BOOL; stdcall;
{$EXTERNALSYM SetProcessUserModeExceptionPolicy}
function SetProcessUserModeExceptionPolicy; external kernel32 name 'SetProcessUserModeExceptionPolicy' delayed;
{.$endif}
{$else} //DELAYEDLOADING
var
{.$ifndef Delphi4orNewerCompiler}
  {$EXTERNALSYM GetGuiResources}
  GetGuiResources: function (hProcess: THandle; uiFlags: DWORD): DWORD; stdcall;
{.$endif}
{$ifndef Delphi2007orNewerCompiler}
  DwmEnableComposition: function (uCompositionAction: UINT): HResult; stdcall;
  //DwmIsCompositionEnabled: function (out pfEnabled: BOOL): HResult; stdcall;
{$endif}
{$ifndef Delphi2009orNewerCompiler}
  GlobalMemoryStatusEx: function (var lpBuffer: TMemoryStatusEx): BOOL; stdcall;
  GetTickCount64: function: ULONGLONG; stdcall;
{$endif}
{$ifndef Delphi2010orNewerCompiler}
  GetNativeSystemInfo: procedure (var lpSystemInformation: TSystemInfo); stdcall;
  SetDllDirectory: function (lpPathName: LPCTSTR): BOOL; stdcall;
  SetDllDirectoryA: function (lpPathName: LPCSTR): BOOL; stdcall;
  SetDllDirectoryW: function (lpPathName: LPCWSTR): BOOL; stdcall;
  SHRestricted: function (rest: RESTRICTIONS): DWORD; stdcall;
{$endif}
{$ifndef DelphiXE2orNewerCompiler}
  GetErrorMode: function : UINT; stdcall;
  IsWow64Process: function (hProcess: THandle; var Wow64Process: BOOL): BOOL; stdcall;
{$endif}
{$ifndef Delphi11orNewerCompiler}
  GetProcessMitigationPolicy: function (hProcess: THandle; MitigationPolicy: TProcessMitigationPolicy; lpBuffer: Pointer; dwLength: SIZE_T): BOOL; stdcall;
  SetProcessMitigationPolicy: function (MitigationPolicy: TProcessMitigationPolicy; lpBuffer: Pointer; dwLength: SIZE_T): BOOL; stdcall;
{$endif}
{.$ifndef DelphiXXorNewerCompiler}
  IsWow64Process2: function (hProcess: THandle; var pProcessMachine: USHORT; var pNativeMachine: USHORT): BOOL; stdcall;
  GetFirmwareType: function (var FirmwareType: _FIRMWARE_TYPE): BOOL; stdcall;
  GetProcessUserModeExceptionPolicy: function (dwFlags: LPDWORD): BOOL; stdcall;
  SetProcessUserModeExceptionPolicy: function (dwFlags: DWORD): BOOL; stdcall;
{.$endif}
{$endif}

//Macro's that weren't converted.
function CopyCursor(pcur: HCursor): HCursor;{$IFDEF Delphi2005orNewerCompiler} inline;{$ENDIF}
function HRESULT_CODE(hr: HResult): DWORD; //Under another name in ActiveX.pas: ResultCode
function SCODE_CODE(sc: SCODE): DWORD;
function HRESULT_FACILITY(hr: HResult): DWORD; //Under another name in ActiveX.pas: ResultFacility
function SCODE_FACILITY(sc: SCODE): DWORD;
function HRESULT_SEVERITY(hr: HResult): DWORD; //Under another name in ActiveX.pas: ResultSeverity
function SCODE_SEVERITY(sc: SCODE): DWORD;

//These functions doesn't exist at all in Delphi:
function CheckWin32VersionWithServicePack(AMajor: Integer; AMinor: Integer = 0; AServicePackMajor: Integer = 0; AServicePackMinor: Integer = 0): Boolean; //Note: We use the wrong datatype to be consistent with CheckWin32Version.
function CheckWin32VersionWithBuildNumber(AMajor: Integer; AMinor: Integer = 0; ABuildNumber: Integer = 0): Boolean; //Note: We use the wrong datatype to be consistent with CheckWin32Version.

//For delay loading functionality:
var
  DelayFunc_GetGuiResources: Boolean;
  DelayFunc_DwmEnableComposition: Boolean;
  //DelayFunc_DwmIsCompositionEnabled: Boolean;
  DelayFunc_GlobalMemoryStatusEx: Boolean;
  DelayFunc_GetNativeSystemInfo: Boolean;
  DelayFunc_GetErrorMode: Boolean;
  DelayFunc_SetDllDirectoryA: Boolean;
  DelayFunc_SetDllDirectoryW: Boolean;
  DelayFunc_SetDllDirectory: Boolean;
  DelayFunc_IsWow64Process: Boolean;
  DelayFunc_IsWow64Process2: Boolean;
  DelayFunc_GetTickCount64: Boolean;
  DelayFunc_GetProcessMitigationPolicy: Boolean;
  DelayFunc_SetProcessMitigationPolicy: Boolean;
  DelayFunc_GetFirmwareType: Boolean;
  DelayFunc_GetProcessUserModeExceptionPolicy: Boolean;
  DelayFunc_SetProcessUserModeExceptionPolicy: Boolean;
  DelayFunc_SHRestricted: Boolean;
{$endif}

implementation

{$ifndef Delphi2orNewerCompiler}
function CompareMem(P1, P2: Pointer; Length: Integer): Boolean; assembler;
asm
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,P1
        MOV     EDI,P2
        MOV     EDX,ECX
        XOR     EAX,EAX
        AND     EDX,3
        SAR     ECX,2
        JS      @@1     // Negative Length implies identity.
        REPE    CMPSD
        JNE     @@2
        MOV     ECX,EDX
        REPE    CMPSB
        JNE     @@2
@@1:    INC     EAX
@@2:    POP     EDI
        POP     ESI
end;

function WideLowerCaseFileName(const S: WideString): WideString;
var
  I,L: Integer;
begin
  if SysLocale.FarEast then
  begin
    L := Length(S);
    SetLength(Result, L);
    I := 1;
    while I <= L do
    begin
      Result[I] := S[I];
      if S[I] in LeadBytes then
      begin
        Inc(I);
        Result[I] := S[I];
      end
      else
        if Result[I] in ['A'..'Z'] then Inc(Byte(Result[I]), 32);
      Inc(I);
    end;
  end
  else
    Result := WideLowerCase(S);
end;

function WideCompareFileName(const S1, S2: WideString): Integer;
begin
  Result := WideCompareStr(WideLowerCaseFileName(S1), WideLowerCaseFileName(S2));
end;
{$endif}

{$ifndef Delphi3orNewerCompiler}
function IsPathDelimiter(const S: string; Index: Integer): Boolean;
begin
  Result := (Index > 0) and (Index <= Length(S)) and (S[Index] = PathDelim)
    and (ByteType(S, Index) = mbSingleByte);
end;

procedure RaiseLastWin32Error;
var
  LastError: DWORD;
  Error: EWin32Error;
begin
  LastError := GetLastError;
  if LastError <> ERROR_SUCCESS then
    Error := EWin32Error.CreateFmt(SWin32Error, [LastError, SysErrorMessage(LastError)])
  else
    Error := EWin32Error.Create(SUnkWin32Error);
  Error.ErrorCode := LastError;
  raise Error;
end;
{$endif}

{$ifndef Delphi4orNewerCompiler}
function GetComCtlVersion: Integer;
begin
  if ComCtlVersion = 0 then
    ComCtlVersion := GetFileVersion(comctl32);
  Result := ComCtlVersion;
end;
{$endif}

{$ifndef Delphi5orNewerCompiler}
function SameText(const S1, S2: string): Boolean; assembler;
asm
        CMP     EAX,EDX
        JZ      @1
        OR      EAX,EAX
        JZ      @2
        OR      EDX,EDX
        JZ      @3
        MOV     ECX,[EAX-4]
        CMP     ECX,[EDX-4]
        JNE     @3
        CALL    CompareText
        TEST    EAX,EAX
        JNZ     @3
@1:     MOV     AL,1
@2:     RET
@3:     XOR     EAX,EAX
end;

function AnsiSameStr(const S1, S2: string): Boolean;
begin
  Result := CompareString(LOCALE_USER_DEFAULT, 0, PChar(S1), Length(S1),
    PChar(S2), Length(S2)) = 2;
end;

function AnsiSameText(const S1, S2: string): Boolean;
begin
  Result := CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE, PChar(S1),
    Length(S1), PChar(S2), Length(S2)) = 2;
end;

procedure FreeAndNil(var Obj);
var
  P: TObject;
begin
  P := TObject(Obj);
  TObject(Obj) := nil;  // clear the reference before destroying the object
  P.Free;
end;
{$endif}

{$ifndef Delphi6orNewerCompiler}
procedure Error(errorCode: Byte);
asm
        AND     EAX,127
        MOV     ECX,ErrorProc
        //Note: Removed the test for ErrorProc<>Nil, for simplicities sake
        POP     EDX
        CALL    ECX
end;

procedure DivMod(Dividend: Integer; Divisor: Word; var Result, Remainder: Word);
begin
  Result    := Dividend div Divisor;
  Remainder := Dividend mod Divisor;
end;

function IncludeTrailingPathDelimiter(const S: string): string;
begin
  Result := S;
  if not IsPathDelimiter(Result, Length(Result)) then
    Result := Result + PathDelim;
end;

function ExcludeTrailingPathDelimiter(const S: string): string;
begin
  Result := S;
  if IsPathDelimiter(Result, Length(Result)) then
    SetLength(Result, Length(Result)-1);
end;

function SameFileName(const S1, S2: string): Boolean;
begin
  Result := AnsiCompareFileName(S1, S2) = 0;
end;

function TryStrToInt(const S: string; out Value: Integer): Boolean;
var
  E: Integer;
begin
  Val(S, Value, E);
  Result := E = 0;
end;

function TryStrToInt64(const S: string; out Value: Int64): Boolean;
var
  E: Integer;
begin
  Val(S, Value, E);
  Result := E = 0;
end;

function StrToFloatDef(const S: String; const Default: Extended) : Extended;
begin
 if S='' then
  Result:=Default
 else
  try
   Result:=StrToFloat(S);
  except
   Result:=Default;
  end;
end;

function BoolToStr(B: Boolean; UseBoolStrs: Boolean = False): string;
const
  cSimpleBoolStrs: array [boolean] of String = ('0', '-1');
begin
  if UseBoolStrs then
    //This is a down-scaled version of BoolToStr, that doesn't
    //support UseBoolStrs.
    raise Exception.Create('BoolToStr: UseBoolStrs not implemented!')
  else
    Result := cSimpleBoolStrs[B];
end;

function AnsiContainsText(const AText, ASubText: string): Boolean;
begin
  Result := AnsiPos(AnsiUppercase(ASubText), AnsiUppercase(AText)) > 0;
end;

function AnsiStartsText(const ASubText, AText: string): Boolean;
var
  P: PChar;
  L, L2: Integer;
begin
  P := PChar(AText);
  L := Length(ASubText);
  L2 := Length(AText);
  if L > L2 then
    Result := False
  else
    Result := CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE,
      P, L, PChar(ASubText), L) = 2;
end;

function AnsiEndsText(const ASubText, AText: string): Boolean;
var
  P: PChar;
  L, L2: Integer;
begin
  P := PChar(AText);
  L := Length(ASubText);
  L2 := Length(AText);
  Inc(P, L2 - L);
  if L > L2 then
    Result := False
  else
    Result := CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE,
      P, L, PChar(ASubText), L) = 2;
end;

function AnsiContainsStr(const AText, ASubText: string): Boolean;
begin
  Result := AnsiPos(ASubText, AText) > 0;
end;

function AnsiStartsStr(const ASubText, AText: string): Boolean;
begin
  Result := AnsiSameStr(ASubText, Copy(AText, 1, Length(ASubText)));
end;

function AnsiEndsStr(const ASubText, AText: string): Boolean;
begin
  Result := AnsiSameStr(ASubText,
                        Copy(AText, Length(AText) - Length(ASubText) + 1,
                                    Length(ASubText)));
end;

function ReverseString(const AText: string): string;
var
  I: Integer;
  P: PChar;
begin
  SetLength(Result, Length(AText));
  P := PChar(Result);
  for I := Length(AText) downto 1 do
  begin
    P^ := AText[I];
    Inc(P);
  end;
end;

function LeftStr(Const Str: String; Size: Word): String;
begin
  LeftStr := Copy(Str, 1, Size)
end;

function RightStr(Const Str: String; Size: Word): String;
begin
  if Size > Length(Str) then Size := Length(Str) ;
  RightStr := Copy(Str, Length(Str)-Size+1, Size)
end;

function MidStr(Const Str: String; From, Size: Word): String;
begin
  MidStr := Copy(Str, From, Size)
end;

function UnixToDateTime(const AValue: Int64): TDateTime;
begin
  Result := AValue / SecsPerDay + UnixDateDelta;
end;
{$endif}

{$ifndef Delphi7orNewerCompiler}
//This code is NOT copied from the StrUtils, so it MIGHT react differently!
function PosEx(const SubStr, S: string; Offset: Cardinal = 1): Integer;
begin
  if Offset < 1 then
    raise Exception.Create('Invalid offset');
  if Offset > Cardinal(MaxInt) then
    raise Exception.Create('Out of bounds');
  Result := Pos(SubStr, RightStr(S, Length(S) - Integer(Offset)));
  if Result <> 0 then
    Result := Result + Integer(Offset);
end;

function GetFileVersion(const AFileName: string): Cardinal;
var
  FileName: string;
  InfoSize, Wnd: DWORD;
  VerBuf: Pointer;
  FI: PVSFixedFileInfo;
  VerSize: DWORD;
begin
  Result := Cardinal(-1);
  // GetFileVersionInfo modifies the filename parameter data while parsing.
  // Copy the string const into a local variable to create a writeable copy.
  FileName := AFileName;
  UniqueString(FileName);
  InfoSize := GetFileVersionInfoSize(PChar(FileName), Wnd);
  if InfoSize <> 0 then
  begin
    GetMem(VerBuf, InfoSize);
    try
      if GetFileVersionInfo(PChar(FileName), Wnd, InfoSize, VerBuf) then
        if VerQueryValue(VerBuf, '\', Pointer(FI), VerSize) then
          Result:= FI.dwFileVersionMS;
    finally
      FreeMem(VerBuf);
    end;
  end;
end;

function TStrings_ValueFromIndex_Get(const ss: TStrings; Index: Integer): string;
begin
  Result := Copy(ss.Strings[Index], Length(ss.Names[Index]) + 2, MaxInt);
end;
{$endif}

{$ifndef Delphi2005orNewerCompiler}
function ContainsText(const AText, ASubText: string): Boolean;
begin
  Result := AnsiContainsText(AText, ASubText); //Note: This function was misnamed, and now it handles Unicode too!
end;

function StartsText(const ASubText, AText: string): Boolean;
begin
  Result := AnsiStartsText(ASubText, AText); //Note: This function was misnamed, and now it handles Unicode too!
end;

function EndsText(const ASubText, AText: string): Boolean;
begin
  Result := AnsiEndsText(ASubText, AText); //Note: This function was misnamed, and now it handles Unicode too!
end;

function ContainsStr(const AText, ASubText: string): Boolean;
begin
  Result := AnsiContainsStr(AText, ASubText); //Note: This function was misnamed, and now it handles Unicode too!
end;

function StartsStr(const ASubText, AText: String): Boolean;
begin
  Result := AnsiStartsStr(ASubText, AText); //Note: This function was misnamed, and now it handles Unicode too!
end;

function EndsStr(const ASubText, AText: String): Boolean;
begin
 Result := AnsiEndsStr(ASubText, AText); //Note: This function was misnamed, and now it handles Unicode too!
end;
{$endif}

{$ifndef Delphi2009orNewerCompiler}
function UIntToStr(Value: Cardinal): string;
begin
  FmtStr(Result, '%u', [Value]);
end;

function UIntToStr(Value: UInt64): string;
begin
  FmtStr(Result, '%u', [Value]);
end;

function CharInSet(C: AnsiChar; const CharSet: TSysCharSet): Boolean;
begin
  Result := C in CharSet;
end;

{$ifndef Delphi2orNewerCompiler}
function CharInSet(C: WideChar; const CharSet: TSysCharSet): Boolean;
begin
  Result := AnsiChar(C) in CharSet; //FIXME: At some point beyond Delphi 7, the cast to AnsiChar is not longer needed.
end;
{$endif}
{$endif}

{$IFDEF UNICODE}
(*function CharInSet(C: UnicodeChar; const CharSet: TSysCharSet): Boolean;
begin
  Result := UnicodeChar(C) in CharSet; //FIXME: At some point beyond Delphi 7, the cast to AnsiChar is not longer needed.
end;*)
{$ENDIF}

{$ifndef DelphiXEorNewerCompiler}
function SplitString(const S, Delimiters: string): TStringDynArray;
var
  I, LastFound: Integer;
begin
  LastFound:=0;
  for I:=1 to Length(S) do
  begin
    if Pos(S[I], Delimiters)<>0 then
    begin
      SetLength(Result, Length(Result) + 1);
      Result[Length(Result) - 1]:=Copy(S, LastFound+1, I-LastFound-1);
      LastFound:=I;
    end;
  end;
  if LastFound<>Length(S) then
  begin
    SetLength(Result, Length(Result) + 1);
    Result[Length(Result) - 1]:=Copy(S, LastFound+1, MaxInt);
  end;
end;
{$endif}

{$ifndef DelphiXE6orNewerCompiler}
function StrToUInt(const S: string): Cardinal;
const
  SInvalidCardinal = '''%s'' is not a valid cardinal value';
begin
  if not TryStrToUInt(S, Result) then EConvertError.Create(Format(SInvalidCardinal, [S]));
end;

function StrToUIntDef(const S: string; Default: Cardinal): Cardinal;
begin
  if not TryStrToUInt(S, Result) then Result:=Default;
end;

function TryStrToUInt(const S: string; out Value: Cardinal): Boolean;
const
  MaxCardinal = 4294967295; //FIXME: Use Cardinal.MaxValue in Delphi 11.3
var
  Dummy: Int64;
begin
  Result:=False;

  //Go through Int64
  if not TryStrToInt64(S, Dummy) then
    Exit;

  //And then check the bounds
  if (Dummy < 0) or (Dummy > MaxCardinal) then
    Exit;

  Value:=Cardinal(Dummy);
  Result:=True;
end;
{$endif}

{$ifndef Delphi12orNewerCompiler}
function GetCompilerVersion: Word;
begin
  {$ifdef CompiledWithDelphi1}
  Result:=8;
  {$else}
  {$ifdef CompiledWithDelphi2}
  Result:=9;
  {$else}
  {$ifdef CompiledWithDelphi3}
  Result:=10;
  {$else}
  {$ifdef CompiledWithDelphi4}
  Result:=12;
  {$else}
  {$ifdef CompiledWithDelphi5}
  Result:=13;
  {$else}
  Result := Trunc(CompilerVersion) shl 8;
  {$endif}
  {$endif}
  {$endif}
  {$endif}
  {$endif}
end;

function GetRTLVersion: Word;
begin
  {$ifdef CompiledWithDelphi1}
  Result:=8;
  {$else}
  {$ifdef CompiledWithDelphi2}
  Result:=9;
  {$else}
  {$ifdef CompiledWithDelphi3}
  Result:=10;
  {$else}
  {$ifdef CompiledWithDelphi4}
  Result:=12;
  {$else}
  {$ifdef CompiledWithDelphi5}
  Result:=13;
  {$else}
  Result := Trunc(RTLVersion) shl 8;
  {$IFDEF CONDITIONALEXPRESSIONS}
  {$IF declared(RTLVersion113) or declared(RTLVersion123)}
  Result := Result + $0003;
  {$ELSEIF declared(RTLVersion1042) or declared(RTLVersion112) or declared(RTLVersion122)}
  Result := Result + $0002;
  {$ELSEIF declared(RTLVersion1041) or declared(RTLVersion111) or declared(RTLVersion121) or declared(RTLVersion131)}
  Result := Result + $0001;
  {$IFEND}
  {$ENDIF}
  {$endif}
  {$endif}
  {$endif}
  {$endif}
  {$endif}
end;

function CanUseDoubleBuffering: Boolean; //Really: TWinControl.CanUseDoubleBuffering and TButtonControl.CanUseDoubleBuffering
const
  SingleBufferingInRemoteSessions = True; //Application.SingleBufferingInRemoteSessions
begin
  //Based on: https://docwiki.embarcadero.com/RADStudio/Florence/en/Double-buffering_and_Remote_Connections
  Result := not ((GetSystemMetrics(SM_REMOTESESSION) <> 0) and SingleBufferingInRemoteSessions);
end;
{$endif}

//From: http://delphi.about.com/od/adptips2004/a/bltip0904_2.htm
function LastPos(const SubStr: String; const S: String): Integer;
begin
  Result := Pos(ReverseString(SubStr), ReverseString(S)) ;
  if (Result <> 0) then
    Result := ((Length(S) - Length(SubStr)) + 1) - Result + 1;
end;

function DateTimeToWin64(const AValue: TDateTime): QWORD;
begin
  Result := Round((AValue - Win64DateDelta) * SecsPerDay * 100000000);
end;

function Win64ToDateTime(const AValue: QWORD): TDateTime;
begin
  Result := AValue / SecsPerDay / 100000000 + Win64DateDelta;
end;

function CompareFileName(const S1, S2: string): Integer;
begin
  {$IFDEF UNICODE}
  Result:=UnicodeCompareFileName(S1, S2);
  {$ELSE}
  Result:=AnsiCompareFileName(S1, S2);
  {$ENDIF}
end;

procedure CleanupFileName(var S: String);
const
{$ifdef MSWINDOWS}
  //Semi-colon and comma are invalid if long filenames are not supported.
  cInvalidChars = ['\', '/', ':', '*', '?', '"', '<', '>', '|'{, ';', ','}];
{$else}
  cInvalidChars = ['/'];
{$endif}
var
 I: Integer;
begin
 for I:=Length(S) downto 1 do
 begin
   {$ifdef MSWINDOWS}
   if (S[I] < #20) //Control characters are invalid
   {$else}
   if (S[I] = #0) //Null bytes are invalid
   {$endif}
   or CharInSet(S[I], cInvalidChars) then
     System.Delete(S, I, 1);
 end;
end;

{$IFDEF UNICODE}
function UnicodeLowerCaseFileName(const S: UnicodeString): UnicodeString;
begin
  Result := AnsiLowerCase(S); //Yes, this function is misnamed in Delphi.
end;

function UnicodeCompareFileName(const S1, S2: UnicodeString): Integer;
begin
  Result := CompareStr(UnicodeLowerCaseFileName(S1), UnicodeLowerCaseFileName(S2)); //UnicodeCompareStr doesn't exist, but CompareStr is documented to handle Unicode.
end;
{$ENDIF}

{$ifndef Delphi2009orNewerCompiler}
function GetCPUCount: Integer;
{$IFDEF MSWINDOWS}
var
  SysInfo: TSystemInfo;
begin
  ZeroMemory(@SysInfo, SizeOf(SysInfo));
  if DelayFunc_GetNativeSystemInfo then
    GetNativeSystemInfo(SysInfo)
  else
    GetSystemInfo(SysInfo);
  Result := SysInfo.dwNumberOfProcessors;
end;
{$ENDIF}
{$IFDEF POSIX}
begin
  Result := sysconf(_SC_NPROCESSORS_ONLN);
end;
{$ENDIF}
{$endif}

{$ifdef MSWINDOWS}
//For delay loading functionality:
{$ifndef DELAYEDLOADING}
var
  UserLib, ShellLib, DWMAPILib: HMODULE;
{$endif}

{$ifndef Delphi5orNewerCompiler}
function SafeLoadLibrary(const Filename: string; ErrorMode: UINT): HMODULE;
var
  OldMode: UINT;
begin
  OldMode := SetErrorMode(ErrorMode);
  try
    Result := LoadLibrary(PChar(Filename));
  finally
    SetErrorMode(OldMode);
  end;
end;
{$endif}

{$ifdef ExtraFunc_CheckWin32Version}
function CheckWin32Version(AMajor: Integer; AMinor: Integer = 0): Boolean;
begin
  Result := (Win32MajorVersion > AMajor) or
            ((Win32MajorVersion = AMajor) and
             (Win32MinorVersion >= AMinor));
end;
{$endif}

function CopyCursor(pcur: HCursor): HCursor;
begin
  Result := HCURSOR(CopyIcon(HICON(pcur)));
end;

function HRESULT_CODE(hr: HResult): DWORD;
begin
  Result := hr and $FFFF;
end;

function SCODE_CODE(sc: SCODE): DWORD;
begin
  Result := sc and $FFFF;
end;

function HRESULT_FACILITY(hr: HResult): DWORD;
begin
  Result := (hr shr 16) and $1fff;
end;

function SCODE_FACILITY(sc: SCODE): DWORD;
begin
  Result := (sc shr 16) and $1fff;
end;

function HRESULT_SEVERITY(hr: HResult): DWORD;
begin
  Result := (hr shr 31) and $1;
end;

function SCODE_SEVERITY(sc: SCODE): DWORD;
begin
  Result := (sc shr 31) and $1;
end;

const
  msgGetVersionExFailed = 'Unable to retrieve system details. Call to GetVersionEx failed!';

function CheckWin32VersionWithServicePack(AMajor, AMinor, AServicePackMajor, AServicePackMinor: Integer): Boolean;
var
  OS: TOSVersionInfoEx;
  Win32ServicePackMajor, Win32ServicePackMinor: Integer;
begin
  if not CheckWin32Version(5, 0) then //Windows 2000
  begin
    Win32ServicePackMajor:=0;
    Win32ServicePackMinor:=0;
  end
  else
  begin
    ZeroMemory(@OS,SizeOf(OS));
    OS.dwOSVersionInfoSize:=SizeOf(TOSVersionInfoEx);
    if not GetVersionEx(POSVersionInfo(@OS)^) then
      raise Exception.Create(msgGetVersionExFailed);
    Win32ServicePackMajor:=OS.wServicePackMajor;
    Win32ServicePackMinor:=OS.wServicePackMinor;
  end;
  Result := (Win32MajorVersion > AMajor) or
            ((Win32MajorVersion = AMajor) and (Win32MinorVersion >= AMinor)) or
            ((Win32MajorVersion = AMajor) and (Win32MinorVersion = AMinor) and (Win32ServicePackMajor >= AServicePackMajor)) or
            ((Win32MajorVersion = AMajor) and (Win32MinorVersion = AMinor) and (Win32ServicePackMajor = AServicePackMajor) and (Win32ServicePackMinor >= AServicePackMinor));
end;

function CheckWin32VersionWithBuildNumber(AMajor: Integer; AMinor: Integer = 0; ABuildNumber: Integer = 0): Boolean;
var
  OS: TOSVersionInfo;
  Win32BuildNumber: Integer;
begin
  ZeroMemory(@OS,SizeOf(OS));
  OS.dwOSVersionInfoSize:=SizeOf(TOSVersionInfo);
  if not GetVersionEx(OS) then
    raise Exception.Create(msgGetVersionExFailed);
  Win32BuildNumber:=OS.dwBuildNumber;
  Result := (Win32MajorVersion > AMajor) or
            ((Win32MajorVersion = AMajor) and (Win32MinorVersion >= AMinor)) or
            ((Win32MajorVersion = AMajor) and (Win32MinorVersion = AMinor) and (Win32BuildNumber >= ABuildNumber));
end;
{$endif}

initialization
{$ifdef MSWINDOWS}
{$ifndef DELAYEDLOADING}
  //Initialize the delayed loading functions now, because this version of Delphi
  //doesn't support delayed loading.
  //Note: The module 'kernel32' is always loaded inside a process.
{.$ifndef Delphi4orNewerCompiler}
  UserLib:=SafeLoadLibrary('user32.dll');
  if UserLib = 0 then
    GetGuiResources := nil
  else
    GetGuiResources := GetProcAddress(UserLib, 'GetGuiResources');

  DelayFunc_GetGuiResources := Assigned(GetGuiResources);
  {$DEFINE DelayFunc_Delphi4Done}
{.$endif}
{$ifndef Delphi2007orNewerCompiler}
  DWMAPILib:=SafeLoadLibrary('DWMAPI.DLL');
  if DWMAPILib = 0 then
  begin
    DwmEnableComposition := nil;
    //DwmIsCompositionEnabled := nil;
  end
  else
  begin
    DwmEnableComposition := GetProcAddress(DWMAPILib, 'DwmEnableComposition');
    //DwmIsCompositionEnabled := GetProcAddress(DWMAPILib, 'DwmIsCompositionEnabled');
  end;

  DelayFunc_DwmEnableComposition := Assigned(DwmEnableComposition);
  //DelayFunc_DwmIsCompositionEnabled := Assigned(DwmIsCompositionEnabled);
  {$DEFINE DelayFunc_Delphi2007Done}
{$endif}
{$ifndef Delphi2009orNewerCompiler}
  GlobalMemoryStatusEx := GetProcAddress(GetModuleHandle('kernel32'), 'GlobalMemoryStatusEx');
  GetTickCount64 := GetProcAddress(GetModuleHandle('kernel32'), 'GetTickCount64');

  DelayFunc_GlobalMemoryStatusEx := Assigned(GlobalMemoryStatusEx);
  DelayFunc_GetTickCount64 := Assigned(GetTickCount64);
  {$DEFINE DelayFunc_Delphi2009Done}
{$endif}
{$ifndef Delphi2010orNewerCompiler}
  GetNativeSystemInfo := GetProcAddress(GetModuleHandle('kernel32'), 'GetNativeSystemInfo');
   SetDllDirectoryA := GetProcAddress(GetModuleHandle('kernel32'), 'SetDllDirectoryA');
  SetDllDirectoryW := GetProcAddress(GetModuleHandle('kernel32'), 'SetDllDirectoryW');
  {$IFDEF UNICODE}SetDllDirectory:=SetDllDirectoryW;{$ELSE}SetDllDirectory:=SetDllDirectoryA;{$ENDIF};
  if ShellLib = 0 then
    ShellLib:=SafeLoadLibrary('shell32.dll');
  if ShellLib = 0 then
    SHRestricted := nil
  else
    SHRestricted := GetProcAddress(ShellLib, 'SHRestricted');

  DelayFunc_GetNativeSystemInfo := Assigned(GetNativeSystemInfo);
  DelayFunc_SetDllDirectoryA := Assigned(SetDllDirectoryA);
  DelayFunc_SetDllDirectoryW := Assigned(SetDllDirectoryW);
  DelayFunc_SetDllDirectory := Assigned(SetDllDirectory);
  DelayFunc_SHRestricted := Assigned(SHRestricted);
  {$DEFINE DelayFunc_Delphi2010Done}
{$endif}
{$ifndef DelphiXE2orNewerCompiler}
  GetErrorMode := GetProcAddress(GetModuleHandle('kernel32'), 'GetErrorMode');
  IsWow64Process := GetProcAddress(GetModuleHandle('kernel32'), 'IsWow64Process');

  DelayFunc_GetErrorMode := Assigned(GetErrorMode);
  DelayFunc_IsWow64Process := Assigned(IsWow64Process);
  {$DEFINE DelayFunc_DelphiXE2Done}
{$endif}
{$ifndef Delphi11orNewerCompiler}
  GetProcessMitigationPolicy := GetProcAddress(GetModuleHandle('kernel32'), 'GetProcessMitigationPolicy');
  SetProcessMitigationPolicy := GetProcAddress(GetModuleHandle('kernel32'), 'SetProcessMitigationPolicy');

  DelayFunc_GetProcessMitigationPolicy := Assigned(GetProcessMitigationPolicy);
  DelayFunc_SetProcessMitigationPolicy := Assigned(SetProcessMitigationPolicy);
  {$DEFINE DelayFunc_Delphi11Done}
{$endif}
{.$ifndef DelphiXXorNewerCompiler}
  IsWow64Process2 := GetProcAddress(GetModuleHandle('kernel32'), 'IsWow64Process2');
  GetFirmwareType := GetProcAddress(GetModuleHandle('kernel32'), 'GetFirmwareType');
  GetProcessUserModeExceptionPolicy := GetProcAddress(GetModuleHandle('kernel32'), 'GetProcessUserModeExceptionPolicy');
  SetProcessUserModeExceptionPolicy := GetProcAddress(GetModuleHandle('kernel32'), 'SetProcessUserModeExceptionPolicy');

  DelayFunc_IsWow64Process2 := Assigned(IsWow64Process2);
  DelayFunc_GetFirmwareType := Assigned(GetFirmwareType);
  DelayFunc_GetProcessUserModeExceptionPolicy := Assigned(GetProcessUserModeExceptionPolicy);
  DelayFunc_SetProcessUserModeExceptionPolicy := Assigned(SetProcessUserModeExceptionPolicy);
  {$DEFINE DelayFunc_DelphiXXDone}
{.$endif}
{$endif}

  //Delphi's delayed loading raises an exception if the function cannot be loaded.
  //To avoid that, don't try to call the function if it's not present.
  {$ifndef DelayFunc_Delphi4Done}
  DelayFunc_GetGuiResources := CheckWin32Version(5, 0); //Windows 2000
  {$endif}
  {$ifndef DelayFunc_Delphi2007Done}
  DelayFunc_DwmEnableComposition := CheckWin32Version(6, 0); //Windows Vista
  //DelayFunc_DwmIsCompositionEnabled := CheckWin32Version(6, 0); //Windows Vista
  {$endif}
  {$ifndef DelayFunc_Delphi2009Done}
  DelayFunc_GlobalMemoryStatusEx := CheckWin32Version(5, 0); //Windows 2000
  DelayFunc_GetTickCount64 := CheckWin32Version(6, 0); //Windows Vista, Windows Server 2008
  {$endif}
  {$ifndef DelayFunc_Delphi2010Done}
  DelayFunc_GetNativeSystemInfo := CheckWin32Version(5, 1); //Windows XP, Windows Server 2003
  DelayFunc_SetDllDirectoryA := CheckWin32VersionWithServicePack(5, 1, 1); //Windows XP SP1, Windows Server 2003
  DelayFunc_SetDllDirectoryW := CheckWin32VersionWithServicePack(5, 1, 1); //Windows XP SP1, Windows Server 2003
  DelayFunc_SetDllDirectory := CheckWin32VersionWithServicePack(5, 1, 1); //Windows XP SP1, Windows Server 2003
  DelayFunc_SHRestricted := CheckWin32VersionWithServicePack(5, 1, 1); //Windows XP SP1, Windows Server 2003, although it already existed in Windows 2000 as ordinal 100.
  {$endif}
  {$ifndef DelayFunc_DelphiXE2Done}
  DelayFunc_GetErrorMode := CheckWin32Version(6, 0); //Windows Vista
  DelayFunc_IsWow64Process := CheckWin32VersionWithServicePack(5, 1, 2); //Windows XP with SP2, Windows Server 2003 with SP1
  {$endif}
  {$ifndef DelayFunc_Delphi11Done}
  DelayFunc_GetProcessMitigationPolicy := CheckWin32Version(6, 2); //Windows 8, Windows Server 2012
  DelayFunc_SetProcessMitigationPolicy := CheckWin32Version(6, 2); //Windows 8, Windows Server 2012
  {$endif}
  {$ifndef DelayFunc_DelphiXXDone}
  DelayFunc_IsWow64Process2 := CheckWin32VersionWithBuildNumber(10, 0, 16299); //Windows 10, version 1709
  DelayFunc_GetFirmwareType := CheckWin32Version(6, 2); //Windows 8, Server 2012
  DelayFunc_GetProcessUserModeExceptionPolicy := CheckWin32VersionWithServicePack(6, 1, 1); //Windows 7 SP 1
  DelayFunc_SetProcessUserModeExceptionPolicy := CheckWin32VersionWithServicePack(6, 1, 1); //Windows 7 SP 1
  {$endif}
{$endif}

  //Initialize other things too.
{$ifndef Delphi2009orNewerCompiler}
  CPUCount:=GetCPUCount;
{$endif}

{$ifdef MSWINDOWS}
{$ifndef DELAYEDLOADING}
finalization
  if UserLib<> 0 then
  begin
    FreeLibrary(UserLib);
    //UserLib:=0;
  end;
  if ShellLib<> 0 then
  begin
    FreeLibrary(ShellLib);
    //ShellLib:=0;
  end;
  if DWMAPILib<> 0 then
  begin
    FreeLibrary(DWMAPILib);
    //DWMAPILib:=0;
  end;
{$endif}
{$endif}
end.
