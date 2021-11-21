package;

import lime.utils.Assets;

using StringTools;

class CoolUtil
{
	public static var difficultyStuff:Array<Dynamic> = [
		['EASY'],
		['NORMAL'],
		['HARD']
	];

	public static function difficultyString():String
		{
			return difficultyStuff[PlayState.storyDifficulty][0].toUpperCase();
		}

	//code used in psych engine
	public static function boundTo(value:Float, min:Float, max:Float):Float {
		var newValue:Float = value;
		if(newValue < min) newValue = min;
		else if(newValue > max) newValue = max;
		return newValue;
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function evenCoolerTextFile(path:String):Array<String>
		{
			var daList:Array<String> = sys.io.File.getContent(path).trim().split('\n');
	
			for (i in 0...daList.length)
			{
				daList[i] = daList[i].trim();
			}
	
			return daList;
		}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}
}
