<?php
require_once('_base_code.php');
require_once('_language_functions.php');
require_once('_news_functions.php');
require_once('_news-database.php');

# Load language file
LoadLanguageFile('archivednews.php');

function pageLocalDisplay()
{
	$CurTime = time(); //Only retrieve this once to prevent race conditions.

	global $OldestNewsYear, $OldestNewsMonth;

	$newsperiod = isset($_GET['newsperiod']) ? $_GET['newsperiod'] : null;
	if (!is_null($newsperiod))
	{
		if (strclen($newsperiod) === 6)
		{
			$newsyear = intval(substr($newsperiod, 0, 4));
			$newsmonth = intval(substr($newsperiod, 4, 2));
			if (($newsyear < $OldestNewsYear) || ($newsmonth < 1) || ($newsmonth > 12) || ($newsyear === $OldestNewsYear && $newsmonth < $OldestNewsMonth))
			{
				//Invalid date
				$newsperiod = null;
				unset($newsyear);
				unset($newsmonth);
			}
			else
			{
				if (($newsyear > intval(date('Y', $CurTime))) || ($newsyear === intval(date('Y', $CurTime)) && $newsmonth > intval(date('m', $CurTime))))
				{
					//Reject future date
					$newsperiod = null;
					unset($newsyear);
					unset($newsmonth);
				}
			}
		}
		else
		{
			//Invalid date
			$newsperiod = null;
		}
	}
	if (is_null($newsperiod))
	{
		//No or invalid period requested. Use the current month instead.
		$newsyear = intval(date('Y', $CurTime));
		$newsmonth = intval(date('m', $CurTime));
	}
	unset($newsperiod); //No longer required or correct; prevent accidental further usage.

	if (isset($newsyear) && isset($newsmonth))
	{
		$month = date('F', mktime(0, 0, 0, $newsmonth, 1, $newsyear));
		pageName('Archived News of ' . $month . ' ' . $newsyear);
	}
	else
		pageName('Archived News'); //Note: Dead code

	$filterpanel = '<form action="archivednews.php" method="get">Select year and month of archived news: <select name="newsperiod">';

	$LastDate = mktime(0, 0, 0, $OldestNewsMonth, 1, $OldestNewsYear);
	$year = intval(date('Y', $CurTime));
	$month = intval(date('m', $CurTime));
	do
	{
		$somedate = mktime(0, 0, 0, $month, 1, $year);
		if (intval(date('Y', $somedate)) === $newsyear && intval(date('m', $somedate)) === $newsmonth)
			$selected = ' selected';
		else
			$selected = '';
		$NRArticles = countArchiveNews(mktime(0, 0, 0, $month+1, 0, $year), $somedate);
		$filterpanel .= '<option' . $selected . ' value="' . date('Ym', $somedate) . '">' . date('Y F', $somedate) . ' (' . $NRArticles . ')';
		$month--;
		if ($month === 0)
		{
			$month = 12;
			$year--;
		}
	}
	while ($somedate > $LastDate); #Note: Not including 'equal' case, because somedate is still pointing to the current iteration.

	$filterpanel .= '</select>&nbsp;&nbsp;<input type="submit" value="Show me"></form>';

	if (($newsyear > $OldestNewsYear) || ($newsyear === $OldestNewsYear && $newsmonth > $OldestNewsMonth))
	{
		$somedate = mktime(0, 0, 0, $newsmonth - 1, 1, $newsyear);
		$prevbutton = '<form action="archivednews.php" method="get"><input type="hidden" name="newsperiod" value="' . date('Ym', $somedate) . '"><input type="submit" value="&lt;--- Prev month"></form>';
	} else
		$prevbutton = '';
	if (($newsyear < intval(date('Y', $CurTime))) || ($newsyear === intval(date('Y', $CurTime)) && $newsmonth < intval(date('m', $CurTime))))
	{
		$somedate = mktime(0, 0, 0, $newsmonth + 1, 1, $newsyear);
		$nextbutton = '<form action="archivednews.php" method="get"><input type="hidden" name="newsperiod" value="' . date('Ym', $somedate) . '"><input type="submit" value="Next month ---&gt;"></form>';
	} else
		$nextbutton = '';
	$bottombuttons = '<table align=center cellspacing=0 cellpadding=0><tr><td>'.$prevbutton.'</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>'.$nextbutton.'</td></tr></table>';

	#if (true) {
		$topbuttons = '<table cellspacing=8 cellpadding=0 width="100%"><tr><td align=left>'.$prevbutton.'</td><td align=center>'.$filterpanel.'</td><td align=right>'.$nextbutton.'</td></tr></table>';
	#} else {
	#  $topbuttons = $filterpanel;
	#}

	pagePanel(null, 'Select...', '', $topbuttons);

	if (isset($newsyear) && isset($newsmonth))
	{
		if (displayArchiveNews(mktime(0, 0, 0, $newsmonth+1, 0, $newsyear), mktime(0, 0, 0, $newsmonth, 1, $newsyear)) > 0)
			pagePanel(null, '', '', $bottombuttons);
	}
}

pageDisplay('Archived News', 'pageLocalDisplay');

?>
