package;

import flixel.FlxSprite;
import openfl.utils.Assets;
import haxe.Json;

// don't blame me i want to get time for do everything
typedef SwagMenuCharacter =
{
	var image:String;
	var scale:Float;
	var position:Array<Int>;
	var idle_anim:String;
	var confirm_anim:String;
	var ?flipX:Bool;
}

class MenuCharacter extends FlxSprite
{
	public var character:String;
	public var hasConfirmAnimation:Bool = false;

	public function new(x:Float, character:String = 'bf')
	{
		super(x);
		changeCharacter(character);
	}

	public function changeCharacter(?character:String = 'bf')
	{
		if (character == null)
			character = '';
		if (character == this.character)
			return;

		this.character = character;
		antialiasing = true;
		visible = true;

		var dontPlayAnim:Bool = false;
		scale.set(1, 1);
		updateHitbox();

		hasConfirmAnimation = false;

		if (character.length <= 0)
		{
			visible = false;
			dontPlayAnim = true;
		}
		else
		{
			var path:String = Paths.getPath('images/menucharacters/' + character + '.json', TEXT);
			if (!Paths.fileExists(path))
				path = Paths.getPreloadPath('images/menucharacters/bf.json');

			var charFile:SwagMenuCharacter = cast Json.parse(Assets.getText(path));
			frames = Paths.getSparrowAtlas('menucharacters/' + charFile.image);
			animation.addByPrefix('idle', charFile.idle_anim, 24);

			var confirmAnim:String = charFile.confirm_anim;
			if (confirmAnim != null && confirmAnim != charFile.idle_anim)
			{
				animation.addByPrefix('confirm', confirmAnim, 24, false);
				if (animation.getByName('confirm') != null) // check for invalid animation
					hasConfirmAnimation = true;
			}

			if (charFile.flipX != null)
				flipX = charFile.flipX;

			if (charFile.scale != 1)
			{
				scale.set(charFile.scale, charFile.scale);
				updateHitbox();
			}
			offset.set(charFile.position[0], charFile.position[1]);
			animation.play('idle');
		}
	}

	public function confirm()
	{
		if (hasConfirmAnimation)
			animation.play('confirm', true);
	}
}
