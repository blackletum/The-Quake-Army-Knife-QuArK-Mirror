unit ThemeMgrDB;

//----------------------------------------------------------------------------------------------------------------------
// This unit is belongs to the Soft Gems Theme Manager package.
//
// This unit is released under the MIT license:
// Copyright (c) 1999-2005 Mike Lischke (mike@lischke-online.de, www.soft-gems.net).
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
// OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
// You are asked to give the author(s) the due credit. This means that you acknowledge the work of the author(s)
// in the product documentation, about box, help or wherever a prominent place is.
//
//----------------------------------------------------------------------------------------------------------------------
//
// The original code is ThemeMgrDB.pas, released 03. February 2002.
//
// The initial developer of the original code is:
//   Mike Lischke (public@soft-gems.net, www.soft-gems.net).
//
// Portions created by Mike Lischke are
// (C) 2001-2005 Mike Lischke. All Rights Reserved.
//----------------------------------------------------------------------------------------------------------------------
//
// This unit contains the implementation of TThemeManagerDB, which is an enhancement of TThemeManager to fix
// DB controls related XP painting problems. Since this requires to take in many DB related units (which might not be
// desirable in most applications) it is kept as a separate unit.
//
// Thanks to Bert Moorthaemer, who greatly helped me to get started here.
//----------------------------------------------------------------------------------------------------------------------
// For version information and history see help file.
//----------------------------------------------------------------------------------------------------------------------

interface

uses
  Windows, Sysutils, Messages, Classes, Controls, Graphics, DBCtrls, ThemeMgr;

type
  TThemeManagerDB = class(TThemeManager)
  private
    FDBLookupControlList: TWindowProcList;
    procedure DBLookupControlWindowProc(Control: TControl; var Message : TMessage);

    procedure PreDBLookupControlWindowProc(var Message : TMessage);
  protected
    procedure HandleControlChange(Control: TControl; Inserting: Boolean); override;
    function NeedsBorderPaint(Control: TControl): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

//----------------------------------------------------------------------------------------------------------------------

implementation

uses
  ThemeSrv;

type
  PInteger = ^Integer;
  PBoolean = ^Boolean;
  PAlignment = ^TAlignment;

//----------------- TThemeManagerDB --------------------------------------------------------------------------------------

constructor TThemeManagerDB.Create(AOwner: TComponent);

begin
  inherited;

  FDBLookupControlList := TWindowProcList.Create(Self, PreDBLookupControlWindowProc, TDBLookupControl);

  // If the current main manager is not a DB manager then force this instance to become the main manager.
  if not (CurrentThemeManager is TThemeManagerDB) then
    ForceAsMainManager;
end;

//----------------------------------------------------------------------------------------------------------------------

destructor TThemeManagerDB.Destroy;

begin
  FDBLookupControlList.Free;

  inherited;
end;

//----------------------------------------------------------------------------------------------------------------------

type
  // In order to have access to some private variables, which are otherwise not reachable, we (partially) redeclare
  // the combo box declaration. This maps directly to the actual declaration.
  // Fortunately, private variables declaration in TDBLookupComboBoxCast hasn't changed since Delphi 4. However
  // this must be checked with future Delphi versions (if subclassing for themes is then still needed).
  {$Hints off} 
  TDBLookupComboBoxCast = class(TDBLookupControl)
  private
    FDataList: TPopupDataList;
    FButtonWidth: Integer;
    FText: string;
    FDropDownRows: Integer;
    FDropDownWidth: Integer;
    FDropDownAlign: TDropDownAlign;
    FListVisible: Boolean;
    FPressed: Boolean;
    FTracking: Boolean;
    FAlignment: TAlignment;
    FLookupMode: Boolean;
  end;
  {$Hints on}

procedure TThemeManagerDB.DBLookupControlWindowProc(Control: TControl; var Message : TMessage);

  //--------------- local function --------------------------------------------

  procedure PaintComboBox(DC: HDC);

  var
    W, X : Integer;
    S: string;
    AAlignment: TAlignment;
    Selected: Boolean;
    R: TRect;
    State : TThemedComboBox;
    P: TPoint;
    Hot: Boolean;
    Details: TThemedElementDetails;

  begin
    with TDBLookupComboBoxCast(Control) do
    begin
      Canvas.Font := Font;
      Canvas.Brush.Color := Color;
      Selected := HasFocus and not FListVisible and not (csPaintCopy in ControlState);
      GetCursorPos(P);
      Hot := (WindowFromPoint(P) = Handle) and not FListVisible;
      if Enabled then
        Canvas.Font.Color := Font.Color
      else
        Canvas.Font.Color := clGrayText;
      if Selected then
      begin
        Canvas.Font.Color := clHighlightText;
        Canvas.Brush.Color := clHighlight;
      end;
      if (csPaintCopy in ControlState) and (Field <> nil) and (Field.Lookup) then
      begin
        S := Field.DisplayText;
        AAlignment := Field.Alignment;
      end
      else
      begin
        if (csDesigning in ComponentState) and (Field = nil) then
          S := Name
        else
          S := FText;
        AAlignment := FAlignment;
      end;
      if UseRightToLeftAlignment then
        ChangeBiDiModeAlignment(AAlignment);
      W := ClientWidth - FButtonWidth;
      X := 2;
      case AAlignment of
        taRightJustify:
          X := W - Canvas.TextWidth(S) - 3;
        taCenter:
          X := (W - Canvas.TextWidth(S)) div 2;
      end;
      SetRect(R, 1, 1, W - 1, ClientHeight - 1);
      if (SysLocale.MiddleEast) and (BiDiMode = bdRightToLeft) then
      begin
        Inc(X, FButtonWidth);
        Inc(R.Left, FButtonWidth);
        R.Right := ClientWidth;
      end;
      if SysLocale.MiddleEast then
        TControlCanvas(Canvas).UpdateTextFlags;
      Canvas.TextRect(R, X, 2, S);
      if Selected then
        Canvas.DrawFocusRect(R);
      SetRect(R, W, 0, ClientWidth, ClientHeight);
      if (SysLocale.MiddleEast) and (BiDiMode = bdRightToLeft) then
      begin
        R.Left := 0;
        R.Right:= FButtonWidth;
      end;
      if not ListActive then
        State := tcDropDownButtonDisabled
      else
        if FPressed then
          State := tcDropDownButtonPressed
        else
          if Hot then
            State := tcDropDownButtonHot
          else
            State := tcDropDownButtonNormal;
      Details := ThemeServices.GetElementDetails(State);
      ThemeServices.DrawElement(DC, Details, R);
    end;
  end;

  //--------------- end local function ----------------------------------------

var
  PS : PaintStruct;

begin
  if ThemeServices.ThemesEnabled and (toAllowControls in Options) then
  begin
    case Message.Msg of
      WM_NCPAINT:
        begin
          FDBLookupControlList.DispatchMessage(Control, Message);
          ThemeServices.PaintBorder(Control as TWinControl, False);
        end;
      WM_PAINT :
        if TWinControl(Control) is TDBLookupComboBox then
        begin
          BeginPaint(TWinControl(Control).Handle, PS);
          PaintComboBox(PS.hdc);
          EndPaint(TWinControl(Control).Handle, PS);
          Message.Result := 0;
        end
        else
          FDBLookupControlList.DispatchMessage(Control, Message);
      CM_MOUSEENTER,
      CM_MOUSELEAVE:
        begin
          Control.Invalidate;
          FDBLookupControlList.DispatchMessage(Control, Message);
        end;
    else
      FDBLookupControlList.DispatchMessage(Control, Message);
    end;
  end
  else
    FDBLookupControlList.DispatchMessage(Control, Message);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TThemeManagerDB.PreDBLookupControlWindowProc(var Message: TMessage);

// Read more about this code in PreAnimateWindowProc.

begin
  TThemeManagerDB(CurrentThemeManager).DBLookupControlWindowProc(TControl(Self), Message);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TThemeManagerDB.HandleControlChange(Control: TControl; Inserting: Boolean);

var
  List: TWindowProcList;

begin
  List := nil;
  // Do subclassing work only on Windows XP or higher.
  if IsWindowsXP then
  begin
    if ThemeServices.ThemesEnabled then
    begin
      if Control is TDBLookupComboBox then
      begin
        if (toSubclassDBLookup in Options) or not Inserting then
          List := FDBLookupControlList
      end;

      if Assigned(List) then
      begin
        if Inserting then
          List.Add(Control)
        else
          List.Remove(Control);
      end
      else
        inherited;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TThemeManagerDB.NeedsBorderPaint(Control: TControl): Boolean;

begin
  Result := inherited NeedsBorderPaint(Control) or (Control is TDBLookupControl);
end;

//----------------------------------------------------------------------------------------------------------------------

end.
