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
program QuArK;
{%File '..\Runtime\addons\Defaults.qrk'}

{$INCLUDE DelphiCompat.inc}
{$INCLUDE MemManager.inc}

uses
  //
  // Memory managers
  //
{$IFDEF MemTester}
  MemTester in 'modules\MemTester.pas',
{$ENDIF}
{$IFDEF RecyclerMM}
  RecyclerMM in 'modules\RecyclerMM.pas',
{$ENDIF}
{$IFDEF FastMM}
  FastMM in 'modules\FastMM.pas',
{$ENDIF}
{$IFDEF FastMM3}
  FastMM3 in 'modules\FastMM3.pas',
{$ENDIF}
{$IFDEF FastMM4}
  FastMM4 in 'modules\FastMM4.pas',
{$ENDIF}
{$IFDEF FastMM5}
  FastMM5 in 'modules\FastMM5.pas',
{$ENDIF}
{$IFDEF MemCheck}
  MemCheck in 'modules\MemCheck.pas',
{$ENDIF}

  //
  // Runtime fixes
  //
{$IFDEF CompiledWithDelphi6}
  //SysUtils.CheckWin32Version was added in Update Pack 2 of Delphi 6,
  //but there is no way to check which Update Pack is installed,
  //so let's check for the existence of the function itself.
  {$IF Declared(CheckWin32Version)}
  {$DEFINE NeedD6CheckWin32VersionFix}
  D6CheckWin32VersionFix in 'modules\D6CheckWin32VersionFix.pas',
  {$IFEND}
{$ENDIF}
{$IFDEF Delphi6orNewerCompiler}{$IFNDEF Delphi2010orNewerCompiler}{$IFDEF CPUX86}
  VCLFixPack in 'modules\VCLFixPack.pas',
{$ENDIF}{$ENDIF}{$ENDIF}
{$IFDEF CompiledWithDelphi7}
  D7DoubleBufferedThemeFix in 'modules\D7DoubleBufferedThemeFix.pas',
{$ENDIF}
{$IFDEF Delphi6orNewerCompiler}{$IFNDEF DelphiXE2orNewerCompiler}
  ControlsAtomFix in 'modules\ControlsAtomFix.pas',
{$ENDIF}{$ENDIF}
  //VistaAltFixUnit in 'modules\VistaAltFixUnit.pas',
  //VistaAltFixUnit2 in 'modules\VistaAltFixUnit2.pas',

  //
  // Runtime optimization
  //
{$IFDEF Delphi6orNewerCompiler}{$IFNDEF DelphiXE2orNewerCompiler}
  //System.Move changed signature in Delphi XE2, and FastMove was never updated for that.
  //And even though some code was licensed into Delphi, FastMove is still useful on Delphi 2006+
  //because only the CPU-generic Assembly version was integrated:
  //https://borland.public.delphi.language.basm.narkive.com/gmmCDU4z/rad-studio-delphi-2007-and-fastobj-fastmove#post4
  FastMove in 'modules\FastMove.pas',
{$ENDIF}{$ENDIF}
{$IFNDEF Delphi2009orNewerCompiler}
{$IFDEF Delphi6orNewerCompiler}
  FastCode in 'modules\FastCode\FastCode.pas',
{$ENDIF}
{$IFDEF Delphi5orNewerCompiler}
  RtlVclOptimize in 'modules\RtlVclOptimize.pas',
{$ENDIF}
{$ENDIF}

  //
  //Soft Gems Theme Manager
  //
{$IFNDEF Delphi7orNewerCompiler}
  ThemeMgr in 'modules\SoftGemsThemeManager\ThemeMgr.pas',
  //ThemeMgrDB in 'modules\SoftGemsThemeManager\ThemeMgrDB.pas',
  ThemeSrv in 'modules\SoftGemsThemeManager\ThemeSrv.pas',
  TmSchema in 'modules\SoftGemsThemeManager\TmSchema.pas',
  UxTheme in 'modules\SoftGemsThemeManager\UxTheme.pas',
{$ENDIF}

  //
  // Delphi version compatibility
  //
  DelphiCompat in 'modules\DelphiCompat.pas',
{$IFNDEF Delphi6orNewerCompiler}
  DateUtils in 'modules\NoSearchPath\DateUtils.pas',
  StrUtils in 'modules\NoSearchPath\StrUtils.pas',
  Types in 'modules\NoSearchPath\Types.pas',
{$ENDIF}

  Forms, SysUtils, {$IFNDEF LINUX}Windows,{$ENDIF}

  //Init the logging module FIRST, otherwise we'll miss log-calls from other init's!
  Logging in 'prog\Logging.pas',

  DX9 in '3dfx\DX9.pas',
  EdDirect3D in '3dfx\EdDirect3D.pas',
  EdGlide in '3dfx\EdGlide.pas',
  EdOpenGL in '3dfx\EdOpenGL.pas',
  EdSceneObject in '3dfx\EdSceneObject.pas',
  EdSoftware in '3dfx\EdSoftware.pas',
  QkDummyWindow in '3dfx\QkDummyWindow.pas',
  QkFullScreenWindow in '3dfx\QkFullScreenWindow.pas',
  GL1 in '3dfx\GL1.pas',
  Glide in '3dfx\Glide.pas',
  form_Model in 'prog\model\form_Model.pas' {FQMdl},
  //Qk3ds in 'prog\model\Qk3ds.pas',
  QkBoneGroup in 'prog\model\QkBoneGroup.pas',
  QkBoundFrame in 'prog\model\QkBoundFrame.pas',
  QkComponent in 'prog\model\QkComponent.pas',
  QkFrame in 'prog\model\QkFrame.pas',
  QkFrameGroup in 'prog\model\QkFrameGroup.pas',
  QkMd2 in 'prog\model\QkMd2.pas',
  QkMd3 in 'prog\model\QkMd3.pas',
  QkMdl in 'prog\model\QkMdl.pas',
  QkMdlObject in 'prog\model\QkMdlObject.pas',
  QkMiscGroup in 'prog\model\QkMiscGroup.pas',
  QkBBoxGroup in 'prog\model\QkBBoxGroup.pas',
  QkModel in 'prog\model\QkModel.pas',
  QkModelBone in 'prog\model\QkModelBone.pas',
  QkModelFile in 'prog\model\QkModelFile.pas',
  QkModelRoot in 'prog\model\QkModelRoot.pas',
  QkModelTag in 'prog\model\QkModelTag.pas',
  QkQkl in 'prog\model\QkQkl.pas',
  QkSkinDrawObject in 'prog\model\QkSkinDrawObject.pas',
  QkSkinGroup in 'prog\model\QkSkinGroup.pas',
  QkSkinSubGroup in 'prog\model\QkSkinSubGroup.pas',
  QkTagFrame in 'prog\model\QkTagFrame.pas',
  About in 'prog\About.pas' {AboutBox},
  AddOns in 'prog\AddOns.pas' {AddOnsAddDlg},
  ApplPaths in 'prog\ApplPaths.pas',
  AutoUpdater in 'prog\AutoUpdater.pas' {AutoUpdater},
  AutoUpdateInstaller in 'prog\AutoUpdateInstaller.pas' {AutoUpdateInstaller},
  Bezier in 'prog\Bezier.pas',
  BrowseForFolder in 'prog\BrowseForFolder.pas',
  CCode in 'prog\CCode.pas',
  Config in 'prog\Config.pas' {ConfigDlg},
  Console in 'prog\Console.pas' {ConsoleForm},
  Coordinates in 'prog\Coordinates.pas',
  DevIL in 'prog\DevIL.pas',
  DispFace in 'prog\DispFace.pas',
  Duplicator in 'prog\Duplicator.pas',
  FormCfg in 'prog\FormCfg.pas',
  FileAssociations in 'prog\FileAssociations.pas',
  FileExists2 in 'prog\FileExists2.pas',
  FreeImage in 'prog\FreeImage.pas',
  Game in 'prog\Game.pas' {GameCfgDlg},
  HelpPopup1 in 'prog\HelpPopup1.pas' {HelpPopup},
  HLLib in 'prog\HLLib.pas',
  HTTP in 'prog\HTTP.pas',
  Keys in 'prog\Keys.pas' {KeyDlg},
  KeySel in 'prog\KeySel.pas' {KeySelDlg},
  MapError in 'prog\MapError.pas',
  NewFolder in 'prog\NewFolder.pas' {NewFolderDlg},
  ObjProp in 'prog\ObjProp.pas' {FormObjProp},
  OsFolder in 'prog\OsFolder.pas',
  Output1 in 'prog\Output1.pas' {OutputDirDlg},
  PakFiles in 'prog\PakFiles.pas',
  PixelSetSizeCache in 'prog\PixelSetSizeCache.pas',
  Platform in 'prog\Platform.pas',
  QConsts in 'prog\QConsts.pas',
  qdraw in 'prog\qdraw.pas',
  qhelper in 'prog\qhelper.pas',
  Qk1 in 'prog\Qk1.pas' {Form1},
  Qk3D in 'prog\Qk3D.pas',
  Qk6DX in 'prog\Qk6DX.pas',
  QkBmp in 'prog\QkBmp.pas',
  QkBsp in 'prog\QkBsp.pas' {FQBsp},
  QkBspHulls in 'prog\QkBspHulls.pas',
  QkCin in 'prog\QkCin.pas',
  QkCoD2 in 'prog\QkCoD2.pas',
  QkD3 in 'prog\QkD3.pas',
  QkDaikatana in 'prog\QkDaikatana.pas',
  QkDDS in 'prog\QkDDS.pas',
  QkExceptions in 'prog\QkExceptions.pas',
  QkExplorer in 'prog\QkExplorer.pas',
  QkFileExplorer in 'prog\QkFileExplorer.pas',
  QkFileObjects in 'prog\QkFileObjects.pas' {QForm1},
  QkFtx in 'prog\QkFtx.pas',
  QkForm in 'prog\QkForm.pas',
  QkFormCfg in 'prog\QkFormCfg.pas',
  QkFormVw in 'prog\QkFormVw.pas' {FQFormVw},
  QkG3D in 'prog\QkG3D.pas',
  QkGCF in 'prog\QkGCF.pas',
  QkGroup in 'prog\QkGroup.pas' {FQGroup},
  QkHL in 'prog\QkHL.pas',
  QkHr2 in 'prog\QkHr2.pas',
  QkImages in 'prog\QkImages.pas' {FQImages},
  QkInclude in 'prog\QkInclude.pas',
  QkIwi in 'prog\QkIwi.pas',
  QkJpg in 'prog\QkJpg.pas',
  QkKEX in 'prog\QkKEX.pas',
  //QkKingPin in 'prog\QkKingPin.pas',
  QkListView in 'prog\QkListView.pas' {QForm2},
  QkLmp in 'prog\QkLmp.pas',
  QkMacro in 'prog\QkMacro.pas',
  QkMap in 'prog\QkMap.pas' {FQMap},
  QkMapObjects in 'prog\QkMapObjects.pas',
  QkMapPoly in 'prog\QkMapPoly.pas',
  QkMesh in 'prog\QkMesh.pas',
  QkNCF in 'prog\QkNCF.pas',
  QkObjectClassList in 'prog\QkObjectClassList.pas',
  QkObjects in 'prog\QkObjects.pas',
  QkOwnExplorer in 'prog\QkOwnExplorer.pas' {QFormExplorer},
  QkPak in 'prog\QkPak.pas' {FQPak},
  QkPcx in 'prog\QkPcx.pas',
  QkPixelSet in 'prog\QkPixelSet.pas',
  QkPng in 'prog\QkPng.pas',
  QkQ1 in 'prog\QkQ1.pas',
  QkQ2 in 'prog\QkQ2.pas',
  QkQ3 in 'prog\QkQ3.pas',
  QkQme in 'prog\QkQme.pas' {FQQme},
  QkQuakeC in 'prog\QkQuakeC.pas' {FQQuakeC},
  QkQuakeCtx in 'prog\QkQuakeCtx.pas',
  QkQuakeMap in 'prog\QkQuakeMap.pas',
  QkRawFile in 'prog\QkRawFile.pas' {FQRawFile},
  QkSin in 'prog\QkSin.pas',
  QkSoF in 'prog\QkSoF.pas',
  QkSpecifics in 'prog\QkSpecifics.pas',
  QkSpr in 'prog\QkSpr.pas',
  QkStoneless in 'prog\QkStoneless.pas',
  QkSylphis in 'prog\QkSylphis.pas',
  QkSysData in 'prog\QkSysData.pas',
  QkText in 'prog\QkText.pas',
  QkTextures in 'prog\QkTextures.pas' {FQTexture},
  QkTga in 'prog\QkTga.pas',
  QkTreeView in 'prog\QkTreeView.pas',
  QkTribes2 in 'prog\QkTribes2.pas',
  QkUnknown in 'prog\QkUnknown.pas' {FQUnknown},
  QkVMF in 'prog\QkVMF.pas',
  QkVMT in 'prog\QkVMT.pas',
  QkVPK in 'prog\QkVPK.pas',
  QkVTF in 'prog\QkVTF.pas',
  QkWad in 'prog\QkWad.pas' {FQWad},
  QkWav in 'prog\QkWav.pas',
  QkWorldCraft in 'prog\QkWorldCraft.pas',
  QkZip2 in 'prog\QkZip2.pas',
  qmath in 'prog\qmath.pas',
  qmathconvert in 'prog\qmathconvert.pas',
  qmatrices in 'prog\qmatrices.pas',
  qquaternions in 'prog\qquaternions.pas',
  QPAcc in 'prog\QPAcc.pas',
  QuickWal in 'prog\QuickWal.pas' {QuickWalParser},
  RedLines in 'prog\RedLines.pas',
  Running in 'prog\Running.pas' {RunForm},
  SearchHoles in 'prog\SearchHoles.pas',
  Setup in 'prog\Setup.pas',
  Splash in 'prog\Splash.pas' {SplashScreen},
  Sprite in 'prog\Sprite.pas',
  SteamFS in 'prog\SteamFS.pas',
  SystemDetails in 'prog\SystemDetails.pas',
  TbPalette in 'prog\TbPalette.pas',
  TbTexture in 'prog\TbTexture.pas',
  TbUndoMenu in 'prog\TbUndoMenu.pas' {UndoDlg},
  TexHints in 'prog\TexHints.pas',
  TextBoxForm in 'prog\TextBoxForm.pas' {TextBoxForm},
  Toolbar1 in 'prog\Toolbar1.pas',
  ToolBox1 in 'prog\ToolBox1.pas' {ToolBoxForm},
  ToolBoxGroup in 'prog\ToolBoxGroup.pas' {FQToolBoxGroup},
  Travail in 'prog\Travail.pas' {FormTravail},
  Undo in 'prog\Undo.pas',
  VersionNumbers in 'prog\VersionNumbers.pas',
  VTFLib in 'prog\VTFLib.pas',
  ZipAbbrevia in 'prog\ZipAbbrevia.pas',
  PyCanvas in 'python\PyCanvas.pas',
  PyControls in 'python\PyControls.pas',
  PyExplorer in 'python\PyExplorer.pas',
  PyFloating in 'python\PyFloating.pas',
  PyFormCfg in 'python\PyFormCfg.pas',
  PyForms in 'python\PyForms.pas' {PyForm},
  PyFullScreen in 'python\PyFullScreen.pas',
  PyImages in 'python\PyImages.pas',
  PyMacros in 'python\PyMacros.pas',
  PyMapView in 'python\PyMapView.pas',
  PyMath in 'python\PyMath.pas',
  PyMenus in 'python\PyMenus.pas',
  PyObjects in 'python\PyObjects.pas',
  PyPanels in 'python\PyPanels.pas',
  PyProcess in 'python\PyProcess.pas',
  Python in 'python\Python.pas',
  PyToolbars in 'python\PyToolbars.pas',
  PyTravail in 'python\PyTravail.pas',
  PyUndo in 'python\PyUndo.pas',
  Quarkx in 'Python\Quarkx.pas';

{$R *.RES}

{$IFNDEF LINUX}
  //Set the support-for-larger-than-2GB-flag, so we can use up to 4 GB!
  {$IFDEF Delphi6orNewerCompiler}
    {$SetPEFlags IMAGE_FILE_LARGE_ADDRESS_AWARE}
    {$IFNDEF Delphi2007orNewerCompiler} //Became an option in Delphi 2007
      {$SetPEOptFlags IMAGE_DLLCHARACTERISTICS_DYNAMIC_BASE}
    {$ENDIF}
    {$SetPEOptFlags IMAGE_DLLCHARACTERISTICS_NX_COMPAT}
  {$ENDIF}
  //Note: There doesn't appear to be a way to set "DependentLoadFlags" in the PE header to LOAD_LIBRARY_SEARCH_SYSTEM32
  //Only on Windows 10 RS1 and later.
{$ENDIF}

begin
  (*
  {$IFDEF Delphi5orNewerCompiler}
  //Disable Runtime error messages.
  NoErrMsg:=True;
  {$ENDIF}
  *)

  Application.Title:='Quake Army Knife';

  {$IFDEF NeedD6CheckWin32VersionFix}
  PatchCheckWin32Version;
  {$ENDIF}

  //Configure localization settings.
  Application.UpdateFormatSettings:=False;
  {$IFDEF DelphiXEorNewerCompiler}
  FormatSettings.DecimalSeparator:='.';
  {$ELSE}
  DecimalSeparator:='.';
  {$ENDIF}

{$IFDEF MemCheck}
  MemChk;
{$ENDIF}

  //This calls InitProc (note: this opens the log file).
  Application.Initialize;

  //Install exception hook to catch exceptions during TForm1 creation.
  InstallExceptProc;

  Log(LOG_VERBOSE, 'Loading main form...');
  Application.CreateForm(TForm1, g_Form1);
  Application.Run;
end.
