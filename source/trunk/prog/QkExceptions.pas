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
unit QkExceptions;

{$INCLUDE DelphiCompat.inc}

interface

uses DelphiCompat, Windows, SysUtils, Classes, Controls, Dialogs, Forms, StdCtrls;

type
  TCustomExceptionHandler = class(TObject)
  private
    OldException: TExceptionEvent;
    procedure AppExceptionMore(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    procedure AppException(Sender: TObject; E: Exception);
    function MessageException(const E: Exception; const Info: String; Buttons: TMsgDlgButtons) : TModalResult;
  end;

  //Used specifically when a game file cannot be found, so these exceptions can be caught separately.
  EFileNotFound = class(Exception);

function GetExceptionMessage(E: Exception) : String;
procedure LogAndWarn(const WarnMessage : String);
procedure LogAndRaiseError(const ErrMessage : String);
function EError(Res: Integer) : Exception;
function EErrorFmt(Res: Integer; const Fmt: array of const) : Exception;
function InternalE(const Hint: String) : Exception;

function QFileNotFound(Res: Integer) : Exception;
function QFileNotFoundFmt(Res: Integer; const Fmt: array of const) : Exception;

procedure GlobalWarning(const Texte: String);
procedure GlobalDisplayWarnings;

procedure LogAndRaiseLastOSError(const AdditionalInfo: string);
procedure LogWindowsError(ErrNr: DWORD; const Call: String);

procedure InstallExceptProc;
procedure CustomExceptHandler(ExceptObject: TObject; ExceptAddr: Pointer);

var
  CustomExceptionHandler: TCustomExceptionHandler;

 {-------------------}

implementation

uses QConsts, TextBoxForm, Quarkx, Logging, Platform;

 {-------------------}

type
  ErrorDetails = record
    Message, Details: String;
  end;

function SplitErrorMessage(const Err: String) : ErrorDetails;
var
  I: Integer;
begin
  I:=Pos('//', Err);
  if I>0 then
  begin
    Result.Message:=Copy(Err, 1, I - 1);
    Result.Details:=Copy(Err, I+2, MaxInt);
  end
  else
  begin
    Result.Message:=Err;
    Result.Details:='';
  end;
end;

function GetExceptionMessage(E: Exception) : String;
var
  ErrMsg: ErrorDetails;
begin
  ErrMsg:=SplitErrorMessage(E.Message);
  if ErrMsg.Details<>'' then
  begin
    Log(LOG_VERBOSE, 'GetExceptionMessage: %s', [ErrMsg.Details]);
    {$IFDEF Debug}
    Result:=ErrMsg.Message+'.//'+ErrMsg.Details;
    {$ELSE}
    Result:=ErrMsg.Message+'.';
    {$ENDIF}
  end
  else
    Result:=ErrMsg.Message+'.';
end;

procedure LogAndWarn(const WarnMessage : String);
begin
  Log(LOG_WARNING, WarnMessage);
  Application.MessageBox(PChar(WarnMessage), 'QuArK', MB_ICONEXCLAMATION or MB_OK);
end;

procedure LogAndRaiseError(const ErrMessage : String);
begin
  Log(LOG_CRITICAL, ErrMessage);
  Raise Exception.Create(ErrMessage);
end;

function EError(Res: Integer) : Exception;
begin
 PythonCodeEnd;
 EError:=Exception.Create(LoadStr1(Res));
end;

function EErrorFmt(Res: Integer; const Fmt: array of const) : Exception;
begin
 PythonCodeEnd;
 EErrorFmt:=Exception.Create(FmtLoadStr1(Res, Fmt));
end;

function InternalE(const Hint: String) : Exception;
begin
  Result:=EErrorFmt(5223, [Hint]);
end;

 {------------------------}

function QFileNotFound(Res: Integer) : Exception;
begin
 PythonCodeEnd;
 Result:=EFileNotFound.Create(LoadStr1(Res));
end;

function QFileNotFoundFmt(Res: Integer; const Fmt: array of const) : Exception;
begin
 PythonCodeEnd;
 Result:=EFileNotFound.Create(FmtLoadStr1(Res, Fmt));
end;

 {------------------------}

var
  GlobalWarnings: TStringList;

procedure GlobalWarning(const Texte: String);
begin
  if Texte='' then Exit;
  Log(LOG_WARNING, 'Global warning: %s', [Texte]);
  if GlobalWarnings=Nil then
  begin
    GlobalWarnings:=TStringList.Create;
   {PostMessage(g_Form1.Handle, wm_InternalMessage, wp_Warning, 0);}
  end;
  GlobalWarnings.Add(Texte);
end;

procedure GlobalDisplayWarnings;
var
  ProcessedWarnings: TStringList;
  I: Integer;
  ErrMsg: ErrorDetails;
begin
  if GlobalWarnings=Nil then
    Exit;

  //Note that we need to clear GlobalWarnings before going into the Modal loop,
  //because AppIdle will trigger, and call this procedure again, causing an endless loop!

  ProcessedWarnings:=TStringList.Create;
  try
    for I:=0 to GlobalWarnings.Count-1 do
    begin
      ErrMsg:=SplitErrorMessage(GlobalWarnings[I]);
      if ProcessedWarnings.IndexOf(ErrMsg.Message) < 0 then
        ProcessedWarnings.Add(ErrMsg.Message);
    end;
    GlobalWarnings.Free;
    GlobalWarnings:=nil;

    ShowTextBox('QuArK', LoadStr1(5835), ProcessedWarnings, mtWarning);
  finally
    ProcessedWarnings.Free;
  end;
end;

 {------------------------}

procedure LogAndRaiseLastOSError(const AdditionalInfo: string);
begin
  try
    //We could use this (missing in Delphi XE2, but existing in Delphi 11.3),
    //but it's bad in two ways:
    //1) We have to retrieve the LastError ourselves, which is dumb. If you
    //are going to have overloads, at least have the right ones.
    //2) AdditionalInfo simply gets appended, without even a sLineBreak. This
    //creates totally unreadable error messages.
    //So instead, we're going to manipulate the error message below.
    //RaiseLastOSError(GetLastError, AdditionalInfo);
    RaiseLastOSError();
    //Note: This always raises something!
  except
    on E: {$IFDEF Delphi6orNewerCompiler}EOSError{$ELSE}EWin32Error{$ENDIF} do
    begin
      E.Message:=AdditionalInfo + sLineBreak + sLineBreak + E.Message;
      Log(LOG_WARNING, E.Message);
      raise;
    end;
  end;
end;

procedure LogWindowsError(ErrNr: DWORD; const Call: String);
begin
  Log(LOG_WARNING, 'Error when calling a Windows API:' + sLineBreak +
                   'Call: %s' + sLineBreak +
                   'Reason: %s', [Call, SysErrorMessage(ErrNr)]);
end;

 {------------------------}

constructor TCustomExceptionHandler.Create();
begin
  //Hook application-level exception handling
  OldException:=Application.OnException;
  Application.OnException:=CustomExceptionHandler.AppException;
end;

destructor TCustomExceptionHandler.Destroy();
begin
  //Unhook application-level exception handling
  Application.OnException:=OldException;
  //OldException:=nil;

  inherited;
end;

procedure TCustomExceptionHandler.AppException(Sender: TObject; E: Exception);
begin
  try
    MessageException(E, '%s', [mbOk]);
  except
    //If anything goes wrong with QuArK's exception handling, use the old one
    try
      Log(LOG_ALWAYS, Format('Error: Exception in exception handler: %s', [GetExceptionMessage(E)]));
    except
      //Ignore any errors here
    end;
    OldException(Sender, E);
  end;

{$IFDEF madExcept}
  //Some parts of QuArK's code (Python exception handling) calls this function directly.
  //So let's force those cases through madExcept too. However, madExcept can't figure out
  //the original exception message, so let's display that first, and then blow up.
  raise E;
{$ENDIF}
end;

function TCustomExceptionHandler.MessageException(const E: Exception; const Info: String; Buttons: TMsgDlgButtons) : TModalResult;
const
 Fallback4614 = '&More >>';
var
 B: TButton;
{P: Integer;}
 S: String;
begin
(*if E.HelpContext=0 then
  Application.ShowException(E)
 else
  begin
   PlaySound(SOUND_ERROR);
   MessageDlg(E.Message, mtError, [mbOk, mbHelp], E.HelpContext);
  end;*)
 if E is EAbort then
  begin
   Result:=mrNone;
   Exit;   { silent exception }
  end;
 PlaySound(SOUND_ERROR);
 Include(Buttons, mbIgnore);
 if E.HelpContext<>0 then Include(Buttons, mbHelp);
 S:=Format(Info, [GetExceptionMessage(E)]);
 try
   Log(LOG_ALWAYS, 'Error: '+S);
 except
   //Ignore any errors here
 end;
{P:=Pos('//', S);
 if P=0 then
  P:=Length(S)+1;}
 with CreateMessageDialog({Copy(}S{,1,P-1)}, mtError, Buttons) do
  try
   HelpContext := E.HelpContext;
   B:=FindComponent('Ignore') as TButton;
   with B do
    begin
     if IsPythonInited then
      Caption:=LoadStr1(4614)
     else
      Caption:=Fallback4614;
     Hint:=E.Message;
     ModalResult:=mrNone;
     OnClick:=AppExceptionMore;
    end;
  {if P<Length(E.Message) then
    ActiveControl:=B;}
   Result:=ShowModal;
  finally
   Free;
  end;
end;

var
  OverrideExceptAddr: Pointer;

procedure TCustomExceptionHandler.AppExceptionMore(Sender: TObject);
const
 DlgW  = 372;
 MemoH = 160;
 Margin = 8;
 Fallback4616 = '                     *** EXCEPTION REPORT ***'+sLineBreak+sLineBreak+'%s'+sLineBreak+'Compiled with: %s'+sLineBreak+'Address in the program: 0x%p (base: 0x%p)';
 Fallback4617 = 'Please report this error to the QuArK development team, so that they can fix the issue promptly.';
 Fallback5823 = '%s on %s';
var
{E: Exception;}
 Msg: String;
 Dlg: TCustomForm;
 P: Integer;
 L: TStringList;
 Delta: Integer;
 ExceptAddrX: Pointer;
{$IFDEF Delphi7orNewerCompiler}
 DateFormat: TFormatSettings;
{$ENDIF}
begin
 with Sender as TButton do
  begin
   Enabled:=False;
   //{$IFDEF DelphiXE2orNewerCompiler}NativeInt{$ELSE}LongInt{$ENDIF}(Pointer(E)):=Tag;
   Msg:=Hint;
  end;
 L:=TStringList.Create; try
 if OverrideExceptAddr = nil then
  ExceptAddrX:=ExceptAddr
 else
  ExceptAddrX:=OverrideExceptAddr;
 {$IFDEF Delphi7orNewerCompiler}
 GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, DateFormat);
 {$ENDIF}
 if IsPythonInited then
  L.Add(AdjustLineBreaks(FmtLoadStr1(4616, [QuArKFullVersion, Format(LoadStr1(5823), [QuArKUsedCompiler, DateToStr(QuArKCompileDate{$IFDEF Delphi7orNewerCompiler}, DateFormat{$ENDIF})]), ExceptAddrX, Pointer(GetModuleHandle(Nil))])))
 else
  L.Add(Format(Fallback4616, [QuArKFullVersion, Format(Fallback5823, [QuArKUsedCompiler, DateToStr(QuArKCompileDate{$IFDEF Delphi7orNewerCompiler}, DateFormat{$ENDIF})]), ExceptAddrX, Pointer(GetModuleHandle(Nil))]));
 {$IFDEF Debug}
 L.Add('DEBUG VERSION');
 {$ENDIF}
 L.Add('');
 P:=Pos('//', Msg);
 if P<>0 then
  begin
   L.Add(Copy(Msg, 1, P-1));
   L.Add(Copy(Msg, P+2, MaxInt));
  end
 else
  L.Add(Msg);
 L.Add(sLineBreak); //Note: This creates two linebreaks.
 if IsPythonInited then
  L.Add(AdjustLineBreaks(LoadStr1(4617)))
 else
  L.Add(Fallback4617);
 Dlg:=GetParentForm(TControl(Sender));
 Delta:=DlgW - Dlg.Width;
 if Delta<0 then Delta:=0;
 with TMemo.Create(Dlg) do
  begin
   SetBounds(Margin, Dlg.ClientHeight, Dlg.ClientWidth + Delta - (2 * Margin), MemoH - Margin);
   Parent:=Dlg;
   Lines:=L;
   ScrollBars:=ssVertical;
   ReadOnly:=True;
   WantReturns:=False;
   SetFocus;
  end;
 Dlg.SetBounds(Dlg.Left - Delta div 2, Dlg.Top, Dlg.Width + Delta, Dlg.Height + MemoH);
 finally L.Free; end;
end;

 {------------------------}

var
  OldExceptProc: Pointer;

procedure InstallExceptProc;
begin
  OldExceptProc:=ExceptProc;
  ExceptProc:=@CustomExceptHandler;
end;

procedure CustomExceptHandler(ExceptObject: TObject; ExceptAddr: Pointer);
begin
 //Restore old ExceptProc to become part of a chain of exception procedures.
 ExceptProc:=OldExceptProc;

 if ExceptObject is Exception then
 begin
   OverrideExceptAddr:=ExceptAddr;
   CustomExceptionHandler.AppException(nil, Exception(ExceptObject));
   Halt(1);
 end;

 //Since we didn't halt, Delphi will raise a runtime error.
end;

initialization
  CustomExceptionHandler:=TCustomExceptionHandler.Create();
finalization
  CustomExceptionHandler.Free;
end.
