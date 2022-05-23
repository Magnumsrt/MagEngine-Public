package;

import flixel.math.FlxMath;
import MagPrefs.Setting;
import flixel.util.FlxColor;
import flixel.text.FlxText;
#if DISCORD
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

using StringTools;

typedef Page =
{
	var title:String;
	var options:Array<Option>;
}

typedef Option =
{
	var name:String;
	var description:String;
	var id:String;
}

class OptionsMenuState extends MusicBeatState
{
	var pages:Array<Page> = [
		{
			title: 'gameplay',
			options: [
				{
					name: 'Ghost Tapping',
					description: 'Let you press where there are not notes.',
					id: 'ghostTapping'
				},
				{
					name: 'Downscroll',
					description: 'Swaps the notes scroll direction to down.',
					id: 'downScroll'
				},
				{
					name: 'Middlescroll',
					description: 'Centers the player strumline and hides the opponent strumline.',
					id: 'middleScroll'
				},
				{
					name: 'Camera Movement',
					description: 'Makes the camera follows the character on note hit.',
					id: 'cameraMove'
				},
				{
					name: 'Misses Display',
					description: 'Shows your misses.',
					id: 'missesDisplay'
				},
				{
					name: 'Accuracy Display',
					description: 'Shows your accuracy.',
					id: 'accDisplay'
				},
				{
					name: 'Combo Display',
					description: 'Swaps the notes scroll direction to down.',
					id: 'comboDisplay'
				}
			]
		},
		{
			title: 'notes',
			options: [
				{
					name: 'Note Splashes',
					description: 'Spawns a splash when getting a "Sick!" hit rating.',
					id: 'noteSplashes'
				},
				{
					name: 'Opponent Notes Glow',
					description: 'Makes the opponent notes glow on hit.',
					id: 'cpuNotesGlow'
				},
				{
					name: 'Notes Behind HUD',
					description: 'Makes the notes goes behind the HUD.',
					id: 'notesBehindHud'
				}
			]
		},
		{
			title: 'graphics',
			options: [
				#if !mobile
				{
					name: 'FPS Display',
					description: 'Shows the current FPS.',
					id: 'fps'
				},
				#if !html5
				{
					name: 'Framerate',
					description: 'How much images the game must display per second?',
					id: 'framerate'
				}, {
					name: 'Memory Display',
					description: 'Shows the current memory usage.',
					id: 'mem'
				}, {
					name: 'Memory Peak Display',
					description: 'Shows the current memory peak.',
					id: 'memPeak'
				}
				#end
				#end
			]
		},
		{
			title: 'misc',
			options: [
				{
					name: 'Version Check',
					description: 'Checks on start if the current version is outdated.',
					id: 'versionCheck'
				}
			]
		}
	];

	var selectinSection:Bool = true;

	static var curPage:Int = 0;
	static var curOption:Int = 0;

	var grpSections:FlxTypedGroup<Alphabet>;
	var optionsText:FlxText;
	var descText:FlxText;

	override function create()
	{
		Cache.clear();

		#if DISCORD
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

		for (i in 0...pages.length)
		{
			var sectionText:Alphabet = new Alphabet(0, coolY, pages[i].title, true, false);
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

		changePage();

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
				changePage(-1);
			}
			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changePage(1);
			}
		}
		else
		{
			optionsText.alpha = 1;

			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeOption(-1);
			}
			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeOption(1);
			}

			if (controls.UI_LEFT || controls.UI_RIGHT)
			{
				var name:String = pages[curPage].options[curOption].id;
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
										num--;
									else
										num++;
									if (num < 0)
										num = setting.options.length - 1;
									else if (num >= setting.options.length)
										num = 0;
									MagPrefs.setOption(name, num);
								}
						}

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
					}

					if (name == 'framerate')
						Main.setFramerate(MagPrefs.getValue('framerate'));
					else if (name == 'fps' || name == 'mem' || name == 'memPeak')
						Main.setFPSDisplay();

					changeOption();
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
			for (option in pages[curPage].options)
				MagPrefs.resetSetting(option.name);
			Main.setFramerate(MagPrefs.getValue('framerate'));
			Main.setFPSDisplay();
			changeOption();
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
				changeOption();
			}
		}

		if (selectinSection && controls.ACCEPT)
		{
			FlxG.sound.play(Paths.sound('confirmMenu'));
			selectinSection = false;
			descText.visible = true;
			changeOption();
		}
	}

	function getSectionX(index:Int)
	{
		return -(FlxG.width / 3) + index * (FlxG.width / 2) - 150;
	}

	function changePage(change:Int = 0)
	{
		curPage += change;

		if (curPage < 0)
			curPage = pages.length - 1;
		if (curPage >= pages.length)
			curPage = 0;

		changeOption();

		for (item in grpSections.members)
		{
			item.targetX = getSectionX(item.ID + 1 - curPage);

			item.alpha = 0.6;

			if (selectinSection && item.ID == curPage)
				item.alpha = 1;
		}
	}

	function changeOption(change:Int = 0)
	{
		var options:Array<Option> = pages[curPage].options;

		curOption += change;

		if (curOption < 0)
			curOption = options.length - 1;
		if (curOption >= options.length)
			curOption = 0;

		descText.text = options[curOption].description;
		descText.y = FlxG.height - descText.height * 2;

		var leText:String = '';

		for (i in 0...options.length)
		{
			var selector:String = '';
			if (!selectinSection && i == curOption)
				selector = '>  ';

			var value:String = '';
			var setting:Setting = MagPrefs.getSetting(options[i].id);
			switch (setting.type)
			{
				case Boolean:
					value = setting.value ? 'Enabled' : 'Disabled';
				case Percent:
					value = setting.value + '%';
				default:
					value = setting.value;
			}

			leText += selector + options[i].name + '  < ' + value + ' >\n';
		}

		optionsText.text = leText;
	}
}
