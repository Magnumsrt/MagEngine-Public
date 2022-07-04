package;

import flixel.FlxG;
import openfl.system.System;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import openfl.media.Sound;
import openfl.utils.Assets;
import openfl.display3D.textures.Texture;

/**
 * Class that manages all images and sounds assets used in-game.
 */
class Cache
{
	public static var dumpExclusions:Array<String> = [
		'assets/music/freakyMenu.${Paths.SOUND_EXT}',
		'assets/shared/music/breakfast.${Paths.SOUND_EXT}'
	];

	static var bitmaps:Array<BitmapAsset> = [];
	static var sounds:Map<String, Sound> = [];

	public static function getGraphic(path:String, storeInGpu:Bool = false)
	{
		for (bitmap in bitmaps)
			if (bitmap.path == path)
				return bitmap.graphic;

		var dumbMap:BitmapAsset = new BitmapAsset(path, storeInGpu);
		bitmaps.push(dumbMap);
		return dumbMap.graphic;
	}

	public static function getSound(path:String)
	{
		if (sounds.exists(path))
			return sounds.get(path);

		var fartSound:Sound = Assets.getSound(path);
		sounds.set(path, fartSound);
		return fartSound;
	}

	inline static public function hasSound(path:String)
	{
		return sounds.exists(path);
	}

	public static function clear()
	{
		clearBitmaps();
		clearSounds();
		System.gc();
	}

	public static function clearBitmaps()
	{
		for (bitmap in bitmaps)
		{
			if (!dumpExclusions.contains(bitmap.path))
			{
				bitmaps.remove(bitmap);
				bitmap.dispose();
			}
		}
	}

	public static function clearSounds()
	{
		for (key in sounds.keys())
		{
			if (!dumpExclusions.contains(key))
			{
				sounds.remove(key);
				Assets.cache.clear(key);
			}
		}
	}
}

class BitmapAsset
{
	public var path:String;

	var texture:Texture;

	public var graphic:FlxGraphic;
	public var bitmap(get, never):BitmapData;

	public function get_bitmap():BitmapData
	{
		if (texture != null)
			return BitmapData.fromTexture(texture);
		else
			return graphic.bitmap;
	}

	public function new(path:String, storeInGpu:Bool = true)
	{
		this.path = path;

		var data:BitmapData = Assets.getBitmapData(path, !storeInGpu);
		if (storeInGpu)
		{
			texture = FlxG.stage.context3D.createTexture(data.width, data.height, BGRA, false);
			texture.uploadFromBitmapData(data);
			data.dispose();
			data.disposeImage();
		}

		graphic = FlxGraphic.fromBitmapData(storeInGpu ? BitmapData.fromTexture(texture) : data);
		graphic.persist = true;
		graphic.destroyOnNoUse = false;
		// trace('new bitmap: ' + path);
	}

	public function dispose()
	{
		if (texture != null)
			texture.dispose();
		else if (bitmap != null)
		{
			bitmap.dispose();
			bitmap.disposeImage();
		}

		Assets.cache.removeBitmapData(path);
		@:privateAccess
		FlxG.bitmap._cache.remove(path);

		graphic.destroy();
		// trace('disposed bitmap: ' + path);
	}
}
