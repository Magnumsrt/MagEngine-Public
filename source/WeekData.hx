package;

#if sys
import sys.FileSystem;
#end
import haxe.Json;
import openfl.utils.Assets;

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

class WeekData
{
	public static var currentDirectory:String;
	public static var loadedWeeks:Map<String, SwagWeek> = [];
	public static var weeksList:Array<String> = [];

	public static function loadWeeks()
	{
		loadedWeeks.clear();
		weeksList = CoolUtil.coolTextFile(Paths.txt('weekList'));

		#if sys
		var folders:Array<String> = [#if MODS Paths.modFolder('weeks') #end, Paths.getPreloadPath('weeks')];
		for (folder in folders)
		{
			if (FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					var omgimcool:String = file.substr(0, file.length - 5);
					if (file.endsWith('.json') && !weeksList.contains(omgimcool))
						weeksList.push(omgimcool);
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

	public static function loadFromJson(week:String):SwagWeek
	{
		return cast Json.parse(Assets.getText(Paths.getPath('weeks/' + week + '.json', TEXT)).trim());
	}
}
