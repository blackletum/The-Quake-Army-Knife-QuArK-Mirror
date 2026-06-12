<?php
require_once('_image_functions.php');
require_once('_main_paths.php');

class cVideo
{
	var $Name;
	var $DatePublished;
	var $Link;
	var $DownloadLink;
	var $Screenshot;
	var $Screenshotwidth;
	var $Screenshotheight;
	var $Website;
	var $Author;
	var $EmailAuthor;
	var $FileSize;
	var $Length;
	var $Type;
	var $Mediatype;
	var $Description;
	var $Codecs;
	var $PlayerSettings; //Player settings
	var $PlayerParameters; //Player parameters

	function __construct($aName, $aDatePublished=0, $aLink=NULL, $aDownloadLink=NULL, $aScreenshot=NULL, $aWebsite=NULL, $aAuthor=NULL, $aEmailAuthor=NULL, $aFileSize=0, $aLength=NULL, $aType='-', $aMediatype='-', $aDescription=NULL, $aCodecs=NULL, $aPlayerSettings=NULL, $aPlayerParameters=NULL)
	{
		$this->Name             = $aName; //Title
		$this->DatePublished    = $aDatePublished;
		$this->Link             = $aLink;
		$this->DownloadLink     = $aDownloadLink;
		$this->Screenshot       = $aScreenshot;
		$this->Website          = $aWebsite;
		$this->Author           = $aAuthor;
		$this->EmailAuthor      = $aEmailAuthor;
		$this->FileSize         = $aFileSize;
		$this->Length           = $aLength;
		$this->Type             = $aType;
		$this->Mediatype        = $aMediatype;
		$this->Description      = $aDescription;
		$this->Codecs           = $aCodecs;
		$this->PlayerSettings   = $aPlayerSettings;
		$this->PlayerParameters = $aPlayerParameters;
	}
}

global $picsroot, $videosroot;

global $videotypeslist;
$videotypeslist = array(
 'TUTO' => 'Tutorial'
,'DEMO' => 'Demonstration'
,'PREV' => 'Preview'
,'?'    => 'Unknown'
);

global $mediatypeslist;
$mediatypeslist = array(
 'M1' => 'AVI File'
,'M2' => 'MOV File'
,'M3' => 'Flash Movie'
,'M4' => 'WMV File'
,'M5' => 'ASF Movie'
,'M6' => 'External Link'
,'-'  => 'Unknown'
);

global $videosdatabase;
$videosdatabase = array(
new cVideo(
 'OpenGL Lighting Preview'
,mktime(0, 0, 0, 4, 6, 2007)
,$videosroot.'QuArKOpenGLLightingPreviewHQ.avi' //.asf
,NULL
,new cImage($picsroot.'videos/OpenGllighting.png', 'Preview', 300, 257)
,NULL
,'DanielPharos'
,NULL
,16989357
,'1:38 (m:ss)'
,'PREV'
,'M1' //'M5'
,'A demonstration of the OpenGL lighting introduced in QuArK 6.5.0 Beta 2.0.'
,'S-Mpeg 4 version 3 (MP43) (video), MP3 (audio)'
,array('fullscreen' => true)
,array('refresh' => '106;url=https://sourceforge.net/projects/quark/files/QuArK/QuArK%206.5.0%20Beta%202.0/')
)

,new cVideo(
 'Basic NoSky Map'
,mktime(0, 0, 0, 1, 3, 2008)
,NULL
,$videosroot.'AVI_Basic_NoSky_Map.zip'
,new cImage($picsroot.'videos/BasicNoSkyMap.png', 'Preview', 300, 257)
,NULL
,'NOTTMOTO'
,NULL
,156961739
,'11:45 (mm:ss)'
,'TUTO'
,'M1'
,"This is a small video tutorial on how to make a basic start map with no sky using QuArK, it will also show one of the ways to use the \"No Draw\" texture and how to \"Miter\" the corners of the walls in your map."
,'TechSmith Screen Capture Codec (tscc) (video), PCM Audio (audio)'
,NULL
,NULL
)

,new cVideo(
 'Creating a Box'
,mktime(0, 0, 0, 2, 19, 2008)
,$videosroot.'Creating a Box.avi'
,$videosroot.'Creating a Box.rar'
,new cImage($picsroot.'videos/CreatingaBox.png', 'Preview', 303, 235)
,NULL
,'Paril'
,NULL
,13786171
,'2:52 (m:ss)'
,'TUTO'
,'M1'
,'A tutorial on how to make a basic room in QuArK.'
,'XviD 1.1.2 Final (XVID) (video), PCM Audio (audio)'
,NULL
,NULL
)

,new cVideo(
 'Doorways'
,mktime(0, 0, 0, 2, 19, 2008)
,$videosroot.'Doorways.avi'
,$videosroot.'Doorways.rar'
,new cImage($picsroot.'videos/Doorways.png', 'Preview', 300, 277)
,NULL
,'Paril'
,NULL
,14804363
,'2:23 (m:ss)'
,'TUTO'
,'M1'
,'A tutorial on how to add a doorway to a basic room in QuArK.'
,'XviD 1.1.2 Final (XVID) (video), PCM Audio (audio)'
,NULL
,NULL
)

,new cVideo(
 'Map Compiler'
,mktime(0, 0, 0, 7, 12, 2007)
,'https://www.youtube.com/watch?v=78dhfSGXtH8' //https://www.youtube.com/watch?v=cflhoBI1P9Y
,NULL
,new cImage($picsroot.'videos/MapCompiler.png', 'Preview', 320, 195)
,NULL
,'webez'
,NULL
,0
,'3:01 (m:ss)'
,'DEMO'
,'M6'
,'Map compiler integrated with Quark'
,NULL
,NULL
,NULL
)

,new cVideo(
 'QuArK - The (almost) Complete Guide'
,mktime(0, 0, 0, 2, 20, 2007)
,'https://www.youtube.com/watch?v=NxB-vT2wHq0'
,NULL
,new cImage($picsroot.'videos/CompleteGuide.png', 'Preview', 320, 195)
,NULL
,'IsraeliRedDragon'
,NULL
,0
,'25:37 (mm:ss)'
,'TUTO'
,'M6'
,"Here's the guide you've been waiting for. It explains straight to the point all the stuff you need to know, which isn't a lot really. It also features Frictional Battlecube recreated in QuArK!"
,NULL
,NULL
,NULL
)

,new cVideo(
 'HL2DM 2 QuArK'
,mktime(0, 0, 0, 1, 19, 2008)
,'https://www.youtube.com/watch?v=TovgpwFQX_g'
,NULL
,new cImage($picsroot.'videos/HL2DM2QuArK.png', 'Preview', 320, 195)
,NULL
,'NightRage'
,NULL
,0
,'3:14 (m:ss)'
,'DEMO'
,'M6'
,"I made a small video, just an export Test map to HalfLife2 DeathMatch. I'm using Quark 6.5 beta 3 by the way."
,NULL
,NULL
,NULL
)

,new cVideo(
 'Nexuiz-QuArK.mov'
,mktime(0, 0, 0, 5, 10, 2008)
,NULL
,$videosroot.'Nexuiz-QuArK.rar'
,new cImage($picsroot.'videos/Nexuiz-QuArK.png', 'Preview', 300, 269)
,NULL
,'Manuel Ponce'
,NULL
,33238780
,'3:08 (m:ss)'
,'TUTO'
,'M2'
,'This is a small video tutorial on where to download the build tools and how to setup and configure QuArK to make maps for Nexuiz.'
,NULL
,NULL
,NULL
)

,new cVideo(
 'SimWorld/Quark Video Tutorial Pack'
,mktime(0, 0, 0, 5, 3, 2005)
,NULL
,$videosroot.'SWQuarkTutorial.rar'
//,'http://www.editingarchive.com/downloads/644'
,new cImage($picsroot.'videos/SimWorld Quark.png', 'Preview', 303, 278)
,NULL
,"Robby \"Sim9\" Zinchak"
,NULL
,83053552
,'7:53 (m:ss) + 13:44 (mm:ss) + 5:59 (m:ss)'
,'TUTO'
,'M1'
,"Here is a nice pack of three video tutorials to help you learn how to make interior structures for SimWorld and other Torque based games using the Quark editor. There are three video tutorials included, each on a different topic:<br>
<br>
Quark1.avi - Part 1 - Teaches how to set up Quark for SimWorld and other Torque based games.<br>
Quark2.avi - Part 2 - Teaches some basic Quark operations like: creating and moving brushes, negative brushes, duplicators, and texture assignment.<br>
Quark3.avi - Part 3 - Teaches how to export from Quark into SimWorld."
,'XviD 1.0.3 (XVID) (video), ADPCM (audio)'
,NULL
,NULL
)

,new cVideo(
 'SOF Quark Map Set Up'
,mktime(0, 0, 0, 9, 23, 2006)
,'https://www.youtube.com/watch?v=ETu3vdk7Y8g'
,NULL
,new cImage($picsroot.'videos/SOF Quark.png', 'Preview', 320, 195)
,NULL
,'NOTTMOTO'
,NULL
,0
,'5:09 (m:ss)'
,'TUTO'
,'M6'
,'How to start a SOF map with quark.'
,NULL
,NULL
,NULL
)

,new cVideo(
 'II Quark-drzwi'
,mktime(0, 0, 0, 1, 4, 2009)
,'https://www.youtube.com/watch?v=Jf4kjWwpA2c'
,NULL
,new cImage($picsroot.'videos/II_Quark-drzwi.png', 'Preview', 322, 194)
,NULL
,'Omagon1994'
,NULL
,0
,'4:10 (m:ss)'
,'TUTO'
,'M6'
,'Jest to mój pierwszy tutorial video (wysylany juz 3 raz xD)'
,NULL
,NULL
,NULL
)

,new cVideo(
 'Quake 2 - My Quark Prefab - Inspired By Macross'
,mktime(0, 0, 0, 11, 14, 2009)
,'https://www.youtube.com/watch?v=eZitQaYdc0c'
,NULL
,new cImage($picsroot.'videos/Quake_2_-_My_Quark_Prefab-Inspired_By_Macross.png', 'Preview', 320, 195)
,NULL
,'q2k2k'
,NULL
,0
,'1:15 (m:ss)'
,'DEMO'
,'M6'
,'My quark prefab - inspired by macross anime'
,NULL
,NULL
,NULL
)

,new cVideo(
 'QuArK - Problem z przegladaniem mapy'
,mktime(0, 0, 0, 1, 8, 2010)
,'https://www.youtube.com/watch?v=ZLtGu9O1X-g'
,NULL
,new cImage($picsroot.'videos/QuArK-Problem_z_przegladaniem_mapy.png', 'Preview', 320, 195)
,NULL
,'StarOuter2'
,NULL
,0
,'2:34 (m:ss)'
,'-'
,'M6'
,"Doczekalem sie Pierwszego Noworocznego Problemu (w skrócie PNP)<br>
<br>
Mój problem polega na QuArK'u edytorze map do roznych gier<br>
w tym do cs'a 1.6<br>
<br>
Posiadam Wersje NonSteam ver. 40<br>
<br>
Podglad odpalam poprzez cs'a(HL.EXE -game cstrike)<br>
Bo przez samego HL.EXE mi nie idzie :/<br>
<br>
Prosze o rozwiazanie problemu za mnie ;)"
,NULL
,NULL
,NULL
)

,new cVideo(
 'QuArK Alignment Question'
,mktime(0, 0, 0, 7, 26, 2009)
,'https://www.youtube.com/watch?v=6p1iClaCHb0'
,NULL
,new cImage($picsroot.'videos/QuArK_Alignment_Question.png', 'Preview', 320, 195)
,NULL
,'RadiantVibe'
,NULL
,0
,'0:18 (m:ss)'
,'-'
,'M6'
,"This is a question that I have in QuArK. I can't figure out how to make the curves aligned properly.<br>
<br>
Notice how the trim is aligned and the green is not."
,NULL
,NULL
,NULL
)

,new cVideo(
 'QuArK - The NEW AND IMPROVED Slope Technique - The Double Perfect Slope Technique'
,mktime(0, 0, 0, 8, 21, 2009)
,'https://www.youtube.com/watch?v=kHi9ZeoImtE'
,NULL
,new cImage($picsroot.'videos/The_Double_Perfect_Slope_Technique.png', 'Preview', 320, 195)
,NULL
,'RadiantVibe'
,NULL
,0
,'1:40 (m:ss)'
,'-'
,'M6'
,"This is a new and improved slope technique (as said in the title). It's better because instead of having to shorten your curve to make the texture right you can make it the same length that you want AND it will be rotated the right way.<br>
<br>
The reason why it's called The Double Perfect Slope Technique (The DPS Technique) is because it requires 2 of the same piece to do each part and it's PERFECT!<br>
<br>
Please Comment!<br>
<br>
Thanks for watching!"
,NULL
,NULL
,NULL
)

,new cVideo(
 'Q2 Jump - Ancientgouki2 by q2k2k'
,mktime(0, 0, 0, 8, 16, 2008)
,'https://www.youtube.com/watch?v=CUXYAhWVth8'
,NULL
,new cImage($picsroot.'videos/Q2_Jump-Ancientgouki2.png', 'Preview', 320, 195)
,NULL
,'q2k2k'
,NULL
,0
,'0:55 (m:ss)'
,'DEMO'
,'M6'
,'ancientgouki2 made by me using quark'
,NULL
,NULL
,NULL
)

,new cVideo(
 'Quark - Quake 1 Tutorial - Pool'
,mktime(0, 0, 0, 8, 30, 2010)
,'https://www.youtube.com/watch?v=AeTPoKLjENw'
,NULL
,new cImage($picsroot.'videos/Quark-Quake1Tutorial-Pool.png', 'Preview', 320, 195)
,NULL
,'cvetomir2'
,NULL
,0
,'4:50 (m:ss)'
,'TUTO'
,'M6'
,'In This Tutorial I Show How To Make a Pool In Quake 1 :) I Hope You Enjoy'
,NULL
,NULL
,NULL
)

,new cVideo(
 'my hexen 2 level'
,mktime(0, 0, 0, 1, 19, 2009)
,'https://www.youtube.com/watch?v=DvbPzh9zo70'
,NULL
,new cImage($picsroot.'videos/myhexen2level.png', 'Preview', 320, 195)
,NULL
,'Kenonrus'
,NULL
,0
,'2:22 (m:ss)'
,'DEMO'
,'M6'
,'my hexen 2 level in quark. Please, where find quark hexen 2 map tutorials!'
,NULL
,NULL
,NULL
)

#Old negative movie (problems long fixed)
#,new cVideo(
# 'The Joy of Quark'
#,mktime(0, 0, 0, 12, 4, 2007)
#,'https://www.youtube.com/watch?v=VbOUjYx9qZc'
#,NULL
#,new cImage($picsroot.'videos/TheJoyofQuark.png', 'Preview', 320, 195)
#,NULL
#,'perishingflames'
#,NULL
#,0
#,'2:55 (m:ss)'
#,'DEMO'
#,'M6'
#,'I love quark already...'
#,NULL
#,NULL
#,NULL
#)

,new cVideo(
 'Old Castle Fortress - Paradox268'
,mktime(0, 0, 0, 1, 31, 2011)
,'https://www.youtube.com/watch?v=nx_mEZf-PNI'
,NULL
,new cImage($picsroot.'videos/OldCastleFortress.png', 'Preview', 320, 195)
,NULL
,'Elfheq'
,NULL
,0
,'1:57 (m:ss)'
,'DEMO'
,'M6'
,"This is one of my Quake 2 maps that I've made with QuArK Quake Army Knife. It uses many aspects of medeval times. This is my first map i;ve videotaped using Fraps 3.2"
,NULL
,NULL
,NULL
)

,new cVideo(
 'Align A door in quark'
,mktime(0, 0, 0, 4, 11, 2012)
,'https://www.youtube.com/watch?v=vj1Wv8-O_0k'
,NULL
,new cImage($picsroot.'videos/AlignADoor.png', 'Preview', 320, 182)
,NULL
,'Hardkore'
,NULL
,0
,'1:47 (m:ss)'
,'TUTO'
,'M6'
,'name says it all'
,NULL
,NULL
,NULL
)

,new cVideo(
 'Make a pipe in quark'
,mktime(0, 0, 0, 4, 15, 2012)
,'https://www.youtube.com/watch?v=sX5U_RKgmho'
,NULL
,new cImage($picsroot.'videos/MakeAPipe.png', 'Preview', 320, 182)
,NULL
,'Hardkore'
,NULL
,0
,'2:37 (m:ss)'
,'TUTO'
,'M6'
,'making a pipe'
,NULL
,NULL
,NULL
)

,new cVideo(
 'Quark - Configuration for counter-strike'
,mktime(0, 0, 0, 12, 14, 2013)
,'https://www.youtube.com/watch?v=8xqFZT3jUvQ'
,NULL
,new cImage($picsroot.'videos/Configuration_for_Counter-Strike.png', 'Preview', 320, 182)
,NULL
,'KZPLcypek'
,NULL
,0
,'1:57 (m:ss)'
,'TUTO'
,'M6'
,'Configuration tutorial for Quake Army Knife ( Quark ) for Counter-Strike'
,NULL
,NULL
,NULL
)

//Marked as "unlisted" on Youtube!
,new cVideo(
 'QuArK editor Dawn of Darkness qrk file'
,mktime(0, 0, 0, 3, 18, 2014)
,'https://www.youtube.com/watch?v=dj-Ocb07tJ0'
,NULL
,new cImage($picsroot.'videos/QuArK_Editor_Dawn_of_Darkness_qrk_file.png', 'Preview', 320, 182)
,NULL
,"Roarke's carnivorous plants" #'Roarkethemerciless'
,NULL
,0
,'1:08 (m:ss)'
,'DEMO'
,'M6'
,'QuArK editor Dawn of Darkness qrk file for Quake 2 Dawn of Darkness mod.'
,NULL
,NULL
,NULL
)

,new cVideo(
 'Portal in Quake II?'
,mktime(0, 0, 0, 1, 16, 2011)
,'https://www.youtube.com/watch?v=sgL89hOBnu0'
,NULL
,new cImage($picsroot.'videos/Portal_in_Quake_II.png', 'Preview', 320, 182)
,NULL
,'erimaxbau'
,NULL
,0
,'1:16 (m:ss)'
,'DEMO'
,'M6'
,"I decided to try and build some Portal objects in Quake II using QuArK. This level uses textures and items all found in the game, and all the Portal objects were constructed using primitives. There are no portals, though. Quake II does have teleporters, but they are pretty limited as best as I can tell. I may make more levels that have puzzles, but they would have to be non-portal related, considering I'm not editing any of the game source code."
,NULL
,NULL
,NULL
)

,new cVideo(
 'Old... OOOLLLDDD HL mod map'
,mktime(0, 0, 0, 4, 4, 2013)
,'https://www.youtube.com/watch?v=IDHPWOLFHH4'
,NULL
,new cImage($picsroot.'videos/Old_OOOLLLDDD_HL_mod_map.png', 'Preview', 320, 182)
,NULL
,'yarrik701'
,NULL
,0
,'0:29 (m:ss)'
,'DEMO'
,'M6'
,'Back when I had a lot of time for creating Half-Life maps... I made... this... man this is old. Mapped using QuArK (Quake Army Knife), great mapping tool...'
,NULL
,NULL
,NULL
)

,new cVideo(
 'New Half-Life 2 - Deathmatch map: blackmesa1.bsp 0.0.1 WIP'
,mktime(0, 0, 0, 12, 19, 2011)
,'https://www.youtube.com/watch?v=uvPozliZ5OM'
,NULL
,new cImage($picsroot.'videos/New_Half-Life_2_-_Deathmatch_map_blackmesa1.bsp_0.0.1_WIP.png', 'Preview', 320, 182)
,NULL
,'SNESIvan'
,NULL
,0
,'1:05 (m:ss)'
,'DEMO'
,'M6'
,"Very early version of my new map. Don't worry, i'm already working on Alpha 2. The project started yesterday. It's being made with QuarK (QUAKE ARMY KNIFE) and does NOT require HL:Source..."
,NULL
,NULL
,NULL
)

,new cVideo(
 'Quake 2 - Quark map editor - strafe jump test...'
,mktime(0, 0, 0, 1, 31, 2016)
,'https://www.youtube.com/watch?v=r-TaDIuw_xE'
,NULL
,new cImage($picsroot.'videos/Quake_2_-_Quark_map_editor_-_strafe_jump_test.png', 'Preview', 320, 172)
,NULL
,'ebkoss'
,NULL
,0
,'0:10 (m:ss)'
,'-'
,'M6'
,'IMAGE:<br>https://drive.google.com/file/d/0BzB8Fy7ShYK8ZUM0V0Y3V0NDekU/view?usp=sharing<br><br>By 4Bidden'
,NULL
,NULL
,NULL
)

//Marked as "unlisted" on Youtube!
,new cVideo(
 'How to add and edit you mod with Quake Army Knife 6 6 0 beta 7'
,mktime(0, 0, 0, 10, 20, 2018)
,'https://www.youtube.com/watch?v=DEA_D_KXPAw' #https://www.youtube.com/watch?v=DEA_D_KXPAw&list=PLYUjdFYquLZmxA1tIZUviv9hRiBaKmYsZ&index=1
,NULL
,new cImage($picsroot.'videos/How_to_add_and_edit_you_mod_with_Quake_Army_Knife_6.6.0_beta_7.png', 'Preview', 320, 180)
,NULL
,"Roarke's carnivorous plants"
,NULL
,0
,'0:42 (m:ss)'
,'TUTO'
,'M6'
,"Here i'm using Quake 2 as a short example."
,NULL
,NULL
,NULL
)

//Marked as "unlisted" on Youtube!
,new cVideo(
 'Quake Army Knife 6.6 beta 6 configuration'
,mktime(0, 0, 0, 7, 5, 2018)
,'https://www.youtube.com/watch?v=iXoj7rBxAGI' #https://www.youtube.com/watch?v=iXoj7rBxAGI&list=PLYUjdFYquLZmxA1tIZUviv9hRiBaKmYsZ&index=2
,NULL
,new cImage($picsroot.'videos/Quake_Army_Knife_6.6_beta_6_configuration.png', 'Preview', 320, 180)
,NULL
,"Roarke's carnivorous plants"
,NULL
,0
,'5:14 (m:ss)'
,'TUTO'
,'M6'
,NULL
,NULL
,NULL
,NULL
)

//Marked as "unlisted" on Youtube!
,new cVideo(
 'Quake Army Knife 6.6 beta 6 - dragging a group of polys in the panel'
,mktime(0, 0, 0, 7, 5, 2018)
,'https://www.youtube.com/watch?v=8GCcd6Ccj3Q' #https://www.youtube.com/watch?v=8GCcd6Ccj3Q&list=PLYUjdFYquLZmxA1tIZUviv9hRiBaKmYsZ&index=3
,NULL
,new cImage($picsroot.'videos/Quake_Army_Knife_6.6_beta_6_-_dragging_a_group_of_polys_in_the_panel.png', 'Preview', 320, 180)
,NULL
,"Roarke's carnivorous plants"
,NULL
,0
,'0:42 (m:ss)'
,'TUTO'
,'M6'
,NULL
,NULL
,NULL
,NULL
)

//Marked as "unlisted" on Youtube!
,new cVideo(
 'Quake Army Knife 6.6 beta 6 - making a group of polys'
,mktime(0, 0, 0, 7, 5, 2018)
,'https://www.youtube.com/watch?v=E_ecBF1MwkE' #https://www.youtube.com/watch?v=E_ecBF1MwkE&list=PLYUjdFYquLZmxA1tIZUviv9hRiBaKmYsZ&index=4
,NULL
,new cImage($picsroot.'videos/Quake_Army_Knife_6.6_beta_6_-_making_a_group_of_polys.png', 'Preview', 320, 180)
,NULL
,"Roarke's carnivorous plants"
,NULL
,0
,'1:11 (m:ss)'
,'TUTO'
,'M6'
,NULL
,NULL
,NULL
,NULL
)

,new cVideo(
 'Quake army knife and a male cat'
,mktime(0, 0, 0, 8, 15, 2017)
,'https://www.youtube.com/watch?v=7iBLkqcPeGg' #https://www.youtube.com/watch?v=7iBLkqcPeGg&list=PLYUjdFYquLZmxA1tIZUviv9hRiBaKmYsZ&index=5
,NULL
,new cImage($picsroot.'videos/Quake_army_knife_and_a_male_cat.png', 'Preview', 320, 180)
,NULL
,"Roarke's carnivorous plants"
,NULL
,0
,'0:41 (m:ss)'
,'-'
,'M6'
,'Quark (Quake army knife) editor si o pisica motan.'
,NULL
,NULL
,NULL
)

,new cVideo(
 'How to import/save a mrg file, if cannot open with Quark editor, when you rename it to a .map file'
,mktime(0, 0, 0, 10, 12, 2015)
,'https://www.youtube.com/watch?v=3xqcX94QTcI' #https://www.youtube.com/watch?v=3xqcX94QTcI&list=PLYUjdFYquLZmxA1tIZUviv9hRiBaKmYsZ&index=6
,NULL
,new cImage($picsroot.'videos/How_to_import_save_a_mrg_file.png', 'Preview', 300, 158)
,NULL
,"Roarke's carnivorous plants"
,NULL
,0
,'2:31 (m:ss)'
,'TUTO'
,'M6'
,'Make a new map first with the BSP editor. Than follow the instructions in the video.<br><br>Faceti o noua mapa prima data cu editorul BSP. Si dupa aceea urmati instructiunile din video.'
,NULL
,NULL
,NULL
)

,new cVideo(
 'Quake 2 - DoD mod - QuArK editor - Importing new textures'
,mktime(0, 0, 0, 8, 7, 2015)
,'https://www.youtube.com/watch?v=seHgD1q8zrM' #https://www.youtube.com/watch?v=seHgD1q8zrM&list=PLYUjdFYquLZmxA1tIZUviv9hRiBaKmYsZ&index=7
,NULL
,new cImage($picsroot.'videos/Quake_2_-_DoD_mod_-_QuArK_editor_-_Importing_new_textures.png', 'Preview', 320, 172)
,NULL
,"Roarke's carnivorous plants" #'Roarke'
,NULL
,0
,'1:33 (m:ss)'
,'TUTO'
,'M6'
,'Importarea unor texturi noi cu un efect de transparenta folosind editorul Quake Army Knife.<br><br>Importing new textures with a transparency effect using Quake Army Knife editor.'
,NULL
,NULL
,NULL
)

,new cVideo(
 'Quake 2 - DoD mod - QuArK editor - Phong shading, wrapping and scaling off a texture'
,mktime(0, 0, 0, 10, 2, 2015)
,'https://www.youtube.com/watch?v=pEMQ_GTU6Go' #https://www.youtube.com/watch?v=pEMQ_GTU6Go&list=PLYUjdFYquLZmxA1tIZUviv9hRiBaKmYsZ&index=8
,NULL
,new cImage($picsroot.'videos/Quake_2_-_DoD_mod_-_QuArK_editor_-_Phong_shading,_wrapping_and_scaling_off_a_texture.png', 'Preview', 320, 180)
,NULL
,"Roarke's carnivorous plants"
,NULL
,0
,'6:50 (m:ss)'
,'TUTO'
,'M6'
,'Phong shading, wrapping and scaling off a texture on a pillar poly.<br><br>Umbrirea phong, curbarea si scalarea texturii pe un poligon a unui stalp.'
,NULL
,NULL
,NULL
)

,new cVideo(
 'Mapping in the QuArK'
,mktime(0, 0, 0, 1, 19, 2012)
,'https://www.youtube.com/watch?v=lsAtpeMHJzQ'
,NULL
,new cImage($picsroot.'videos/Mapping_in_the_QuArK.png', 'Preview', 320, 200)
,NULL
,'Aleksandr Barybin'
,NULL
,0
,'1:39 (m:ss)'
,'TUTO'
,'M6'
,NULL
,NULL
,NULL
,NULL
)

,new cVideo(
 'quark to unity'
,mktime(0, 0, 0, 12, 7, 2014)
,'https://www.youtube.com/watch?v=Rpd-Hhi9FoI'
,NULL
,NULL
,NULL
,'djokerSoft'
,NULL
,0
,'0:50 (m:ss)'
,'DEMO'
,'M6'
,'tool to export quark army knife maps to xml then load and animte on Unity3d'
,NULL
,NULL
,NULL
)

,new cVideo(
 'quark army knife with Unity3d(CREATE QUAKE ENGINE)'
,mktime(0, 0, 0, 6, 29, 2016)
,'https://www.youtube.com/watch?v=ou99hyD5Gyc'
,NULL
,NULL
,NULL
,'djokerSoft'
,NULL
,0
,'9:11 (m:ss)'
,'TUTO'
,'M6'
,"A few years ago, when i was still discovering the 3d programming I had so much fun using 6DX engine but always with the dream of one day create something similar. So, using Unity3D with Quark and one little of programming i've made this."
,NULL
,NULL
,NULL
)

,new cVideo(
 'quark army knife. slope corrodor. negitive poly'
,mktime(0, 0, 0, 7, 3, 2016)
,'https://www.youtube.com/watch?v=9lyt8SXUAUg'
,NULL
,NULL
,NULL
,'hypov8'
,NULL
,0
,'5:26 (m:ss)'
,'TUTO'
,'M6'
,"apply a 'negative poly' to hollow out an area to make a corrodor between 2 rooms"
,NULL
,NULL
,NULL
)

#DEAD: https://www.youtube.com/watch?v=IRS8CMdPIp4

,new cVideo(
 'Tutorial for quark to make .qrk addon file for mods'
,mktime(0, 0, 0, 1, 25, 2018)
,'https://www.youtube.com/watch?v=miOhJB5cbOM'
,NULL
,NULL
,NULL
,'macanah'
,NULL
,0
,'1:31 (m:ss)'
,'TUTO'
,'M6'
,'short tutorial for quakr to make addon<br>addons for quark have the extensioon .qrk'
,NULL
,NULL
,NULL
)

,new cVideo(
 'Quark 6.6.0 Beta 7 Issue'
,mktime(0, 0, 0, 12, 6, 2015)
,'https://www.youtube.com/watch?v=sg-x5pcHMZo'
,NULL
,NULL
,NULL
,'TOMYSSHADOW'
,NULL
,0
,'0:56 (m:ss)'
,'DEMO'
,'M6'
,"Cube appears to be going through itself. Quick unedited video showing the problem I'm experiencing with OpenGL so that it can be debugged."
,NULL
,NULL
,NULL
)

,new cVideo(
 'Tire not done on 1912 Ford model TT Tanker'
,mktime(0, 0, 0, 3, 22, 2021)
,'https://www.youtube.com/watch?v=L7JzmLVirTU'
,NULL
,new cImage($picsroot.'videos/Tire_not_done_on_1912_Ford_model_TT_Tanker.png', 'Preview', 320, 180)
,NULL
,"Roarke's carnivorous plants"
,NULL
,0
,'4:25 (m:ss)'
,'DEMO'
,'M6'
,'Prefab made for Kingpin life of crime in Quake army knife, in a stage of development.'
,NULL
,NULL
,NULL
)

,new cVideo(
 'Game Level Design Tutorial for Beginners - 01'
,mktime(0, 0, 0, 11, 9, 2018)
,'https://www.youtube.com/watch?v=och-e8iaJaM'
,NULL
,NULL
,NULL
,'Fryziu DeMol'
,NULL
,0
,'22:14 (mm:ss)'
,'TUTO'
,'M6'
,'Simple game level design tutorial for beginners, how to create a map for a classic first-person shooter. What you need is a computer with Windows on it, a mouse and a small pen-drive.'
,NULL
,NULL
,NULL
)

,new cVideo(
 'Game Level Design Tutorial 02 - editor QuArK first steps'
,mktime(0, 0, 0, 12, 1, 2018)
,'https://www.youtube.com/watch?v=uYlqj2Mbn3g'
,NULL
,NULL
,NULL
,'Fryziu DeMol'
,NULL
,0
,'51:38 (mm:ss)'
,'TUTO'
,'M6'
,'Tutorial based on editor QuArK and classic shooter Quake 2 as a base for learning simple steps for creating a map in .bsp format.'
,NULL
,NULL
,NULL
)

,new cVideo(
 'Game Level Design Tutorial 03 - build a map for Quake 2'
,mktime(0, 0, 0, 1, 13, 2019)
,'https://www.youtube.com/watch?v=LpExkcQUGl8'
,NULL
,NULL
,NULL
,'Fryziu DeMol'
,NULL
,0
,'50:06 (mm:ss)'
,'TUTO'
,'M6'
,'Learn to rotate, mirror, cut and enlarge polyhedrons, create some boulders and make a first simple map for Quake 2.'
,NULL
,NULL
,NULL
)

,new cVideo(
 'Game Level Design Tutorial 04 - lights, weapons & secret sauce'
,mktime(0, 0, 0, 1, 26, 2019)
,'https://www.youtube.com/watch?v=n89EBLXPQNM'
,NULL
,NULL
,NULL
,'Fryziu DeMol'
,NULL
,0
,'45:26 (mm:ss)'
,'TUTO'
,'M6'
,'Add lights to your Quake 2 map, place some weapons, spawning points and make it playable.'
,NULL
,NULL
,NULL
)

,new cVideo(
 'QuArK tutorial - boring stuff (negative polyhedrons & make it hollow)'
,mktime(0, 0, 0, 5, 18, 2019)
,'https://www.youtube.com/watch?v=FzhGmMsPGkk'
,NULL
,NULL
,NULL
,'Fryziu DeMol'
,NULL
,0
,'15:17 (mm:ss)'
,'TUTO'
,'M6'
,'How to create emptiness, how to build walls around & quick tunnel boring.'
,NULL
,NULL
,NULL
)

,new cVideo(
 'QuArK tutorial - stairs'
,mktime(0, 0, 0, 5, 23, 2020)
,'https://www.youtube.com/watch?v=8s5-By42qXY'
,NULL
,NULL
,NULL
,'Fryziu DeMol'
,NULL
,0
,'14:48 (mm:ss)'
,'TUTO'
,'M6'
,NULL
,NULL
,NULL
,NULL
)

,new cVideo(
 'QuArK tutorial - rotate stuff (func_rotating)'
,mktime(0, 0, 0, 5, 8, 2021)
,'https://www.youtube.com/watch?v=N04s9ZP0YiE'
,NULL
,NULL
,NULL
,'Fryziu DeMol'
,NULL
,0
,'25:31 (mm:ss)'
,'TUTO'
,'M6'
,NULL
,NULL
,NULL
,NULL
)

,new cVideo(
 'Quake 1 train test with QuArK editor.'
,mktime(0, 0, 0, 2, 13, 2021)
,'https://www.youtube.com/watch?v=NGowmr5a0oA'
,NULL
,NULL
,NULL
,'resonancerim'
,NULL
,0
,'0:21 (m:ss)'
,'-'
,'M6'
,'QuArK is a nice editor even in 2021.'
,NULL
,NULL
,NULL
)

,new cVideo(
 'Quake 2 - Quark map editor - First step... By 4Bidden.'
,mktime(0, 0, 0, 1, 31, 2016)
,'https://www.youtube.com/watch?v=hcfzUr-kp3E'
,NULL
,NULL
,NULL
,'ebkoss'
,NULL
,0
,'26:03 (mm:ss)'
,'TUTO'
,'M6'
,'Hello! Here u have link for Basic stuff...ramps,lights.'
,NULL
,NULL
,NULL
)

,new cVideo(
 'FourthX presents: Paintball2 mapping with Quark.'
,mktime(0, 0, 0, 4, 21, 2018)
,'https://www.youtube.com/watch?v=7ed8Aqjynr4'
,NULL
,NULL
,NULL
,'Robert Luben'
,NULL
,0
,'2:53:42 (h:mm:ss)'
,'TUTO'
,'M6'
,'Various features and functions of the Quake Army Knife.'
,NULL
,NULL
,NULL
)

,new cVideo(
 'QuArK - q2jump - ForBiddenJump33 part 1'
,mktime(0, 0, 0, 8, 13, 2018)
,'https://www.youtube.com/watch?v=wG-viXsnX5Q'
,NULL
,NULL
,NULL
,'ebkoss'
,NULL
,0
,'23:03 (mm:ss)'
,'TUTO'
,'M6'
,'QuArK map editor + quake 2 + jump mod.<br>
Mapping and testing.'
,NULL
,NULL
,NULL
)

,new cVideo(
 'QuArK - q2jump - ForBiddenJump33 part 2'
,mktime(0, 0, 0, 8, 13, 2018)
,'https://www.youtube.com/watch?v=jhO7JkMzhaQ'
,NULL
,NULL
,NULL
,'ebkoss'
,NULL
,0
,'26:33 (mm:ss)'
,'TUTO'
,'M6'
,'QuArK map editor + quake 2 + jump mod.<br>
Mapping and testing.'
,NULL
,NULL
,NULL
)

,new cVideo(
 'QuArK - q2jump - ForBiddenJump33 part 3'
,mktime(0, 0, 0, 8, 14, 2018)
,'https://www.youtube.com/watch?v=Jw3d8IMKEwk'
,NULL
,NULL
,NULL
,'ebkoss'
,NULL
,0
,'33:34 (mm:ss)'
,'TUTO'
,'M6'
,'QuArK map editor + quake 2 + jump mod.<br>
Mapping and testing.'
,NULL
,NULL
,NULL
)

,new cVideo(
 'QuArK - q2jump - ForBiddenJump33 part 4'
,mktime(0, 0, 0, 14, 8, 2018)
,'https://www.youtube.com/watch?v=6wINncwMT3w'
,NULL
,NULL
,NULL
,'ebkoss'
,NULL
,0
,'36:09 (mm:ss)'
,'TUTO'
,'M6'
,'QuArK map editor + quake 2 + jump mod.<br>
Mapping and testing.'
,NULL
,NULL
,NULL
)

,new cVideo(
 'QuArK - q2jump - ForBiddenJump33 part 5'
,mktime(0, 0, 0, 14, 8, 2018)
,'https://www.youtube.com/watch?v=1q6Fp_YFLVM'
,NULL
,NULL
,NULL
,'ebkoss'
,NULL
,0
,'12:02 (mm:ss)'
,'TUTO'
,'M6'
,'QuArK map editor + quake 2 + jump mod.<br>
Mapping and testing.'
,NULL
,NULL
,NULL
)

,new cVideo(
 'QuArK - q2jump - ForBiddenJump33 - VISUALS part 1'
,mktime(0, 0, 0, 8, 15, 2018)
,'https://www.youtube.com/watch?v=8mFFjzqoXDc'
,NULL
,NULL
,NULL
,'ebkoss'
,NULL
,0
,'54:14 (mm:ss)'
,'TUTO'
,'M6'
,'QuArK map editor + quake 2 + jump mod.<br>
Visuals (texturing, extras).'
,NULL
,NULL
,NULL
)

,new cVideo(
 'QuArK - q2jump - ForBiddenJump33 - VISUALS part 2'
,mktime(0, 0, 0, 8, 15, 2018)
,'https://www.youtube.com/watch?v=mELyetPpICs'
,NULL
,NULL
,NULL
,'ebkoss'
,NULL
,0
,'1:05:36 (h:mm:ss)'
,'TUTO'
,'M6'
,'QuArK map editor + quake 2 + jump mod.<br>
Visuals (texturing, extras).'
,NULL
,NULL
,NULL
)

,new cVideo(
 'QuArK - q2jump - ForBiddenJump33 - VISUALS part 3'
,mktime(0, 0, 0, 8, 15, 2018)
,'https://www.youtube.com/watch?v=pGiINNX0v-Q'
,NULL
,NULL
,NULL
,'ebkoss'
,NULL
,0
,'49:42 (mm:ss)'
,'TUTO'
,'M6'
,'QuArK map editor + quake 2 + jump mod.<br>
Visuals (texturing, extras).'
,NULL
,NULL
,NULL
)

,new cVideo(
 'QuArK - q2jump - ForBiddenJump33 - VISUALS part 4'
,mktime(0, 0, 0, 8, 19, 2018)
,'https://www.youtube.com/watch?v=Wh57TEdqJXw'
,NULL
,NULL
,NULL
,'ebkoss'
,NULL
,0
,'38:22 (mm:ss)'
,'TUTO'
,'M6'
,'QuArK map editor + quake 2 + jump mod.<br>
Visuals (texturing, extras).'
,NULL
,NULL
,NULL
)

,new cVideo(
 'QuArK - q2jump - ForBiddenJump33 - VISUALS part 5'
,mktime(0, 0, 0, 8, 19, 2018)
,'https://www.youtube.com/watch?v=v1_C6nP6I9U'
,NULL
,NULL
,NULL
,'ebkoss'
,NULL
,0
,'1:11:25 (h:mm:ss)'
,'TUTO'
,'M6'
,'QuArK map editor + quake 2 + jump mod.<br>
Visuals (texturing, extras).'
,NULL
,NULL
,NULL
)

,new cVideo(
 'q2jump - ForBiddenJump33 - Goblin replay'
,mktime(0, 0, 0, 9, 8, 2018)
,'https://www.youtube.com/watch?v=H2xvRNh-X7s'
,NULL
,NULL
,NULL
,'ebkoss'
,NULL
,0
,'2:08 (m:ss)'
,'DEMO'
,'M6'
,'One of my q2jump maps.'
,NULL
,NULL
,NULL
)

,new cVideo(
 'Quark And Quake 3 - 01 - Introduction'
,mktime(0, 0, 0, 22, 1, 2018)
,'https://www.youtube.com/watch?v=UO8foJhvWOI'
,NULL
,NULL
,NULL
,'The House Of Ellis'
,NULL
,0
,'1:20 (m:ss)'
,'TUTO'
,'M6'
,'Want to learn how to map for Quake 3 using Quark map editor? This is the beginning of a series of tutorials just for you!'
,NULL
,NULL
,NULL
)

,new cVideo(
 'Quark And Quake 3 - 02 - Terminology'
,mktime(0, 0, 0, 26, 1, 2018)
,'https://www.youtube.com/watch?v=WANC7tVGVx4'
,NULL
,NULL
,NULL
,'The House Of Ellis'
,NULL
,0
,'9:45 (m:ss)'
,'TUTO'
,'M6'
,'An almost complete list of mapping terminology and jargon.'
,NULL
,NULL
,NULL
)

,new cVideo(
 'Quark And Quake 3 - 03 - Install, Configure and Test'
,mktime(0, 0, 0, 3, 2, 2018)
,'https://www.youtube.com/watch?v=354M8jfIPMo'
,NULL
,NULL
,NULL
,'The House Of Ellis'
,NULL
,0
,'8:10 (m:ss)'
,'TUTO'
,'M6'
,"Let's install, configure and test IOQuake3, Quark and our compiler tools (QMAP2, BSPC & PAKScape)."
,NULL
,NULL
,NULL
)

,new cVideo(
 'Quark And Quake 3 - 04 - Quark Overview'
,mktime(0, 0, 0, 3, 5, 2018)
,'https://www.youtube.com/watch?v=FxndM4Ik4Zk'
,NULL
,NULL
,NULL
,'The House Of Ellis'
,NULL
,0
,'16:15 (mm:ss)'
,'TUTO'
,'M6'
,"In this video I go over Quark's interface."
,NULL
,NULL
,NULL
)

,new cVideo(
 'QuArK Guide'
,mktime(9, 9, 0, 8, 11, 2007) #EST
,'https://vimeo.com/269212'
,NULL
,NULL
,NULL
,'ShadowMarble'
,NULL
,0
,'11:18 (mm:ss)'
,'TUTO'
,'M6'
,NULL //Unknown? Need to login
,NULL
,NULL
,NULL
)

//Doesn't actually involve QuArK, but uses a tool download from our website.
/*,new cVideo(
 'Tutorial: How to convert Q3A maps to QLSteam format'
,mktime(0, 0, 0, 11, 24, 2015)
,'https://www.youtube.com/watch?v=8TInaORyq1E'
,NULL
,NULL
,NULL
,'Fer BarraEs'
,NULL
,0
,'1:29 (m:ss)'
,'TUTO'
,'M6'
,'http://quark.sourceforge.net/downloads/build_tools/q3map_2.5.17_win32_x86-unofficial.zip'
,NULL
,NULL
,NULL
)*/

);
?>
