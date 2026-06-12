<?php
require_once('_base_code.php');
require_once('_language_functions.php');
require_once('_usermaps-database.php');
require_once('_people-database.php');

# Load language file
LoadLanguageFile('usermaps.php');

if (isset($_GET['page']))
{
	$page = intval($_GET['page']) - 1;
	if ($page < 0)
		$page = 0;
}
else
{
	$page = 0;
}

function parseQuery($query)
{
	if (!isset($_GET[$query]))
		return false;

	return ($_GET[$query] === 'on') or ($_GET[$query] === '1');
}

global $gameslist;
$games = array();
$ALL = parseQuery('*');
foreach (array_keys($gameslist) as $game)
{
	if ($ALL or parseQuery($game)) $games[] = $game;
}
if ($ALL)
	$games[] = '*';
unset($ALL);

global $modslist;
$mods = array();
$M_ALL = parseQuery('M_*');
foreach (array_keys($modslist) as $mod)
{
	if ($M_ALL or parseQuery('M_'.$mod)) $mods[] = $mod;
}
if ($M_ALL)
	$mods[] = '*';
unset($M_ALL);

global $maptypeslist;
$maptypes = array();
$T_ALL = parseQuery('T_*');
foreach (array_keys($maptypeslist) as $maptype)
{
	if ($T_ALL or parseQuery('T_'.$maptype)) $maptypes[] = $maptype;
}
if ($T_ALL)
	$maptypes[] = '*';
unset($T_ALL);

function getChecked($list, $item)
{
	if (in_array('*', $list))
		return 'checked ';
	if (in_array($item, $list))
		return 'checked ';
	return '';
}

$usermapsform = "<div class=\"centered\">
<form action=\"usermaps.php\" method=\"get\">
<table cellspacing=2 cellpadding=0 align=center>
  <tr><td valign=top style=\"padding-left: 8px; padding-right: 8px;\">
    <table cellspacing=0 cellpadding=0>
      <tr><td colspan=2 class=\"filterhead\"><b>Games:</b></td></tr>
      <tr><td class=\"filterbody\" valign=top align=left style=\"padding-left: 8px; padding-right: 8px;\">
        <label><input ".getChecked($games, 'Q1') ."type=\"checkbox\" value=\"1\" name=\"Q1\" >Quake 1</label><br>
        <label><input ".getChecked($games, 'Q2') ."type=\"checkbox\" value=\"1\" name=\"Q2\" >Quake 2</label><br>
        <label><input ".getChecked($games, 'Q3') ."type=\"checkbox\" value=\"1\" name=\"Q3\" >Quake 3: Arena</label><br>
        <label><input ".getChecked($games, 'Q4') ."type=\"checkbox\" value=\"1\" name=\"Q4\" >Quake 4</label><br>
        <label><input ".getChecked($games, 'CS') ."type=\"checkbox\" value=\"1\" name=\"CS\" >Counter-Strike</label><br>
        <label><input ".getChecked($games, 'D3') ."type=\"checkbox\" value=\"1\" name=\"D3\" >Doom 3</label><br>
        <label><input ".getChecked($games, 'HL') ."type=\"checkbox\" value=\"1\" name=\"HL\" >Half-Life</label><br>
        <label><input ".getChecked($games, 'HL2')."type=\"checkbox\" value=\"1\" name=\"HL2\">Half-Life 2</label><br>
        <label><input ".getChecked($games, 'HX2')."type=\"checkbox\" value=\"1\" name=\"HX2\">Hexen II</label>
      </td>
      <td class=\"filterbody\" valign=top align=left style=\"padding-left: 8px; padding-right: 8px;\">
        <label><input ".getChecked($games, 'HR2')  ."type=\"checkbox\" value=\"1\" name=\"HR2\"  >Heretic 2</label><br>
        <label><input ".getChecked($games, 'KP')   ."type=\"checkbox\" value=\"1\" name=\"KP\"   >Kingpin</label><br>
        <label><input ".getChecked($games, 'MOHAA')."type=\"checkbox\" value=\"1\" name=\"MOHAA\">Medal of Honor</label><br>
        <label><input ".getChecked($games, 'SIN')  ."type=\"checkbox\" value=\"1\" name=\"SIN\"  >SiN</label><br>
        <label><input ".getChecked($games, 'SOF')  ."type=\"checkbox\" value=\"1\" name=\"SOF\"  >Soldier of Fortune</label><br>
        <label><input ".getChecked($games, 'EF')   ."type=\"checkbox\" value=\"1\" name=\"EF\"   >Star Trek Voyager: Elite Force</label><br>
        <label><input ".getChecked($games, 'EF2')  ."type=\"checkbox\" value=\"1\" name=\"EF2\"  >Star Trek: Elite Force 2</label><br>
        <label><input ".getChecked($games, '?')    ."type=\"checkbox\" value=\"1\" name=\"?\"    >Unknown</label>
      </td></tr>
      <tr><td colspan=2 class=\"filterbody\" align=center>
        <label><input ".getChecked($games, '*')."type=\"checkbox\" value=\"1\" name=\"*\">Just show me for all games!</label>
      </td></tr>
    </table>
  </td>
  <td valign=top style=\"padding-left: 8px; padding-right: 8px;\"><b>and</b></td>
  <td valign=top style=\"padding-left: 8px; padding-right: 8px;\">
    <table cellspacing=0 cellpadding=0>
      <tr><td colspan=2 class=\"filterhead\"><b>Mods:</b></td></tr>
      <tr><td class=\"filterbody\" valign=top align=left style=\"padding-left: 8px; padding-right: 8px;\">
        <label><input ".getChecked($mods, 'NO') ."type=\"checkbox\" value=\"1\" name=\"M_NO\" >Vanilla game (no mods)</label><br>
        <label><input ".getChecked($mods, 'RA') ."type=\"checkbox\" value=\"1\" name=\"M_RA\" >Rocket Arena 'Q2'</label><br>
        <label><input ".getChecked($mods, 'TFC')."type=\"checkbox\" value=\"1\" name=\"M_TFC\">Team Fortress 'Q1/HL'</label><br>
        <label><input ".getChecked($mods, 'ACT')."type=\"checkbox\" value=\"1\" name=\"M_ACT\">Action 'Q2/HL'</label><br>
        <label><input ".getChecked($mods, 'AIR')."type=\"checkbox\" value=\"1\" name=\"M_AIR\">AirQuake 'Q1/Q2'</label>
      </td>
      <td class=\"filterbody\" valign=top align=left style=\"padding-left: 8px; padding-right: 8px;\">
        <label><input ".getChecked($mods, 'GLM') ."type=\"checkbox\" value=\"1\" name=\"M_GLM\" >Gloom 'Q2'</label><br>
        <label><input ".getChecked($mods, 'OP4') ."type=\"checkbox\" value=\"1\" name=\"M_OP4\" >Opposing Forces 'HL'</label><br>
        <label><input ".getChecked($mods, 'KMQ2')."type=\"checkbox\" value=\"1\" name=\"M_KMQ2\">Knightmare 'Q2'</label><br>
        <label><input ".getChecked($mods, '?')   ."type=\"checkbox\" value=\"1\" name=\"M_?\"   >Unknown</label>
      </td></tr>
      <tr><td colspan=2 class=\"filterbody\" align=center>
        <label><input ".getChecked($mods, '*')."type=\"checkbox\" value=\"1\" name=\"M_*\">Just show me for all mods!</label>
      </td></tr>
    </table>
  </td>
  <td valign=top style=\"padding-left: 8px; padding-right: 8px;\"><b>and</b></td>
  <td valign=top style=\"padding-left: 8px; padding-right: 8px;\">
    <table cellspacing=0 cellpadding=0>
      <tr><td colspan=2 class=\"filterhead\"><b>Maptypes:</b></td></tr>
      <tr><td class=\"filterbody\" valign=top align=left style=\"padding-left: 8px; padding-right: 8px;\">
        <label><input ".getChecked($maptypes, 'SP')  ."type=\"checkbox\" value=\"1\" name=\"T_SP\"  >Single player</label><br>
        <label><input ".getChecked($maptypes, 'COOP')."type=\"checkbox\" value=\"1\" name=\"T_COOP\">Cooperative</label><br>
        <label><input ".getChecked($maptypes, 'DM')  ."type=\"checkbox\" value=\"1\" name=\"T_DM\"  >Deathmatch</label><br>
        <label><input ".getChecked($maptypes, 'TP')  ."type=\"checkbox\" value=\"1\" name=\"T_TP\"  >Teamplay</label>
      </td>
      <td class=\"filterbody\" valign=top align=left style=\"padding-left: 8px; padding-right: 8px;\">
        <label><input ".getChecked($maptypes, 'TD')  ."type=\"checkbox\" value=\"1\" name=\"T_TD\"  >Team deathmatch</label><br>
        <label><input ".getChecked($maptypes, 'TOUR')."type=\"checkbox\" value=\"1\" name=\"T_TOUR\">Tourney</label><br>
        <label><input ".getChecked($maptypes, 'CTF') ."type=\"checkbox\" value=\"1\" name=\"T_CTF\" >Capture the Flag</label><br>
        <label><input ".getChecked($maptypes, '?')   ."type=\"checkbox\" value=\"1\" name=\"T_?\"   >Unknown</label>
      </td></tr>
      <tr><td colspan=2 class=\"filterbody\" align=center>
        <label><input ".getChecked($maptypes, '*')."type=\"checkbox\" value=\"1\" name=\"T_*\">Just show me for all maptypes!</label>
      </td></tr>
    </table>
  </td>
  </tr>
  <tr><td colspan=9 align=center>
  <input type=\"submit\" value=\"Show me\">
  </td></tr>
</table>
</form>
Select minimum a game checkbox, mod checkbox, <u>and</u> a maptype checkbox, to view the list of maps.
</div>
";

function pageLocalDisplay()
{
	global $usermapsform, $games, $maptypes, $mods;
	global $gameslist, $maptypeslist, $modslist;

	global $userlevelsdatabase;
	global $mapname_arraycol;
	global $maptype_arraycol;
	global $game_arraycol;
	global $mod_arraycol;
	global $screenshot_arraycol;
	global $description_arraycol;
	global $download_arraycol;
	global $size_arraycol;
	global $author_arraycol;
	global $website_arraycol;

	global $personsdatabase;

	pageName('User maps');

	pagePanel(null, 'Filter...', '', $usermapsform);

	if ($games && $maptypes && $mods)
	{
		global $page;

		# This is used for the next/prev button panel
		$listhidden = '';
		foreach (array_keys($gameslist) as $game)
		{
			if (in_array($game, $games))
				$listhidden .= '<input type="hidden" name="'.$game.'" value="1">';
		}
		foreach (array_keys($maptypeslist) as $maptype)
		{
			if (in_array($maptype, $maptypes))
				$listhidden .= '<input type="hidden" name="T_'.$maptype.'" value="1">';
		}
		foreach (array_keys($modslist) as $mod)
		{
			if (in_array($mod, $mods))
				$listhidden .= '<input type="hidden" name="M_'.$mod.'" value="1">';
		}

		# First, find all the maps that match the filter options
		$SelectedMaps = array();

		for ($mapno = 0; $mapno < count($userlevelsdatabase); $mapno++)
		{
			$CurrentUserMap = &$userlevelsdatabase[$mapno];
			if ((count(array_intersect(explode(' ', $CurrentUserMap[$game_arraycol]), $games)) !== 0) && (count(array_intersect(explode(' ', $CurrentUserMap[$maptype_arraycol]), $maptypes)) !== 0) && (count(array_intersect(explode(' ', $CurrentUserMap[$mod_arraycol]), $mods)) !== 0))
			{
				$SelectedMaps[] = $mapno;
			}
		}

		$SelectedMapsCount = count($SelectedMaps);
		if ($SelectedMapsCount === 0)
		{
			$bodytext = '<p>No user maps matching your filter options were found.</p>';
			pagePanel('community', 'Nothing to display', '', $bodytext);
		}
		else
		{
			global $Settings;
			global $UserMapsPageSize;
			$mapsperpage = $Settings[$UserMapsPageSize]->GetCurrentValue();

			$max_page = (floor(($SelectedMapsCount + $mapsperpage - 1) / $mapsperpage)) - 1;

			if (($page * $mapsperpage) > $SelectedMapsCount)
			{
				$page = 0;
			}

			#FIXME: Allow to disable paging!
			if ($SelectedMapsCount > $mapsperpage)
			{
				# If needed, display the top paging panel
				if ($page > 0)
				{
					$prevbutton = '<form action="usermaps.php" method="get">'.$listhidden.'<input type="hidden" name="page" value="' . ($page + 1 - 1) . '"><input type="submit" value="&lt;--- Prev page"></form>';
				}
				else
				{
					$prevbutton = '';
				}
				if ($page < $max_page)
				{
					$nextbutton = '<form action="usermaps.php" method="get">'.$listhidden.'<input type="hidden" name="page" value="' . ($page + 1 + 1) . '"><input type="submit" value="Next page ---&gt;"></form>';
				}
				else
				{
					$nextbutton = '';
				}
				$filterpanel = ''; #$listhidden
				#FIXME: TEMP:
				$filterpanel = 'Page: ' . ($page + 1) . ' / ' . ($max_page + 1);

				$pagepaneltext = '<table cellspacing=8 cellpadding=0 width="100%"><tr><td align=left>'.$prevbutton.'</td><td align=center>'.$filterpanel.'</td><td align=right>'.$nextbutton.'</td></tr></table>';
				pagePanel(null, 'Select...', '', $pagepaneltext);
			}

			# Display the maps
			for ($SelectedMap = $page * $mapsperpage; $SelectedMap < (($page + 1) * $mapsperpage); $SelectedMap++)
			{
				if ($SelectedMap === $SelectedMapsCount)
					# Done all the maps that need to be done (this page is not full)
					break;
				$CurrentUserMap = &$userlevelsdatabase[$SelectedMaps[$SelectedMap]];

				$bodytext = '<table cellspacing="2px" cellpadding=0>';

				$bodytext .= '<tr><td>';
				$bodytext .= 'Maptype:';
				$bodytext .= '</td><td>';
				$currentmaptypes = explode(' ', $CurrentUserMap[$maptype_arraycol]);
				for ($i = 0; $i < count($currentmaptypes); $i++)
				{
					if ($i !== 0)
						$bodytext .= '<br>';
					$bodytext .= $maptypeslist[$currentmaptypes[$i]];
				}
				$bodytext .= '</td></tr>';

				if (!is_null($CurrentUserMap[$screenshot_arraycol]))
				{
					$bodytext .= '<tr><td>';
					$bodytext .= 'Screenshot:';
					$bodytext .= '</td><td>';
					$bodytext .= '<a rel="noopener" target="_blank" href="' . $CurrentUserMap[$screenshot_arraycol] . '">Click here</a>';
					$bodytext .= '</td></tr>';
				}

				$bodytext .= '<tr><td>';
				$bodytext .= 'Size:';
				$bodytext .= '</td><td>';
				if (is_null($CurrentUserMap[$size_arraycol]))
					$bodytext .= '*unknown*';
				else
					$bodytext .= DisplayByteSize($CurrentUserMap[$size_arraycol]);
				$bodytext .= '</td></tr>';

				$bodytext .= '<tr><td>';
				$bodytext .= '<b>Download</b>:';
				$bodytext .= '</td><td>';
				if (is_null($CurrentUserMap[$download_arraycol]))
					$bodytext .= '*no link*';
				else
					$bodytext .= '<a rel="noopener" target="_blank" href="' . $CurrentUserMap[$download_arraycol] . '">Click here</a>';
				$bodytext .= '</td></tr>';

				$bodytext .= '<tr><td>';
				$bodytext .= '&nbsp;';
				$bodytext .= '</td><td>';
				$bodytext .= '&nbsp;';
				$bodytext .= '</td></tr>';

				if (!is_null($CurrentUserMap[$author_arraycol]))
				{
					$bodytext .= '<tr><td>';
					$bodytext .= 'Author:';
					$bodytext .= '</td><td>';
					for ($i = 0; $i < count($CurrentUserMap[$author_arraycol]); $i++)
					{
						if ($i !== 0)
						{
							$bodytext .= '<br>';
						}
						$PersonIndex = $CurrentUserMap[$author_arraycol][$i];
						$CurrentPerson = &$personsdatabase[$PersonIndex]; //FIXME: Check for bounds?
						$bodytext .= '<a href="person.php?PersonID='.($PersonIndex+1).'">'.$CurrentPerson->getDisplayName().'</a>'; //FIXME: Need to escape HTML entities!!! EVERYWHERE!!!
					}
					$bodytext .= '</td></tr>';
				}

				if (!is_null($CurrentUserMap[$website_arraycol]))
				{
					$bodytext .= '<tr><td>';
					$bodytext .= 'Website:';
					$bodytext .= '</td><td>';
					$bodytext .= '<a rel="noopener" target="_blank" href="' . $CurrentUserMap[$website_arraycol] . '">Website</a>';
					$bodytext .= '</td></tr>';
				}

				$bodytext .= '</table>';

				$bodytext .= '<br>';

				$bodytext .= '<p>Description:<br>';
				if (is_null($CurrentUserMap[$description_arraycol]))
				{
					$bodytext .= '-';
				}
				else
				{
					$bodytext .= $CurrentUserMap[$description_arraycol];
				}
				$bodytext .= '</p>';

				pagePanel('community', $CurrentUserMap[$mapname_arraycol], $gameslist[$CurrentUserMap[$game_arraycol]], $bodytext);
			}

			if ($SelectedMapsCount > $mapsperpage)
			{
				# Display bottom paging panel
				$pagepaneltext = '<table cellspacing=8 cellpadding=0 width="100%"><tr><td align=left>'.$prevbutton.'</td><td align=right>'.$nextbutton.'</td></tr></table>';
				pagePanel(null, '', '', $pagepaneltext);
			}
		}
	}
	else
	{
		$bodytext = '<p>Please select both at least one game, mod, <u>and</u> maptype!</p>';
		pagePanel('alert', 'Nothing to display', '', $bodytext);
	}
}

pageDisplay('User maps', 'pageLocalDisplay');

?>
