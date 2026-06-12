<?php

global $dateadded_arraycol;
global $dateupdated_arraycol;
global $mapname_arraycol;
global $download_arraycol;
global $screenshot_arraycol;
global $website_arraycol;
global $author_arraycol;
global $size_arraycol;
global $maptype_arraycol;
global $game_arraycol;
global $mod_arraycol;
global $description_arraycol;
$dateadded_arraycol = 0;
$dateupdated_arraycol = 1;
$mapname_arraycol = 2;
$download_arraycol = 3;
$screenshot_arraycol = 4;
$website_arraycol = 5;
$author_arraycol = 6;
$size_arraycol = 7;
$maptype_arraycol = 8;
$game_arraycol = 9;
$mod_arraycol = 10;
$description_arraycol = 11;

global $gameslist;
$gameslist = array(
 'Q1'    => 'Quake'
,'Q2'    => 'Quake 2'
,'Q3'    => 'Quake 3: Arena' //Q3A
,'Q4'    => 'Quake 4'
,'CS'    => 'Counter-Strike'
,'D3'    => 'Doom 3'
,'HL'    => 'Half-Life'
,'HL2'   => 'Half-Life 2'
,'HX2'   => 'Hexen II' //Hx2
,'HR2'   => 'Heretic 2' //Hr2
,'KP'    => 'Kingpin'
,'MOHAA' => 'Medal of Honor'
,'SIN'   => 'SiN'
,'SOF'   => 'Soldier of Fortune'
,'EF'    => 'Star Trek Voyager: Elite Force' //STVEF
,'EF2'   => 'Star Trek: Elite Force 2'
,'?'     => 'Unknown'
);

global $maptypeslist;
$maptypeslist = array(
 'SP'   => 'Single Player'
,'DM'   => 'Deathmatch'
,'COOP' => 'Cooperative'
,'TD'   => 'Team Deathmatch'
,'TOUR' => 'Tourney'
,'TP'   => 'Team Play'
,'CTF'  => 'Capture The Flag'
,'?'    => 'Unknown'
#FIXME: Add 1vs1?
);

global $modslist;
$modslist = array(
 'NO'   => 'Vanilla game (no mods)'
,'RA'   => 'Rocket Arena'
,'TFC'  => 'Team Fortress (Classic)'
,'ACT'  => 'Action (Q2/HL)'
,'AIR'  => 'AirQuake (Q1/Q2)'
,'GLM'  => 'Gloom'
,'OP4'  => 'Opposing Force'
,'KMQ2' => 'Knightmare (Q2)'
,'?'    => 'Unknown'
);

global $userlevelsdatabase;
$userlevelsdatabase = array(
array(
 mktime(0, 0, 0, 11, 10, 2009)
,0
,'Callisto'
,'http://www.deaconstomb.org/pub/q2/maps/callisto.zip'
,NULL
,NULL
,array(61)
,436284
,'DM'
,'Q2'
,'NO'
,"This level is set on a moon of Jupiter, close enough to reflect the giant planets' redish-orange atmoshpere..  This is The fourth level
in the Outland series-  i'm working backwards for quake II.  Expect 'The Outland' soon.... This level is dark and moody intentionally..  All the weapons are there.  I know the BFG is easy to get, but I tried to skimp on the ammo to off-set this.  The super shotgun is my favorite quake and q2 weapon, so this will obviously be the most common..  Power-ups are also freely given, because I find this makes for intense situations.. :) I won't be so forgiving in future maps...."
)

,array(
 mktime(0, 0, 0, 10, 10, 2009)
,0
,'COBRA CTF1'
,'http://lvlworld.com/dl.php?ftp=lvl&amp;zip=cobractf1'
,NULL
,'http://lvlworld.com/readme.php?id=cobractf1'
,array(62)
,3.29*1024*1024
,'CTF'
,'Q3'
,'NO'
,"This map proudly made with QuArK! Released 31/12/08. Roughly 2037 brushes, just in case you were interested ;)"
)

,array(
 mktime(0, 0, 0, 10, 10, 2009)
,0
,'Cheaters Hell Office'
,'http://www.idtsoft.com/~muldy/mapa/de_chell_v16.zip'
,'http://www.idtsoft.com/~muldy/mapa/'
,'http://www.idtsoft.com/~muldy/mapa/'
,array(63)
,1597614
,'TD' #FIXME: Guess...
,'CS'
,'NO'
,"de_chell is based on a virtual <a href=\"http://cheaters-hell.megauser.net/\">http://cheaters-hell.megauser.net</a> offices, were our cheaters database is kept. It is a fast passed map, in 5 secs you are already shooting, is very tuff to secure a bomb site."
)

,array(
 mktime(0, 0, 0, 10, 10, 2009)
,0
,'Van Down By the River: A Tribute to Chris Farley'
,'http://ftp.gameaholic.com/pub/mirrors/ftp.cdrom.com/idgames2/levels/deathmatch/v-z/van.zip'
,NULL
,'http://ftp.gameaholic.com/pub/mirrors/ftp.cdrom.com/idgames2/levels/deathmatch/v-z/van.txt'
,array(64)
,122172
,'DM'
,'Q2'
,'NO'
,"This is a deathmatch level. Like the title of the level says, it's a Van down by the river. A lot of work went in to making this level. Don't forget to go inside the van for a little surpirse! This level was designed off of the motivational speaker skit on Saturday Night Live. The motivational speaker of course is Chris Farley, who played Matt Foley."
)

,array(
 mktime(0, 0, 0, 9, 8, 2009)
,0
,'Q3PONG2'
,'http://www.map-factory.org/download/quake-3-q3pong2-494.zip' #FIXME: Originally at lvlworld-website!
,'http://www.map-factory.org/quake-3/deathmatch/q3pong2-494'
,'http://www.map-factory.org/quake-3/deathmatch/q3pong2-494'
,array(65)
,530806
,'DM TD TOUR'
,'Q3'
,'NO'
,"Just a quick level I made in Quark. It can be fun for a few matches and I understand it won't win too many design awards. I saw an old map using this same idea on LVL and thought I would remake it. I think it came out fine for the few hours of work I put into it."
)

,array(
 mktime(0, 0, 0, 3, 24, 2002)
,0
,"Baal-Peor's Two Towers"
,'http://www.baal-peor.gq.nu/releases/yhvh_two_towers.html'
,'http://www.baal-peor.gq.nu/releases/yhvh_two_towers.html'
,'http://www.baal-peor.gq.nu/'
,array(66)
,1.93*1024*1024
,'DM'
,'HL'
,'NO'
,"Baal-Peor is proud to announce the release of my latest Half-Life Deathmatch level, Baal-Peor's Two Towers!<br>SPECS:<br>40+ custom textures for atmospheric game play<br> Massive killing arena and semi-secret areas<br> Sneak behind the doors of the top-secret Black Mesa Training Center: Two Towers Section<br> Multi-leveled indoors & outdoor arenas including several elemental traps: two towers with baal-guns for face-to-face and extreme combat"
)

,array(
 mktime(0, 0, 0, 11, 25, 2001)
,0
,'Power Unleashed'
,'http://galileo.spaceports.com/~rogerdoo/q3a/rg3dm5/rg3dm5.pk3'
,'http://galileo.spaceports.com/~rogerdoo/q3a/rg3dm5/rg3dm5.htm'
,'http://www.rogeridoo.cjb.net/'
,array(67)
,1.02*1024*1024
,'DM'
,'Q3'
,'NO'
,"<b>AUTHOR's HELLO</b> : Hi guys. It's been a long time since I've seen you-I've missed you and this powerful site. Army you see & ofcourse that damn NBCI web-hosting service. I've changed my web-hosting service provider to SPACEPORTS which rock. My website's new address is : <a href=\"http://galileo.spaceports.com/~rogerdoo/\">http://galileo.spaceports.com/~rogerdoo/</a> or <a href=\"http://www.rogeridoo.cjb.net/\">http://www.rogeridoo.cjb.net/</a> My new nickname is RoGeRidoo (added the idoo coz I am into music now as well) Also my Q3A maps are now placed in <a href=\"http://galileo.spaceports.com/~rogerdoo/q3a/q3a.htm\">http://galileo.spaceports.com/~rogerdoo/q3a/q3a.htm</a><br><b>STORY</b> : Taking back control of the [OH-IR-NETA] power supply spaceship, you arrive at your final destination - planet Vensar. Now you have to confront Planojiva's infected workers to gain access to the castle's hidden dungeons that lead to Vensar's power generators. The castle is filled with powerful weapons and energy-boosts, which can come in handy, throughout your difficult mission, for both - you and the Planojiva's workers. Can you reestablish the harmony in which Vensar's inhabitants lived once or is their colony doomed for ever? Their fate is in your hands...<br><b>AUTHOR's COMMENTS</b> : A very powerful map as its title suggests. It has very nice architecture along with a very atmospheric theme. Plenty of cleverly-placed and timed-calculated power-ups. Features big battle areas, new-style teleporters, jump-pads, power-ups, many weapons and tricks to find out. It takes some time to master the map but it will certainly offer you a fragging(happy)... hour! Cheers to 'Endless Fragging'! Make sure to fill the field with at least 3 bots. Any other information you need, plus snapshots, can be obtained at : <a href=\"http://galileo.spaceports.com/~rogerdoo/q3a/rg3dm5/rg3dm5.htm\">http://galileo.spaceports.com/~rogerdoo/q3a/rg3dm5/rg3dm5.htm</a> Remember to update your links to my site with the new ones. That's all - thank you for your support."
)

,array(
 mktime(0, 0, 0, 11, 12, 2001)
,0
,"Fargin's Keep"
,'http://www.quakelevels.com/quake3/fb_keep.zip'
,'http://www.quakelevels.com/quake3/fb_keep1.jpg'
,'http://www.quakelevels.com/' #FIXME: http://www.quakelevels.com/quake3/fb_keep.htm
,array(34)
,1776955
,'DM'
,'Q3'
,'NO'
,"This is my 19th level and my finest work to date. It is \"fun as hell\" to play. Lots of stuff to pick up and use both indoors and outdoors. Lots of places to snipe from and lots of paths for running. Flight is good for 10 seconds so don't waste it. There is an invisible platform in the sky. Beneath the fog is lava and also safe trails. Jump with care. Bots can only fall from certain points to keep it challenging. There are 6 secret doors in the castle and none require \"shooting\"." #,"A very realistic castle perched in the mountains with lava beneath the fog below, with lots of indoor/outdoor action and lots of running. \"Fun as hell\" to play."
)

//,array(
// mktime(0, 0, 0, 9, 24, 2001)
//,0
//,'Savage Palace'
//,'http://www.linkoping.bonet.se/famthuresson/clan/maps/q3etdm2.htm'
//,'http://www.linkoping.bonet.se/famthuresson/clan/maps/q3etdm2.htm'
//,'http://www.linkoping.bonet.se/famthuresson/clan/'
//,array(69)
//,1.27*1024*1024
//,'DM'
//,'Q3'
//,'?'
//,"Savage Palace is rather small map, made for 2 - 8 players, the environment is similar to those in q3dm7 and q3dm13 Intense fragging in the main room, but in the other areas as well. You will have an advantage if you are good at 'close quarter combat' The bots really like this map so Enjoy!"
//)

,array(
 mktime(0, 0, 0, 5, 21, 2001)
,0
,"Baal-Peor's Water & Power"
,'http://www.baal-peor.gq.nu/hl_dm_levels/bp_[w&amp;p]/bp_[w&amp;p].zip'
,'http://www.baal-peor.gq.nu/hl_dm_levels/baal_releases.html'
,'http://www.baal-peor.gq.nu/hl_dm_levels/'
,array(66)
,2.03*1024*1024
,'DM'
,'HL'
,'NO'
,"Sadistic! Players get to use the elements of water and electricity to shock, drown and otherwise slaughter opponents!"
)

,array(
 mktime(0, 0, 0, 3, 17, 2001)
,0
,'BkQ3Dm1 (Frags in Stock)'
,'http://neofraggers.cplp.net/Neo_Fraggers_Index/Jogos/Quake_3_Arena/BkQ3Dm1.zip'
,NULL
,'http://neofraggers.cplp.net'
,array(70)
,764*1024
,'DM'
,'Q3'
,'NO'
,"It's sort of a building surrounded by what I like to call \"cars\" (hay, give me a break, think about the future) and which windows are shoot through, so many frags for only seeing the name appear on screen. in the building are most of the weapons, but no powerups. All powerups are reacable with the flight powerup, and by doing a rocket jump, or bfg jump (the case of the battle suit) the cobat armor (yellow) is rocket jumping reachable, and the red armour is falling reachable. The BFG is inside one truck and in the other truck there's plenty of ammo (I do mean plenty.) There's a tower where you shoot at the ground and you  get the haste, the mega health, the teleporter and the medkit - too bad you can't carry the medkit and the teleporter at the same time - tough luck, kid."
)

,array(
 mktime(0, 0, 0, 3, 17, 2001)
,0
,'BkQ3Dm2 (Mansion - The beggining of the Frags)'
,'http://neofraggers.cplp.net/Neo_Fraggers_Index/Jogos/Quake_3_Arena/BkQ3Dm2.zip'
,NULL
,'http://neofraggers.cplp.net'
,array(70)
,764*1024
,'DM'
,'Q3'
,'NO'
,"It's a big house, sorta like bigbrother - nah, not at all. But you can't get out and there aren't any windows. I'm very fond of rocket jumps, so you have to rocket jump to reach the Haste and you have to rocket jump to reach the battle suit. The quad damage is inside the fridge (yes, it's a fridge) near one of the teleporters. there's also a shotgun on the table in the kitchen, and one in the garden. (pretty dark where it is). there's also the combat armour (yellow) in a corner near the curved column and the other bulbs what sould I call them??). In the games room there's major's statue, there's a rippped snooker table with the lightning gun, and the battle suit on the light. In front of the door that leads to the garden there's the rocketlanucher, if you go to the left (considering you came from the garden) there's the grenade launcher and if you follow on there's the kitchen. if you turn right on the rocketlauncer there are the column and the bulbs and after those tere's the game room. if you follow on on the rocketlauncher, there's another door, that has a jump pad inside. this jump pad leads to another jump pad which leads to  the railgun area. this area has a see thru grid, where you can walk, and you can shoot at the garden and at the other parts of the house. by going into the garden ON the superior platform, you find the personal teleporter laying ar the end of it and there's the body armour on the \"tree\" :) . then there are four holes , 2 on each side,  to snipe into the house. that's about all of it. and again, in the jump pad area, if you jump on the first pad and try to lean back a little, you lead to another jump pad, which leads to the BFG. this was at the beginning a bug for bots, but it's fixed now. bots sometimes grab the bf, but not much, or at least, not in the skill I was playing. It's a kewl map for team dm."
)

,array(
 mktime(0, 0, 0, 3, 9, 2001)
,0
,'de_celtic'
,'http://www.web-solarium.de/games/maps/de_celtic.zip'
,'http://members.aol.com/Vanx2001/images/celtic1b.jpg'
,'http://members.aol.com/Vanx2001'
,array(71)
,2.5*1024*1024
,'TD' #FIXME: Guess
,'CS'
,'NO'
,"This maps contains new texture, a new sky and new music. It is located in scotland. Counter-Terrorists have to prevent Terrorists from bombing the missiles that where prepared to launch from Earl Skibos Castle."
)

,array(
 mktime(0, 0, 0, 2, 21, 2001)
,0
,'Deserted Complex Version 1.74'
,'http://dl.fileplanet.com/dl/dl.asp?PlanetHalfLife/cc/decomp74.zip'
,NULL
,'http://www.planethalflife.com/cc'
,array(72, 73)
,450*1024 //APPROX
,'DM'
,'HL'
,'NO'
,"2-20 Player, Stalkyard style level. Small, yet very large. Simple, yet complex. This Level is an abandoned military building complex, which was abandoned some time ago, ventilation system for getting away quickly, All weapons exist in the level."
)

,array(
 mktime(0, 0, 0, 2, 21, 2001)
,0
,'Railectric version 1.42'
,'http://dl.fileplanet.com/dl/dl.asp?PlanetHalfLife/cc/railec42.zip'
,NULL
,'http://www.planethalflife.com/cc'
,array(72, 73)
,450*1024 //APPROX
,'DM'
,'HL'
,'NO'
,"2-20 Player, Stalkyard / Subtransit style. A railstation, with all weapons in the level, the train runs around the level in a square circle, and the rail can be electrified with the push of a button which reactivates once a minute. Expect some fascinating lighting here."
)

,array(
 mktime(0, 0, 0, 2, 21, 2001)
,0
,'Firing Frenzy version 1.14'
,'http://dl.fileplanet.com/dl/dl.asp?PlanetHalfLife/cc/xfrenz14.zip'
,NULL
,'http://www.planethalflife.com/cc'
,array(72, 73)
,450*1024 //APPROX
,'DM'
,'HL'
,'NO'
,"2-14 Player, Stalkyard / Frenzy style level. At first this level was created as a 1-1 level, but with some enhancements, it was voted to be big enough for more players, plenty of tripmines, a tricky to get longjump, all should add for some interesting deathmatch abilities."
)

,array(
 mktime(0, 0, 0, 2, 4, 2001)
,0
,'S-S-S BPS'
,'http://members.xoom.com/rojigerm/downloads/q3a/rg3dm4/rg3dm4.pk3'
,'http://members.xoom.com/rojigerm/downloads/q3a/rg3dm4/rg3dm4.htm'
,'http://www.rojigerm.cjb.net/'
,array(67)
,1.15*1024*1024
,'DM'
,'Q3'
,'NO'
,"Continuing from where we left off, you manage to weak up from the dream/reality state, you had fallen into, to find yourself back to your spaceship which is attacked by aliens ! A duo_platform spaceship with nice atmospheric textures, impressive architecture, jump pads, teleports, all accompanied with a new music piece taken from Aphex Twin and made into a small loop. Btw, long time no see - army is really eating me up ! But anyway, I am glad I am still in one piece to create maps for everybody ! Check out also the new style of my website - I think it is cool : <a href=\"http://www.rojigerm.cjb.net\">www.rojigerm.cjb.net</a> About the map just check all about it here : <a href=\"http://members.xoom.com/rojigerm/downloads/q3a/rg3dm4/rg3dm4.htm\">http://members.xoom.com/rojigerm/downloads/q3a/rg3dm4/rg3dm4.htm</a>."
)

,array(
 mktime(0, 0, 0, 1, 14, 2001)
,0
,'Blindsided'
,'http://www.speakeasy.org/~jefman/blind.zip'
,NULL
,'http://www.speakeasy.org/~jefman'
,array(74)
,1.8*1024*1024
,'DM'
,'Q2'
,'NO'
,"A fun medium sized map for you and 6 - 12 of your favorite AI buddies. Also would be great for netplay if someone wants to give it a shot."
)

,array(
 mktime(0, 0, 0, 1, 14, 2001)
,0
,'Toxicity'
,'http://www.speakeasy.org/~jefman/Toxicity.zip'
,NULL
,'http://www.speakeasy.org/~jefman'
,array(74)
,670*1024
,'DM'
,'Q2'
,'NO'
,"A larger sized map using the Boss texture set. Quite suited for 8 - 12+ players. Give it try, you won't be disappointed :o)"
)

,array(
 mktime(0, 0, 0, 1, 14, 2001)
,0
,'Carnage Absolute'
,'http://home.earthlink.net/~jefman/carnage.zip'
,NULL
,'http://www.speakeasy.org/~jefman'
,array(74)
,2.5*1024*1024
,'DM'
,'Q2'
,'NO'
,"A highly detailed map that makes use of the Kingpin texture set. It plays great with a player load of 10 - 16. Not recommended for machines less than P233 and a Voodoo3 video card."
)

,array(
 mktime(0, 0, 0, 1, 14, 2001)
,0
,'Concrete'
,'http://geocities.com/espibrown/Concrete.zip' #FIXME: http://www.fileplanet.com/dl/dl.asp?planethalflife/complex/mp/concrete.zip
,'http://geocities.com/espibrown/concrete.jpg'
,'http://geocities.com/espibrown/'
,array(75)
,650*1024
,'DM'
,'HL'
,'NO'
,"My first (and so far the only) Half-Life map I've finished."
)

,array(
 mktime(0, 0, 0, 12, 27, 2000)
,0
,'Tatooine'
,'http://members.aol.com/Vanx2003/tatooine.zip'
,'http://members.aol.com/Vanx2001/images/tatoo1b.jpg'
,'http://members.aol.com/Vanx2001'
,array(71)
,NULL
,'TD' #FIXME: Guess...
,'HL'
,'TFC'
,"This tfc-map is inspired by the famed star wars planet. In Tatooine - Mos Eisley vs. Mos Espa you are a citizen in one of these desert spaceports and have to drop your team's flag into your shuttle. Unfortunately is has landed in the docking bay of the opposite team. The way between both bases is controlled from a tower both teams can use."
)

,array(
 0
,0
,'2Aren13'
,'http://dl.fileplanet.com/dl/dl.asp?PlanetHalfLife/cc/2aren13.zip'
,'http://www.planethalflife.com/cc'
,'http://www.planethalflife.com/cc'
,array(73)
,NULL
,'DM'
,'HL'
,'NO'
,"Slight optimisation."
)

,array(
 mktime(0, 0, 0, 9, 25, 2000)
,0
,"Fargin Bastage's Two Castles CTF"
,'http://www.quakelevels.com/quake3/fb_2castles.zip'
,'http://www.quakelevels.com/quake3/fb_2castles1.jpg'
,'http://www.quakelevels.com/'
,array(34)
,1427366
,'CTF'
,'Q3'
,'NO'
,"I took the castle from the other leel and simplified it by removing towers and some other stuff so the bots could use it and make use of the secrets. Then I cloned it to form an ideal CTF level. All weapons and player spawn positions are cloned as well, so no team has a starting advantage. The setting is two embassies facing each other across a swimming pool on a starless, black night. There are lots of torches for ample lighting. It is a CTF level that supports 16 players and bots, but it will also run in the other modes."
)

,array(
 mktime(0, 0, 0, 9, 25, 2000)
,0
,"Fargin Bastage's Castle at RockHenge"
,'http://www.quakelevels.com/quake3/fb_castle.zip'
,'http://www.quakelevels.com/quake3/fb_castle1.jpg'
,'http://www.quakelevels.com/'
,array(34)
,1944118
,'DM'
,'Q3'
,'NO'
,"Scale model of a Spanish castle utilizing some new textures to give it a bright environment. It features high walls, towers, estate manor, secret passages, and courtyard. Outside the castle is a large orchard with a stonehenge-type alter at one end and a barn-like building at the other. It is great for Deathmatch, FFA, Team Deathmatch. 16 Maximum players. Too large for bot support."
)

,array(
 0
,0
,'The High Underground 2'
,'http://www.geocities.com/gaidin_TS/high_underground2.zip'
,'http://www.geocities.com/gaidin_TS'
,'http://www.geocities.com/gaidin_TS'
,array(68)
,NULL
,'TD' #FIXME: Guess...
,'HL'
,'TFC'
,NULL
)

,array(
 0
,0
,'new map'
,'http://www.detpack.com'
,'http://www.detpack.com'
,'http://www.detpack.com'
,array(76)
,NULL
,'TD' #FIXME: Guess
,'CS'
,'NO'
,"It's a counter-strike defusion map for 4 up to 20 players. It's a bit of a mix between cs_italy and de_aztec. So if you like those two maps... you'll probably like thisone."
)

,array(
 mktime(0, 0, 0, 7, 19, 2000)
,0
,'a DM level for 1on1'
,'http://members.xoom.com/_XMCM/lauwsoft/c4dm9.zip'
,NULL
,'http://members.xoom.com/lauwsoft/index.html'
,array(77)
,NULL
,'DM'
,'Q2'
,'NO'
,NULL
)

,array(
 mktime(0, 0, 0, 7, 19, 2000)
,0
,'a CTF level for 3v3/4v4'
,'http://members.xoom.com/_XMCM/lauwsoft/q2ctf03.zip'
,NULL
,'http://members.xoom.com/lauwsoft/index.html'
,array(77)
,NULL
,'CTF'
,'Q2'
,'NO'
,NULL
)

,array(
 mktime(0, 0, 0, 7, 19, 2000)
,0
,'Arena of Dreams'
,'http://users3.50megs.com/sandman'
,'http://users3.50megs.com/sandman/pics/smdm1.jpg'
,'http://www.sandmansland.com'
,array(78)
,674*1024
,'DM'
,'Q3'
,'NO'
,"This is my first Quake 3 map ever, and it´s a small one best suited for 1on1 tourney. I don´t want you to have too high expectations on this map, since it is my first one."
)

,array(
 mktime(0, 0, 0, 7, 16, 2000)
,0
,'[M]->(D:R) State'
,'http://members.xoom.com/rojigerm/downloads/q3a/rg3dm3/rg3dm3.pk3'
,'http://members.xoom.com/rojigerm/downloads/q3a/rg3dm3/rg3dm3.htm'
,'http://www.rojigerm.cjb.net/'
,array(67)
,1.33*1024*1024
,'DM'
,'Q3'
,'NO'
,"A Q3A DM map inspired by a dream I had one night. New textures & music to get you into the dream feeling. An unusual map which like a dream, when experiencing a fight in everything seems normal and logic while when you see it from a distance it looks abnormal and insane ! Original connectivity with architecture to confuse and lighting to... guide you. Just check all about it (with story) here: <a href=\"http://members.xoom.com/rojigerm/downloads/q3a/rg3dm3/rg3dm3.htm\">http://members.xoom.com/rojigerm/downloads/q3a/rg3dm3/rg3dm3.htm</a>."
)

,array(
 0
,0
,'de_Mayhem'
,'http://www.crosswinds.net/~hypn0tech'
,'http://www.crosswinds.net/~hypn0tech'
,'http://www.crosswinds.net/~hypn0tech'
,array(76)
,NULL
,'TD' #FIXME: Guess...
,'CS'
,'NO'
,"I just finished another map. It's a rebuild of my de_office map. It's much bigger now and there's a better balance between the teams."
)

,array(
 0
,0
,"Life's too Short"
,'http://www.speakeasy.org/~jefman/life.zip'
,NULL
,'http://www.speakeasy.org/~jefman'
,array(74)
,406*1024
,'DM'
,'Q2'
,'NO'
,"Quake 2 DM map designed for 1-on-1 duels or 3-8 player FFA. More players than that and the map lives up to it's name..."
)

,array(
 0
,0
,'Rail Arena'
,'http://users.breathemail.net/clanrabiduk/files/railarena.zip'
,'http://users.breathemail.net/clanrabiduk/maps/railarena/railarena.jpg'
,'http://users.breathemail.net/clanrabiduk'
,array(79)
,374*1024
,'DM'
,'Q2'
,'NO'
,"A relatively simple arena I created in about six hours for my buddy Giblet ('cos he begged and stuff!) with four annexed rooms containing the spawn points and RailGuns. The doors to the rooms are one way so there's no backing out once you're in! There is a Q3 style bounce pad on a mound in the centre of the arena with four pistons surrounding it (good fun to land on!). I suggest you turn 'Weapon Stay' and 'Unlimited Ammo' to \"ON\" and set 'Falling Damage' to \"OFF\". Have fun!"
)

,array(
 0
,0
,'The right hell'
,'http://www.geocities.com/w_1_us/level44.zip'
,'http://www.geocities.com/w_1_us/level44.jpg'
,'http://www.geocities.com/w_1_us'
,array(80)
,315*1024
,'DM'
,'Q3'
,'NO'
,"Sorry about the sky it is a good level 3 -6 players"
)

,array(
 0
,0
,'BORG-SHIP'
,'http://www.crosswinds.net/hypn0tech'
,'http://www.crosswinds.net/hypn0tech'
,'http://www.crosswinds.net/hypn0tech'
,array(76)
,NULL
,'CTF'
,'HL'
,'TFC'
,"I made this map at [BORG]virus request for clan [BORG], [BORG]punisher's clan. It's a tfc - capture the flag map."
)

,array(
 0
,0
,'Mumindalen'
,'http://www.geocities.com/w_1_us/Mumin.zip'
,NULL
,'http://www.geocities.com/w_1_us'
,array(80)
,314*1024
,'DM'
,'Q3'
,'NO'
,"My first map with bots and index picture"
)

,array(
 0
,0
,'Arena17R'
,'http://dl.fileplanet.com/dl/dl.asp?planethalflife/cc/arena17r.zip'
,'http://www.planethalflife.com/cc'
,'http://www.planethalflife.com/cc'
,array(73)
,NULL
,'DM'
,'HL'
,'NO'
,"Small Arena type level build with the Xen textures. Suggested 2-6 players. (8 or more for complete chaos)"
)

,array(
 0
,0
,'Q1BASA2'
,'http://www.quake.cz/sp/files/Q1BASA2.zip'
,NULL
,'http://www.quake.cz/sp'
,array(81)
,287.6*1024
,'DM'
,'Q1'
,'NO'
,"A very small exterier map for a good FFA. Not very much small details just map. The reason is the higher FPS and lower lagging. Caused some troubles with this gray gaps but this is fixed. Created in QuArK 5. What else? Just let me know."
)

,array(
 0
,0
,'DoWnUpS QuAkE LeVeL'
,'http://www.geocities.com/w_1_us/quake3.zip'
,NULL
,'http://www.geocities.com/w_1_us'
,array(80)
,203*1024
,'DM'
,'Q3'
,'NO'
,"( The best \" players map in the world , Say Bill Gate  )"
)

,array(
 0
,0
,'XenDM'
,'http://www.student.citg.tudelft.nl/ct375215/XenDM.zip'
,'http://www.student.citg.tudelft.nl/ct375215/xendm41x1.jpg'
,NULL
,array(51)
,674*1024
,'DM'
,'HL'
,'NO'
,"It's a medium sized, fully Xen style map build with speed in mind, so should be well suited for internet play."
)

,array(
 0
,0
,'QualterGeist'
,'http://members.xoom.com/rojigerm/downloads/q3a/rg3dm2/rg3dm2.pk3'
,'http://members.xoom.com/rojigerm/downloads/q3a/rg3dm2/rg3dm2.htm'
,'http://www.rojigerm.cjb.net/'
,array(67)
,920*1024
,'DM'
,'Q3'
,'NO'
,"A DM map that promises spooky atmosphere, wild hair-raising chases, unexpected attacks, fast paced action and a lot more. Has a straight forward, nicely textured layout which features wide & tall areas to frag in, jump-pad sequences, GOOD connectivity between rooms, good item placement, tricks, portholes etc.. Just check all about it here: <a href=\"http://members.xoom.com/rojigerm/downloads/q3a/rg3dm2/rg3dm2.htm\">http://members.xoom.com/rojigerm/downloads/q3a/rg3dm2/rg3dm2.htm</a>."
)

,array(
 0
,0
,'The Leech Pits'
,'http://www.fileleech.com/?file=6358'
,'http://tranquil.stomped.com/levels/halflife/leechpit/images/shot_04.gif'
,'http://tranquil.stomped.com/'
,array(82)
,368*1024
,'SP DM'
,'HL'
,'NO'
,"Well, here's a little deathmatch sample area from my upcoming \"The Erroneous Decision\" Single-Player/Deathmatch mini-conversion!"
)

,array(
 0
,0
,'The Lost BSP #22-The Strogg Wars 2056'
,'http://www.fileplanet.com/index.asp?file=43280'
,'http://tranquil.stomped.com/levels/quake2/tlb_22/images/shot_03.gif'
,'http://tranquil.stomped.com/'
,array(82)
,496*1024
,'SP DM'
,'Q2'
,'NO'
,"Medium to large level with tons of tricks and traps for ALL players."
)

,array(
 0
,0
,'Hexen 2 PoP SP Map'
,'http://www.coyoterock.net/Inigo/files.htm' #http://users.ez-net.com/~inigo/files.htm
,NULL
,NULL
,array(83)
,NULL
,'SP'
,'HX2'
,'NO'
,"A blurb: Medium-small SP Hexen2 PoP map that is fast with lotsa werecats. Hope this suffices"
)

,array(
 0
,0
,'The Pit Of Pain'
,'http://members.xoom.com/clanofhades/files/dmpit1.zip'
,'http://dmpit1.sadistic.de'
,'http://www.sadistic.de'
,array(84)
,1.15*1024*1024
,'DM'
,'Q3'
,'NO'
,"I created a new QuArK-made-Death-Match-Map for Quake 3 Arena. It's called 'The Pit Of Pain' and is suggested for 4 players, although there are 6 Spawn-Positions ;o)<br>it took me about 1 week to build it, cuz i'm still a rookie in things like map-building etc (and i think, you can see that), but i've been supported by RoGeR, who told me to be more careful in building :o)"
)

,array(
 0
,0
,'The LAVA PIT (lavapit.bsp)'
,NULL
,NULL
,NULL
,array(85)
,139*1024
,'DM'
,'Q1'
,'NO'
,"A \"HOT\" deathmatch level containing raised platforms over a large and deep pool of lava... CAUTION: Slipping off a platform may be hazardous to your health!<br>My Quake 1 map is not on the net yet so it doesn't have any location URL's.. If at your request... I can attach my screen shots and/or map to an e-mail......."
)

,array(
 0
,0
,"Let´s rock and rail"
,'http://members.aol.com/Vanx2002/randr.zip'
,'http://members.aol.com/laky0815/randrb1.jpg'
,'http://members.aol.com/laky0815/index.html'
,array(71)
,1.3*1024*1024
,'DM'
,'Q2'
,'NO'
,"Let`s Rock and Rail - pick up a weappon and fight this Q2-arena with jump-pads and he,he some curved walls. The map uses the sun-feature. No more ugly orange outside areas - a real sun is shining from the bright blue (new custom) sky. The map runs smooth (low r_speed) and is designed for from 1-on-1 up to 5-on-5 teamplay. So, what are you waiting for?"
)

,array(
 0
,0
,'de_canyon'
,'http://www.crosswinds.net/~hypn0tech/maps.htm'
,NULL
,'http://www.crosswinds.net/~hypn0tech/'
,array(76)
,NULL
,'TD' #FIXME: Guess
,'CS'
,'NO'
,"Outdoor desert map for 2-8 players."
)

,array(
 0
,0
,'de_office'
,'http://www.crosswinds.net/~hypn0tech/maps.htm'
,NULL
,'http://www.crosswinds.net/~hypn0tech/'
,array(76)
,NULL
,'TD' #FIXME: Guess
,'CS'
,'NO'
,"Like the title says: bomb the building!!!"
)

,array(
 0
,0
,'C.H. Arena'
,'http://members.xoom.com/rojigerm/downloads/q3a/rg3dm1/rg3dm1.pk3'
,'http://members.xoom.com/rojigerm/downloads/q3a/rg3dm1/rg3dm1.htm'
,'http://www.rojigerm.cjb.net/'
,array(67)
,986*1024
,'DM'
,'Q3'
,'NO'
,"My first Q3A map created with QuArK 6b1. Nice architecture with nicely fitted textures. Clever connectivity between rooms. Has two teleports, pad jumping sequences... ect.. words fail me. Just check all about it here: <a href=\"http://members.xoom.com/rojigerm/downloads/q3a/rg3dm1/rg3dm1.htm\">http://members.xoom.com/rojigerm/downloads/q3a/rg3dm1/rg3dm1.htm</a>. I let the screenshots do the talking."
)

,array(
 0
,0
,'The Three Fates: Clothos, Lachesis and Atropos'
,'http://www.coyoterock.net/zip/Three%20Fates.zip' //http://members.xoom.com/Ahumado/zip/3Fates.zip
,NULL
,'http://www.coyoterock.net/Inigo/files.htm' //http://members.nbci.com/Ahumado/ //http://members.xoom.com/Ahumado/
,array(83)
,NULL
,'SP'
,'HR2'
,'NO'
,"You were just hangin' at the pub when the barkeep, Chum, axed you to get him some of that special port. As you were pickin the bottle off the rack......A curious Ogle opened the wrong box after reading the tale of Pandoria, your ex-squeeze. Anyhow, you must go do battle yet again which is gonna be a bitch seeing as how you are overweight from years of the cushy life. But you hitch your belt and set off to fix the world when all ya wanted was another glass of the port."
)

,array(
 0
,0
,'Efil Dungeon'
,'http://members.xoom.com/rojigerm/downloads/quakeII/rg2dm8/rg2dm8.zip'
,'http://members.xoom.com/rojigerm/downloads/quakeII/rg2dm8/rg2dm8.htm'
,'http://www.rojigerm.cjb.net/'
,array(67)
,486*1024
,'DM'
,'Q2'
,'NO'
,"A DM map which is to be remade for Q3A. Round surfaces, excellent architecture and atmosphere. Original connectivity between wide+tall rooms. In other words, happy fragging. You will need my RoGeR_A Add-On to run this map if you don't already have it (412 KB). Read more about it at: <a href=\"http://www.rojigerm.cjb.net/downloads/quakeII/quakeII.htm\">http://www.rojigerm.cjb.net/downloads/quakeII/quakeII.htm</a>"
)

,array(
 0
,0
,'The Storageyard'
,'http://users.breathemail.net/clanrabiduk/files/storageyard.zip'
,'http://users.breathemail.net/clanrabiduk/maps/syard/syard.jpg'
,'http://users.breathemail.net/clanrabiduk'
,array(79)
,227*1024
,'DM'
,'Q2'
,'NO'
,"'The Storageyard' is a map based around a warehouse of some sort. It boasts three dual level storage rooms, various corridors, a canyon, collapsed tunnel and fortlike building. Weapons-wise I left out some of the more powerful weaponry such as the Hyperblaster and Chaingun, but the level is very biased towards the rocket launcher :-). The BFG is in there but you'll have to go find it :-). Just finished a major bugfixing session and uploaded a new version to the website."
)

,array(
 0
,0
,"BadMonk's DM Pack"
,'http://www.fortunecity.com/tatooine/dredd/724/badmonkdm.zip'
,'http://members.dencity.com/BadMonk/images/badmonkdm_big.jpg'
,'http://www.badmonk.8m.com'
,array(87)
,1.58*1024*1024
,'DM'
,'KP'
,'?'
,"This is a Map pak containing all of my DM maps. The maps have been updated and I have fixed some bugs and added some things to them. They are allot better now than before. I have changed the filenames so that you can see what version of the maps you have."
)

,array(
 0
,0
,'Slaughter'
,'http://home.soneraplaza.nl/qn/prive/pg.mariany/PGM.html'
,NULL
,'http://home.soneraplaza.nl/qn/prive/pg.mariany/PGM.html'
,array(88)
,215*1024
,'DM'
,'HL'
,'NO'
,"My first map with all weapons and lots of suprises... Second map is coming up!!!"
)

,array(
 0
,0
,'W.A.L'
,'http://www.geocities.com/w_1_us/wal.zip'
,NULL
,'http://www.geocities.com/w_1_us'
,array(80)
,184*1024
,'DM'
,'Q2'
,'NO'
,NULL
)

,array(
 0
,0
,'HallsOfOtto'
,'http://www.hb.lu.se/~jimb/q2/maps/megadm02.zip'
,NULL
,'http://www.hb.lu.se/~jimb/'
,array(89)
,653*1024*1024
,'DM'
,'Q2'
,'NO'
,"Rather large DM-map with a total of 13 spawnplats. Playtesting has shown that the first impression usually is that it is a _very_ large map, but this seems to change after a few minutes of exploration. Feedback would be appreciated."
)

,array(
 0
,0
,'Naamloos'
,'http://kkc.gamepoint.net/q1naamloos.zip'
,NULL
,'http://kkc.gamepoint.net'
,array(90)
,NULL
,'DM'
,'Q1'
,'NO'
,"A medium sized (mainly outdoor) arena. Fast Gameplay, but bad architecture."
)

,array(
 0
,0
,'Q1 ArenA'
,'http://kkc.gamepoint.net/q1arena.zip'
,NULL
,'http://kkc.gamepoint.net'
,array(90)
,NULL
,'DM'
,'Q1'
,'NO'
,"A small ArenA suitable for 1 on 1 deathmatch."
)

,array(
 0
,0
,'Deathmatch Zone'
,'http://kkc.gamepoint.net/hldzone.zip'
,'http://kkc.gamepoint.net/scrdzone3.jpg'
,'http://kkc.gamepoint.net'
,array(90)
,NULL
,'DM'
,'HL'
,'NO'
,"A small map for 2-3 players."
)

,array(
 0
,0
,'Hondelul'
,'http://kkc.gamepoint.net/cs_hondelul.zip'
,'http://kkc.gamepoint.net/scrhondelul2.jpg'
,'http://kkc.gamepoint.net'
,array(90)
,NULL
,'TD' #FIXME: Guess
,'CS'
,'NO'
,"A hostage rescuing map for 2-4 players."
)

,array(
 0
,0
,'Hondelul X-Tra Large'
,'http://kkc.gamepoint.net/op4_hondelulxl.zip'
,'http://kkc.gamepoint.net/scrwarehouse2.jpg'
,'http://kkc.gamepoint.net'
,array(90)
,NULL
,'DM' #FIXME: Guess...
,'HL'
,'OP4'
,"A warehouse type of map. Suitable for 2-6 players."
)

,array(
 0
,0
,'Camp Land'
,'http://kkc.gamepoint.net/hlcampland.zip'
,'http://kkc.gamepoint.net/scrcampland3.jpg'
,'http://kkc.gamepoint.net'
,array(90)
,NULL
,'DM'
,'HL'
,'NO'
,"A medium sized map 2-5 players. With lot's of camping places."
)

,array(
 0
,0
,'Combat Frag Simulator 1.0'
,'http://kkc.gamepoint.net/hlcombatfs.zip'
,'http://kkc.gamepoint.net/scrcombatfs2.jpg'
,'http://kkc.gamepoint.net'
,array(90)
,NULL
,'DM'
,'HL'
,'NO'
,"Designed for one on one combat. That means 2 players."
)

,array(
 0
,0
,'Hurt Me Plenty'
,'http://kkc.gamepoint.net/hlhurtme.zip'
,'http://kkc.gamepoint.net/scrhurtme2.jpg'
,'http://kkc.gamepoint.net'
,array(90)
,NULL
,'DM'
,'HL'
,'NO'
,"Outdoor/Indoor map for 2-5 players."
)

,array(
 0
,0
,'GLCDM1Q2'
,'http://www.ironworld.freeserve.co.uk\glc\glcdm1q2.htm'
,'http://www.ironworld.freeserve.co.uk/glc/screen_shot_dm1q2.htm'
,'http://www.ironworld.freeserve.co.uk/glc/'
,array(91)
,1078*1024
,'DM'
,'Q2'
,'NO'
,"Medium-large map for six to ten players, Lots of interconnected hallways on three levels with some wide open areas thrown in for good measure or rail fights."
)

,array(
 0
,0
,'GLCDM2Q2'
,'http://www.ironworld.freeserve.co.uk/glc/glcdm2q2.htm'
,'http://www.ironworld.freeserve.co.uk/glc/screen_shot_dm2q2.htm'
,'http://www.ironworld.freeserve.co.uk/glc/'
,array(91)
,1.26*1024*1024
,'DM'
,'Q2'
,'NO'
,"This is a small map for two to four players that represents a set of \"floating\" platforms and includes a custom environment map.<br>This is a quote from one of the testers.<br>\"You're mad. That map is the most frustrating, dangerous and difficult-to-survive map I have ever seen. You have excelled yourself. :-)\""
)

,array(
 0
,0
,'GLCDM2HL'
,'http://www.ironworld.freeserve.co.uk/glc/glcdm2hl.htm'
,'http://www.ironworld.freeserve.co.uk/glc/screen_shot_dm2hl.htm'
,'http://www.ironworld.freeserve.co.uk/glc/'
,array(91)
,1.38*1024*1024
,'DM'
,'HL'
,'NO'
,"This is a small map for two to four players that represents a set of \"floating\" platforms and includes a custom environment map."
)

,array(
 0
,0
,'Imminent Demise - Your 2nd Command'
,'http://members.aol.com/Vanx2001/demise2.zip'
,'http://members.aol.com/Vanx2001/demise21.jpg'
,'http://members.aol.com/laky0815/index.html'
,array(71)
,550*1024
,'DM COOP'
,'Q2'
,'NO'
,"You are in an orbit-station. This map is designed for playing 1-on-1 duels, and runs even fine with 4-on-4 team play. The surrounding: Finest brush-work and light-settings - and a cool quad-trap."
)

,array(
 0
,0
,"BadMonk's Place 3"
,'http://www.fortunecity.se/arkaden/tilten/108/bmp3.zip'
,NULL
,'http://www.badmonk.8m.com'
,array(87)
,NULL
,'SP DM'
,'KP'
,'NO'
,"A medium sized map with nice lightning. It is both a single player and deathmatch map."
)

,array(
 0
,0
,'Intricate Hell'
,'http://hometown.aol.com/blaquekidd/myhompage/rotdm3.zip'
,NULL
,'http://hometown.aol.com/blaquekidd/myhomepage/index.html'
,array(92)
,NULL
,'DM'
,'Q2'
,'NO'
,"My best looking and running of the four that i have made.  It is medium size map for like 4-6 peeps or something, maybe more.  It has one hding spot and a few things you'll never see in any quake2 map ever!"
)

,array(
 0
,0
,'Claustofibicus Quadratus'
,'http://www.xs4all.nl/~thijspc/maps/el2dm8.zip'
,'http://www.xs4all.nl/~thijspc/images/el2dm8_1.jpg'
,'http://www.xs4all.nl/~thijspc'
,array(93)
,332*1024
,'DM'
,'Q2'
,'NO'
,"Small dm map ment for 1 on 1, but also very playeble for small FFA's, gameplay is vertical and chaotic, just the way I like it."
)

,array(
 0
,0
,'Anther Equ'
,'http://www.rojigerm.cjb.net/downloadFiles/quakeII/rg2dm7.zip'
,'http://www.rojigerm.cjb.net/pages/downloads/quakeII/quakeII_scrnshts_rg2dm7.htm'
,'http://www.rojigerm.cjb.net'
,array(67)
,376*1024
,'DM'
,'Q2'
,'NO'
,"A very good and enhanced remake of Q3A's Arena Gate. (new realistic textures of wood, marble, metal, stone, excellent architecture, wide areas, continuous action, atmophere and new stuff that have nothing to do with Q2 - that is because it is a Q3 remake. A level mostly for 1 vs 1 action. You will need my RoGeR_A Add-On to run this map (412 KB). Read more about it at my Web Site: <a href=\"http://www.rojigerm.cjb.net\">http://www.rojigerm.cjb.net</a>.)"
)

,array(
 0
,0
,'Training arena'
,'http://members.xoom.com/kane182/arena2.zip'
,NULL
,'http://members.xoom.com/kane182'
,array(94)
,NULL
,'DM'
,'Q2'
,'NO'
,"A re-release of my Training Arena map, new changes are colored lights and a new enviroment map."
)

,array(
 0
,0
,"el2dm7 \"Adrenalized Insanaty!\""
,NULL
,'http://www.xs4all.nl/~thijspc'
,'http://www.xs4all.nl/~thijspc'
,array(93)
,420*1024
,'DM'
,'Q2'
,'NO'
,"My first map with a LITTLE \"retinal, headshot ztn\" feeling in it."
)

,array(
 0
,0
,'Nifra Giht'
,'http://www.rojigerm.cjb.net/pages/downloads/quakeII.htm'
,'http://www.rojigerm.cjb.net/pages/downloads/quakeII_scrnshts_rg2dm6.htm'
,'http://www.rojigerm.cjb.net/'
,array(67)
,404*1024
,'DM'
,'Q2'
,'NO'
,"Care for some... night fragging ? (new environment - night sky (taken by one of \"Battle[BITCH]\"'s maps), new realistic textures of wood, stone, ground, realistic architecture, interesting atmophere & can be very good for some 1 vs 1 action. You will need my RoGeR_A & RoGeR_B Add-On's to run this map (412 + 179 KB). Read more about it at my Web Site: <a href=\"http://www.rojigerm.cjb.net\">http://www.rojigerm.cjb.net</a>. Also, check out some funny stuff at the insta-poll)"
)

,array(
 0
,0
,'Building'
,NULL
,NULL
,'http://www.tht.net/~bigfoot'
,array(95)
,500*1024 //APPROX
,'DM'
,'Q1'
,'?'
,"A kewl map where people fight in an office building"
)

,array(
 0
,0
,'Fall'
,NULL
,NULL
,'http://www.tht.net/~bigfoot'
,array(95)
,500*1024 //APPROX
,'DM'
,'Q1'
,'NO'
,"A kewl map where people fight in a virtical hall"
)

,array(
 0
,0
,'tfmap'
,NULL
,NULL
,'http://www.tht.net/~bigfoot'
,array(95)
,500*1024 //APPROX
,'TD' //FIXME: Guess...
,'Q1'
,'TFC'
,"A kewl Team Fortress map (unfinished)"
)

,array(
 0
,0
,'tfmap4'
,NULL
,NULL
,'http://www.tht.net/~bigfoot'
,array(95)
,500*1024 //APPROX
,'TD' //FIXME: Guess...
,'Q1'
,'TFC'
,"A samll map mainly used with bots"
)

,array(
 0
,0
,'1st'
,NULL
,NULL
,'http://www.tht.net/~bigfoot'
,array(95)
,500*1024 //APPROX
,'SP' //FIXME: Guess...
,'Q1'
,'AIR'
,"A big map with a floating city which you must destroy"
)

,array(
 0
,0
,'SatComm'
,'http://anarchy.counter-strike.net/Maps/De_Satcomm.zip'
,'http://anarchy.counter-strike.net/Feature/SatcommPics.html'
,'http://anarchy.counter-strike.net/'
,array(96)
,2.8*1024*1024
,'TD' //FIXME: Guess...
,'CS'
,'NO'
,"A defuse map for <a href=\"http://www.counter-strike.net\">Counter-Strike</a>. Terrorists have located a government Early Warning satellite control center, and plan to blow it up... meanwhile, a group of SEALs and German GSG-9 operatives are flown in on an Osprey to stop them - if they can!"
)

,array(
 0
,0
,'Unearthed'
,'http://www.captured.com/dteam/'
,'http://www.captured.com/dteam/'
,'http://www.captured.com/dteam/'
,array(97)
,446*1024
,'DM'
,'Q2'
,'NO'
,"Unearthed is an average sized map with a lot of wide open spaces. It incorporates wind tunnels and jump pads which make for a very fast paced game. It has an above ground area which is cast in a blue light of a night sky and a large underground area that contains no shortage of lava. This map tends to favour those who like the railgun."
)

,array(
 0
,0
,'119snip'
,'http://www.nucleus.com/~wamphyri/119snip.zip'
,'http://www.nucleus.com/~wamphyri/119snipshot.jpg'
,'http://www.nucleus.com/~wamphyri/'
,array(86)
,328*1024
,'DM' #FIXME: Guess...
,'HL'
,'TFC'
,"This is a sniper only map for Team Fortress Classic for about 10-15 players max."
)

,array(
 0
,0
,'Death is not The End'
,'http://user.tninet.se/~jtv108p/q2etctf3.zip'
,'http://user.tninet.se/~jtv108p/q2etctf3_21.jpg'
,'http://user.tninet.se/~jtv108p/index.html'
,array(69)
,2.02*1024*1024
,'CTF'
,'Q2'
,'NO'
,"\"Death is not The End\" you can allways respawn. ha ha. Hmm, Yes another map. The most complete map I've made so far. CTF. Throw in like 20 bots, 10 on each side, and you of course. Get hold of some weapons and your favorite \"tech\" and try to get the flag. It's big only the *.bsp is 2.86 mb And only two texture f**k ups. Probably you won't see them, but I do. Let the textures rule I say."
)

,array(
 0
,0
,'Infested Caverns Special Edition'
,'http://www.planetquake.com/dl/dl.asp?gmd/gloomse.zip'
,NULL
,NULL
,array(98)
,1.3*1024*1024
,'DM' #FIXME: Guess...
,'Q2'
,'GLM'
,"An underwater mining base connected to underwater caves. Has some nice looking areas. For the mod <a rel=\"noopener\" target=\"_blank\" href=\"http://www.planetquake.com/rxn/gloom/\">GLOOM</a> by Team Reaction."
)

,array(
 0
,0
,"Devil's Inferno"
,'http://www.planetquake.com/dl/dl.asp?gmd/devinf-a.zip'
,NULL
,NULL
,array(98)
,349*1024
,'DM' #FIXME: Guess...
,'Q2'
,'GLM'
,"A room. May not seem like much, but you are the size of bug. Wonder across my computer desk, crawl inside the television, check out what I have on my table. :) For the mod <a rel=\"noopener\" target=\"_blank\" href=\"http://www.planetquake.com/rxn/gloom/\">GLOOM</a> by Team Reaction."
)

,array(
 0
,0
,'Evil Playground'
,'http://user.tninet.se/~jtv108p/q2etdm6.zip'
,'http://user.tninet.se/~jtv108p/q2etdm6_31.jpg'
,'http://user.tninet.se/~jtv108p/index.html'
,array(69)
,1.39*1024*1024
,'DM TD'
,'Q2'
,'NO'
,"It's not a playground, but it's kind of evil.I wanted to do a map with some hight, and there it was! The name \"Evil Playground\" Front Line Assembly, I hope they don't mind."
)

,array(
 0
,0
,'The Mind of a Killer'
,'http://www.bitchclan.org/mapmurder.html'
,'http://www.bitchclan.org/mapmurder.html'
,'http://www.bitchclan.org/'
,array(99)
,784*1024 //exe format
,'DM'
,'Q2'
,'NO'
,NULL
)

,array(
 0
,0
,'20,000 Leagues'
,'http://www.bitchclan.org/mapatlantis.html'
,'http://www.bitchclan.org/mapatlantis.html'
,'http://www.bitchclan.org/'
,array(99)
,1.21*1024*1024 //exe format
,'DM'
,'Q2'
,'NO'
,NULL
)

,array(
 0
,0
,'[BITCH]SkyArena'
,'http://www.bitchclan.org/mapskyarena.html'
,'http://www.bitchclan.org/mapskyarena.html'
,'http://www.bitchclan.org/'
,array(99)
,1.56*1024*1024 //exe format
,'DM'
,'Q2'
,'NO'
,NULL
)

,array(
 0
,0
,'[BITCH]Bayou'
,'http://www.bitchclan.org/mapbayou.html'
,'http://www.bitchclan.org/mapbayou.html'
,'http://www.bitchclan.org/'
,array(99)
,0.97*1024 //exe format
,'DM'
,'Q2'
,'NO'
,NULL
)

,array(
 0
,0
,"SunTzu's Club House"
,'http://www.bitchclan.org/mapclubhouse.html'
,'http://www.bitchclan.org/mapclubhouse.html'
,'http://www.bitchclan.org/'
,array(99)
,561*1024 //exe format
,'DM'
,'Q2'
,'NO'
,NULL
)

,array(
 0
,0
,'Training arena'
,'http://members.xoom.com/kane182/arena.bsp'
,NULL
,'http://members.xoom.com/kane182'
,array(94)
,NULL
,'DM'
,'Q2'
,'NO'
,"A very small arena specificly made for 2 players training on there rocket launcher and rail gun skills."
)

,array(
 0
,0
,'Enthalpy'
,'ftp://ftp.cdrom.com/pub/idgames2/quake2/levels/deathmatch/a-c/cm3.zip'
,NULL
,NULL
,array(100)
,NULL
,'DM'
,'Q2'
,'NO'
,"Tight deathmatch arena for 2-6 players, best with three upwards. First completed \"decent*\" map by me. *(depends whethre you think its decent or not, but its the only playable map I have made)"
)

,array(
 0
,0
,'The Plaza'
,'http://www.rojigerm.cjb.net/pages/downloads/quakeII.htm'
,'http://members.xoom.com/rojigerm/pages/downloads/quakeII_scrnshts_rg2dm4.htm'
,'http://www.rojigerm.cjb.net/'
,array(67)
,433*1024
,'DM'
,'Q2'
,'NO'
,"An oldy but still a goody. (I have moved my site to XOOM)"
)

,array(
 0
,0
,'Deplat Ache'
,'http://www.rojigerm.cjb.net/pages/downloads/quakeII.htm'
,'http://www.rojigerm.cjb.net/pages/downloads/quakeII_scrnshts_rg2dm5.htm'
,'http://www.rojigerm.cjb.net/'
,array(67)
,419*1024
,'DM'
,'Q2'
,'NO'
,"Wonder about in a medieval scenery and \"modernize\" it, using your hi-tech weapons to frag from dust till dawn. No doubt, this is a place you won't forget. (Outstanding architecture, new realistic textures and sounds. You will need my RoGeR_A Add-On to run this map (412 KB). Read more about it at my Web Site : <a href=\"http://www.rojigerm.cjb.net\">http://www.rojigerm.cjb.net</a>. Also, vote at the InstaPoll pls)"
)

,array(
 0
,0
,'In the House of Pain'
,'http://www.geocities.com/TimesSquare/Cave/9029/Files/HofP.zip'
,'http://www.geocities.com/TimesSquare/Cave/9029/downloads.htm'
,'http://www.geocities.com/TimesSquare/Cave/9029'
,array(101)
,1.06*1024*1024
,'DM'
,'KP'
,'NO'
,"A fast paced map, with a large warehouse, Bar & Lady of the night, all linked via hallways and rooms. Also a nice roof area for sniping and grenade fun.  A great addition to your LAN or Internet server."
)

,array(
 0
,0
,'King Of My Castle'
,'https://www.quaddicted.com/files/idgames2/quake2/levels/deathmatch/a-c/bwdm.zip' //ftp://ftp.cdrom.com/.1/idgames2/quake2/levels/deathmatch/a-c/bwdm.zip
,NULL
,NULL
,array(102)
,443*1024
,'DM'
,'Q2'
,'NO'
,"A simple deathmatch map for 2 to 5 players."
)

,array(
 0
,0
,'Big Kitchen'
,'http://www.geocities.com/~mikereeves/quake2/bigkitchen.zip'
,'http://www.geocities.com/~mikereeves/quake2/bigkitchen.jpg'
,'http://www.geocities.com/~mikereeves'
,array(103)
,327*1024
,'DM'
,'Q2'
,'NO'
,"Land of the Giants? 100% of household frag-cidents happen in the kitchen... Fight on a kitchen worktop, complete with sink, cooker, kettle, and other household items. The difference is, they are bigger than you are. Oh yeah - and don't fall off the edge."
)

,array(
 0
,0
,'Tech-World'
,'http://www.geocities.com/SiliconValley/Bridge/2408/DownloadFiles/rg2dm1.zip'
,'http://www.geocities.com/SiliconValley/Bridge/2408/downloads.htm'
,'http://www.geocities.com/SiliconValley/Bridge/2408/'
,array(67)
,581*1024
,'DM'
,'Q2'
,'NO'
,"Excellent architecture with new complex textures, nice colored lighting & great connectivity between rooms +PluS+ two electrical wagons to move from one side of the level to another!"
)

,array(
 0
,0
,'The Axis Arena'
,'http://user.tninet.se/~jtv108p/q2etdm5.zip'
,'http://user.tninet.se/~jtv108p/q2etdm5_11.jpg'
,'http://user.tninet.se/~jtv108p/index.html'
,array(69)
,418*1024
,'DM TD'
,'Q2'
,'NO'
,"The Axis Arena, don't be offended or think that im a freakin' natzi, IM NOT!! But I've got this idea from Martin \"Raven\" Anderson, His map didn't work so I remade it, too damned fun playing so I couldn't help it. A big place, you can run but you cannot hide!!Made for 10 players"
)

,array(
 0
,0
,'The Arena1'
,'ftp://ftp.cdrom.com/pub/idgames2/incoming/harena1.zip'
,NULL
,NULL
,array(104)
,NULL
,'DM'
,'Q1'
,'NO'
,"Designed for 1 to 4 players (maybe a few more - gets a little messy though) Note - r_speeds get as high as 690 in some areas, although this does not affect the  playability that much. Any comments, positive or negative, are welcome! ... well, at least positive ones ;)"
)

,array(
 0
,0
,'The Mine Facility'
,'http://user.tninet.se/~jtv108p/q2etdm4.zip'
,'http://user.tninet.se/~jtv108p/q2etdm4_11.jpg'
,'http://user.tninet.se/~jtv108p/index.html'
,array(69)
,1.98*1024*1024
,'DM TD'
,'Q2'
,'NO'
,"The Mine Facility, battle it out in this Mine facility, try to find the secrets and burn your enemy!. A big map with loads of weapons. Made for 12 players"
)

,array(
 0
,0
,'Cross Fire 2.0'
,'http://www.merfax.com/quake/xfire2.zip'
,'http://www.merfax.com/quake/xfire3.jpg'
,'http://www.merfax.com/quake/default.htm'
,array(105)
,4.4*1024*1024
,'SP DM'
,'Q2'
,'NO'
,"Starts with a three map unit on Earth where you fight off an invasion, then a second three map unit where you invade the mother ship. See the web site for screen shots."
)

,array(
 0
,0
,'Quake Mountain'
,'http://publish.hometown.aol.com/wgnwsr/myhomepage/qmountr.zip'
,NULL
,'http://hometown.aol.com/blaquekidd/myhomepage/index.html'
,array(92)
,123*1024
,'CTF'
,'Q2'
,'NO'
,"My third map. I wanna to make it different so I made a CTF map! Its nice, but its on fullbright because the ARGHRad program takes to damn long to do lightin on a Pentium 200MHz! Its a Meduim Sized map, Good for 4 on 4 i think."
)

,array(
 0
,0
,'Cylindrical Death'
,'http://user.tninet.se/~jtv108p/q2etctf2.zip'
,'http://user.tninet.se/~jtv108p/q2etctf2_11.jpg'
,'http://user.tninet.se/~jtv108p/index.html'
,array(69)
,706*1024
,'CTF'
,'Q2'
,'NO'
,"Nothing to say, find the big cylindrical room in the center of the map \"grapple\" and take the \"quad\" let's frag! That's it."
)

,array(
 0
,0
,'The Fortress'
,'http://user.tninet.se/~jtv108p/q2etctf1.zip'
,'http://user.tninet.se/~jtv108p/q2etctf1_11.jpg'
,'http://user.tninet.se/~jtv108p/index.html'
,array(69)
,769*1024
,'CTF'
,'Q2'
,'NO'
,"A lookalike to Stronghold Opposition, but that's the greatest CTF to play I think. You have landed, and your team are to struggle your way to steal the other flag!"
)

,array(
 0
,0
,'Battlecruiser'
,'http://user.tninet.se/~jtv108p/q2etdm3.zip'
,'http://user.tninet.se/~jtv108p/q2etdm3_11.jpg'
,'http://user.tninet.se/~jtv108p/index.html'
,array(69)
,1510*1024
,'DM' #FIXME: Add: TD?
,'Q2'
,'NO'
,"My third map, I got the idea from Behemouth Battlecruisers floating around in Starcraft?, A big map, so don't get lost out there! Very joyable to play, both deathmatch and team play."
)

,array(
 0
,0
,'A Bridge To Near'
,'http://user.tninet.se/~jtv108p/q2etdm2.zip'
,'http://user.tninet.se/~jtv108p/q2etdm2_11.jpg'
,'http://user.tninet.se/~jtv108p/index.html'
,array(69)
,1510*1024
,'DM'
,'Q2'
,'NO'
,"My second map, It was ment to be a CTF, but there was to many objects and too much of everything \"vismap overflowed\" so I remade it And there it was.<br><br>A fast map to play, I made some \"secrets\" find them and get your self an advantage! I forgot to tell you, but  this map and q2etdm1 are \"zipped\" with all the sounds you need!"
)

,array(
 0
,0
,'The Cistern II'
,'http://user.tninet.se/~jtv108p/q2etdm1.zip'
,'http://user.tninet.se/~jtv108p/q2etdm1_11.jpg'
,'http://user.tninet.se/~jtv108p/index.html'
,array(69)
,982*1024
,'DM'
,'Q2'
,'NO'
,"My first map, I remade \"The Cistern\" DM map that we all played in Quake, A kind of small, but asskickin' map. I didn't know that \"Quake Generations\" would be made"
)

,array(
 0
,0
,'Ancient Temple'
,'http://publish.hometown.aol.com/blaquekidd/myhomepage/ancienttemple.zip'
,NULL
,'http://hometown.aol.com/blaquekidd/myhomepage/index.html'
,array(92)
,941*1024
,'DM'
,'Q2'
,'NO'
,"A relatively small map made for 4-6 people. This looks like a Ancient Temple! It's my second map and is a lot better than the first. Map made with Quark 5.0."
)

,array(
 0
,0
,'The Whore House'
,'http://www.geocities.com/SiliconValley/Bridge/2408/DownloadFiles/rg2dm2.zip'
,'http://www.geocities.com/SiliconValley/Bridge/2408/downloads.htm'
,'http://www.geocities.com/SiliconValley/Bridge/2408/'
,array(67)
,490*1024
,'DM'
,'Q2'
,'NO'
,"There is no business like show business (or whore business - no camping whores offended)"
)

,array(
 0
,0
,'Graveyard'
,'ftp://www.bitchclan.org/anonymous/graveyard.zip'
,'http://www.bitchclan.org/mapgrave.html'
,'http://www.bitchclan.org/'
,array(99)
,789*1024
,'DM'
,'Q2'
,'NO'
,"I aim for unique usually... This you've prolly learned from my other maps.. I mean.. Aren't you sick of looking at the same old boring warehouse looking maps??? I am =P<br><br>Haha. Ok this map is two levels... Only those willing to explore will find the second level. An entrance to the catacombs is in the larger mosoleum. And a second entrance is falling through and open grave near the smaller mosoleum. Below is a merky nasty puddles underground cavern. There is a Quad down there! This map is best viewed slightly dark on your screen brightness.. But for better target visibility.. Max it out."
)

,array(
 0
,0
,'ToyStory'
,'ftp://www.bitchclan.org/anonymous/toystory.zip'
,'http://www.bitchclan.org/maptoy.html'
,'http://www.bitchclan.org/'
,array(99)
,927*1024
,'DM'
,'Q2'
,'NO'
,"When you were a kid... ever thought it'd be neat to see you little action figures come to life? Like in that movie Small Soldiers? Now your little childhood dream can come true :) You are a SPACEMARINE the size of a large cockroach defending your child's Bedroom from the evil forces of \"the Bad Guys\" lol<br><br>One drawer opens up and there is knot hole in it that leads to the bottom drawer. Indide is a QUAD. But don't go there unless you got a lithium hook to get out again. [BITCH]clan is a lithium only clan.. That's why most my maps are geared toward that. Anyway... A quad is in the glass of water next to the picture on the drawer set. The bedposts, I made ladders for all you DM only players. There is a BFG on top of the lightbulb but watch out! A lightbulb will burn you :)"
)

,array(
 0
,0
,'Temple of [BITCH]'
,'ftp://www.bitchclan.org/anonymous/templeofBITCH.zip'
,'http://www.bitchclan.org/maptemple.html'
,'http://www.bitchclan.org/'
,array(99)
,872*1024
,'DM'
,'Q2'
,'NO'
,"Welcome to the sacred meeting place of the [BITCH]Clan... <br>There is a 1 minute Quad on top of the obolisc inside the Pyramid. Enjoy :)"
)

,array(
 0
,0
,'Space Junk'
,'ftp://www.bitchclan.org/anonymous/SpaceJunk.zip'
,'http://www.bitchclan.org/mapspace.html'
,'http://www.bitchclan.org/'
,array(99)
,1025*1024
,'DM'
,'Q2'
,'NO'
,"A Marine prisoner Transport Vessel, carrying several various clanned Marines, is struck by a meteor. The ship starts to lose integrity and breaks up. Many of the crew and prisoners manage to get away in escape pods... Those who didn't suited themselves up in environmental suits before being sucked into space. One small drop ship survived the wreck... Now it's every man for himself!<br><br>THIS MAP IS An almost ZERO G combat simulator. So bring a barf bag..."
)

,array(
 0
,0
,'TrailerTrash'
,'ftp://www.bitchclan.org/anonymous/trailertrash.zip'
,'http://www.bitchclan.org/maptrailr.html'
,'http://www.bitchclan.org/'
,array(99)
,757*1024
,'DM'
,'Q2'
,'NO'
,"Self explainatory :) Just don't forget to bring your own Mad Dog 20/20 :) I wanted to add a bunch of Junk cars.. But I didn't want to lag the map out."
)

,array(
 0
,0
,'Killahdm2'
,'http://www.fortunecity.com/underworld/blood/992/killah.zip'
,'http://www.fortunecity.com/underworld/blood/992/killah.jpg'
,'http://welcome.to/mame'
,array(106)
,238*1024
,'DM'
,'Q2'
,'NO'
,"Quake 1 styled map. Small sized one-on-one."
)

,array(
 0
,0
,"Jabba's Pallace"
,'http://www.horizon.nl/~lime/hear/quake/jabba.zip'
,NULL
,'http://www.horizon.nl/~lime/hear/quake'
,array(107)
,NULL
,'DM'
,'Q2'
,'NO'
,"As the name says, this is Jabba the Hutt's Pallace as seen in the Star Wars movie: 'Return of the Jedi'. the architecture of the building is very cool and moody. I tried to stay as close to the original as possible, though I had to put in some of my own ideas to make it playable. Still much of the origional concept is intact and makes this Dm-level quite unique in a way..."
)

,array(
 0
,0
,"Vargas' Rest Place"
,'http://www.geocities.com/SiliconValley/Bridge/2408/DownloadFiles/rg2dm3.zip'
,'http://www.geocities.com/SiliconValley/Bridge/2408/downloads.htm'
,'http://www.geocities.com/SiliconValley/Bridge/2408/'
,array(67)
,600*1024
,'DM'
,'Q2'
,'NO'
,"Rest Place ??? Kidding us ??? Let's ROCK this joint !"
)

,array(
 0
,0
,'Fun With Death'
,'http://www.sec.lia.net/rahzar/mike/q2dmd.zip'
,'http://www.sec.lia.net/rahzar/mike/gonad1.jpg'
,NULL
,array(108)
,148*1024
,'DM'
,'Q2'
,'NO'
,"If you wanna have Fun With Death, you should play this map one-on-one. It is tested extensively with the Eraser bot too."
)

,array(
 0
,0
,'Mos Eisley'
,'http://members.aol.com/laky0816/mos.zip'
,'http://members.aol.com/laky0815/mos1.jpg'
,'http://members.aol.com/laky0815/index.html'
,array(71)
,500*1024
,'DM'
,'HL'
,'NO'
,"A star wars theme: Mos Eisley spaceport."
)

,array(
 0
,0
,'Dalek11q2 - 1976'
,'http://193.217.42.4/dalek/maps/dalek11q2.zip'
,'http://193.217.42.4/dalek/'
,'http://193.217.42.4/dalek/'
,array(109)
,781*1024
,'DM'
,'Q2'
,'NO'
,"It's my first big deathmatch map! It's a big map with som sort of temple style in it, but also some outside areas. Buildt it for 10-15 players in mind. I never tested it with real players, only bots. So I don't know if the weaponbalance is god or not.  Hope you enjoy it!! (1976? Year of the dragon, Year I was born and the number of brushes in the map!)"
)

,array(
 0
,0
,'Factor X'
,'http://www.sec.lia.net/rahzar/maps/quake2/q2dp1.zip'
,'http://www.sec.lia.net/rahzar/jacques/q2prev.jpg'
,'http://www.sec.lia.net/rahzar'
,array(110)
,935*1024
,'DM'
,'Q2'
,'NO'
,"Now these maps are really built for some serious deathmatch! Maybe not as hot as id's own DM maps, but at least it is something different with most likely the same quality."
)

,array(
 0
,0
,'UnKnown Fortress'
,'http://members.xoom.com/thughome/jondm6.zip'
,'http://www.gibbed.com/botg/FORTRESS.jpg'
,'http://www.gibbed.com/botg'
,array(111)
,NULL
,'DM' #FIXME: TD?
,'Q2'
,'NO'
,"A bit large FFA or 2on2 + Teamplay map for Quake2 I designed. It comes with some custom textures and stuff."
)

,array(
 0
,0
,'Invectus 3'
,'http://www.planetfortress.com/downloads/mirror.asp?radium/tfc/invect3.zip'
,'http://www.planetfortress.com/radium/tfc/invect3.shtml'
,'http://www.planetfortress.com/radium/tfc/invect3.shtml'
,array(96)
,1058*1024
,'TD' #FIXME: Guess...
,'HL'
,'TFC'
,"<b>INVECTUS - HAVOC</b> Objective: Travel the canyon to the Enemy Base. Gain entrance to the basement and hit the Security Override! This opens the blast door to the Control Room in the top section of the base... Destroy the Control Center!"
)

,array(
 0
,0
,'Garden of Death'
,'http://home1.gte.net/davep/index.htm'
,'http://home1.gte.net/davep/index.htm'
,'http://home1.gte.net/davep/index.htm'
,array(112)
,NULL
,'DM'
,'Q2'
,'NO'
,"My new Quake II Death Match level. This is a small arena level best for 2 to 4 players. I made this level to work with bots. I have play tested it with bots and humans. If you like small arenas and quick frags, then this is for you. I have also included a route file for Eraser Bot (Thanks to Fred for the improved route file and Gladiator .aas file). If anyone would like to send a file for any other bot, I will post these also."
)

,array(
 0
,0
,"Wayne Peeples' Quake levels and prefabs"
,'http://www.quakelevels.com'
,'http://www.quakelevels.com'
,'http://www.quakelevels.com'
,array(34)
,NULL //varies
,'SP DM'
,'Q1 Q2 HL'
,'NO'
,"Quakelevels.com - There are 9 maps for Quake, 6 maps for Quake 2, 1 new halflife map, and several prefabs. I even have a hot-air balloon for Quake 1 that you can fly around in.  I also have spike traps and grinding spiked rollers. Each one is showcased at the above site with info and screenshots. I have a Q2 server running all original maps. I also feature maps by others, and YES, I'll even post your map if you send it and my buddies like it. I'll even run it on the Q2 server."
)

,array(
 0
,0
,"Zway's Way"
,'http://members.xoom.com/Zway/zip/zway.zip'
,'http://members.xoom.com/Zway/pix/zway.jpg'
,'http://www.portup.com/~gus/download.html'
,array(83)
,384*1024 //APPROX
,'DM'
,'Q2'
,'NO'
,"This is a good deathmatch for two to four but it will support up to six. During the Dark Ages I made a real crappy Doom level that this map is based on. The Quake 2 version is really pretty good regarding gameplay and it looks OK also. If you try it let me know...."
)

,array(
 0
,0
,'Cross Fire 1.0'
,'http://www.merfax.com/quake/xfire1.zip'
,'http://www.merfax.com/quake/xfire1.jpg'
,'http://www.merfax.com/quake/default.htm'
,array(105)
,1.7*1024*1024
,'SP DM COOP'
,'Q2'
,'NO'
,"This is a three map unit designed for single player, but should be O.K. for coop & deathmatch. The second level is BIG and might not play well without a fast machine and/or good video card - it is also Dangerous on hard+ (skill 3). There is a hard to find secret on level three, but worth the effort. Level 1: Stop i nvaders from taking the Lab. Level 2: Deal with an attack on your Base. Level 3: Get weapons to help clean out level 2."
)

,array(
 0
,0
,'THE HALLOWED'
,'http://underworld.fortunecity.com/snowboard/940/hallowed.zip'
,'http://underworld.fortunecity.com/snowboard/940/maps.htm'
,'http://underworld.fortunecity.com/snowboard/940/'
,array(113)
,NULL
,'DM'
,'Q2'
,'NO'
,"A 3 story ffa frag hallocaust for all. Or a one on one waltz:)"
)

,array(
 0
,0
,'Q1monas'
,'http://www.geocities.com/TimesSquare/Cavern/4090/Q1monas.zip'
,NULL
,'http://www.geocities.com/TimesSquare/Cavern/4090'
,array(114)
,NULL
,'DM'
,'Q1'
,'NO'
,"Based on my old Doom2 level of the same name with the idea of four Kick ass rooms linked  together....with gothic looking areas and a sewer making for some underwater action ...and a Lightning Gun hidden under a elevator...and long hallways for rocket fire fights and good grenade tossing ....So RUN IF YOU CAN in the MONASTRY"
)

,array(
 0
,0
,'Arena'
,'http://www.geocities.com/TimesSquare/Cavern/4090/Arena.zip'
,NULL
,'http://www.geocities.com/TimesSquare/Cavern/4090'
,array(114)
,NULL
,'DM'
,'Q1'
,'NO'
,"Arena is another level based on a old Doom2 level.. Designed to have a Large main room with a Nasty Weapon in the Middle (RocketLauncher) I placed a nail gun trap in one of the rooms for fun ....There is a large tower room with a grassy playing field leading to a Water Pit room with  the Double sided teleporter each side leading to different locations....ONE OF MY FAV'S DEATH MATCH and DIE"
)

,array(
 0
,0
,'Burning Zone'
,'http://www.geocities.com/TimesSquare/Cavern/4090/Brnzone.zip'
,NULL
,'http://www.geocities.com/TimesSquare/Cavern/4090'
,array(114)
,NULL
,'DM'
,'Q1'
,'NO'
,"Brnzone ..... One of the Best Levels I made for Quake..I spent a lot of time doing the  water pits and the Acid lake surrounding the pits ....with plenty of suits laying around for leaps into acid for the hidden goodies....also the textures for the main halls blend Nicely ......  I've also hidden a Major Power Up in the Vertical Lava Tube ...wich appears every now and then after picked up...A GREAT RUN AND GUN LEVEL"
)

,array(
 0
,0
,'Ritter'
,'http://members.aol.com/Vanx2000/ritter.zip'
,'http://members.aol.com/laky0815/ritter1.jpg'
,'http://members.aol.com/laky0815/index.html'
,array(71)
,540*1024 //APPROX
,'SP DM'
,'Q1'
,'NO'
,"The dark middle-age in germany. Free the holy church from satans childs."
)

,array(
 0
,0
,'Temple Of Frags'
,'http://members.xoom.com/thughome/jondm4.zip'
,'http://www.gibbed.com/botg/filespage/FT.jpg'
,'http://www.gibbed.com/botg'
,array(111)
,880*1024
,'DM'
,'Q2'
,'NO'
,"My newest map.It rules.check it out"
)

,array(
 0
,0
,'The Cooling Chamber'
,'http://www.alex.fasthosts.co.uk/cc_q2.zip'
,'http://www.alex.fasthosts.co.uk/clips.gif'
,'http://www.alex.fasthosts.co.uk/'
,array(115)
,281*1024
,'DM'
,'Q2'
,'NO'
,"This is my first ever released Quake II deathmatch level. Designed for 2 or 3 players, this small map makes for a furious deathmatch with atmospheric scenery and stunning architecture."
)

,array(
 0
,0
,'Bros Of The Gun Domain'
,'http://members.xoom.com/thughome/botgra1.exe'
,NULL
,'http://www.gibbed.com/botg'
,array(111, 116)
,1.11*1024*1024
,'DM' #FIXME: Guess...
,'Q2'
,'RA'
,"4 Arenas and 1 pickup map. 3 Arenas made by DieHard and 1 arena by spoke. He also helped with the pickup map a bit.You also need the Textures from our hompage to view it right. The server side file is only required if you plan on setting up a server for it.If you want or need this files click on (Website)"
)

,array(
 0
,0
,'Toe Tag'
,'http://underworld.fortunecity.com/snowboard/940/toetag.zip'
,'http://underworld.fortunecity.com/snowboard/940/toetag.jpg'
,'http://underworld.fortunecity.com/snowboard/940/'
,array(113)
,349*1024
,'DM'
,'Q2'
,'NO'
,"This is my first releases DM level, it is a small/medium size level were the focus is on a fast paced action DM game!"
)

,array(
 0
,0
,'Genocide'
,'http://andrew.absol.co.za/excen/maps/quake2/csdm1.zip'
,'http://www.sec.lia.net/excen/jacques/q2prev.jpg'
,'http://www.sec.lia.net/excen'
,array(110)
,1.6*1024*1024
,'SP DM COOP'
,'Q2'
,'NO'
,"This is actually a DM map, but can also be played in a Single Player environment. It features ambience that is capable of killing you or helping you out of your opponents deadly aim! It has respawning monsters. You would stay alive until all ammo and health are drained from the map, you last frontier would be survival and ultimately, DEATH!"
)

,array(
 0
,0
,'Monastry'
,'http://www.Geocities.com/TimesSquare/Cavern/4090/monastry.zip'
,NULL
,'http://www.Geocities.com/TimesSquare/Cavern/4090/'
,array(114)
,587*1024 //zipped up
,'DM'
,'Q2'
,'NO'
,"Quake 2 Deathmatch Level Designed for Quick run and gun areas ,with 4 main rooms linking to each other,for fast entrance and escapes if needed,players start with armour and shotgun in start locations for a slim survival do you dare enter the MONASTRY....."
)

,array(
 0
,0
,"Diehard's Domain CTF"
,'http://members.xoom.com/thughome/jonctf1.exe'
,'http://members.xoom.com/thughome/news.html'
,'http://members.xoom.com/thughome/index.html'
,array(111)
,500*1024 //APPROX
,'DM CTF'
,'Q2'
,'NO'
,"Diehard's Domain converted into CTF."
)

,array(
 0
,0
,'Combat Arena'
,'http://members.xoom.com/thughome/jondm3.exe'
,'http://members.xoom.com/thughome/news.html'
,'http://members.xoom.com/thughome/index.html'
,array(111)
,350*1024 //APPROX
,'DM'
,'Q2'
,'NO'
,"My smallest stage because I wanted this one to be for a 1 on 1 or 2 on 2 Deathmatch.Its a nice small stage and very competitive for 1 on 1 combat."
)

,array(
 0
,0
,'Combat Arena CTF'
,'http://members.xoom.com/thughome/jonctf2.exe'
,'http://members.xoom.com/thughome/news.html'
,'http://members.xoom.com/thughome/index.html'
,array(111)
,500*1024 //APPROX
,'DM CTF'
,'Q2'
,'NO'
,"This is the Combat Arena converted into CTF.Its about 2 the size as the Cambat arena and is for CTF only."
)

,array(
 0
,0
,'Blood Pool'
,'http://members.xoom.com/thughome/jondm2.exe'
,'http://members.xoom.com/thughome/quake00.jpg'
,'http://members.xoom.com/thughome/index.html'
,array(111)
,550*1024 //APPROX
,'DM'
,'Q2'
,'NO'
,"This map is a pretty large map that takes place on a coast. The coast is a secret Weapons Facility that the marines come to get thier weapons at.Because these weapons are not supposed to be available to the public stroggs they and have built it on a small island that is in the middle of a bay called the blood pool.The Blood Pool is contaminated with this acid that keeps others from coming and taking over the base.Even ships have to have an armory to keep thier ships from melting and sinking."
)

,array(
 0
,0
,"Diehard's Domain"
,'http://members.xoom.com/thughome/jondm1.exe'
,'http://members.xoom.com/thughome/jondm1.jpg'
,'http://members.xoom.com/thughome/index.html'
,array(111)
,400*1024 //APPROX
,'SP DM'
,'Q2'
,'NO'
,"A Stage I think i did a average jon on.Its my first actual stage and ended out looking quite good.I have more stages I will post later but for now this is the only one cause the others arent quite finished.If you still wish to download the others visit my homepage."
)

,array(
 0
,0
,'Bassein'
,'http://www.chat.ru/~spronin/bassein.zip'
,NULL
,NULL
,array(117)
,190*1024
,'DM'
,'Q2'
,'NO'
,"Edit Quark 5b9 4-6 players"
)

,array(
 0
,0
,'Warehouse Whimperings'
,'http://www.geocities.com/TimesSquare/Labyrinth/9236/ibase2.zip'
,'http://www.geocities.com/TimesSquare/Labyrinth/9236/shot1.gif'
,'http://www.geocities.com/TimesSquare/Labyrinth/9236/index.html'
,array(118)
,300*1024
,'DM'
,'Q1'
,'NO'
,"A base level inspired by the quake2 warehouse level. Also email me if you'd like me to make anything. I have prefabs, and will post any that you have."
)

,array(
 0
,0
,'The Inner Silos'
,'http://www.geocities.com/TimesSquare/Hangar/3663/silos.zip'
,'http://www.geocities.com/TimesSquare/Hangar/3663/quake03.jpg'
,'http://www.geocities.com/TimesSquare/Hangar/3663/index.html'
,array(119)
,287*1024
,'DM'
,'Q2'
,'NO'
,"Lots of places to hide and to camp. But, it is nearly impossible to corner yourself on this strange little level."
)

,array(
 0
,0
,'Romp'
,'http://www.jwimage.com/realtime/romp2.zip'
,'http://www.jwimage.com/realthumbs/romp02.jpg'
,'http://www.jwimage.com/'
,array(120)
,650*1024
,'DM'
,'?'
,'?'
,NULL
)

,array(
 0
,0
,'plumbers nightmare'
,'http://www.geocities.com/TimesSquare/Labyrinth/9236/plumber.zip'
,'http://www.geocities.com/TimesSquare/Labyrinth/9236/quake00.gif'
,'http://www.geocities.com/TimesSquare/Labyrinth/9236/index.htm'
,array(118)
,225*1024 //APPROX
,'DM'
,'?'
,'?'
,"A base style level with lots of water."
)

,array(
 0
,0
,'The home of the NecroGod'
,'http://www.geocities.com/SiliconValley/Vista/7041/necro1.zip'
,NULL
,NULL
,array(121)
,100*1024
,'DM'
,'?'
,'?'
,"This is a DM map that is a first in an ongoing series of maps centered around the title \"necrogod\". Expect much deaths and frags when playing this map. Lava, traps, snipe spots, this map has it all!"
)

,array(
 0
,0
,"Marty's Stuff!"
,'ftp://ftp.cdrom.com/pub/quake/levels/compilations/martys.zip'
,NULL
,NULL
,array(122)
,6*1024*1024
,'SP'
,'Q1'
,'NO'
,"Just a bunch of levels I threw together. They ARE designed for the most part to be played in sequence. If you try them out of order and get your ass kicked, I don't want to hear about it. Otherwise I love feedback good or bad. Requirements: Quake Mission Pack 1: Ya gotta have it or these levels just AINT gonna work. A burning desire to blow stuff up kinda helps too. Oh yeah, about 14 megs open disk space."
)

,array(
 0
,0
,"Joshua's Playhouse"
,'http://www.thegrid.net/cardshark/files/Playhaus.zip'
,NULL
,'http://www.thegrid.net/cardshark/index.htm'
,array(123, 61)
,172*1024
,'DM'
,'?'
,'?'
,"Made by Joshua (with help from Uncle ThunderMug) "."A really good DM level by Joshua. Wanna know how easy QuArK is? Ask Joshua, he's 3 1/2 years old!! This level is one of many on <a href=\"http://www.thegrid.net/cardshark/index.htm\" target=\"_blank\" rel=\"noopener\">Green Hornet's Quake Page</a>. Check it out."
)

,array(
 0
,0
,'Electric Company'
,'ftp://ftp.cdrom.com/pub/idgames2/levels/d-f/electric.zip'
,NULL
,'http://www.pressroom.com/~fiction/'
,array(124)
,1595*1024
,'SP'
,'?'
,'?'
,"This is a beta in the ongoing &quot;Utilities&quot; series by Erik. He likes loooong hallways, and rotating brushes. It looks cool, and has some neat monsters. Other levels he's done can be found at <a href=\"http://www.pressroom.com/~fiction/\" target=\"_blank\" rel=\"noopener\">http://www.pressroom.com/~fiction/</a>."
)

,array(
 0
,0
,'The Factory of Sin'
,'http://users.rttinc.com/~mborle/files/factory.zip'
,NULL
,'http://users.rttinc.com/~mborle/'
,array(28)
,358*1024
,'?'
,'?'
,'RA'
,"One large room with an overhead walkway, and a water treatment pool. Each area has a couple ways to get to it, and the boxes scattered throughout the building make for good defensive strategy."
)

,array(
 0
,0
,'The Base in The Valley'
,'http://home4.swipnet.se/~w-49918/baseinva.zip'
,NULL
,NULL
,array(125)
,233*1024
,'DM'
,'?'
,'?'
,"Simple deathmatch level. Should be fun for a blast-fest though."
)

,array(
 0
,0
,'I Wore My Doormat Face'
,'http://www.pressroom.com/~fiction/maps/doormat.zip'
,NULL
,'http://www.pressroom.com/~fiction'
,array(124)
,466*1024
,'SP'
,'?'
,'?'
,"Another great level by Erik. He's really serious about map editing, and has written an essay on styles. Check his webpage at: <a href=\"http://www.pressroom.com/~fiction\" target=\"_blank\" rel=\"noopener\">http://www.pressroom.com/~fiction</a>"
)

,array(
 0
,0
,'First Heaven After Hell'
,'http://www.dalnet.se/~peda/quake/download/first.zip'
,NULL
,'http://www.dalnet.se/~peda/'
,array(126)
,784*1024
,'SP'
,'?'
,'?'
,"This is JeÐa's first level with QuArK. It's big, and kinda linear, but shows promise. Check it out."
)

,array(
 0
,0
,'Save Your Own Skin 2'
,'http://users.cybercity.dk/~bbl6915/down/SKIN2.ZIP'
,NULL
,'http://users.cybercity.dk/~bbl6915/prod.html'
,array(127)
,209*1024
,'DM'
,'?'
,'?'
,"A deathmatch level modelled on his home."
)

,array(
 0
,0
,'The Camper Installation'
,'http://home4.swipnet.se/~w-49918/camp_dm.zip'
,NULL
,NULL
,array(125)
,110*1024 //APPROX
,'DM CTF'
,'?'
,'?'
,"A fairly small but interesting DM level. (I didn't look at the <a href=\"http://home4.swipnet.se/~w-49918/campinst.zip\">CTF version</a>)."
)

,array(
 0
,0
,'JawRaw v1.0'
,'ftp://ftp.cdrom.com/pub/idgames2/levels/team_fortress/jawraw1.zip'
,NULL
,NULL
,array(128)
,712*1024
,'DM' #FIXME: Guess...
,'Q1'
,'TFC'
,"A TeamFortress Level designed for v2.65 and up. Includes levels, models, and sounds."
)

,array(
 0
,0
,'The Maze'
,'http://www.tiac.net/users/brewman/maps/maze.zip'
,NULL
,NULL
,array(129)
,888*1024
,'TD' #FIXME: Guess...
,'Q1'
,'TFC'
,"Started in WC, mostly done with QuArK. Seems to be a pattern starting..."
)

,array(
 0
,0
,'2Sarge'
,'ftp://ftp.cdrom.com/pub/quake/levels/team_fortress/2sarge.zip'
,NULL
,NULL
,array(130)
,NULL
,'TD' #FIXME: Guess...
,'Q1'
,'TFC'
,"2Sarge is a TF map w/ CTF style scoring and the ability to damage your opponent's control room after the first flag capture. It was meant for clan matches. It has 2 bad respawns in blue base and a few weird textures, but that'll be fixed in the new version that's coming out in like 2 weeks."
)

,array(
 0
,0
,'Gates3'
,'ftp://ftp.cdrom.com/pub/quake/levels/team_fortress/gates3.zip'
,NULL
,NULL
,array(130)
,NULL
,'TD' #FIXME: Guess...
,'Q1'
,'TFC'
,"Gates3 is a TF map where the first team is made of 1 civilian(only has 50 health and an axe) who is Bill Gates. the second team is an unlimited amount of bodygaurds for Bill. The third are a max of 2 assassin snipers, and the 4th team are civilian convention geeks. A very large, open map, it was made very simple, and not meant to be intricate."
)

,array(
 0
,0
,'Dark Zone Forever'
,'http://users.rttinc.com/~mborle/files/dzf.zip'
,NULL
,NULL
,array(28)
,600*1024
,'DM'
,'Q1'
,'NO'
,"This is a level which is laid out architecturally nearly identical to the original Dark Zone (DM6) except has been made slightly larger, and there's one hard-ass secret to find. Good for about 4-6 people."
)

,array(
 0
,0
,'Emerald Palace'
,'http://www.ia-omni.com/flapjack/files/arena/eparena.zip'
,NULL
,NULL
,array(131)
,287*1024
,'RA'
,'?'
,'?'
,"Map Notes : My first published map of any kind. Expect a huge 200-player DM map for Q2 in the near future (Quark-made)."
)

,array(
 0
,0
,'Dmz'
,'ftp://ftp.cdrom.com/pub/idgames2/quake2/levels/deathmatch/d-f/dmz.zip'
,NULL
,NULL
,array(132)
,246*1024
,'DM'
,'Q2'
,'NO'
,"This is a very good remake of DM6 for Quake2. Highly recommended for those of you who loved the original DM6."
)

,array(
 0
,0
,'Colony 1'
,'ftp://ftp.cdrom.com/pub/quake/levels/a-c/colony.zip'
,NULL
,NULL
,array(133)
,399*1024 //APPROX
,'SP DM COOP'
,'Q1'
,'NO'
,"Both of these levels were featured at <a href=\"http://www.planetquake.com/spq/matt/\" target=\"_blank\" rel=\"noopener\">Matt Sefton's SPQ</a>. They are both single player but have DM and coop support."
)

,array(
 0
,0
,'Colony 2'
,'ftp://ftp.cdrom.com/pub/quake/levels/a-c/colony2.zip'
,NULL
,NULL
,array(133)
,632*1024 //APPROX
,'SP DM COOP'
,'Q1'
,'NO'
,"Both of these levels were featured at <a href=\"http://www.planetquake.com/spq/matt/\" target=\"_blank\" rel=\"noopener\">Matt Sefton's SPQ</a>. They are both single player but have DM and coop support."
)

,array(
 0
,0
,'Untitled (eq2_sp1)'
,'http://www.pressroom.com/~fiction/maps/eq2_sp1.zip'
,NULL
,NULL
,array(124)
,460*1024
,'SP'
,'Q2'
,'NO'
,"Another nice level from Erik. I fudged around a little getting this one up, so it very well could be the first Q2 map released. It looks very nice, and also plays well. Plus, he has generously included the .map file in the archive."
)

,array(
 0
,0
,'Self Destruct Part1'
,'http://www.dalnet.se/~peda/quake/download/self.zip'
,NULL
,NULL
,array(126)
,293*1024
,'SP'
,'?'
,'?'
,"A small single player map by Jeda."
)

,array(
 0
,0
,'The Forgotten Outpost'
,'ftp://ftp.cdrom.com/pub/idgames2/planetquake/talon/outpost.zip' #FIXME: REALLY?!?
,NULL
,NULL
,array(134)
,469*1024
,'DM'
,'?'
,'?'
,"Just a Dm level for about 2-4 players! All the weapons r in there including the GL 2x and RL 2x. Its a base still map with lots of traps."
)

,array(
 0
,0
,'Margaal5'
,'http://www.clanwos.org/pub/q2/maps/margaal5.zip'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,array(60)
,1364319
,'DM'
,'Q2'
,'NO'
,"This margaal5 Version 23-aug-2oo3   (is released on internet 13March Q2cafe 2o1o)."
)

,array(
 0
,0
,'Margaal7'
,'http://www.clanwos.org/pub/q2/maps/margaal7.zip'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,array(60)
,578483
,'DM'
,'Q2'
,'NO'
,"Version 2oo5 - Map was broken...repair it 25Nov 2o1o,released on internet 25Nov 2o1o Q2cafe`."
)

,array(
 0
,0
,'Margaal8'
,'http://www.clanwos.org/pub/q2/maps/margaal8.zip'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,array(60)
,1519842
,'DM'
,'Q2'
,'NO'
,"This margaal8 final Version 2oo7 - is released on internet 22okt 2o1o."
)

,array(
 0
,0
,'Margaal9'
,'http://www.clanwos.org/pub/q2/maps/margaal9final.zip'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,array(60)
,1164727
,'DM'
,'Q2'
,'NO'
,"Margaal9final - is released on internet 10nov 2o1o."
)

,array(
 0
,0
,'Margaal10'
,'http://www.clanwos.org/pub/q2/maps/margaal10.zip'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,array(60)
,1268644
,'DM'
,'Q2'
,'NO'
,"Margaal10 2oo5/2oo6 - is released on internet 22okt 2o1o."
)

,array(
 0
,0
,'Margaal11'
,'http://www.clanwos.org/pub/q2/maps/margaal11.zip'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,array(60)
,1927017
,'DM'
,'Q2'
,'NO'
,"New fresh map - Version 17 okt 2o1o ( after a mapping break from 5 years )."
)

,array(
 0
,0
,'Margaal12 - Q2reloaded contest map Canyon'
,'http://www.clanwos.org/pub/q2/maps/margaal12.zip'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,array(60)
,2714681
,'DM'
,'Q2'
,'NO'
,"Version 16Nov 2o1o contest Map Canyon."
)

,array(
 0
,0
,'Margaal13 - Q2reloaded contest map otherworld'
,'http://www.clanwos.org/pub/q2/maps/margaal13.zip'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,array(60)
,1776925
,'DM'
,'Q2'
,'NO'
,"Version 13Nov 2o1o contest Map Otherworld."
)

,array(
 0
,0
,'Margaal14'
,'http://www.clanwos.org/pub/q2/maps/margaal14.zip'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,array(60)
,4231394
,'DM'
,'Q2'
,'NO'
,"Version b (4.595.804 bytes) 7 dec 2o1o contest Map Dark City."
)

,array(
 0
,0
,'Margaal15'
,'http://www.clanwos.org/pub/q2/maps/margaal15.zip'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,array(60)
,1638310
,'DM'
,'Q2'
,'NO'
,"like the gameplay Margaal14 Dark city."
)

,array(
 0
,0
,'Margaal16 - Dark City II'
,'http://www.clanwos.org/pub/q2/maps/margaal16.zip'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,array(60)
,3128815
,'DM'
,'Q2'
,'NO'
,"Margaal16 Darkcity II.."
)

,array(
 0
,0
,'Margaal17 - Quake2cafe 9th mapping contest Winner'
,'http://www.clanwos.org/pub/q2/maps/margaal17clip.zip'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,array(60)
,3228373
,'DM'
,'Q2'
,'NO'
,"A secret train station with an old underground test lab for what seems to be heavy water. Small meteorites had crashed into the area and exposed the lab. The Strogg soldiers that discovered the place then thought it would make a nice playing arena so they installed jumppads. Before they could finish their project, Margaal and Pan came in and brutally kicked the Strogg out and with care and attention to detail they turned it into a DM map for Q2. (True story!)"
)

,array(
 0
,0
,'Margaal18'
,'http://www.clanwos.org/pub/q2/maps/margaal18.zip'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,array(60)
,3628868
,'DM'
,'Q2'
,'NO'
,"Margaal18 ( on 17 Sept 2o11 )"
)

,array(
 0
,0
,'Margaal19 - Back to Basics'
,'http://www.clanwos.org/pub/q2/maps/margaal19.zip'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,array(60)
,2711638
,'DM'
,'Q2'
,'NO'
,"After some difficult mapz ( M17 / m18 ) ,i just need a refreshment.<br>Have some mapz viewed from 99 and try make one of my own..<br>Here is Margaal19 - Back to Basics - Metalic look."
)

,array(
 0
,0
,'Margaal20'
,'http://www.mediafire.com/download/5nww2jn2c64ddnx/margaal20.zip'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,array(60)
,3188557
,'DM'
,'Q2'
,'NO'
,"Fun working with such a limited amount of brushes."
)

,array(
 0
,0
,'Margaal21'
,'http://www.mediafire.com/download/os8bbe0n8n386ag/margaal21.zip'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,array(60)
,9569326
,'DM'
,'Q2'
,'NO'
,"Map started with water & rocks cave idea, from there slowly extended.."
)

,array(
 0
,0
,'Margaal22'
,'http://www.mediafire.com/download/gs5qfohtqo9v7t0/margaal22.zip'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,array(60)
,3928161
,'DM'
,'Q2'
,'NO'
,"A small base surrounded by rocks."
)

,array(
 0
,0
,'Margaal23'
,'http://download1081.mediafire.com/pf14oro55byg/ieo73ex1o2apz56/margaal23c.zip?action=display&board=q2mappinghelp&thread=3281&page=1'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,array(60)
,11431217
,'DM'
,'Q2'
,'KMQ2 NO'
,NULL
)

,array(
 0
,0
,'Margaal24'
,'http://www.mediafire.com/download/c1sz33l1vn0uubs/margaal24.zip?action=display&board=q2mappinghelp&thread=3281&page=1'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,array(60)
,4587995
,'DM'
,'Q2'
,'KMQ2 NO'
,NULL
)

,array(
 0
,0
,'Margaal25'
,'http://www.mediafire.com/download/k0iq2x283erl159/margaal25.zip?action=display&board=q2mappinghelp&thread=3281&page=1'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,array(60)
,13264468
,'DM'
,'Q2'
,'KMQ2 NO'
,"This is my small single player Outerbase version.<br>
Goal is power shutdown five computers and escape.<br>
<br>
My intention was to make a large SP story,<br>
( a biggg pak file ) with all my map sketches from recent years.<br>
<br>
,but aaargggg a nasty annoying Error line has screwed up my further map motivation,<br>
Unfortunately this map is no longer in the Sp package."
)

,array(
 0
,0
,'Margaal26'
,'http://download2054.mediafire.com/fv80jmpf6ang/suu4oykuhkwj3l4/margaal26final.zip?action=display&board=q2mappinghelp&thread=3281&page=1'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,array(60)
,13838028
,'DM'
,'Q2'
,'KMQ2 NO'
,"margaal26final a extensive margaal20 map version."
)

,array(
 0
,0
,'Margaal27'
,'http://download1411.mediafire.com/tuib0a89cofg/d8n8oaimn1c4q1l/margaal27final.zip?action=display&board=q2mappinghelp&thread=3281&page=1'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,array(60)
,20027550
,'DM'
,'Q2'
,'KMQ2 NO'
,"Design for 3 players Max<br>Design for 1vs1 player"
)

,array(
 0
,0
,'Margaal28'
,'http://download2198.mediafire.com/dbrap6cw407g/oozigw69yo3mtav/margaal28final.zip?action=display&board=q2mappinghelp&thread=3281&page=1'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,'http://members.ziggo.nl/margaal/quake/qmaps.htm'
,array(60)
,21736550
,'DM'
,'Q2'
,'KMQ2 NO'
,"A map design which I am very proud of...technical very difficult, Design for 5 players Max"
)

,array(
 0
,0
,'WDDM01 : Higher Ground'
,'http://dervish.tastyspleen.net/files/wddm01.zip' #http://deaconstomb.org/pub/q2/maps/wddm01.zip
,'http://dervish.tastyspleen.net/maps.html'
,'http://dervish.tastyspleen.net/maps.html'
,array(135)
,3002603
,'DM FFA'
,'Q2'
,'NO'
,"This map is a medium sized deathmatch area, with 6-7 main areas interconnected by short halls, and passageways. The main \"arena\" is a multi-level atrium with thin walkways and struts to access the upper ledges, a cliff edge with a tough-to-reach (and even tougher to retain) quad-damage, and some deep shadows for sniping down into the middle while remaining fairly invisible.<BR>There is a building to the east with a laser cannon, to control one of the few east to west hallways, and a stairwell that makes for some interesting SSG battles. Off to the south are a subterranean lava cave and storage room, and another atrium containing the BFG, PS, and another laser cannon to fry anyone running for the BFG."
)

,array(
 0
,0
,'WDDM02 : Two Men Enter, One Man Leaves... '
,'http://dervish.tastyspleen.net/files/wddm02.zip' #Strogg DM: http://deaconstomb.org/pub/q2/maps/wdsdm02.zip   http://deaconstomb.org/pub/q2/maps/wddm02.zip http://dervish.tastyspleen.net/files/wdsdm02.zip
,'http://dervish.tastyspleen.net/maps.html'
,'http://dervish.tastyspleen.net/maps.html'
,array(135)
,626318
,'DM FFA' #StroggDM
,'Q2'
,'NO'
,"This map is a small deathmatch arena, with 6 spawns and 1 large area that makes up the majority of the open arena. The center of the arena is gaurded by two double-barrelled lasers that intersect in the middle, right around the invulnerability. There are 2 other main structures in the map, including a 3 story gaurd house, and a semi-circular bunker that houses the rail and RA. Overall, the map is incredibly fun for FFA and even a small TDM match, with tons of movement and jumping opportunities coupled with large open spaces and rolling hills. "
)

,array(
 0
,0
,'WDRAIL01 : Into the Blue.'
,'http://dervish.tastyspleen.net/files/wdrail01.zip'
,'http://dervish.tastyspleen.net/maps.html'
,'http://dervish.tastyspleen.net/maps.html'
,array(135)
,1357115
,'DM' #Rails DM/Insta-gib
,'Q2'
,'NO'
,"This map is a medium sized floating arena in space, with platforms suspended around the perimeter and a large teleporter in the middle. There are 2 jump pads that enable you to reach the higher platforms, and 2 sets of teleporters as well. The big one in the center is a one-way teleporter that you can jump into, but the two that are on the floating platforms work as 2-way portals, allowing you to quickly switch sides of the arena.<BR>Needless to say, if you happen to miss the platforms or the \"ring\" of the arena floor, you'll die in space, so jump carefully! "
)

,array(
 0
,0
,"WDRAIL02 : Odin's Altar"
,'http://dervish.tastyspleen.net/files/wdrail02.zip'
,'http://dervish.tastyspleen.net/maps.html'
,'http://dervish.tastyspleen.net/maps.html'
,array(135)
,682436
,'DM' #Rails DM/Insta-gib
,'Q2'
,'NO'
,"This map consists of a large courtyard hemmed in by walls and a ridge of stones, with a rocky peak adorning the center surmounted by a small domed temple and a stone altar. There's plenty of smooth mounds and rocks to make for some very fun jumping, and there is a very chilly looking pool of water to splash around in. Lit by the full moon and a scattering of torches, the map is fairly dark and dreary and it conveys a very gloomy atmosphere."
)

,array(
 0
,0
,'WDRAIL03 : Shinto Shrine'
,'http://dervish.tastyspleen.net/files/wddm03.zip' #Rail version: http://dervish.tastyspleen.net/files/wdrail03.zip
,'http://dervish.tastyspleen.net/maps.html'
,'http://dervish.tastyspleen.net/maps.html'
,array(135)
,1314825
,'DM TD' #1v1
,'Q2'
,'NO' #Rail
,"The Shinto Shrine, is probably my smoothest and most well thought-out map to date. The architecture is based on traditional Japanese castles and monastaries, and even though I had to fake a lot of the curves, I think the effect is quite pleasing and convincing.<BR>The map consists of 2 main areas, one of which holds a water-gate and a small gaurdhouse along with docks and such, while the other is a simple courtyard with a little covered structure that contains a very large gong. Connecting the two is a large keep-like building that acts as a focal point for both areas. The entire area is surronded by high castle walls with tiled rooftops."
)

,array(
 0
,0
,'WDRAIL04 : Insta Arena'
,'http://dervish.tastyspleen.net/files/wdrail04.zip'
,'http://dervish.tastyspleen.net/maps.html'
,'http://dervish.tastyspleen.net/maps.html'
,array(135)
,362732
,'DM' #Rails DM/Insta-gib/DM
,'Q2'
,'NO'
,"This map is primarily a large stadium with 3 levels that you can access via jump pad and teleporter. The bottom level is littered with crates to provide some cover and opportunities for surprising trickjumps. There are forcefields down there too, to funnel the action down the middle of the arena, and provide cover to the newly spawned near the large jump pads. The upper levels consist of 4 high platforms up in the nosebleed section, and a ring shaped catwalk that surrounds the arena."
)

,array(
 0
,0
,'WDDM05 : Vale of the Eldar'
,'http://dervish.tastyspleen.net/files/wddm05.zip'
,'http://dervish.tastyspleen.net/maps.html'
,'http://dervish.tastyspleen.net/maps.html'
,array(135)
,2940651
,'DM TD'
,'Q2'
,'NO'
,"I made this gothic themed map during a little downtime at work, and I was very happy with how it came out for how simple the brushwork and texturing were.<BR>I drew inspiration from Quake 1 and a little bit from the dead simple but incredibly playable AQ2 maps and I tried to make a small dueling map that would have as many opportunities for surprise attacks and direction changes as I could manage, while still being decent to look at.<BR><BR>It should work well for small FFA games, duels and even some itdm matches due to it's open areas and elevation changes."
)

,array(
 0
,0
,'WDDM06 : Down and Dirty'
,'http://dervish.tastyspleen.net/files/wddm06.zip'
,'http://dervish.tastyspleen.net/maps.html'
,'http://dervish.tastyspleen.net/maps.html'
,array(135)
,899957
,'DM TD'
,'Q2'
,'NO'
,"I created this Deathmatch map for the Quake 2 Cafe's most recent mapping contest (#5). The rules called for a regular deathmatch map using only stock textures, sounds and env. We had hoped to create a group of maps that looked and felt as if they were made during the early days of quake 2, before all of the custom resources were created and imported into the world of q2 mapping.<BR><BR>I am very proud to say that I received enough points to attain 2nd place in the contest, and I can't thank all of the judges and mappers enough, for helping to make the contest such a success.<BR><BR>As for the map, it's big and slightly complex at first glance, with plenty of twists and turns and ups and downs throughout the various hallways. The largest of the indooor atriums is a multilevel structure that acts as a focal point for many of the different routes in that area. It hides the mega health up in a tough to reach alcove, and the powerscreen on the small bridge over a channel of lava. The quad and BFG are tucked away in the lower area that sports large clunky machinery and lava pipelines along with an assortment of other useful items.<BR><BR>Nearer to the top level, there are lifts from the areas below, the RA, and another series of tight interconnecting hallways that tie the level up into an intricate knot of pathways, with one leading to the only outdoor area in the map."
)

,array(
 0
,0
,'WDDM07 : Equilibrium'
,'http://dervish.tastyspleen.net/files/wddm07.zip'
,'http://dervish.tastyspleen.net/maps.html'
,'http://dervish.tastyspleen.net/maps.html'
,array(135)
,2910858
,'DM TD' #1vs1
,'Q2'
,'NO'
,"I started working on this map, while I was practicing dueling, due to my entry into the NADL. I really developed a liking for a map called \"The Rage\" (ztn2dm3.bsp) because it is so well layed out for a tense dueling match, with 2 main areas that are relatively equal in terms of weapons, armor and health. In this map, I tried my best to imitate this style and layout while adding a bit more vertical action and a bit more room to work with while attacking/defending. I find a slightly more open game to be much more enjoyable as compared to a 15 minute match that's all corner shots and spamming.<BR><BR>The two arena areas, are stacked with weapons that should balance well against each other, and there are plenty of paths to choose from when launching a sneak attack, or running before a stacked opponent. I tried to make sure that the item balance was reasonably similar for every spawn point as well, to insure a more enjoyable game, even if you're losing. In addition, I tried to maximize the  movement speed in the halls by including ramps instead of those stupid staircases that everyone seems to enjoy putting in their maps. A side-effect of this is relatively low r_speeds in most areas, and those are definitely a good thing in a dueling map."
)

,array(
 0
,0
,'Rail Gun'
,'http://cybopat.net/download/maps/railgun.zip'
,'http://cybopat.net/quark.htm'
,'http://cybopat.net/quark.htm'
,array(136)
,1778868
,'DM TD' #FIXME: Guess
,'MOHAA' #FIXME: MOHAA Spearhead
,'NO' #FIXME: Objective Mod Map
,"Objective mapa pro MOHAA-Spearhead.<BR>Jeden objective cíl pro spojence - dalekonosné delo na vlakovém podvozku.<BR>Dve nálože - ke splnení mise stací znicit pouze jednu, jako v mape Bridge."
)

,array(
 0
,0
,'Bloody Snow'
,'http://cybopat.net/download/maps/bloody_snow.zip'
,'http://cybopat.net/quark.htm'
,'http://cybopat.net/quark.htm'
,array(136)
,856603
,'DM TD' #FIXME: Guess
,'MOHAA'
,'NO' #@Objective Mod Map
,"Objective mapa s dvemi cíly pro spojence."
)

,array(
 0
,0
,'Airport'
,'http://cybopat.net/download/maps/airport.zip'
,'http://cybopat.net/quark.htm'
,'http://cybopat.net/quark.htm'
,array(136)
,1165354
,'DM TD' #FIXME: Guess
,'KP'
,'NO'
,"Mapa pro mód Crash (obdoba CS pro Kingpina)."
)

,array(
 0
,0
,'Bunker War'
,'http://cybopat.net/download/maps/bunkerwar.zip'
,'http://cybopat.net/quark.htm'
,'http://cybopat.net/quark.htm'
,array(136)
,874684
,'DM TD' #FIXME: Guess
,'KP'
,'NO'
,"Mapa pro mód Bagman."
)

,array(
 0
,0
,'Bank'
,'http://cybopat.net/download/maps/bank.zip'
,'http://cybopat.net/quark.htm'
,'http://cybopat.net/quark.htm'
,array(136)
,1940893
,'DM TD' #FIXME: Guess
,'KP'
,'NO'
,"Deathmatch mapa."
)

,array(
 0
,0
,'Tomb'
,'http://cybopat.net/download/maps/tomb.zip'
,'http://cybopat.net/quark.htm'
,'http://cybopat.net/quark.htm'
,array(136)
,1062808
,'DM TD' #FIXME: Guess
,'KP'
,'NO'
,"Deathmatch mapa pro duel."
)

,array(
 0
,0
,'Symbol'
,'http://cybopat.net/download/maps/symbol.zip'
,'http://cybopat.net/quark.htm'
,'http://cybopat.net/quark.htm'
,array(136)
,1822219
,'DM TD' #FIXME: Guess
,'KP'
,'NO'
,"Deathmatch mapa pro duel."
)

,array(
 mktime(0, 0, 0, 6, 5, 2024)
,0
,'Test Me' #testie
,'https://archive.org/download/testie/testie.zip'
,null
,null
,array(140)
,32209
,'SP'
,'Q1'
,'NO'
,"My first ever 100% finished Quake map. Source included.

To do - Fix lighting bug!"
)

);
?>
