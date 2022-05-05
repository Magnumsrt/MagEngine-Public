package;

import flixel.FlxG;
import flixel.FlxSprite;

class NoteSplash extends FlxSprite
{
	public var texture(default, set):String;

	private function set_texture(value:String):String
	{
		if (texture != value)
			reloadSplash(value);
		texture = value;
		return value;
	}

	public function new(x:Float, y:Float, noteData:Int)
	{
		super(x, y);

		texture = '';

		alpha = 0.6;
		offset.x += 90;
		offset.y += 80;

		animation.play('splash ' + FlxG.random.int(0, 1) + ' ' + noteData);
	}

	public function reloadSplash(texture:String, ?prefix:String = '', ?suffix:String = '')
	{
		if (texture == null || texture.length < 1)
			texture = 'noteSplashes';

		var arraySkin:Array<String> = texture.split('/');
		arraySkin[arraySkin.length - 1] = prefix + arraySkin[arraySkin.length - 1] + suffix;
		var boringPath:String = arraySkin.join('/');

		var lastAnim:String = null;
		if (animation.curAnim != null)
			lastAnim = animation.curAnim.name;

		if (PlayState.isPixelStage)
		{
			loadGraphic(Paths.image('pixelUI/' + boringPath), true, 50, 50);
			animation.add('splash 0 0', [0, 1, 2, 3], 24, false);
			animation.add('splash 1 0', [4, 5, 6, 7], 24, false);
			animation.add('splash 0 1', [8, 9, 10, 11], 24, false);
			animation.add('splash 1 1', [12, 13, 14, 15], 24, false);
			animation.add('splash 0 2', [16, 17, 18, 19], 24, false);
			animation.add('splash 1 2', [20, 21, 22, 23], 24, false);
			animation.add('splash 0 3', [24, 25, 26, 27], 24, false);
			animation.add('splash 1 3', [28, 29, 30, 31], 24, false);
			animation.add('splash 0 4', [32, 33, 34, 35], 24, false);
			animation.add('splash 1 4', [36, 37, 38, 39], 24, false);

			setGraphicSize(Std.int(width * PlayState.daPixelZoom));
			updateHitbox();
		}
		else
		{
			frames = Paths.getSparrowAtlas(boringPath);
			animation.addByPrefix('splash 0 0', 'note impact 1 purple', 24, false);
			animation.addByPrefix('splash 0 1', 'note impact 1  blue', 24, false);
			animation.addByPrefix('splash 0 2', 'note impact 1 green', 24, false);
			animation.addByPrefix('splash 0 3', 'note impact 1 red', 24, false);
			animation.addByPrefix('splash 1 0', 'note impact 2 purple', 24, false);
			animation.addByPrefix('splash 1 1', 'note impact 2 blue', 24, false);
			animation.addByPrefix('splash 1 2', 'note impact 2 green', 24, false);
			animation.addByPrefix('splash 1 3', 'note impact 2 red', 24, false);
		}

		if (lastAnim != null)
			animation.play(lastAnim, true);
	}
}
