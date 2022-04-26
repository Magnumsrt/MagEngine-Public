package;

import Song.SwagSong;
import haxe.Json;
import lime.utils.Assets;

using StringTools;

typedef SwagStage =
{
	var directory:String;
	var isPixelStage:Bool;
	var zoom:Float;

	var boyfriend:Array<Float>;
	var dad:Array<Float>;
	var gf:Array<Float>;
}

class Stage
{
	public static function loadFromSong(SONG:SwagSong, ?stageData:SwagStage)
	{
		var stage:String = SONG.stage;
		if (stage == null && SONG.song != null)
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
			stage = 'stage';

		if (stageData == null)
			stageData = loadFromJson(stage);

		if (stageData != null && stageData.directory != null)
			LoadingState.nextDirectory = stageData.directory;
		else
			LoadingState.nextDirectory = stage;
	}

	public static function loadFromJson(stage:String):SwagStage
	{
		return cast Json.parse(Assets.getText(Paths.getPath('stages/' + stage + '.json', TEXT)).trim());
	}
}
