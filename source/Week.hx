package;

import sys.FileSystem;
import haxe.Json;
import lime.utils.Assets;

using StringTools;

typedef SwagWeek =
{
	var songs:Array<Array<Dynamic>>;
	var weekCharacters:Array<String>;
	var storyName:String;
	var weekBefore:String;
	var weekName:String;
	var startUnlocked:Bool;
	var hideStoryMode:Bool;
	var hideFreeplay:Bool;
}

class Week
{
	public static var currentDirectory:String;
	public static var loadedWeeks:Map<String, SwagWeek> = [];
	public static var weeksList:Array<String> = [];

	public static function loadWeeks()
	{
		weeksList = [];
		loadedWeeks.clear();

		weeksList = CoolUtil.coolTextFile(Paths.txt('weekList'));

		#if MODS
		var folders:Array<String> = [Paths.modFolder('weeks'), Paths.getPreloadPath('weeks'),];
		for (folder in folders)
		{
			if (FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if (file.endsWith('.json'))
						weeksList.push(file.substr(0, file.length - 5));
				}
			}
		}
		#end

		for (week in weeksList)
			loadedWeeks.set(week, loadFromJson(week));
	}

	public static function getWeekFileName()
	{
		return weeksList[PlayState.storyWeek];
	}

	public static function getCurrentWeek()
	{
		return loadedWeeks.get(getWeekFileName());
	}

	public static function setNextDirectory(week:Int)
	{
		LoadingState.nextDirectory = null;
		if (weeksList[week] != null)
			LoadingState.nextDirectory = weeksList[week];
	}

	public static function loadFromJson(week:String):SwagWeek
	{
		return cast Json.parse(Assets.getText(Paths.getPath('weeks/' + week + '.json', TEXT)).trim());
	}
}
