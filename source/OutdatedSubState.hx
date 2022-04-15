package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;
	public static var newVersion:String = "";

	override function create()
	{
		super.create();

		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"HEY! You're running an outdated version of the game!\nCurrent version is v"
			+ Application.current.meta.get("version")
			+ " while the most recent version is "
			+ newVersion
			+ "! Press Space to go to GitHub, or ESCAPE to ignore this!!",
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
			CoolUtil.openURL("hhttps://github.com/magnumsrtisswag/MagEngine-Public/releases");

		if (controls.BACK)
		{
			leftState = true;
			MusicBeatState.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}
}
