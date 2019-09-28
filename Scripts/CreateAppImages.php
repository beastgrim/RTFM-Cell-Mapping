<?php

$SOURCE_ROOT = $_ENV['SOURCE_ROOT'];
$ASSETS_PATH = '/RTFM/Assets.xcassets';


function rglob($pattern, $flags = 0) {
    $files = glob($pattern, $flags); 
    foreach (glob(dirname($pattern).'/*', GLOB_ONLYDIR|GLOB_NOSORT) as $dir) {
        $files = array_merge($files, rglob($dir.'/'.basename($pattern), $flags));
    }
    return $files;
}

$ROOT_KEY = '______root_______';

$struct = [];

$files = array_filter(rglob($ASSETS_PATH.'/*{.imageset}', GLOB_BRACE), 'is_dir');
foreach($files as $filePath) {
	$name = str_replace([$ASSETS_PATH.'/', '.imageset'], ['', ''], $filePath);
	$content = json_decode(file_get_contents($filePath.'/Contents.json'), true);
	if (!is_array($content) || !is_array($content['images']) || count($content['images']) == 0) {
		echo "ERROR with ".$name.' asset! Images not found.';
		exit(1);
	}

	$array = &$struct;
	$dirs = explode('/', $name);

	foreach ($dirs as $index => $dir) {
		// if ($index == 0 && count($dirs) == 1) {
		// 	$array = &$struct[$ROOT_KEY];
		// } 

		if ($index == count($dirs) - 1) {
			if (empty($array[$ROOT_KEY])) {
				$array[$ROOT_KEY] = [];
			}
			$array[$ROOT_KEY][] = $dir;
		} else {
			if (empty($array[$dir])) {
				$array[$dir] = [];
			}
			$array = &$array[$dir];
		}
	}
}

function createStruct($struct, $name, $tab = '') {
	global $ROOT_KEY;

	ksort($struct);

	$CODE = '';
	foreach ($struct as $key => $value) {
		if ($key == $ROOT_KEY) {
			continue;
		}

		$structName = str_replace(['-', '_'], '', ucwords($key));
		$structName[0] = strtolower($structName);

		$CODE .= createStruct($value, $key, $tab.'    ').PHP_EOL.PHP_EOL;
	}

	$structName = 'FA'.$name;

	if (isset($struct[$ROOT_KEY])) {
		sort($struct[$ROOT_KEY]);
		foreach ($struct[$ROOT_KEY] as $value) {
			$varName = str_replace($name, '', $value);
			$varName = str_replace(['-', '_'], '', ucwords($varName));
			$varName[0] = strtolower($varName);

			$isSelected = strpos($value, '-Dark');
			$hasSelected = in_array($value.'-Dark', $struct[$ROOT_KEY]);

			if ($isSelected) {
				$CODE .= $tab.'    var '.$varName.': UIImage { return Application.shared.appearance.isDark ? UIImage(named: "'.str_replace('-Dark', '', $value).'")! : UIImage(named: "'.$value.'")! }'.PHP_EOL;
			} elseif ($hasSelected) {
				$CODE .= $tab.'    var '.$varName.': UIImage { return Application.shared.appearance.isDark ? UIImage(named: "'.$value.'-Dark")! : UIImage(named: "'.$value.'")! }'.PHP_EOL;
			} else {
				$CODE .= $tab.'    var '.$varName.': UIImage { return UIImage(named: "'.$value.'")! }'.PHP_EOL;
			}
		}
	}
	$CODE = substr($CODE, 0, -1);


$BREAK = '';
if ($tab == '') {
	$BREAK = PHP_EOL;
}

$CODE = <<<SWIFT
{$tab}let {$name} = {$structName}() {$BREAK}
{$tab}struct {$structName} { {$BREAK}
{$CODE} {$BREAK}
{$tab}}
SWIFT;

	return $CODE;
}

$CODE = createStruct($struct, 'AppImages');

// ksort($struct);
// foreach ($struct as $key => $value) {
// 	var_dump($value);
// }


$CODE = <<<SWIFT
//
//  AppImages.swift
//  RTFM
//
//  Created by Evgeny Bogomolov AUTOMATIC
//
//  DON'T CHANGE ANYTHING
//
//  Copyright © 2019 FaceApp. All rights reserved.
//

{$CODE}

SWIFT;

// file_put_contents($SOURCE_ROOT.'/RTFM/AppImages.swift', $CODE.PHP_EOL);
file_put_contents('RTFM/AppImages.swift', $CODE.PHP_EOL);

// var_dump($struct);


