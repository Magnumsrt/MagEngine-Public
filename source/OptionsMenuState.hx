package;

import MagPrefs.Setting;
import flixel.util.FlxColor;
import flixel.text.FlxText;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

using StringTools;

class OptionsMenuState extends MusicBeatState
{
	var options:Array<Array<Dynamic>> = [
		[
			'gameplay',
			[
				['Ghost Tapping', 'Let you press where there are not notes.', 'ghostTapping'],
				['Downscroll', 'Swaps the notes scroll direction to down.', 'downScroll'],
				[
					'Middlescroll',
					'Centers the player strumline and hides the opponent strumline.',
					'middleScroll'
				],
				['Misses Display', 'Shows your misses.', 'missesDisplay'],
				['Accuracy Display', 'Shows your accuracy.', 'accDisplay'],
			]
		],
		[
			'notes',
			[['Opponent Notes Glow', 'Makes the opponent notes glow on hit.', 'cpuNotesGlow']]
		],
		[
			'misc',
			[
				['FPS Display', 'Shows the current FPS.', 'fps'],
				['Memory Display', 'Shows the current memory usage.', 'mem'],
				['Memory Peak Display', 'Shows the current memory peak.', 'memPeak']
			]
		]
	];

	var selectinSection:Bool = true;

	static var curSection:Int = 0;
	static var curSelected:Int = 0;

	var grpSections:FlxTypedGroup<Alphabet>;

	var curOptions:Array<Array<String>>;

	// TODO: add a black box or something like KE options menu
	var optionsText:FlxText;
	var descText:FlxText;

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

		var coolY:Int = 50;

		optionsText = new FlxText(50, coolY + 90, 0, "", 12);
		optionsText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		optionsText.borderSize = 1.75;
		add(optionsText);

		for (i in 0...options.length)
		{
			var sectionText:Alphabet = new Alphabet(0, coolY, options[i][0], true, false);
			sectionText.horizontalScroll = true;
			sectionText.targetX = getSectionX(i);
			sectionText.ID = i;
			grpSections.add(sectionText);

			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		descText = new FlxText(0, FlxG.height - 20, FlxG.width, "", 14);
		descText.setFormat("VCR OSD Mono", 19, FlxColor.YELLOW, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.visible = false;
		add(descText);

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

		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume += 0.5 * elapsed;

		if (selectinSection)
		{
			optionsText.alpha = 0.6;

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
		}
		else
		{
			optionsText.alpha = 1;

			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				changeSelection(-1);
			}
			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				changeSelection(1);
			}
		}

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			if (!selectinSection)
			{
				selectinSection = true;
				descText.visible = false;
				changeSelection();
			}
			else
			{
				MagPrefs.save();
				MusicBeatState.switchState(new MainMenuState());
			}
		}

		if (controls.ACCEPT)
		{
			if (selectinSection)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectinSection = false;
				descText.visible = true;
				changeSelection();
			}
			else
			{
				var name:String = curOptions[curSelected][2];
				var setting:Setting = MagPrefs.getSetting(name);
				if (setting.type == Boolean)
					MagPrefs.setSetting(name, !setting.value);

				if (name == 'fps' || name == 'mem' || name == 'memPeak')
					Main.setFPSDisplay();

				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				changeSelection();
			}
		}
	}

	function getSectionX(index:Int)
	{
		return -(FlxG.width / options.length) + index * (FlxG.width / 2) - 125;
	}

	function changeSelection(change:Int = 0)
	{
		curOptions = options[curSection][1];

		curSelected += change;

		if (curSelected < 0)
			curSelected = curOptions.length - 1;
		if (curSelected >= curOptions.length)
			curSelected = 0;

		descText.text = curOptions[curSelected][1];
		descText.y = FlxG.height - descText.height;

		optionsText.text = '';

		for (i in 0...curOptions.length)
		{
			var selector:String = '';
			if (!selectinSection && i == curSelected)
				selector = '>  ';

			var value:String = '';
			var setting:Setting = MagPrefs.getSetting(curOptions[i][2]);
			switch (setting.type)
			{
				case Boolean:
					value = setting.value ? 'Enabled' : 'Disabled';
				case Percent:
					value = setting.value + '%';
				default:
					value = setting.value;
			}

			optionsText.text += selector + curOptions[i][0] + ' - ' + value + '\n';
		}
	}

	function changeSection(change:Int = 0)
	{
		curSection += change;

		if (curSection < 0)
			curSection = options.length - 1;
		if (curSection >= options.length)
			curSection = 0;

		changeSelection();

		for (item in grpSections.members)
		{
			item.targetX = getSectionX(item.ID + 1 - curSection);

			item.alpha = 0.6;

			if (selectinSection && item.ID == curSection)
				item.alpha = 1;
		}
	}
}
