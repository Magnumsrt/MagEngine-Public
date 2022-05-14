package;

import modloader.ModList;
#if sys
import sys.FileSystem;
#end
import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	public static var currentModDirectory:String = '';
	public static final ignoredFolders:Array<String> = [
		'custom_characters', 'custom_events', 'custom_states', 'data', 'songs', 'stages', 'music', 'sounds', 'fonts', 'videos', 'images', 'weeks', 'scripts'
	];

	public static var currentLevel:String;

	public static function getPath(file:String, type:AssetType, ?library:String)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath = getLibraryPathForce(file, currentLevel);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		return '$library:${getPreloadPath('$library/$file')}';
	}

	inline static public function getPreloadPath(file:String)
	{
		return 'assets/$file';
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	static public function sound(key:String, ?library:String)
	{
		return returnSound('sounds', key, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String)
	{
		return returnSound('music', key, library);
	}

	inline static public function voicesPath(song:String)
	{
		return Paths.getPath('${formatToSongPath(song)}/Voices', SOUND, 'songs');
	}

	inline static public function instPath(song:String)
	{
		return Paths.getPath('${formatToSongPath(song)}/Voices', SOUND, 'songs');
	}

	inline static public function voices(song:String)
	{
		return returnSound(null, '${formatToSongPath(song)}/Voices', 'songs');
	}

	inline static public function inst(song:String)
	{
		return returnSound(null, '${formatToSongPath(song)}/Inst', 'songs');
	}

	inline static public function image(key:String, ?library:String)
	{
		return returnGraphic(key, library);
	}

	inline static public function font(key:String)
	{
		return getPreloadPath('fonts/$key');
	}

	inline static public function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}

	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}

	inline static public function mods(key:String = '')
	{
		return 'mods/' + key;
	}

	inline static public function fileExists(key:String, ?ignoreMods:Bool = false)
	{
		#if MODS
		if (!ignoreMods && (FileSystem.exists(mods(key)) || FileSystem.exists(mods(key))))
			return true;
		#end
		if (OpenFlAssets.exists(key))
			return true;
		return false;
	}

	public static function modFolder(key:String)
	{
		#if MODS
		var list:Array<String> = [];
		var modsFolder:String = Paths.mods();
		if (FileSystem.exists(modsFolder))
		{
			for (folder in FileSystem.readDirectory(modsFolder))
			{
				var path = haxe.io.Path.join([modsFolder, folder]);
				if (sys.FileSystem.isDirectory(path) && !ignoredFolders.contains(folder) && !list.contains(folder))
				{
					list.push(folder);
					for (i in 0...list.length)
						currentModDirectory = list[i];
				}
			}
		}
		if (currentModDirectory != null && currentModDirectory.length > 0)
		{
			var fileToCheck:String = mods(currentModDirectory + '/' + key);
			if (FileSystem.exists(fileToCheck) && ModList.getModEnabled(currentModDirectory))
				return fileToCheck;
		}

		return mods(key);
		#else
		return key;
		#end
	}

	inline static public function formatToSongPath(path:String)
	{
		return path.toLowerCase().replace(' ', '-');
	}

	public static function returnGraphic(key:String, ?library:String)
	{
		var path = getPath('images/$key.png', IMAGE, library);
		if (fileExists(path))
			return Cache.getGraphic(path);
		trace('oh no ${key} is returning null NOOOO');
		return null;
	}

	inline static public function returnSound(?path:String, key:String, ?library:String)
	{
		var drip:String = '$key.$SOUND_EXT';
		if (path != null && path.length > 0)
			drip = '$path/$drip';
		return Cache.getSound(getPath(drip, SOUND, library));
	}
}
