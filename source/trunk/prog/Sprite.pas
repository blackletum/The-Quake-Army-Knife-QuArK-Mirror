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
unit Sprite;

{$INCLUDE DelphiCompat.inc}

interface

uses DelphiCompat, Types, SysUtils, Classes, qmath, QkObjects, Qk3D, QkImages, QkMdlObject;

type
  QSprite = class(Q3DObject)
  protected
    procedure GetVertices(var p: vec3_p);
  public
    class function TypeInfo: String; override;
    procedure ObjectState(var E: TEtatObjet); override;
    procedure Dessiner; override;
    Function GetSkinDescr: String;
    Function Skin0: QImage;
    procedure AddTo3DScene(Scene: TObject); override;
    procedure BuildRefList(L: TQList); virtual;
    procedure ChercheExtremites(var Min, Max: TVect); override;
    function Triangles(var P: PComponentTris) : Integer;
  end;

implementation

uses EdSceneObject, QkObjectClassList{$IFDEF PyProfiling}, Logging{$ENDIF};

class function QSprite.TypeInfo;
begin
  Result:=':sprite';
end;

procedure QSprite.ObjectState(var E: TEtatObjet);
begin
  inherited;
  E.IndexImage:=iiSpriteFile;
end;

procedure QSprite.Dessiner;
begin
 {$IFDEF PyProfiling}
 LogProfiling('QSprite, Dessiner', [], nil);
 {$ENDIF}
  //FIXME: Implement something
end;

procedure QSprite.BuildRefList(L: TQList);
begin
  L.Add(Self);
end;

function QSprite.GetSkinDescr: String;
begin
  Result:=':'+Parent.Name+':0';
end;

function QSprite.Skin0: QImage;
begin
  Result:=QImage(Subelements[0]);
  if result=nil then
    Parent.Acces;
end;

function QSprite.Triangles(var P: PComponentTris) : Integer;
var
  p_o: PComponentTris;
  size: TPoint;
begin
  size:=Skin0.GetSize;
  p_o:=AllocMem(sizeof(TComponentTris)*2);
  p:=p_o;
  p_o^[0].VertexNo:=0; P^[0].S:=0; P^[0].T:=0;
  p_o^[1].VertexNo:=1; P^[1].S:=size.x; P^[1].T:=0;
  p_o^[2].VertexNo:=2; P^[2].S:=0; P^[2].T:=size.y;
  inc(p_o);
  p_o^[0].VertexNo:=1; P^[0].S:=size.x; P^[0].T:=0;
  p_o^[1].VertexNo:=2; P^[1].S:=0; P^[1].T:=size.y;
  p_o^[2].VertexNo:=3; P^[2].S:=size.x; P^[2].T:=size.y;
  result:=2;
end;

procedure QSprite.GetVertices(var p: vec3_p);
var
  size: TPoint;
  p_o: vec3_p;
begin
  size:=Skin0.GetSize;
  GetMem(p_o, sizeof(vec3_t)*4);
  p:=p_o;
  p_o^[0]:=0.0;
  p_o^[1]:=0.0;
  p_o^[2]:=0.0;
  inc(p_o);
  p_o^[0]:=size.x;
  p_o^[1]:=0.0;
  p_o^[2]:=0.0;
  inc(p_o);
  p_o^[0]:=0.0;
  p_o^[1]:=size.y;
  p_o^[2]:=0.0;
  inc(p_o);
  p_o^[1]:=size.x;
  p_o^[1]:=size.y;
  p_o^[2]:=0.0;
end;

procedure QSprite.AddTo3DScene(Scene: TObject);
var
  Info: PSpriteInfo;
  size: TPoint;
begin
  size:=Skin0.GetSize;
  New(Info);
  FillChar(Info^, SizeOf(TSpriteInfo), 0);
  Info^.Base:=Self;
  Info^.Alpha:=255;
  Info^.VertexCount:=4;
  Info^.Width:=size.x;
  Info^.Height:=size.y;
  GetVertices(Info^.Vertices);
  AddRef(+1);
  TSceneObject(Scene).AddSprite(Info);
end;

procedure QSprite.ChercheExtremites(var Min, Max: TVect);
var
  I: Integer;
  P: vec3_p;
begin
  GetVertices(P);
  try
    for I:=1 to 4 do
    begin
      if P^[0] < Min.X then
        Min.X:=P^[0];
      if P^[1] < Min.Y then
        Min.Y:=P^[1];
      if P^[2] < Min.Z then
        Min.Z:=P^[2];
      if P^[0] > Max.X then
        Max.X:=P^[0];
      if P^[1] > Max.Y then
        Max.Y:=P^[1];
      if P^[2] > Max.Z then
        Max.Z:=P^[2];
      Inc(P);
    end;
  finally
    FreeMem(P);
  end;
end;

initialization
  RegisterQObject(QSprite, 'a');
end.
