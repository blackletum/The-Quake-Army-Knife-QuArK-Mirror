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

unit QCompat;

{$I AbDefine.inc}

interface

uses
  {$IF COMPILERVERSION < 31}
  Classes,
  {$IFEND}
  Types;

type
  {$IF COMPILERVERSION < 20}
  Int16  = SmallInt;
  UInt16 = Word;

  Int32  = LongInt;
  UInt32 = LongWord;
  {$IFEND}

  TBytes = TByteDynArray;

  {$IF COMPILERVERSION < 15}
  NativeInt = Integer;
  NativeUInt = Cardinal;
  {$IFEND}

  {$IF COMPILERVERSION >= 20}
  ArithByte = Byte;
  PArithByte = PByte;
  {$ELSE}
  ArithByte = AnsiChar;
  PArithByte = PAnsiChar;
  {$IFEND}

implementation

end.
