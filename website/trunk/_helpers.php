<?php
//PHP is still missing a build-in function that can return the length of a string in characters, so let's make our own.
function strclen(string $string): int
{
	//If "mbstring" is installed, use that
	if (function_exists('mb_strlen'))
	{
		if (version_compare(phpversion(), '8.0.0', '<'))
		{
			return mb_strlen($string, mb_internal_encoding());
		}
		else
		{
			return mb_strlen($string);
		}
	}

	//If "iconv" is installed, use that
	if (function_exists('iconv_strlen'))
	{
		if (version_compare(phpversion(), '8.0.0', '<'))
		{
			$len = iconv_strlen($string, iconv.internal_encoding);
		}
		else
		{
			$len = iconv_strlen($string);
		}
		if ($len === false)
		{
			if (version_compare(phpversion(), '7.0.0', '<'))
			{
				throw new Exception('Invalid string');
			}
			elseif (version_compare(phpversion(), '8.0.0', '<'))
			{
				throw new TypeError('Invalid string');
			}
			else
			{
				throw new ValueError('Invalid string');
			}
		}
		return $len;
	}

	//Fall back to strlen
	return strlen($string);
}

function StringLeft(string $string, int $length)
{
	return substr($string, 0, $length);
}

function StringRight(string $string, int $length)
{
	return substr($string, strclen($string) - $length, $length);
}

function MultiExplode(&$string, $delimiters)
{
	//Based on: https://stackoverflow.com/a/27767665
	$tmp = str_replace($delimiters, $delimiters[0], $string);
	return explode($delimiters[0], $tmp);
}

//Based on: Symfony Polyfill
if (version_compare(phpversion(), '8.0.0', '<'))
{
	function str_contains($haystack, $needle)
	{
		return strpos($haystack, $needle) !== FALSE;
	}

	function str_starts_with($string, $needle)
	{
		return strncmp($string, $needle, strclen($needle)) === 0;
	}

	function str_ends_with($string, $needle)
	{
		return substr_compare($string, $needle, -strclen($needle)) === 0;
	}
}

function in_cidrv4($needle, $haystack_first, $haystack_last)
{
	return (ip2long($haystack_first) <= ip2long($needle)) and (ip2long($needle) <= ip2long($haystack_last));
}

//This function is missing, even in PHP 8.4
//Based on: https://www.php.net/manual/en/function.parse-url.php#106731
function unparse_url($parsed_url) //Note: PHP doesn't allow this to be passed by reference?
{
	$scheme   = isset($parsed_url['scheme']) ? $parsed_url['scheme'] . '://' : '';
	$host     = isset($parsed_url['host']) ? $parsed_url['host'] : '';
	$port     = isset($parsed_url['port']) ? ':' . $parsed_url['port'] : '';
	$user     = isset($parsed_url['user']) ? $parsed_url['user'] : '';
	$pass     = isset($parsed_url['pass']) ? ':' . $parsed_url['pass']  : '';
	$pass     = ($user || $pass) ? "$pass@" : '';
	$path     = isset($parsed_url['path']) ? $parsed_url['path'] : '';
	$query    = isset($parsed_url['query']) ? '?' . $parsed_url['query'] : '';
	$fragment = isset($parsed_url['fragment']) ? '#' . $parsed_url['fragment'] : '';
	return "$scheme$user$pass$host$port$path$query$fragment";
}

//PHP (still) doesn't have a function to parse Accept-headers, so we have to do it ourselves.
function parseAcceptHeader($header)
{
	$result = array();
	while (strclen($header) !== 0)
	{
		$index = strpos($header, ';q=');
		if ($index === false)
		{
			$foundItem = $header;
			$foundWeight = 1.0;
			$header = '';
		}
		else
		{
			$foundItem = StringLeft($header, $index);
			$header = substr($header, $index + strclen(';q='));
			$index = strpos($header, ',');
			if ($index === false)
			{
				$foundWeight = floatval(trim($header));
				$header = '';
			}
			else
			{
				$foundWeight = floatval(trim(StringLeft($header, $index)));
				$header = substr($header, $index + strclen(','));
			}
		}
		foreach (explode(',', $foundItem) as $foundItemX)
		{
			$result[trim($foundItemX)] = $foundWeight;
		}
	}
	return $result;
}
?>