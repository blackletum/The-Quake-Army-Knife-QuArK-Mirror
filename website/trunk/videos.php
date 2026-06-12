<?php
require_once('_base_code.php');
require_once('_image_functions.php');
require_once('_language_functions.php');
require_once('_video-database.php');
require_once('_settings-database.php');

# Load language file
LoadLanguageFile('videos.php');

function parseQuery($query)
{
	if (!isset($_GET[$query]))
		return false;

	return ($_GET[$query] === 'on') or ($_GET[$query] === '1');
}

global $videotypeslist;
$videotypes = array();
$ALL = parseQuery('*');
foreach (array_keys($videotypeslist) as $videotype)
{
	if ($ALL or parseQuery($videotype)) $videotypes[] = $videotype;
}
if ($ALL)
	$videotypes[] = '*';
unset($ALL);

function getChecked($list, $item)
{
	if (in_array('*', $list))
		return 'checked ';
	if (in_array($item, $list))
		return 'checked ';
	return '';
}

$videosform = '<div class="centered">
<form action="videos.php" method="get">
<table cellspacing=0 cellpadding=0 align=center>
  <tr><td colspan=2 class="filterhead"><b>Types:</b></td></tr>
  <tr><td class="filterbody" valign=top align=left style="padding-left: 8px; padding-right: 8px;">
    <label><input '.getChecked($videotypes, 'TUTO').'type="checkbox" value="1" name="TUTO">Tutorials</label><br>
    <label><input '.getChecked($videotypes, 'DEMO').'type="checkbox" value="1" name="DEMO">Demonstrations</label><br>
    <label><input '.getChecked($videotypes, 'PREV').'type="checkbox" value="1" name="PREV">Previews</label>
  </td>
  <td class="filterbody" valign=top align=left style="padding-left: 8px; padding-right: 8px;">
    <label><input '.getChecked($videotypes, '?').'type="checkbox" value="1" name="?">Unknown</label>
  </td></tr>
  <tr><td colspan=2 class="filterbody" align=center>
    <label><input '.getChecked($videotypes, '*').'type="checkbox" value="1" name="*">Just show me for all types!</label>
  </td></tr>
  <tr><td colspan=2 align=center>
  <input type="submit" value="Show me">
  </td></tr>
</table>
</form>
Select at least one video type checkbox.
</div>
<p>Note: Some videos might be in compressed files (.zip, .rar, ...) or need special plugins or codecs to play properly.</p>';

function pageLocalDisplay()
{
	global $videosform, $videotypes;
	global $videotypeslist, $mediatypeslist;

	global $videosdatabase;

	global $mainroot;

	global $Settings;
	global $VideoPlayer;

	pageName('Videos');

	pagePanel('movies', 'Filter...', '', $videosform);

	if ($Settings[$VideoPlayer]->Value === 0)
	{
		echo '<a name="chooseplayer"></a>';
		$bodytext = '<p>To select the type of video player to use, please <a href="'.$mainroot.'choosevideoplayer.php">select your preference here</a>.</p>';
		pagePanel("movies", 'Choose video player', '', $bodytext);
	}

	if ($videotypes)
	{
		# First, find all the maps that match the filter options
		$SelectedVideos = array();

		for ($videono = 0; $videono < count($videosdatabase); $videono++)
		{
			$CurrentVideo = &$videosdatabase[$videono];
			if (count(array_intersect(explode(' ', $CurrentVideo->Type), $videotypes)) !== 0)
			{
				$SelectedVideos[] = $videono;
			}
		}

		$SelectedVideosCount = count($SelectedVideos);
		if ($SelectedVideosCount === 0)
		{
			$bodytext = '<p>No videos matching your filter options were found.</p>';
			pagePanel('community', 'Nothing to display', '', $bodytext);
		}
		else
		{
			# Display the videos
			for ($SelectedVideo = 0; $SelectedVideo < $SelectedVideosCount; $SelectedVideo++)
			{
				$CurrentVideo = &$videosdatabase[$SelectedVideos[$SelectedVideo]];

				$bodytext = array();

				if (!is_null($CurrentVideo->Screenshot))
				{
					$bodytext1 = '<div style="float: right;">';

					if (!is_null($CurrentVideo->Link))
						$bodytext1 .= '<a href="showvideo.php?VideoID='.($SelectedVideos[$SelectedVideo]+1).'">';
					$bodytext1 .= DisplayRawImage($CurrentVideo->Screenshot);
					if (!is_null($CurrentVideo->Link))
						$bodytext1 .= '</a>';

					$bodytext1 .= '</div>';

					$bodytext[] = $bodytext1;
					unset($bodytext1);
				}

				if (!is_null($CurrentVideo->Length))
					$bodytext[] = '<b>Video length</b>: ' . $CurrentVideo->Length;
				else
					$bodytext[] = '<b>Video length</b>: unknown';
				$bodytext[] = '<b>Movie format</b>: ' . $mediatypeslist[$CurrentVideo->Mediatype];
				if (!is_null($CurrentVideo->Codecs))
					$bodytext[] = '<b>Used codec(s)</b>: ' . $CurrentVideo->Codecs;
				if ($CurrentVideo->FileSize !== 0)
					$bodytext[] = '<b>File size</b>: ' . DisplayByteSize($CurrentVideo->FileSize);

				if ($CurrentVideo->DatePublished !== 0)
					$bodytext[] = '<b>Published</b>: ' . DisplayDate($CurrentVideo->DatePublished);
				if (!is_null($CurrentVideo->Author))
				{
					if (!is_null($CurrentVideo->EmailAuthor))
					{
						$bodytext[] = '<b>Author</b>: <a href=' . DisplayEncodedEmail($CurrentVideo->EmailAuthor) . '>' . $CurrentVideo->Author . '</a>';
					}
					else
					{
						$bodytext[] = '<b>Author</b>: '.$CurrentVideo->Author;
					}
				}
				if (!is_null($CurrentVideo->Website))
					$bodytext[] = '<b>Website</b>: <a href="' . $CurrentVideo->Website . '">'.$CurrentVideo->Website.'</a>';

				if (!is_null($CurrentVideo->Description))
					$bodytext[] = '<p><b>Description</b>:<br>' . $CurrentVideo->Description . '</p>';

				$found_a_link = false;
				if (!is_null($CurrentVideo->Link))
				{
					$found_a_link = true;
					$bodytext[] = '<a href="showvideo.php?VideoID='.($SelectedVideos[$SelectedVideo]+1).'">Play this movie!</a>';
				}
				if (!is_null($CurrentVideo->DownloadLink))
				{
					$found_a_link = true;
					$bodytext[] = '<a href="' . $CurrentVideo->DownloadLink . '">Download this movie!</a>';
				}
				if (!$found_a_link)
				{
					$bodytext[] = 'No play/download link';
				}

				pagePanel('community', $CurrentVideo->Name, $videotypeslist[$CurrentVideo->Type], join('<br>', $bodytext));
			}
		}
	}
	else
	{
		$bodytext = '<p>Please select at least one video type!</p>';
		pagePanel('alert', 'Nothing to display', '', $bodytext);
	}
}

pageDisplay('Videos', 'pageLocalDisplay');

?>
