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
unit QkSpecifics;

{$B-,R-,X+}

//Originally, QuArK used TStringList to store specifics internally. However,
//this causes problems when we switch to 64-bit and/or Unicode, as the string
//data format and the binary data format are no longer compatible. Older Delphi's
//don't have a convenient container type to handle this, so let's make our own.
//
//It is heavily inspired by TStringList, but we've stripped functionality
//we don't need.

{$INCLUDE DelphiCompat.inc}

interface

uses DelphiCompat, Classes;

resourcestring
  SListItemNotFoundError = 'Item not found (%s)';
  SDuplicateSpecific = 'Specifics list does not allow duplicates (%s)';

type
  PSpecificsItem = ^TSpecificsItem;
  TSpecificsItem = record
    Key: String;
    Value: String;
  end;

const
  MaxSpecificsListSize = MaxInt div SizeOf(TSpecificsItem);

type
  TTryGetResult = (tgrSuccess, tgrNotFound, tgrWrongType);

  PSpecificsItemList = ^TSpecificsItemList;
  TSpecificsItemList = array[0..MaxSpecificsListSize-1] of TSpecificsItem;

  TSpecificsList = class(TPersistent)
  private
    FList: PSpecificsItemList;
    FCount: Integer;
    FCapacity: Integer;
    function GetName(Index: Integer): String;
    procedure Grow;
    function GetBytes(const Name: String): String;
    function GetBytesFromIndex(Index: Integer): String;
    procedure SetBytes(const Name: String; const B: String);
    procedure SetBytesFromIndex(Index: Integer; const B: String);
    function GetFloat(const Name: String): Single;
    function GetFloatFromIndex(Index: Integer): Single;
    procedure SetFloat(const Name: String; const F: Single);
    procedure SetFloatFromIndex(Index: Integer; const F: Single);
    function GetInteger(const Name: String): Integer;
    function GetIntegerFromIndex(Index: Integer): Integer;
    procedure SetInteger(const Name: String; const I: Integer);
    procedure SetIntegerFromIndex(Index: Integer; const I: Integer);
    function GetString(const Name: String): String;
    function GetStringFromIndex(Index: Integer): String;
    procedure SetString(const Name: String; const S: String);
    procedure SetStringFromIndex(Index: Integer; const S: String);
  protected
    procedure Error(const Msg: String; Data: Integer); overload;
    procedure Error(const Msg: String; const Data: String); overload;
    procedure Error(Msg: PResStringRec; Data: Integer); overload;
    procedure Error(Msg: PResStringRec; const Data: String); overload;
    function Get(Index: Integer): TSpecificsItem;
    procedure Put(Index: Integer; const Item: TSpecificsItem);
    procedure SetCapacity(NewCapacity: Integer);
  public
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
    procedure Delete(const Name: String; raiseError: Boolean = false); overload;
    procedure Delete(Index: Integer); overload;
    function GetSize(Index: Integer) : Integer;
    function IndexOfName(const Name: String): Integer;
    procedure Insert(Index: Integer; const Item: TSpecificsItem);
    procedure InsertBytes(Index: Integer; const Name: String; const B: String);
    procedure InsertFloat(Index: Integer; const Name: String; const F: Single);
    procedure InsertInteger(Index: Integer; const Name: String; const I: Integer);
    procedure InsertString(Index: Integer; const Name: string; const S: string); overload;
    procedure InsertString(Index: Integer; const Name: string; const S: PChar; Len: Integer); overload;
    function TryGetBytes(const Name: String; var B: String): TTryGetResult;
    function TryGetFloats(const Name: String; var F: Single): TTryGetResult;
    function TryGetIntegers(const Name: String; var I: Integer): TTryGetResult;
    function TryGetStrings(const Name: String; var S: String): TTryGetResult;

    property Count: Integer read FCount;
    property Items[Index: Integer]: TSpecificsItem read Get write Put; (*default;*)
    property Names[Index: Integer]: String read GetName;

    property ByteArray[const Name: String]: String read GetBytes write SetBytes;
    property ByteArrayFromIndex[Index: Integer]: String read GetBytesFromIndex write SetBytesFromIndex;
    property Floats[const Name: String]: Single read GetFloat write SetFloat;
    property FloatsFromIndex[Index: Integer]: Single read GetFloatFromIndex write SetFloatFromIndex;
    property Integers[const Name: String]: Integer read GetInteger write SetInteger;
    property IntegersFromIndex[Index: Integer]: Integer read GetIntegerFromIndex write SetIntegerFromIndex;
    property Strings[const Name: String]: String read GetString write SetString;
    property StringsFromIndex[Index: Integer]: String read GetStringFromIndex write SetStringFromIndex;
  end;

 {------------------------}

implementation

uses {$IFDEF Delphi6orNewerCompiler}RTLConsts{$ELSE}consts{$ENDIF}, SysUtils;

destructor TSpecificsList.Destroy;
begin
  inherited Destroy;
  Clear();
end;

procedure TSpecificsList.Assign(Source: TPersistent);
var
  I: Integer;
begin
  if Source is TSpecificsList then
  begin
    Clear;
    for I := 0 to TSpecificsList(Source).Count - 1 do
      Insert(FCount, TSpecificsList(Source).Items[I]);
    Exit;
  end;
  inherited Assign(Source);
end;

procedure TSpecificsList.Clear;
begin
  if FCount <> 0 then
  begin
    Finalize(FList^[0], FCount);
    FCount := 0;
  end;
  SetCapacity(0);
end;

procedure TSpecificsList.Delete(const Name: String; raiseError: Boolean);
var
  Index: Integer;
begin
  Index := IndexOfName(Name);
  if Index < 0 then
  begin
    if raiseError then
      Error(@SListIndexError, Index);
    Exit;
  end;
  Finalize(FList^[Index]);
  Dec(FCount);
  if Index < FCount then
    System.Move(FList^[Index + 1], FList^[Index],
      (FCount - Index) * SizeOf(TSpecificsItem));
end;

procedure TSpecificsList.Delete(Index: Integer);
begin
  if (Index < 0) or (Index >= FCount) then Error(@SListIndexError, Index);
  Finalize(FList^[Index]);
  Dec(FCount);
  if Index < FCount then
    System.Move(FList^[Index + 1], FList^[Index],
      (FCount - Index) * SizeOf(TSpecificsItem));
end;

procedure TSpecificsList.Error(const Msg: String; Data: Integer);

  function ReturnAddr: Pointer;
  asm
          MOV     EAX,[EBP+4]
  end;

begin
  raise EStringListError.CreateFmt(Msg, [Data]) at ReturnAddr;
end;

procedure TSpecificsList.Error(const Msg: String; const Data: String);

  function ReturnAddr: Pointer;
  asm
          MOV     EAX,[EBP+4]
  end;

begin
  raise EStringListError.CreateFmt(Msg, [Data]) at ReturnAddr;
end;

procedure TSpecificsList.Error(Msg: PResStringRec; Data: Integer);
begin
  Error(LoadResString(Msg), Data);
end;

procedure TSpecificsList.Error(Msg: PResStringRec; const Data: String);
begin
  Error(LoadResString(Msg), Data);
end;

function TSpecificsList.Get(Index: Integer): TSpecificsItem;
begin
  if (Index < 0) or (Index >= FCount) then Error(@SListIndexError, Index);
  Result := FList^[Index];
end;

function TSpecificsList.GetBytes(const Name: String): String;
begin
  //FIXME: For now, store the bytes in a string
  Result := GetString(Name);
end;

function TSpecificsList.GetBytesFromIndex(Index: Integer): String;
begin
  //FIXME: For now, store the bytes in a string
  Result := GetStringFromIndex(Index);
end;

function TSpecificsList.GetFloat(const Name: String): Single;
var
  Index: Integer;
begin
  Index := IndexOfName(Name);
  if (Index < 0) then Error(@SListItemNotFoundError, Name);
  Result := StrToFloat(FList^[Index].Value);
end;

function TSpecificsList.GetFloatFromIndex(Index: Integer): Single;
begin
  if (Index < 0) or (Index >= FCount) then Error(@SListIndexError, Index);
  Result := StrToFloat(FList^[Index].Value);
end;

function TSpecificsList.GetInteger(const Name: String): Integer;
var
  Index: Integer;
begin
  Index := IndexOfName(Name);
  //if (Index < 0) then Error(@SListItemNotFoundError, Name); //FIXME: This is a backwards compatibility thing!!!
  if (Index < 0) then begin Result:=0; Exit; end; //FIXME: This is a backwards compatibility thing!!!
  Result := StrToInt(FList^[Index].Value);
end;

function TSpecificsList.GetIntegerFromIndex(Index: Integer): Integer;
begin
  if (Index < 0) or (Index >= FCount) then Error(@SListIndexError, Index);
  Result := StrToInt(FList^[Index].Value);
end;

function TSpecificsList.GetString(const Name: String): String;
var
  Index: Integer;
begin
  Index := IndexOfName(Name);
  //if (Index < 0) then Error(@SListItemNotFoundError, Name); //FIXME: This is a backwards compatibility thing!!!
  if (Index < 0) then begin Result:=''; Exit; end; //FIXME: This is a backwards compatibility thing!!!
  Result := FList^[Index].Value;
end;

function TSpecificsList.GetStringFromIndex(Index: Integer): String;
begin
  if (Index < 0) or (Index >= FCount) then Error(@SListIndexError, Index);
  Result := FList^[Index].Value;
end;

function TSpecificsList.GetName(Index: Integer): String;
begin
  Result := Get(Index).Key;
end;

function TSpecificsList.GetSize(Index: Integer) : Integer;
begin
  Result := SizeOf(String)+Length(Names[Index])*SizeOf(Char) //Key
           +SizeOf(String)+Length(ByteArrayFromIndex[Index])*SizeOf(Char); //Value
  //FIXME: This doesn't take into account possible string sharing/pooling between objects!
end;

procedure TSpecificsList.Grow;
var
  Delta: Integer;
begin
  if FCapacity > 64 then Delta := FCapacity div 4 else
    if FCapacity > 8 then Delta := 16 else
      Delta := 4;
  SetCapacity(FCapacity + Delta);
end;

function TSpecificsList.IndexOfName(const Name: String): Integer;
begin
  for Result := 0 to FCount - 1 do
    if CompareText(FList^[Result].Key, Name) = 0 then Exit;
  Result := -1;
end;

procedure TSpecificsList.Insert(Index: Integer; const Item: TSpecificsItem);
begin
  if (Index < 0) or (Index > FCount) then Error(@SListIndexError, Index); //Note: Index = FCount is allowed!
  if (IndexOfName(Item.Key) >= 0) then Error(@SDuplicateSpecific, Item.Key);
  if FCount = FCapacity then Grow;
  if Index < FCount then
    System.Move(FList^[Index], FList^[Index + 1],
      (FCount - Index) * SizeOf(TSpecificsItem));
  with FList^[Index] do
  begin
    Pointer(Key) := nil;
    Pointer(Value) := nil;
  end;
  FList^[Index]:=Item;
  Inc(FCount);
end;

procedure TSpecificsList.InsertBytes(Index: Integer; const Name: String; const B: string);
begin
  //FIXME: For now, store the bytes in a string
  InsertString(Index, Name, B);
end;

procedure TSpecificsList.InsertFloat(Index: Integer; const Name: String; const F: Single);
begin
  if (Index < 0) or (Index > FCount) then Error(@SListIndexError, Index); //Note: Index = FCount is allowed!
  if (IndexOfName(Name) >= 0) then Error(@SDuplicateSpecific, Name);
  if FCount = FCapacity then Grow;
  if Index < FCount then
    System.Move(FList^[Index], FList^[Index + 1],
      (FCount - Index) * SizeOf(TSpecificsItem));
  with FList^[Index] do
  begin
    Pointer(Key) := nil;
    Pointer(Value) := nil;
    Key := Name;
  end;
  FList^[Index].Value := FloatToStr(F);
  Inc(FCount);
end;

procedure TSpecificsList.InsertInteger(Index: Integer; const Name: String; const I: Integer);
begin
  if (Index < 0) or (Index > FCount) then Error(@SListIndexError, Index); //Note: Index = FCount is allowed!
  if (IndexOfName(Name) >= 0) then Error(@SDuplicateSpecific, Name);
  if FCount = FCapacity then Grow;
  if Index < FCount then
    System.Move(FList^[Index], FList^[Index + 1],
      (FCount - Index) * SizeOf(TSpecificsItem));
  with FList^[Index] do
  begin
    Pointer(Key) := nil;
    Pointer(Value) := nil;
    Key := Name;
  end;
  FList^[Index].Value := IntToStr(I);
  Inc(FCount);
end;

procedure TSpecificsList.InsertString(Index: Integer; const Name: String; const S: String);
begin
  if (Index < 0) or (Index > FCount) then Error(@SListIndexError, Index); //Note: Index = FCount is allowed!
  if (IndexOfName(Name) >= 0) then Error(@SDuplicateSpecific, Name);
  if FCount = FCapacity then Grow;
  if Index < FCount then
    System.Move(FList^[Index], FList^[Index + 1],
      (FCount - Index) * SizeOf(TSpecificsItem));
  with FList^[Index] do
  begin
    Pointer(Key) := nil;
    Key := Name;
    Pointer(Value) := nil;
  end;
  FList^[Index].Value := S;
  Inc(FCount);
end;

procedure TSpecificsList.InsertString(Index: Integer; const Name: String; const S: PChar; Len: Integer);
begin
  if (Index < 0) or (Index > FCount) then Error(@SListIndexError, Index); //Note: Index = FCount is allowed!
  if (IndexOfName(Name) >= 0) then Error(@SDuplicateSpecific, Name);
  if FCount = FCapacity then Grow;
  if Index < FCount then
    System.Move(FList^[Index], FList^[Index + 1],
      (FCount - Index) * SizeOf(TSpecificsItem));
  with FList^[Index] do
  begin
    Pointer(Key) := nil;
    Key := Name;
    Pointer(Value) := nil;
  end;
  System.SetString(FList^[Index].Value, S, Len);
  Inc(FCount);
end;

procedure TSpecificsList.Put(Index: Integer; const Item: TSpecificsItem);
begin
  if (Index < 0) or (Index >= FCount) then Error(@SListIndexError, Index);
  FList^[Index] := Item;
end;

procedure TSpecificsList.SetCapacity(NewCapacity: Integer);
begin
  ReallocMem(FList, NewCapacity * SizeOf(TSpecificsItem));
  FCapacity := NewCapacity;
end;

procedure TSpecificsList.SetBytes(const Name: String; const B: String);
begin
  //FIXME: For now, store the bytes in a string
  SetString(Name, B);
end;

procedure TSpecificsList.SetBytesFromIndex(Index: Integer; const B: String);
begin
  //FIXME: For now, store the bytes in a string
  SetStringFromIndex(Index, B);
end;

procedure TSpecificsList.SetFloat(const Name: String; const F: Single);
var
  Index: Integer;
begin
  Index := IndexOfName(Name);
  if (Index < 0) then
    InsertFloat(FCount, Name, F)
  else
    FList^[Index].Value := FloatToStr(F);
end;

procedure TSpecificsList.SetFloatFromIndex(Index: Integer; const F: Single);
begin
  if (Index < 0) or (Index >= FCount) then Error(@SListIndexError, Index);
  FList^[Index].Value := FloatToStr(F);
end;

procedure TSpecificsList.SetInteger(const Name: String; const I: Integer);
var
  Index: Integer;
begin
  Index := IndexOfName(Name);
  if (Index < 0) then
    InsertInteger(FCount, Name, I)
  else
    FList^[Index].Value := IntToStr(I);
end;

procedure TSpecificsList.SetIntegerFromIndex(Index: Integer; const I: Integer);
begin
  if (Index < 0) or (Index >= FCount) then Error(@SListIndexError, Index);
  FList^[Index].Value := IntToStr(I);
end;

procedure TSpecificsList.SetString(const Name: String; const S: String);
var
  Index: Integer;
begin
  Index := IndexOfName(Name);
  if (Index < 0) then
    InsertString(FCount, Name, S)
  else
    FList^[Index].Value := S;
end;

procedure TSpecificsList.SetStringFromIndex(Index: Integer; const S: String);
begin
  if (Index < 0) or (Index >= FCount) then Error(@SListIndexError, Index);
  FList^[Index].Value := S;
end;

function TSpecificsList.TryGetBytes(const Name: String; var B: String): TTryGetResult;
var
  Index: Integer;
begin
  Index := IndexOfName(Name);
  if (Index < 0) then
  begin
    Result := tgrNotFound;
    Exit;
  end;

  try
    B := FList^[Index].Value;
  except
   on EConvertError do
    begin
     Result := tgrWrongType;
     Exit;
    end;
  end;
  Result := tgrSuccess;
end;

function TSpecificsList.TryGetFloats(const Name: String; var F: Single): TTryGetResult;
var
  Index: Integer;
begin
  Index := IndexOfName(Name);
  if (Index < 0) then
  begin
    Result := tgrNotFound;
    Exit;
  end;

  try
    F := StrToFloat(FList^[Index].Value);
  except
   on EConvertError do
    begin
     Result := tgrWrongType;
     Exit;
    end;
  end;
  Result := tgrSuccess;
end;

function TSpecificsList.TryGetIntegers(const Name: String; var I: Integer): TTryGetResult;
var
  Index: Integer;
begin
  Index := IndexOfName(Name);
  if (Index < 0) then
  begin
    Result := tgrNotFound;
    Exit;
  end;

  try
    I := StrToInt(FList^[Index].Value);
  except
   on EConvertError do
    begin
     Result := tgrWrongType;
     Exit;
    end;
  end;
  Result := tgrSuccess;
end;

function TSpecificsList.TryGetStrings(const Name: String; var S: String): TTryGetResult;
var
  Index: Integer;
begin
  Index := IndexOfName(Name);
  if (Index < 0) then
  begin
    Result := tgrNotFound;
    Exit;
  end;

  try
    S := FList^[Index].Value;
  except
   on EConvertError do
    begin
     Result := tgrWrongType;
     Exit;
    end;
  end;
  Result := tgrSuccess;
end;

end.
