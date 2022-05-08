package modloader;

import modloader.ModList;
import modloader.PolymodHandler;
import modloader.ModsMenuOption;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;
import lime.utils.Assets;

class ModsMenu extends MusicBeatState
{
	#if MODS
	var curSelected:Int = 0;

	var page:FlxTypedGroup<ModsMenuOption> = new FlxTypedGroup<ModsMenuOption>();

	public static var enabledMods = [];

	public static var coolId:String;
	public static var disableButton:FlxButton;
	public static var enableButton:FlxButton;

	var infoText:FlxText;
	var infoTextcool:FlxText;

	override function create()
	{
		Cache.clear();

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = FlxColor.GRAY;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		infoText = new FlxText(0, 0, 0, "NO MODS INSTALLED!", 12);
		infoText.scrollFactor.set();
		infoText.setFormat("VCR OSD Mono", 35, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		infoText.borderSize = 2;
		infoText.screenCenter();
		infoText.visible = false;
		infoText.antialiasing = true;
		add(infoText);

		infoTextcool = new FlxText(340, 340, Std.int(FlxG.width * 0.9), "", 12);
		infoTextcool.scrollFactor.set();
		infoTextcool.setFormat(Paths.font("funkin.otf"), 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		infoTextcool.borderSize = 2;
		infoTextcool.screenCenter(Y);

		super.create();

		PolymodHandler.loadModMetadata();

		add(page);

		loadMods();
		FlxG.mouse.visible = true;
	}

	function loadMods()
	{
		page.forEachExists(function(option:ModsMenuOption)
		{
			page.remove(option);
			option.kill();
			option.destroy();
		});

		var optionLoopNum:Int = 0;

		for (modId in PolymodHandler.metadataArrays)
		{
			var modOption = new ModsMenuOption(ModList.modMetadatas.get(modId).title, modId, optionLoopNum);
			page.add(modOption);
			optionLoopNum++;
			coolId = modId;
		}

		if (optionLoopNum > 0)
			buildUI();

		infoText.visible = (page.length == 0);
	}

	function buildUI()
	{
		enableButton = new FlxButton(1120, 310, "Enable mod", function()
		{
			page.members[curSelected].enabled = true;
			if (!enabledMods.contains(page.members[curSelected].value))
				enabledMods.push(page.members[curSelected].value);
			ModList.setModEnabled(page.members[curSelected].value, page.members[curSelected].enabled);
		});

		disableButton = new FlxButton(enableButton.x, enableButton.y + 70, "Disable mod", function()
		{
			page.members[curSelected].enabled = false;
			if (enabledMods.contains(page.members[curSelected].value))
				enabledMods.remove(page.members[curSelected].value);
			ModList.setModEnabled(page.members[curSelected].value, page.members[curSelected].enabled);
		});

		enableButton.setGraphicSize(150, 70);
		enableButton.updateHitbox();
		enableButton.color = FlxColor.GREEN;
		enableButton.label.setFormat(Paths.font("pixel.otf"), 12, FlxColor.WHITE);
		enableButton.label.fieldWidth = 135;
		setLabelOffset(enableButton, 5, 22);

		disableButton.setGraphicSize(150, 70);
		disableButton.updateHitbox();
		disableButton.color = FlxColor.RED;
		disableButton.label.setFormat(Paths.font("pixel.otf"), 12, FlxColor.WHITE);
		disableButton.label.fieldWidth = 135;
		setLabelOffset(disableButton, 5, 22);

		add(infoTextcool);
		add(disableButton);
		add(enableButton);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// a bit ugly but i was in a hurry
		if (page.length > 0)
		{
			infoTextcool.text = ModList.modMetadatas.get(PolymodHandler.metadataArrays[curSelected]).description;
			infoTextcool.visible = true;
			infoTextcool.antialiasing = true;
		}

		if (page.length > 0)
		{
			if (controls.UI_UP_P)
			{
				curSelected--;
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			}

			if (controls.UI_DOWN_P)
			{
				curSelected++;
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			}
		}

		if (controls.BACK)
		{
			PolymodHandler.loadMods();
			FlxG.mouse.visible = false;
			MusicBeatState.switchState(new MainMenuState());
		}

		if (curSelected < 0)
			curSelected = page.length - 1;

		if (curSelected >= page.length)
			curSelected = 0;

		var bruh = 0;

		for (x in page.members)
		{
			x.text.targetY = bruh - curSelected;
			bruh++;
		}
	}

	// haxeflixel bro why
	function setLabelOffset(button:FlxButton, x:Float, y:Float)
	{
		for (point in button.labelOffsets)
		{
			point.set(x, y);
		}
	}
	#end
}
