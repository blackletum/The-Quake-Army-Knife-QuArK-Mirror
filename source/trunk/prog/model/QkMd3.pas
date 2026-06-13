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
unit QkMd3;

{$INCLUDE DelphiCompat.inc}

interface

uses DelphiCompat, Types, SysUtils, Classes, QkObjects, QkImages, QkTextures, QkFileObjects,
     QkModelFile, QkModelRoot, QkFrame, QkComponent, QkMdlObject, QkModelTag,
     QkTagFrame, QkBoundFrame, QkMiscGroup{, QkFrameGroup};

type
  QMd3File = class(QModelFile)
    protected
      procedure LoadFile(F: TStream; FSize: TStreamPos); override;
      procedure SaveFile(Info: TInfoEnreg1); override;
      Procedure ReadMesh(fs: TStream; Root: QModelRoot);
    public
      class function TypeInfo: String; override;
      class procedure FileObjectClassInfo(var Info: TFileObjectClassInfo); override;
      function Loaded_ShaderFile(Comp: QComponent; tex_name: string): QImage;
      function AttachModelToTag(const Tag_Name: string; model: QModelFile): boolean;
      function AttachModelToTagFromFileName(const Tag_Name: string; const Filename: string): boolean;
      function TryAutoLoadParts: boolean;
      Function GetFullFilename: string;
    end;

{--------------------------}

implementation

uses StrUtils, qhelper, QuarkX, QkExceptions, Setup, QkObjectClassList, Game, QkQ3,
     QkPixelset, QkPcx, ApplPaths, qmath, qmatrices, Logging, Travail;

(***********  Quake 3 .md3 format  ***********)
const
  SignatureMdl3 = $33504449; //"IDP3" = Quake-3 Model file
  SignatureMdlRMD5 = $354D4452; //"RDM5" = MoDel Raven file - Raven Software's completed version of MD4, used in Star Trek Voyager: Elite Force and Star Trek: Elite Force II
  SignatureMdlMGL2 = $44474C32; //"2LGM" = Raven Software's Ghoul2 Model file - Used in Soldier of Fortune 2 Model and Star Wars: Jedi Knight games

  MAX_QPATH = 64;

type
  TMD3Header = packed record
    id: Int32;                   //id of file, always "IDP3"
    version: Int32;              //version number, always 15
    filename: array[1..MAX_QPATH] of Byte;//sometimes left Blank...
    flags: Int32;                //???
    BoundFrame_num: Int32;       //number of BoundFrames
    Tag_num: Int32;              //number of 'tags' per Frame
    Mesh_num: Int32;             //number of meshes/skins
    Skin_num: Int32;             //number of unique skins
    BoundFrame_offset: Int32;    //offset of the boundframes
    Tag_offset: Int32;           //offset of the tags
    Surface_offset: Int32;       //offset of the surface
    End_offset: Int32;           //offset of the end of the file
  end;
  { Comments to TMD3Header
     After the header comes a list of frame, then follows a list of tags, if available.
     The amount of tags is the header variable Tag_num times the header variable BoundFrame_num.
     So it is highly probably that tags have something to do with boundframes and that objects
     can have 0 to n tags 'attached' to them.
     Note: We call them 'Tags' because the name in tag usually starts with "tag_".
  }

  TMD3BoundFrame = packed record
    Mins: vec3_t;
    Maxs: vec3_t;
    Position: vec3_t;
    Radius: single;
    Name: array[1..16] of Byte;
  end;
  { TMD3BoundFrame
     If you divide the maximum and minimum xyz values of all the vertices from each meshframe you get
     the exact values as mins and maxs.
     Position is the exact center of mins and maxs, most of the time anyway.

     Name is very probably just the name of the program or file of which it (the boundframe?) was created,
     sometimes it's "(from ASE)" sometimes it's the name of a .3ds file.
  }

  TMD3Tag = packed record
    Name: array[1..MAX_QPATH] of Byte; //name of 'tag' as it's usually
                                   //called in the md3 files try to
                                   //see it as a sub-mesh/seperate
                                   //mesh-part.
                                   //sometimes this 64 string may
                                   //contain some garbage, but
                                   //i've been told this is because
                                   //some tools leave garbage in
                                   //those strings, but they ARE
                                   //strings...
    Position: vec3_t;               //relative position of tag
    Rotation: array[1..3] of vec3_t;              //the direction the tag is facing relative to the rest of the model
  end;
  { Comments to TMD3Tag
     fairly obvious i think, the name is the name of the tag.
     "position" is the relative position and "rotation" is the relative rotation to the rest of the model.

     After the tags come the 'boundframes'.
     The number of meshframes is usually identical to this number or simply 1.
     The header variable BoundFrame_num holds the amount of BoundFrame..
  }

  TMD3Mesh = packed record
    ID: Int32;                      //id, must be IDP3
    Name: array[1..MAX_QPATH] of Byte; //name of mesh
    flags: Int32;                   //???
    Frame_num: Int32;               //number of frames in mesh
    Skin_num: Int32;                //number of skins in mesh
    Vertex_num: Int32;              //number of vertices
    Triangle_num: Int32;            //number of Triangles
    Triangle_Start: Int32;          //starting position of Triangle data, relative to start of this header
    Skin_Start: Int32;              //starting position of Skin data, relative o start of this header
    TexVec_Start: Int32;            //starting position of texvector data, relative to start of this header
    Vertex_Start: Int32;            //starting position of vertex data, relative to start of this header
    MeshSize: Int32;                //size of mesh
  end;
  { Comments to TMD3Mesh
     Meshframe_num is the number of quake1/quake2 type frames in the mesh.
     (these frames work on a morph like way, the vertices are moved from one position to another instead of rotated around
     eachother like in bone-based-animations)
     Skin_num is the number of skins in the md3 file..
     These skins are animated.
     Triangle_Start, TexVec_Start & Vertex_Start are the number of bytes in the file from the start of the mesh header to the
     start of the triangle, texvec and vertex data (in that order).
  }

  TMD3Skin = packed record
    Name: array[1..MAX_QPATH] of Byte; //name of skin used by mesh
    Shader_index: Int32;              //?
  end;
  { Comments to TMD3Skin
     Name holds the name of the texture, relative to the baseq3 path.
     Q3 has a peculiar way of handling textures..
     The scripts in the /script directory in the baseq3 directory contain scripts that hold information about how some
     surfaces are drawn and animate (and out of how many layers it consist etc.)
     Now the strange thing is, if you remove the ".tga" at the end of the skin, and that name is used in the script files, than
     that scripted surface is used.
     If it isn't mentioned in the script files then the filename is used to load the tga file.
  }

  PMD3Triangle = ^TMD3Triangle;
  TMD3Triangle = packed record
    Triangle: array[1..3] of Int32; //vertex 1,2,3 of triangle
  end;
  { Comments to TMD3Triangle
     This is the simplest of structures.
     A triangle has 3 points which make up the triangle, each point is a vertex and the three ints that the triangle has point
     to those vertices.
     So you have a list of vertices, for example you have a list of 28 vertices and the triangle uses 3 of them: vertex 1, vertex
     14 and vertex 7.
     Then the ints contain 1, 14 and 7.
  }

  PMD3TexVec = ^TMD3TexVec;
  TMD3TexVec = packed record
    Vec: array[1..2] of Single;
  end;
  { Comments to TMD3TexVec
     U/V coordinates are basically the X/Y coordinates on the texture.
     This is used by the triangles to know which part of the skin to display.
  }

  PMD3Vertex = ^TMD3Vertex;
  TMD3Vertex = packed record
    Vec: array[1..3] of Int16; //vertex X/Y/Z coordinate
    Normal: Int16;
  end;
  { Comments to TMD3Vertex
     Vec contains the 3d xyz coordinates of the vertices that form the model.
     Normal contains the texture coordinates for the environmental mapping; the normal.
     Why does md3 have a second set of texture coordinates?
     Because:
     1. these texture coordinates need to be interpolated when the model changes shape,
     2. these texture coordinates are different from the normal texture coordinates but still both need to be used (with shaders you can
     have multi-layered surfaces, one could be an environmental map, an other could be a transparent texture)
  }

{--------------------------}

Function BeforeZero(const S: array of byte; SLength: Integer): string;
var
  i: integer;
begin
  Result:='';
  for i:=0 to SLength-1 do
  begin
    if S[i]=0 then
      Break
    else
      Result := Result+Char(S[i]);
  end;
end;

function MD3TagToMatrix(t: TMD3Tag): TMatrixTransformation;
begin
  Result:=MatrixFromRows(t.rotation[1], t.rotation[2], t.rotation[3]);
end;

procedure MatrixToMD3Tag(var t: TMD3Tag; m: TMatrixTransformation);
var
  i: integer;
begin
  for i:=1 to 3 do
  begin
    t.rotation[i][0]:=m[i][1];
    t.rotation[i][1]:=m[i][2];
    t.rotation[i][2]:=m[i][3];
  end;
end;

{--------------------------}

class function QMd3File.TypeInfo;
begin
 Result:='.md3';
end;

class procedure QMd3File.FileObjectClassInfo(var Info: TFileObjectClassInfo);
begin
 inherited;
 Info.DescriptionText:=LoadStr1(5176);
 Info.FileExt:=805;
end;

function QMd3File.Loaded_ShaderFile(Comp: QComponent; tex_name: string): QImage;
var
  shader_filename: string;
  shader_texturename: string;
  ShaderExt: String;
  I: Integer;
  shader_file: QObject;
  shader_texture: QPixelSet;
begin
  if ContainsText(tex_name, '/') then
    shader_filename:=copy(tex_name, 1, pos('/', tex_name)-1)
  else
    shader_filename:=copy(tex_name, 1, pos('\', tex_name)-1);

  result:=nil;

  if shader_filename='' then
    exit;

  if shader_filename='textures' then
  begin
    // use tiglaris code in quickwal.pas ... how ? ....
    exit;
  end;

  ShaderExt:=SetupGameSet.Specifics.Strings['ShaderExt'];
  if ShaderExt<>'' then
    shader_filename:=ConcatPaths([GameShadersPath, shader_filename+ShaderExt])
  else
    shader_filename:=ConcatPaths([GameShadersPath, shader_filename+'.shader']);
  shader_texturename:=copy(tex_name, 1, pos('.', tex_name)-1);

  Log(LOG_VERBOSE, 'attempting to load %s', [shader_filename]);
  try
    shader_file:=NeedGameFile(shader_filename, '');
  except
    on E: EFileNotFound do
    begin
      Log(LOG_WARNING, E.Message);
      Result:=nil;
      Exit;
    end;
  end;
  shader_file.Acces;
  for i:=0 to shader_file.subelements.count-1 do
  begin
    shader_texture:=QPixelSet(shader_file.subelements[i]);
    if (shader_texture is QShader) and (uppercase(shader_texture.name)=uppercase(shader_texturename)) then
    begin
      Result:=QPcx.Create(shader_texturename, Comp.SkinGroup);
      try
        Result.ConversionFrom(shader_texture);
      except
        Result.Free;
        Raise;
      end;
      Comp.SkinGroup.Subelements.Add(result);
      exit;
    end;
  end;
end;

Procedure QMD3File.ReadMesh(fs: TStream; Root: QModelRoot);
const
  SpecTris = 'Tris';
  SpecVertices = 'Vertices';
type
  PVertxArray = ^TVertxArray;
  TVertxArray = array[0..0] of TMD3TexVec;
var
  mhead: TMD3Mesh;
  tex: TMD3Skin;
  i, j, k: Integer;
  Skin: QImage;
  Frame: QFrame;
  s: String; //FIXME: Switch to bytes!
  size: TPoint;
  sizeset: Boolean;
  org: TStreamPos;
  fsize: array[1..2] of Single;
  mn: String;
  Comp: QComponent;
  t, base_tex_name: string;
  //------ Pointers from here
  Tris, Tris2: PMD3Triangle;
  TexCoord: PVertxArray;
  Vertexes, Vertexes2: PMD3Vertex;
  CTris: PComponentTris;
  CVert: vec3_p; 
  ImageFile: QFileObject;
begin
  org:=fs.position;
  fs.readbuffer(mhead, sizeof(mhead));

  //-----------------------------------------------------------
  //-- LOAD SKINS + GET SIZE OF FIRST
  //-----------------------------------------------------------
  mn := BeforeZero(mhead.name, MAX_QPATH);
  Comp:=Loaded_Component(Root, mn);
  sizeset:=false;
  size.x:=0;
  size.y:=0;
  for i:=1 to mhead.skin_Num do
  begin
    fs.Seek(mhead.Skin_Start - sizeof(mhead), 1);
    fs.readbuffer(tex, sizeof(tex));
    //FIXME: There was a check here: was that needed?
    if tex.name[1]=0 then
      tex.name[1]:=Byte('m');
    base_tex_name:=BeforeZero(tex.name, MAX_QPATH);
    { The Raven guys seem to have used #0 as the filename-extension
      separator for textures in their .md3's !!! }
    if CurrentGameMode=mjSoF2 then
      if Pos(#0,base_tex_name)<>0 then
         base_tex_name[Pos(#0,base_tex_name)]:='.';
    Skin:=Loaded_ShaderFile(Comp, base_tex_name);
    if skin=nil then
      skin:=Loaded_SkinFile(Comp, ChangeFileExt(base_tex_name,'.tga'), false);
    if skin=nil then
      skin:=Loaded_SkinFile(Comp, ChangeFileExt(base_tex_name,'.jpg'), false);
    if skin=nil then
      skin:=Loaded_SkinFile(Comp, ChangeFileExt(base_tex_name,'.png'), false);

    // SilverPaladin - 12/01/2003 - If we have not been able to find a skin file
    // in the current directories (unpure has priority), look for it in the PK3
    // files (pure mode) that have been loaded for the game.
    if Skin = nil then
    begin
      Log(LOG_VERBOSE, 'attempting to load %s', [base_tex_name]);
      {$IFNDEF Delphi10_1orNewerCompiler}
      ImageFile := nil; //Supress compiler warning
      {$ENDIF}
      try
        ImageFile := NeedGameFile(base_tex_name, '');
      except
        on E: EFileNotFound do
        begin
          Log(LOG_WARNING, E.Message);
          ImageFile := nil; //file not found, ignore
        end;
      end;
      if ImageFile <> nil then
      begin
        ImageFile.AddRef(+1);
        try
          ImageFile.Acces;
          if (ImageFile is QImage) then
            Skin := QImage(ImageFile);
        finally
          ImageFile.AddRef(-1);
        end;
      end;
    end;

    // If the files does not exist in the directories or in the packs then raise
    // an error.
    if skin=nil then
    begin
      t:=FmtLoadStr1(5575, [base_tex_name+' or '+ChangeFileExt(base_tex_name,'.jpg'), LoadName]);
      GlobalWarning(t);
      skin:=CantFindTexture(Comp, base_tex_name, Size);
    end;

    if skin<>nil then
    begin
      if (not sizeset) then
      begin
        Size:=Skin.GetSize;
        Sizeset:=true;
      end;
    end;
  end;
  fSize[1]:=size.x;
  fSize[2]:=size.y;
  Comp.SetFloatsSpec('skinsize', fSize);

  //-----------------------------------------------------------
  //-- LOAD TRIANGLES
  //-----------------------------------------------------------
  fs.seek(org+mhead.triangle_start, soBeginning);
  getmem(tris, mhead.triangle_num*sizeof(TMD3Triangle));
  fs.readbuffer(tris^, mhead.triangle_num*sizeof(TMD3Triangle));

  //-----------------------------------------------------------
  //-- LOAD TEXTURE CO-ORDS
  //-----------------------------------------------------------
  fs.seek(org+mhead.TexVec_Start, soBeginning);
  getmem(texCoord, mhead.vertex_num*sizeof(TMD3TexVec));
  fs.readbuffer(texCoord^, mhead.vertex_num*sizeof(TMD3TexVec));

  //-----------------------------------------------------------
  //-- PROCESS TRIANGLES + TEXTURE CO-ORDS
  //-----------------------------------------------------------
  try
    SetLength(S, mhead.Triangle_num*SizeOf(TComponentTris));
    Tris2:=Tris;
    PChar(CTris):=PChar(S);
    for I:=1 to mhead.Triangle_num do
    begin
      for J:=0 to 2 do
      begin
        with CTris^[J] do
        begin
          VertexNo:=Tris2^.triangle[J+1];
          if VertexNo>=mhead.vertex_num then
           raise EError(5810);
          //The following lines result in FALSE range check errors, because
          //the array's size is not defined up front. Let's disable range
          //check errors for this bit (if they were enabled).
          {$IfOpt R+}
          {$Define RangeChecksWereEnabled}
          {$R-}
          {$EndIf}
          with texCoord^[VertexNo] do
          begin
            S:=round(vec[1]*Size.X);
            T:=round(vec[2]*Size.Y);
          end;
          {$IfDef RangeChecksWereEnabled}
          {$R+}
          {$EndIf}
        end;
      end;
      Inc(CTris);
      Inc(Tris2);
    end;
    Comp.Specifics.ByteArray[SpecTris]:=S;
  finally
    freemem(Tris);
    freemem(texcoord);
  end;

  //-----------------------------------------------------------
  //-- LOAD FRAMES + VERTEXES
  //-----------------------------------------------------------
  fs.seek(org+mhead.Vertex_Start, soBeginning);
  for i:=1 to mhead.Frame_num do
  begin
    Frame:=Loaded_Frame(Comp, format('Frame %d',[i]));
    GetMem(Vertexes, mhead.vertex_Num * Sizeof(TMD3Vertex));
    try
      fs.readbuffer(Vertexes^, mhead.vertex_Num * Sizeof(TMD3Vertex));
      //-----------------------------------------------------------
      //-- PROCESS VERTEXES
      //-----------------------------------------------------------
      SetLength(S, mhead.Vertex_num*SizeOf(vec3_t));
      PChar(CVert):=PChar(S);
      Vertexes2:=Vertexes;
      for J:=0 to mhead.vertex_Num-1 do
      begin
        with Vertexes2^ do
        begin
          for k:=0 to 2 do
            CVert^[k]:=(Vec[k+1] / 64);
          //FIXME: Handle normal!
        end;
        Inc(Vertexes2);
        Inc(CVert);
      end;
      Frame.Specifics.ByteArray[FloatSpecNameOf(SpecVertices)]:=S;
    finally
      FreeMem(Vertexes);
    end;
  end;
end;

Function QMD3File.GetFullFilename: string;
var
  O: QObject;
begin
  if Filename='' then
  begin
    Result:=Name+Self.TypeInfo;
    O:=Self;
    While O.Parent<>nil do
    begin
      O:=O.Parent;
      Result:=O.Name+PathDelim+Result;
    end;
  end
  else
  begin
    Result:=filename;
  end;
end;

function QMd3File.TryAutoLoadParts: boolean;
  function TagNameToMd3FileName(const name, sname: string): String;
  begin
    result:='';
         if (name='tag_head')  and (sname='head')  then result:='upper.md3'
    else if (name='tag_head')  and (sname='upper') then result:='head.md3'
    else if (name='tag_torso') and (sname='lower') then result:='upper.md3'
    else if (name='tag_torso') and (sname='upper') then result:='lower.md3';
  end;
var
  tag: QModelTag;
  mg: QMiscGroup;
  fname, TagFilename: string;
  AbsolutePath: string;
  i: integer;
  TagList: TQList;
  z_result: boolean;
begin
  if GetRoot.Specifics.Strings['md3_autolink_done']<>'' then
  begin
    Result:=True;
    Exit;
  end;
  Log(LOG_VERBOSE, 'Starting MD3 autoload parts...');
  z_result:=true;
  mg:=GetRoot.GetMisc;
  TagList:=TQList.Create;
  try
    mg.FindAllSubObjects('', QModelTag, Nil, TagList);
    AbsolutePath:=ConcatPaths([QuakeDir, GetBaseDir]);
    for i:=0 to TagList.count-1 do
    begin
      tag:=QModelTag(TagList[i]);
      Log(LOG_VERBOSE, 'Processing MD3 tag %s', [tag.name]);
      TagFilename:=TagNameToMd3FileName(tag.name, name);
      if TagFilename='' then
        continue;
      fname:=GetFullFilename;
      fname:=extractfilepath(fname);
      if CheckForRelativePath(fname)<>'' then
        //Probably a pak-file; cut it off
        fname:=copy(fname, pos(PathDelim, fname)+1, length(fname)-pos(PathDelim,fname)+1)
      else
        //Probably a full path... cut off the basedir
        if StartsStr(fname, AbsolutePath) then
          fname:=Copy(fname, length(AbsolutePath), MaxInt);
      fname:=fname+TagFilename;
      z_result:=z_result and AttachModelToTagFromFilename(tag.name, fname);
    end;
  finally
    TagList.Free;
  end;
  GetRoot.Specifics.Strings['md3_autolink_done']:='1';
  result:=z_result;
end;

function QMd3File.AttachModelToTagFromFilename(const Tag_Name: string; const filename: string): boolean;
var
  FileObj2: QObject;
begin
  Result:=false;
  Log(LOG_VERBOSE, 'attempting to load %s', [filename]);
  try
    FileObj2:=NeedGameFile(filename, '');
  except
    on E: EFileNotFound do
    begin
      Log(LOG_WARNING, E.Message);
      FileObj2:=nil; //file not found, ignore
    end;
  end;
  if FileObj2=nil then
  begin
    FileObj2:=ExactFileLink(filename, nil, false);
    if FileObj2 = nil then
      exit;
  end;
  if not(FileObj2 is QModelFile) then
    exit;
  FileObj2.Acces;
  Result:=AttachModelToTag(Tag_Name, QModelFile(FileObj2));
end;

function QMd3File.AttachModelToTag(const Tag_Name: string; model: QModelFile): boolean;
var
  other_root: QModelRoot;
begin
  Log(LOG_VERBOSE, 'attaching loaded %s to %s', [model.name, self.name]);
  model.acces;
  other_root:=model.getRoot;
  other_root:=QModelRoot(other_root.clone(getroot, false));
  other_root.Specifics.Strings['linked_to']:=tag_name;
  getroot.SubElements.add(other_root);
{  for i:=0 to other_root.subelements.count-1 do
  begin
    if other_root.subelements[i] is QComponent then
    begin
      old_component:=QComponent(other_root.subelements[i]);
      new_component:=QComponent(old_component.clone(getroot, false));
      new_component.name:='*'+model.name+' - '+new_component.name;
      new_component.IntSpec['linked']:=1;
      getroot.subelements.add(new_component);
    end;
  end;}
  result:=true;
end;

procedure QMd3File.LoadFile(F: TStream; FSize: TStreamPos);
var
  i, j: Longint;
  org, org2: TStreamPos;
  head: TMD3Header;
  tag: TMD3Tag;
  boundframe: TMD3BoundFrame;
  //---
  Root: QModelRoot;
  Tags: TQList;
  OTag: QModelTag;
  OTagFrame: QTagFrame;
  OBoundFrame: QBoundFrame;
  misc: QMiscGroup;
begin
  case ReadFormat of
    rf_Default: begin  { as stand-alone file }
      if FSize<SizeOf(TMD3Header) then
        Raise EError(5519);
      org:=f.position;
      f.readbuffer(head, sizeof(head));
      org2:=f.position;
      if (head.id=SignatureMdl3) and (CurrentGameMode=mjSTVEF) then
        ObjectGameCode := mjSTVEF;
      if (head.id=SignatureMdl3) and (CurrentGameMode=mjEF2) then
        ObjectGameCode := mjEF2;
      if (head.id=SignatureMdl3) and (CurrentGameMode=mjRTCWET) then
        ObjectGameCode := mjRTCWET;
      if (head.id=SignatureMdl3) and (CurrentGameMode=mjNEXUIZ) then
        ObjectGameCode := mjNEXUIZ;
      if (head.id=SignatureMdl3) and (CurrentGameMode=mjWarsow) then
        ObjectGameCode := mjWarsow;
      if (head.id=SignatureMdl3) and (CurrentGameMode=mjWarfork) then
        ObjectGameCode := mjWarfork;
      if (head.id=SignatureMdl3) and (head.version=15) then //FIXME: Hardcoded!
      begin
        if (CurrentGameMode<mjQ3A) then
          ObjectGameCode := mjQ3A
        else
          ObjectGameCode := CurrentGameMode;
      end
      else if (head.id=SignatureMdlRMD5) {and (head.version=2)} then //FIXME: Hardcoded!
        Raise EQObjectLoadingNotSupported.Create('RDM5 MD3 models')
      else if (head.id=SignatureMdlMGL2) then
        Raise EQObjectLoadingNotSupported.Create('2LGM MD3 models') //FIXME: Known versions: 4 and 6   NO, this has a .glm file extension!!!
      else
        Raise EErrorFmt(5809, [String(head.id)]);
      Root:=Loaded_Root;
      Misc:=Root.GetMisc;
      if head.BoundFrame_num<>0 then
      begin
        f.seek(head.BoundFrame_offset + org, soBeginning);
        for i:=1 to head.boundframe_num do
        begin
          f.readbuffer(boundframe,sizeof(boundframe));
          OBoundFrame:=QBoundFrame.Create('Bound Frame '+inttostr(i), Misc);
          OBoundFrame.SetQ3AData(boundframe.position, boundframe.mins, boundframe.maxs, boundframe.radius);
          Misc.SubElements.Add(OBoundFrame);
        end;
        if head.Tag_num<>0 then
        begin
          f.seek(head.Tag_offset + org, soBeginning);
          Tags:=TQList.Create;
          try
            Misc.FindAllSubObjects('', QModelTag, nil, Tags);

            for j:=1 to head.boundframe_num do
            begin
              for i:=1 to head.tag_num do
              begin
                f.readbuffer(tag,sizeof(tag));
                OTag:=QModelTag(Tags.FindShortName(BeforeZero(tag.name, MAX_QPATH)));
                if OTag = nil then
                begin
                  OTag:=QModelTag.Create(BeforeZero(tag.name, MAX_QPATH), Misc);
                  Misc.SubElements.Add(OTag);
                  Tags.Add(OTag);
                end;
                OTagFrame:=QTagFrame.Create('Tag Frame ' + inttostr(j), OTag);
                OTagFrame.SetPosition(tag.position);
                OTagFrame.SetRotMatrix(MD3TagToMatrix(tag));
                OTag.SubElements.Add(OTagFrame);
              end;
            end;
          finally
            Tags.Free;
          end;
          f.seek(org2, soBeginning);
        end;
      end;
      if head.Mesh_num<>0 then
      begin
        f.seek(org + head.Surface_offset, soBeginning);
        for i:=1 to head.Mesh_num do
        begin
          ReadMesh(f, Root);
        end;
      end;
    end;
  else
    inherited;
  end;
end;

procedure QMd3File.SaveFile(Info: TInfoEnreg1);
const
  DefTexSize = 64;
var
  head: TMD3Header;
  tag: TMD3Tag;
  boundframe: TMD3BoundFrame;
  mesh: TMD3Mesh;
  skin: TMD3Skin;
  //---
  Root: QModelRoot;
  Misc: QMiscGroup;
  SkinObj: QImage;
  BoundFrames: TQList;
  OBoundFrame: QBoundFrame;
  Tags: TQList;
  OModelTag: QModelTag;
  TagFrames: TQList;
  OTagFrame: QTagFrame;
  Components: TQList;
  Comp: QComponent;
  Skins: TQList;
  Frames: TQList;
  FrameObj: QFrame;
  I, J, K, L: Longint;
  Position0, Position1: TStreamPos;
  vec3: vec3_p;
  CVert, CVert2: vec3_p;
  CTris, CTriangles: PComponentTris;
  CTrianglesB: String;
  Vertexes, Vertexes2: PMD3Vertex;
  TrisData, Tris: PMD3Triangle;
  TexCoord, TexCoord2: PMD3TexVec;
  VertexFound: Boolean;
  Size: TPoint;
  TagMatrix: PMatrixTransformation;
begin
  with Info do
   case Format of
   rf_Siblings: begin  { write the skin files }
     if Flags and ofNotLoadedToMemory <> 0 then
       Exit;
     Root:=Saving_Root;
     Info.TempObject:=Root;
     Components:=TQList.Create;
     try
       Root.FindAllSubObjects('', QComponent, Nil, Components);
       for I:=0 to Components.Count-1 do
       begin
         Comp:=QComponent(Components.Items1[I]);
         Skins:=Comp.BuildSkinList;
         try
           for J:=0 to Skins.Count-1 do
           begin
             SkinObj:=QImage(Skins.Items1[J]);
             Info.WriteSibling(SkinObj.Name+SkinObj.TypeInfo, SkinObj);
           end;
         finally
           Skins.free;
         end;
       end;
     finally
       Components.free;
     end;
   end;
   rf_Default: begin  { write the .md3 file }
     if Info.TempObject=Nil then
       Root:=Saving_Root
     else
     begin
       Root:=Info.TempObject as QModelRoot;
       Info.TempObject:=Nil;
     end;

     Components:=Root.BuildComponentList;
     ProgressIndicatorStart(502, Components.Count);

     try
       Position0:=F.Position;
       FillChar(head, SizeOf(head), 0);
       F.WriteBuffer(head, SizeOf(head));

       if ObjectGameCode=mjSTVEF then
       begin
         head.id:=SignatureMdlRMD5;
         head.version:=2; //FIXME: Hardcoded!
       end
       else
       begin
         head.id:=SignatureMdl3;
         head.version:=15; //FIXME: Hardcoded!
       end;

       //FIXME: We need to check for all the maxima!
       //Original Q3 Tools source example:
       //if ( g_data.model.numFrames >= MD3_MAX_FRAMES)
       //  Error ("model.numFrames >= MD3_MAX_FRAMES");

       //We need a decent way of setting these:
       FillChar(head.filename, sizeof(head.filename), 0);
       FillChar(head.flags, sizeof(head.flags), 0);

       Misc:=Root.GetMisc;

       BoundFrames:=TQList.Create;
       try
         Misc.FindAllSubObjects('', QBoundFrame, nil, BoundFrames);

         head.BoundFrame_num := BoundFrames.Count;
         head.BoundFrame_offset:=F.Position-Position0;

         for I:=0 to head.BoundFrame_num-1 do
         begin
           OBoundFrame := QBoundFrame(BoundFrames[I]);
           OBoundFrame.GetQ3A_Mins(vec3);
           boundframe.Mins := vec3^;
           OBoundFrame.GetQ3A_Maxs(vec3);
           boundframe.Maxs := vec3^;
           OBoundFrame.GetQ3A_Position(vec3);
           boundframe.Position := vec3^;
           boundframe.Radius := OBoundFrame.GetQ3A_Scale;
           PasToChar(boundframe.name, OBoundFrame.Name);
           F.WriteBuffer(boundframe, SizeOf(boundframe));
         end;
       finally
         BoundFrames.Free;
       end;

       Tags:=TQList.Create;
       try
         Misc.FindAllSubObjects('', QModelTag, nil, Tags);

         head.Tag_num := Tags.Count;
         head.Tag_offset:=F.Position-Position0;

         for I:=0 to head.BoundFrame_num-1 do
         begin
           for J:=0 to head.Tag_num-1 do
           begin
             OModelTag := QModelTag(Tags[J]);
             TagFrames:=TQList.Create;
             try
               OModelTag.FindAllSubObjects('', QTagFrame, nil, TagFrames);
               if TagFrames.Count<>head.BoundFrame_num then
                 raise EError(5811);
               OTagFrame:=QTagFrame(TagFrames[I]);

               PasToChar(tag.name, OModelTag.Name);
               vec3:=OTagFrame.GetPosition;
               tag.Position := vec3^;
               OTagFrame.GetRotMatrix(TagMatrix);
               MatrixToMD3Tag(tag, TagMatrix^);
               F.WriteBuffer(tag, SizeOf(tag));
             finally
               TagFrames.Free;
             end;
           end;
         end;
       finally
         Tags.Free;
       end;

         head.Mesh_num := Components.Count;
         head.Skin_num := 0;  //Not used, as far as known


       Comp:=QComponent(Components[0]); //FIXME: Might not exist!
       Frames:=Comp.BuildFrameList;
       try

       finally
         Frames.Free;
       end;

       head.Surface_offset:=F.Position-Position0;

       for I:=0 to Components.Count-1 do
       begin
         Position1:=F.Position;
         FillChar(mesh, SizeOf(mesh), 0);
         F.WriteBuffer(mesh, SizeOf(mesh));

         Comp:=QComponent(Components[I]);
         mesh.id:=head.id; //@
         PasToChar(mesh.name, Comp.Name);
         FillChar(mesh.flags, sizeof(mesh.flags), 0); //@

         Frames:=Comp.BuildFrameList;
         try
           mesh.Frame_num:=Frames.Count;
           Skins:=Comp.BuildSkinList;

           mesh.Skin_Start:=F.Position-Position1;

           try
             Size.X:=DefTexSize;
             Size.Y:=DefTexSize;
             mesh.Skin_num:=Skins.Count;
             for J:=0 to Skins.Count-1 do
             begin
               SkinObj:=QImage(Skins[J]);
               PasToChar(skin.name, SkinObj.Name);
               skin.Shader_index:=0; //@
               F.WriteBuffer(skin, SizeOf(skin));
               if J=0 then
                 Size:=SkinObj.GetSize;
             end;

             mesh.Triangle_Start:=F.Position-Position1;

             CTrianglesB:=Comp.Triangles(mesh.Triangle_num, CTriangles);
             GetMem(TrisData, mesh.Triangle_num * SizeOf(TMD3Triangle));
             Tris:=TrisData;
             CTris:=CTriangles;
             try
               for J:=0 to mesh.Triangle_num-1 do
               begin
                 for K:=0 to 2 do
                   with CTris^[K] do
                   begin
                     Tris^.Triangle[K+1]:=VertexNo;
                   end;
                 Inc(Tris);
                 Inc(CTris);
               end;
               F.WriteBuffer(TrisData^, mesh.Triangle_num * SizeOf(TMD3Triangle));
             finally
               FreeMem(TrisData);
             end;

             mesh.TexVec_Start:=F.Position-Position1;

             FrameObj:=QFrame(Frames[0]); //@
             mesh.Vertex_num:=FrameObj.GetVertices(CVert);
             GetMem(TexCoord, mesh.Vertex_num * SizeOf(TMD3TexVec));
             TexCoord2:=TexCoord;
             try
               for J:=0 to mesh.Vertex_num-1 do
               begin
                 CTris:=CTriangles;
                 VertexFound:=False;
                 for K:=0 to mesh.Triangle_num-1 do
                 begin
                   for L:=0 to 2 do
                   begin
                     with CTris^[L] do
                       if VertexNo = J then
                       begin
                         TexCoord2^.Vec[1]:=S / Size.X;
                         TexCoord2^.Vec[2]:=T / Size.Y;
                         VertexFound:=True;
                         break;
                       end;
                   end;
                   if VertexFound then break;
                   Inc(CTris);
                 end;
                 if not VertexFound then
                 begin
                   TexCoord2^.Vec[1]:=0;
                   TexCoord2^.Vec[2]:=0;
                 end;
                 Inc(TexCoord2);
               end;
               F.WriteBuffer(TexCoord^, mesh.Vertex_num * SizeOf(TMD3TexVec));
             finally
               FreeMem(TexCoord);
             end;

             mesh.Vertex_Start:=F.Position-Position1;

             for J:=0 to Frames.Count-1 do
             begin
               FrameObj:=QFrame(Frames[J]);
               //K:=FrameObj.GetVertices(CVert);
               //@ Check K?
               FrameObj.GetVertices(CVert);
               CVert2:=CVert;
               GetMem(Vertexes, mesh.Vertex_num * SizeOf(TMD3Vertex));
               try
                 Vertexes2:=Vertexes;
                 for K:=0 to mesh.Vertex_num-1 do
                 begin
                   Vertexes2^.Vec[1]:=Round(CVert2^[0] * 64);
                   Vertexes2^.Vec[2]:=Round(CVert2^[1] * 64);
                   Vertexes2^.Vec[3]:=Round(CVert2^[2] * 64);
                   Vertexes2^.Normal:=0; //FIXME: Handle!
                   Inc(Vertexes2);
                   Inc(CVert2);
                 end;
                 F.WriteBuffer(Vertexes^, mesh.Vertex_num * SizeOf(TMD3Vertex));
               finally
                 FreeMem(Vertexes);
               end;
             end;

             mesh.MeshSize:=F.Position-Position1;

             F.Position:=Position1;
             F.WriteBuffer(mesh, SizeOf(mesh));
             F.Position:=Position1+mesh.MeshSize;
           finally
             Skins.Free;
           end;
         finally
           Frames.Free;
         end;
       end;

     finally
       Components.Free;
       ProgressIndicatorStop;
     end;

     head.End_offset:=F.Position-Position0;
     F.Position:=Position0;
     F.WriteBuffer(head, SizeOf(head));
     F.Position:=Position0+head.End_offset;

     end;
   else
     inherited;
   end;
end;

initialization
  RegisterQObject(QMd3File, 'v');
end.

