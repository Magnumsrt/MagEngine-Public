package;

import flixel.FlxG;
import openfl.system.System;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import flash.media.Sound;
import openfl.utils.Assets;
import openfl.display3D.textures.Texture;

/**
 * This class manages all images and sounds assets used in-game.
 * 
 * The images are stored on the GPU. This means that the image doesn't exists in the RAM.
 * 
 * GPU bitmaps idea stolen from Rozebud trololol!
 */
class Cache
{
	private static var graphics:Map<String, FlxGraphic> = [];
	private static var textures:Map<String, Texture> = [];
	private static var sounds:Map<String, Sound> = [];

	public static function getGraphic(path:String)
	{
		if (graphics.exists(path))
			return graphics.get(path);

		// this is a baby. please play with this baby.
		var babyMap:BitmapData = Assets.getBitmapData(path, false);
		var tex:Texture = FlxG.stage.context3D.createTexture(babyMap.width, babyMap.height, BGRA, true);
		tex.uploadFromBitmapData(babyMap);
		textures.set(path, tex);
		babyMap.dispose();
		babyMap.disposeImage();

		var graphix:FlxGraphic = FlxGraphic.fromBitmapData(BitmapData.fromTexture(tex), false, path, false);
		graphix.persist = true;
		graphics.set(path, graphix);

		return graphix;
	}

	public static function getSound(path:String)
	{
		if (sounds.exists(path))
			return sounds.get(path);

		// poop fart
		#if sys
		var fartSound:Sound = Sound.fromFile('./' + path.substring(path.indexOf(':') + 1, path.length));
		#else
		var fartSound:Sound = Assets.getSound(path);
		#end
		sounds.set(path, fartSound);

		return fartSound;
	}

	public static function clear()
	{
		disposeAllGraphics();
		disposeAllSounds();
		System.gc();
	}

	public static function disposeAllGraphics()
	{
		@:privateAccess
		for (key => graphic in graphics)
		{
			textures.get(key).dispose();
			textures.remove(key);
			Assets.cache.removeBitmapData(key);
			FlxG.bitmap._cache.remove(key);
			graphic.destroy();
			graphics.remove(key);
		}
	}

	// not really dispose, but still
	public static function disposeAllSounds()
	{
		for (key in sounds.keys())
		{
			Assets.cache.clear(key);
			sounds.remove(key);
		}
		Assets.cache.clear('songs');
	}
}
