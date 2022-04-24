package;

import flixel.graphics.FlxGraphic;

using StringTools;

class HealthIcon extends AttachedSprite
{
	private var char:String = '';
	private var isPlayer:Bool = false;

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
			if (!Paths.fileExists('images/' + name + '.png', IMAGE))
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

}
