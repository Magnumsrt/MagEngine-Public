package;

import flixel.math.FlxMath;
import flixel.graphics.FlxGraphic;

using StringTools;

class HealthIcon extends AttachedSprite
{
	private var char:String = '';
	private var isPlayer:Bool = false;

	public var canBounce:Bool = false;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		this.isPlayer = isPlayer;
		changeIcon(char);
		scrollFactor.set();
	}

	public function changeIcon(char:String)
	{
		if (this.char != char)
		{
			var name:String = 'icons/icon-' + char;
			if (!Paths.fileExists(Paths.getPath('images/' + name + '.png', IMAGE)))
				name = 'icons/icon-face';
			var file:FlxGraphic = Paths.image(name);

			loadGraphic(file);
			loadGraphic(file, true, Math.floor(width / 2), Math.floor(height));

			animation.add(char, [0, 1], 0, false, isPlayer);
			animation.play(char);
			this.char = char;

			antialiasing = !char.endsWith('-pixel');
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (canBounce)
		{
			setGraphicSize(Std.int(FlxMath.lerp(150, width, CoolUtil.boundTo(1 - elapsed * 4.35, 0, 1))));
			updateHitbox();
		}
	}

	public function bounce()
	{
		if (canBounce)
		{
			setGraphicSize(Std.int(width + 30));
			updateHitbox();
		}
	}
}
