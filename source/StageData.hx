package;

import openfl.utils.Assets;
import Song.SwagSong;
import haxe.Json;

using StringTools;

// sorry guys i just wanted to do shit fast
typedef SwagStage =
{
	var directory:String;
	var defaultZoom:Float;
	var isPixelStage:Bool;

	var boyfriend:Array<Dynamic>;
	var girlfriend:Array<Dynamic>;
	var opponent:Array<Dynamic>;
	var camera_boyfriend:Array<Float>;
	var camera_opponent:Array<Float>;
	var camera_girlfriend:Array<Float>;
}

class StageData
{
	public static var currentStage:SwagStage;
	public static var forceNextDirectory:String;

	public static function loadDirectory(SONG:SwagSong)
	{
		var stage:String = '';
		if (SONG.stage != null)
			stage = SONG.stage;
		else if (SONG.song != null)
		{
			switch (Paths.formatToSongPath(SONG.song))
			{
				case 'spookeez' | 'south' | 'monster':
					stage = 'spooky';
				case 'pico' | 'blammed' | 'philly' | 'philly-nice':
					stage = 'philly';
				case 'milf' | 'satin-panties' | 'high':
					stage = 'limo';
				case 'cocoa' | 'eggnog':
					stage = 'mall';
				case 'winter-horrorland':
					stage = 'mallEvil';
				case 'senpai' | 'roses':
					stage = 'school';
				case 'thorns':
					stage = 'schoolEvil';
				default:
					stage = 'stage';
			}
		}
		else
		{
			stage = 'stage';
		}

		var stageFile:SwagStage = loadFromJson(stage);
		currentStage = stageFile;
		if (stageFile == null)
			forceNextDirectory = '';
		else
			forceNextDirectory = stageFile.directory;
	}

	public static function loadFromJson(stage:String):SwagStage
	{
		return cast Json.parse(Assets.getText(Paths.getPath('stages/' + stage + '.json', TEXT)).trim());
	}
}
