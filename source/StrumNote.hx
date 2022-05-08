package;

import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.FlxSprite;

class StrumNote extends FlxSprite
{
	public var resetAnim:Float = 0;

	public var direction:Float = 90;
	public var downScroll:Bool = false;

	var noteData:Int = 0;
	var player:Int = 0;

	public var texture(default, set):String;

	private function set_texture(value:String):String
	{
		if (texture != value)
			reloadNote(value);
		texture = value;
		return value;
	}

	public function new(x:Float, y:Float, noteData:Int, player:Int)
	{
		super(x, y);

		this.noteData = noteData;
		this.player = player;

		texture = '';

		updateHitbox();
	}

	public function reloadNote(texture:String, ?prefix:String = '', ?suffix:String = '')
	{
		if (texture == null || texture.length < 1)
			texture = 'NOTE_assets';

		var arraySkin:Array<String> = texture.split('/');
		arraySkin[arraySkin.length - 1] = prefix + arraySkin[arraySkin.length - 1] + suffix;
		var boringPath:String = arraySkin.join('/');

		var lastAnim:String = null;
		if (animation.curAnim != null)
			lastAnim = animation.curAnim.name;

		if (PlayState.isPixelStage)
		{
			var file:FlxGraphic = Paths.image('pixelUI/' + boringPath);
			loadGraphic(file);
			width = width / 4;
			height = height / 5;
			loadGraphic(file, true, Math.floor(width), Math.floor(height));

			animation.add('green', [6]);
			animation.add('red', [7]);
			animation.add('blue', [5]);
			animation.add('purple', [4]);

			switch (Math.abs(noteData))
			{
				case 0:
					animation.add('static', [0]);
					animation.add('pressed', [4, 8], 12, false);
					animation.add('confirm', [12, 16], 24, false);
				case 1:
					animation.add('static', [1]);
					animation.add('pressed', [5, 9], 12, false);
					animation.add('confirm', [13, 17], 24, false);
				case 2:
					animation.add('static', [2]);
					animation.add('pressed', [6, 10], 12, false);
					animation.add('confirm', [14, 18], 12, false);
				case 3:
					animation.add('static', [3]);
					animation.add('pressed', [7, 11], 12, false);
					animation.add('confirm', [15, 19], 24, false);
			}

			antialiasing = false;
			setGraphicSize(Std.int(width * PlayState.daPixelZoom));
		}
		else
		{
			frames = Paths.getSparrowAtlas(boringPath);

			animation.addByPrefix('green', 'arrowUP');
			animation.addByPrefix('blue', 'arrowDOWN');
			animation.addByPrefix('purple', 'arrowLEFT');
			animation.addByPrefix('red', 'arrowRIGHT');

			switch (Math.abs(noteData))
			{
				case 0:
					animation.addByPrefix('static', 'arrowLEFT');
					animation.addByPrefix('pressed', 'left press', 24, false);
					animation.addByPrefix('confirm', 'left confirm', 24, false);
				case 1:
					animation.addByPrefix('static', 'arrowDOWN');
					animation.addByPrefix('pressed', 'down press', 24, false);
					animation.addByPrefix('confirm', 'down confirm', 24, false);
				case 2:
					animation.addByPrefix('static', 'arrowUP');
					animation.addByPrefix('pressed', 'up press', 24, false);
					animation.addByPrefix('confirm', 'up confirm', 24, false);
				case 3:
					animation.addByPrefix('static', 'arrowRIGHT');
					animation.addByPrefix('pressed', 'right press', 24, false);
					animation.addByPrefix('confirm', 'right confirm', 24, false);
			}

			antialiasing = true;
			setGraphicSize(Std.int(width * 0.7));
		}
		updateHitbox();

		if (lastAnim != null)
			playAnim(lastAnim, true);
	}

	public function postAddedToGroup()
	{
		playAnim('static');
		x += Note.swagWidth * noteData;
		x += 50;
		x += FlxG.width / 2 * player;
		ID = noteData;
	}

	override function update(elapsed:Float)
	{
		if (resetAnim > 0)
		{
			resetAnim -= elapsed;
			if (resetAnim <= 0)
			{
				playAnim('static');
				resetAnim = 0;
			}
		}

		if (animation.curAnim.name == 'confirm' && !PlayState.isPixelStage)
			centerOrigin();

		super.update(elapsed);
	}

	public function playAnim(anim:String, ?force:Bool = false)
	{
		animation.play(anim, force);

		centerOffsets();
		centerOrigin();

		if (animation.curAnim.name == 'confirm' && !PlayState.isPixelStage)
			centerOrigin();
	}
}