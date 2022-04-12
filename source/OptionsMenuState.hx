package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

using StringTools;

class OptionsMenuState extends MusicBeatState
{
	var sections:Array<String> = ['gameplay', 'notes', 'misc'];

	var curSection:Int = 0;
	var curSelected:Int = 0;

	private var grpSections:FlxTypedGroup<Alphabet>;

	// private var iconArray:Array<HealthIcon> = [];

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		add(bg);

		grpSections = new FlxTypedGroup<Alphabet>();
		add(grpSections);

		for (i in 0...sections.length)
		{
			var sectionText:Alphabet = new Alphabet(0, 15, sections[i], true, false);
			sectionText.x = sectionText.width * 2 + i * 165 + 30;
			sectionText.ID = i;
			grpSections.add(sectionText);
		}

		changeSection();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (controls.UI_LEFT_P)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			changeSection(-1);
		}
		if (controls.UI_RIGHT_P)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			changeSection(1);
		}

		if (controls.BACK)
		{
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.ACCEPT)
		{
			trace('current section: ' + sections[curSection]);
		}
	}

	function changeSection(change:Int = 0)
	{
		curSection += change;

		if (curSection < 0)
			curSection = sections.length - 1;
		if (curSection >= sections.length)
			curSection = 0;

		var bullShit:Int = 0;

		for (item in grpSections.members)
		{
			bullShit++;

			item.alpha = 0.6;

			if (item.ID == curSection)
				item.alpha = 1;
		}
	}
}
