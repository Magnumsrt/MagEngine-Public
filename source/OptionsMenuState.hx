package;

import flixel.math.FlxMath;
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
				[
					'Camera Movement',
					'Makes the camera follows the character on note hit.',
					'cameraMove'
				],
				['Misses Display', 'Shows your misses.', 'missesDisplay'],
				['Accuracy Display', 'Shows your accuracy.', 'accDisplay'],
			]
		],
		[
			'notes',
			[
				[
					'Note Splashes',
					'Spawns a splash when getting a "Sick!" hit rating.',
					'noteSplashes'
				],
				['Opponent Notes Glow', 'Makes the opponent notes glow on hit.', 'cpuNotesGlow']
			],
		],
		[
			'graphics',
			[
				#if !html5 ['Framerate', 'How much images the game must display per second?', 'framerate'],
				#end
				['FPS Display', 'Shows the current FPS.', 'fps'],
				['Memory Display', 'Shows the current memory usage.', 'mem'],
				['Memory Peak Display', 'Shows the current memory peak.', 'memPeak']
			]
		],
		[
			'misc',
			[
				[
					'Version Check',
					'Checks on start if the current version is outdated',
					'versionCheck'
				]
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

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

		grpSections = new FlxTypedGroup<Alphabet>();
		add(grpSections);

		var coolY:Int = 40;

		var optionsBG:FlxSprite = new FlxSprite(0, coolY + 110).makeGraphic(Std.int(FlxG.width * 0.825), Std.int(FlxG.height * 0.7), 0xFF000000);
		optionsBG.alpha = 0.75;
		optionsBG.screenCenter(X);
		add(optionsBG);

		optionsText = new FlxText(125, optionsBG.y + 10, 0, "", 12);
		optionsText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		optionsText.borderSize = 1.65;
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

		descText = new FlxText(0, 0, FlxG.width, "", 14);
		descText.setFormat("VCR OSD Mono", 20, FlxColor.YELLOW, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.borderSize = 1.5;
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

	var holdTime:Float = 0;
	var holdValue:Float = 0;

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
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeSection(-1);
			}
			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeSection(1);
			}
		}
		else
		{
			optionsText.alpha = 1;

			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeSelection(-1);
			}
			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeSelection(1);
			}

			if (controls.UI_LEFT || controls.UI_RIGHT)
			{
				var name:String = curOptions[curSelected][2];
				var setting:Setting = MagPrefs.getSetting(name);

				var pressed = (controls.UI_LEFT_P || controls.UI_RIGHT_P);
				if (holdTime > 0.5 || pressed)
				{
					if (pressed)
					{
						switch (setting.type)
						{
							case Integer | Float | Percent:
								holdValue = setting.value + (controls.UI_LEFT ? -1 : 1);

								var min:Float = MagPrefs.getMinValue(name);
								var max:Float = MagPrefs.getMaxValue(name);
								if (min != Math.NaN && holdValue < min)
									holdValue = min;
								else if (max != Math.NaN && holdValue > max)
									holdValue = max;

								if (setting.type == Integer)
									holdValue = Math.round(holdValue);
								else
									holdValue = FlxMath.roundDecimal(holdValue, setting.decimals != null ? setting.decimals : 1);
								MagPrefs.setSetting(name, holdValue);

							case Boolean | String:
								if (setting.type == Boolean)
									MagPrefs.setSetting(name, !setting.value);
								else
								{
									var num:Int = MagPrefs.getCurOption(name);
									if (controls.UI_LEFT_P)
										--num;
									else
										num++;
									if (num < 0)
										num = setting.options.length - 1;
									else if (num >= setting.options.length)
										num = 0;
									MagPrefs.setOption(name, num);
								}
						}
						if (name == 'framerate')
							onChangeFramerate();
						else if (name == 'fps' || name == 'mem' || name == 'memPeak')
							Main.setFPSDisplay();
						changeSelection();
						FlxG.sound.play(Paths.sound('scrollMenu'));
					}
					else if (setting.type != String)
					{
						holdValue += 50 * elapsed * (controls.UI_LEFT ? -1 : 1);

						var min:Float = MagPrefs.getMinValue(name);
						var max:Float = MagPrefs.getMaxValue(name);
						if (min != Math.NaN && holdValue < min)
							holdValue = min;
						else if (max != Math.NaN && holdValue > max)
							holdValue = max;

						if (setting.type == Integer)
							MagPrefs.setSetting(name, Math.round(holdValue));
						else if (setting.type == Float || setting.type == Percent)
							MagPrefs.setSetting(name, Math.round(FlxMath.roundDecimal(holdValue, setting.decimals != null ? setting.decimals : 1)));
						else
							MagPrefs.setSetting(name, !setting.value);

						if (name == 'framerate')
							onChangeFramerate();
						else if (name == 'fps' || name == 'mem' || name == 'memPeak')
							Main.setFPSDisplay();

						changeSelection();
					}
				}

				if (setting.type != String)
					holdTime += elapsed;
			}
			else if ((controls.UI_LEFT_R || controls.UI_RIGHT_R) || (!controls.UI_LEFT || !controls.UI_RIGHT))
			{
				if (holdTime > 0.5)
					FlxG.sound.play(Paths.sound('scrollMenu'));
				holdTime = 0;
			}
		}

		if (controls.RESET)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			for (option in curOptions)
				MagPrefs.resetSetting(option[2]);
			onChangeFramerate();
			Main.setFPSDisplay();
			changeSelection();
		}

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			if (selectinSection)
			{
				MagPrefs.flush();
				MusicBeatState.switchState(new MainMenuState());
			}
			else
			{
				selectinSection = true;
				descText.visible = false;
				changeSelection();
			}
		}

		if (selectinSection && controls.ACCEPT)
		{
			FlxG.sound.play(Paths.sound('confirmMenu'));
			selectinSection = false;
			descText.visible = true;
			changeSelection();
		}
	}

	function onChangeFramerate()
	{
		Main.setFramerate(MagPrefs.getValue('framerate'));
	}

	function getSectionX(index:Int)
	{
		return -(FlxG.width / 3) + index * (FlxG.width / 2) - 150;
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
		descText.y = FlxG.height - descText.height * 2;

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

			optionsText.text += selector + curOptions[i][0] + '  < ' + value + ' >\n';
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
