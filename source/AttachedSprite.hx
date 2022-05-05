package;

import flixel.FlxSprite;

class AttachedSprite extends FlxSprite
{
	public var sprTracker:FlxSprite;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
