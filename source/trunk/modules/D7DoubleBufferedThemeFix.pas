{**************************************************************************************************}
{                                                                                                  }
{ D7DoubleBufferedThemeFix unit - Unoffical bug fix for Delphi 7                                        }
{ Version 1.0 (2009-02-18)                                                                         }
{                                                                                                  }
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is VCLFixPack.pas.                                                             }
{                                                                                                  }
{ The Initial Developer of the Original Code is Andreas Hausladen (Andreas.Hausladen@gmx.de).      }
{ Portions created by Andreas Hausladen are Copyright (C) 2008 Andreas Hausladen.                  }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{ Contributor(s):                                                                                  }
{ Sebastian Jänicke (D7DoubleBufferedThemeFix)                                                     }
{                                                                                                  }
{**************************************************************************************************}

// Das Original VCLFixPack gibt es hier:
// http://www.delphipraxis.net/post966823.html

unit D7DoubleBufferedThemeFix;

interface

{$IF CompilerVersion = 15} // Delphi 7
  {$DEFINE D7DoubleBufferedTheme}
{$IFEND}

uses
  Windows, SysUtils, Controls, Messages, Themes, StdCtrls;

implementation

// ORIGINAL CODE from VCLFixPack ***********************************************

type
  TJumpOfs = Integer;
  PPointer = ^Pointer;

  PXRedirCode = ^TXRedirCode;
  TXRedirCode = packed record
    Jump: Byte;
    Offset: TJumpOfs;
  end;

  PWin9xDebugThunk = ^TWin9xDebugThunk;
  TWin9xDebugThunk = packed record
    PUSH: Byte;
    Addr: Pointer;
    JMP: TXRedirCode;
  end;

  PAbsoluteIndirectJmp = ^TAbsoluteIndirectJmp;
  TAbsoluteIndirectJmp = packed record
    OpCode: Word;   //$FF25(Jmp, FF /4)
    Addr: PPointer;
  end;

{ Hooking }

function GetActualAddr(Proc: Pointer): Pointer;

  function IsWin9xDebugThunk(AAddr: Pointer): Boolean;
  begin
    Result := (AAddr <> nil) and
              (PWin9xDebugThunk(AAddr).PUSH = $68) and
              (PWin9xDebugThunk(AAddr).JMP.Jump = $E9);
  end;

begin
  if Proc <> nil then
  begin
    if (Win32Platform <> VER_PLATFORM_WIN32_NT) and IsWin9xDebugThunk(Proc) then
      Proc := PWin9xDebugThunk(Proc).Addr;
    if (PAbsoluteIndirectJmp(Proc).OpCode = $25FF) then
      Result := PAbsoluteIndirectJmp(Proc).Addr^
    else
      Result := Proc;
  end
  else
    Result := nil;
end;

procedure HookProc(Proc, Dest: Pointer; var BackupCode: TXRedirCode);
var
  n: DWORD;
  Code: TXRedirCode;
begin
  Proc := GetActualAddr(Proc);
  Assert(Proc <> nil);
  if ReadProcessMemory(GetCurrentProcess, Proc, @BackupCode, SizeOf(BackupCode), n) then
  begin
    Code.Jump := $E9;
    Code.Offset := PAnsiChar(Dest) - PAnsiChar(Proc) - SizeOf(Code);
    WriteProcessMemory(GetCurrentProcess, Proc, @Code, SizeOf(Code), n);
  end;
end;

procedure UnhookProc(Proc: Pointer; var BackupCode: TXRedirCode);
var
  n: Cardinal;
begin
  if (BackupCode.Jump <> 0) and (Proc <> nil) then
  begin
    Proc := GetActualAddr(Proc);
    Assert(Proc <> nil);
    WriteProcessMemory(GetCurrentProcess, Proc, @BackupCode, SizeOf(BackupCode), n);
    BackupCode.Jump := 0;
  end;
end;

procedure ReplaceVmtField(AClass: TClass; OldProc, NewProc: Pointer);
type
  PVmt = ^TVmt;
  TVmt = array[0..MaxInt div SizeOf(Pointer) - 1] of Pointer;
var
  I: Integer;
  Vmt: PVmt;
  n: Cardinal;
  P: Pointer;
begin
  OldProc := GetActualAddr(OldProc);
  NewProc := GetActualAddr(NewProc);

  I := vmtSelfPtr div SizeOf(Pointer);
  Vmt := Pointer(AClass);
  while (I < 0) or (Vmt[I] <> nil) do
  begin
    P := Vmt[I];
    if (P <> OldProc) and (Integer(P) > $10000) and not IsBadReadPtr(P, 6) then
      P := GetActualAddr(P);
    if P = OldProc then
    begin
      WriteProcessMemory(GetCurrentProcess, @Vmt[I], @NewProc, SizeOf(NewProc), n);
      Exit;
    end;
    Inc(I);
  end;
end;

function GetDynamicMethod(AClass: TClass; Index: Integer): Pointer;
asm
  call System.@FindDynaClass
end;

procedure DebugLog(const S: string);
begin
  OutputDebugString(PChar('VCLFixPack patch installed: ' + S));
end;

// ORIGINAL CODE from VCLFixPack END *******************************************

// The following code is written following the code of other fixes in the
// original VCLFixPack.

{---------------------------------------------------------------------------}
{$IFDEF D7DoubleBufferedTheme}
var
  WinControl_WMEraseBkgnd, ButtonControl_CNCtlColorStatic,
  Button_CNCtlColorBtn: Pointer;
  BackupWinControlWMEraseBkgnd, BackupButtonControlCNCtlColorStatic,
  BackupButtonCNCtlColorBtn: TXRedirCode;
  ButtonControl_CNCtlColorStaticCritSect: TRTLCriticalSection; //DanielPharos
  Button_CNCtlColorBtnCritSect: TRTLCriticalSection; //DanielPharos

type
  TD7DoubleBufferedThemeButton = class(TButton)
  private
    procedure CNCtlColorBtn(var Message: TWMCtlColorBtn); message CN_CTLCOLORBTN;
  end;

  TD7DoubleBufferedThemeWinControl = class(TWinControl)
  private
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
  end;

  TD7DoubleBufferedThemeButtonControl = class(TButtonControl)
  private
    procedure CNCtlColorStatic(var Message: TWMCtlColorStatic); message CN_CTLCOLORSTATIC;
  end;

procedure TD7DoubleBufferedThemeButton.CNCtlColorBtn(var Message: TWMCtlColorBtn);
begin
  if ThemeServices.ThemesEnabled then
  begin
    if Parent.DoubleBuffered then
      PerformEraseBackground(Self, Message.ChildDC)
    else
      ThemeServices.DrawParentBackground(Handle, Message.ChildDC, nil, False);
    { Return an empty brush to prevent Windows from overpainting we just have created. }
    Message.Result := GetStockObject(NULL_BRUSH);
  end
  else
  begin //DanielPharos
    EnterCriticalSection(Button_CNCtlColorBtnCritSect);
    try
      UnhookProc(Button_CNCtlColorBtn, BackupButtonCNCtlColorBtn);
      try
        inherited; // "inherited" is required here, otherwise this would be an endless recursion
      finally
        HookProc(Button_CNCtlColorBtn, @TD7DoubleBufferedThemeButton.CNCtlColorBtn,
          BackupButtonCNCtlColorBtn);
      end;
    finally
      LeaveCriticalSection(Button_CNCtlColorBtnCritSect);
    end;
  end;
end;

procedure TD7DoubleBufferedThemeWinControl.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  if ThemeServices.ThemesEnabled and Assigned(Parent) and (csParentBackground in ControlStyle) then
    begin
      { Get the parent to draw its background into the control's background. }
      if Parent.DoubleBuffered then
        PerformEraseBackground(Self, Message.DC)
      else
        ThemeServices.DrawParentBackground(Handle, Message.DC, nil, False);
    end
    else
    begin
      { Only erase background if we're not doublebuffering or painting to memory. }
      if not FDoubleBuffered or
         (TMessage(Message).wParam = TMessage(Message).lParam) then
        FillRect(Message.DC, ClientRect, Brush.Handle);
    end;

  Message.Result := 1;
end;

procedure TD7DoubleBufferedThemeButtonControl.CNCtlColorStatic(var Message: TWMCtlColorStatic);
begin
  if ThemeServices.ThemesEnabled then
  begin
    if Parent.DoubleBuffered then
      PerformEraseBackground(Self, Message.ChildDC)
    else
      ThemeServices.DrawParentBackground(Handle, Message.ChildDC, nil, False);
    Message.Result := GetStockObject(NULL_BRUSH);
  end
  else
  begin //DanielPharos
    EnterCriticalSection(ButtonControl_CNCtlColorStaticCritSect);
    try
      UnhookProc(ButtonControl_CNCtlColorStatic, BackupButtonControlCNCtlColorStatic);
      try
        inherited; // "inherited" is required here, otherwise this would be an endless recursion
      finally
        HookProc(ButtonControl_CNCtlColorStatic, @TD7DoubleBufferedThemeButtonControl.CNCtlColorStatic,
          BackupButtonControlCNCtlColorStatic);
      end;
    finally
      LeaveCriticalSection(ButtonControl_CNCtlColorStaticCritSect);
    end;
  end;
end;

procedure InitD7DoubleBufferedThemeFix;
begin
  InitializeCriticalSection(Button_CNCtlColorBtnCritSect); //DanielPharos
  InitializeCriticalSection(ButtonControl_CNCtlColorStaticCritSect); //DanielPharos
  WinControl_WMEraseBkgnd := GetDynamicMethod(TWinControl, WM_ERASEBKGND);
  if WinControl_WMEraseBkgnd <> nil then
  begin
    DebugLog('D7DoubleBufferedThemeFix 1');
    { Redirect the original function to the bug fixed version }
    HookProc(WinControl_WMEraseBkgnd, @TD7DoubleBufferedThemeWinControl.WMEraseBkgnd,
      BackupWinControlWMEraseBkgnd);
  end;
  ButtonControl_CNCtlColorStatic := GetDynamicMethod(TButtonControl, CN_CTLCOLORSTATIC);
  if ButtonControl_CNCtlColorStatic <> nil then
  begin
    DebugLog('D7DoubleBufferedThemeFix 2');
    { Redirect the original function to the bug fixed version }
    HookProc(ButtonControl_CNCtlColorStatic, @TD7DoubleBufferedThemeButtonControl.CNCtlColorStatic,
      BackupButtonControlCNCtlColorStatic);
  end;
  Button_CNCtlColorBtn := GetDynamicMethod(TButton, CN_CTLCOLORBTN);
  if Button_CNCtlColorBtn <> nil then
  begin
    DebugLog('D7DoubleBufferedThemeFix 3');
    { Redirect the original function to the bug fixed version }
    HookProc(Button_CNCtlColorBtn, @TD7DoubleBufferedThemeButton.CNCtlColorBtn,
      BackupButtonCNCtlColorBtn);
  end;
end;

procedure FiniD7DoubleBufferedThemeFix;
begin
  { Restore the original function }
  UnhookProc(WinControl_WMEraseBkgnd, BackupWinControlWMEraseBkgnd);
  UnhookProc(ButtonControl_CNCtlColorStatic, BackupButtonControlCNCtlColorStatic);
  UnhookProc(Button_CNCtlColorBtn, BackupButtonCNCtlColorBtn);
  DeleteCriticalSection(ButtonControl_CNCtlColorStaticCritSect); //DanielPharos
  DeleteCriticalSection(Button_CNCtlColorBtnCritSect); //DanielPharos
end;
{$ENDIF D7DoubleBufferedTheme}
{---------------------------------------------------------------------------}

initialization
  {$IFDEF D7DoubleBufferedTheme}
  InitD7DoubleBufferedThemeFix;
  {$ENDIF D7DoubleBufferedTheme}

finalization
  {$IFDEF D7DoubleBufferedTheme}
  FiniD7DoubleBufferedThemeFix;
  {$ENDIF D7DoubleBufferedTheme}

end.
