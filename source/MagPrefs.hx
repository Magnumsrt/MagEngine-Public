package;

import Controls.KeyboardScheme;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;

typedef Setting =
{
	var type:SettingType;
	var value:Dynamic;
	// for percent and integer types
	@:optional var min:Float;
	@:optional var max:Float;
}

enum SettingType
{
	Boolean;
	Integer;
	Percent;
	Text;
}

// my awesome oop take on haxe :O
class MagPrefs
{
	private static var settings:Map<String, Setting> = [
		// gampeplay settings
		'ghostTapping' => {
			type: Boolean,
			value: true
		},
		'downScroll' => {
			type: Boolean,
			value: false
		},
		'middleScroll' => {
			type: Boolean,
			value: false
		},
		// notes settings
		'cpuNotesGlow' => {
			type: Boolean,
			value: true
		},
		// other settings idk
		'fpsCounter' => {
			type: Boolean,
			value: true
		}
	];

	public static var keyBinds:Map<String, Array<FlxKey>> = [
		'note_left' => [A, LEFT],
		'note_down' => [S, DOWN],
		'note_up' => [W, UP],
		'note_right' => [D, RIGHT],
		'ui_left' => [A, LEFT],
		'ui_down' => [S, DOWN],
		'ui_up' => [W, UP],
		'ui_right' => [D, RIGHT],
		'accept' => [SPACE, ENTER],
		'back' => [BACKSPACE, ESCAPE],
		'pause' => [ENTER, ESCAPE],
		'reset' => [R, NONE],
		'volume_mute' => [ZERO, NONE],
		'volume_up' => [NUMPADPLUS, PLUS],
		'volume_down' => [NUMPADMINUS, MINUS],
		'debug_1' => [SEVEN, NONE],
		'debug_2' => [EIGHT, NONE]
	];
	public static var defaultKeys:Map<String, Array<FlxKey>>;

	public static function load()
	{
		if (FlxG.save.data.settings == null)
		{
			FlxG.save.data.settings = settings;
			FlxG.save.flush();
		}
		else
			settings = FlxG.save.data.settings;

		trace(settings);

		var controlsSave:FlxSave = new FlxSave();
		controlsSave.bind('controls_v2', 'ninjamuffin99');
		if (controlsSave.data.customControls != null)
		{
			var loadedControls:Map<String, Array<FlxKey>> = controlsSave.data.customControls;
			for (control => keys in loadedControls)
				keyBinds.set(control, keys);
			reloadControls();
		}
	}

	public static function loadDefaultKeys()
	{
		defaultKeys = keyBinds.copy();
	}

	public static function copyKey(arrayToCopy:Array<FlxKey>)
	{
		var copiedArray:Array<FlxKey> = arrayToCopy.copy();
		var i:Int = 0;
		var len:Int = copiedArray.length;

		while (i < len)
		{
			if (copiedArray[i] == NONE)
			{
				copiedArray.remove(NONE);
				--i;
			}
			i++;
			len = copiedArray.length;
		}
		return copiedArray;
	}

	public static function reloadControls()
	{
		PlayerSettings.player1.controls.setKeyboardScheme(KeyboardScheme.Solo);

		TitleState.muteKeys = copyKey(keyBinds.get('volume_mute'));
		TitleState.volumeDownKeys = copyKey(keyBinds.get('volume_down'));
		TitleState.volumeUpKeys = copyKey(keyBinds.get('volume_up'));
		FlxG.sound.muteKeys = TitleState.muteKeys;
		FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
		FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
	}

	public static function save()
	{
		FlxG.save.data.settings = settings;
		FlxG.save.flush();

		// place shit in a separate save since this is better for don't erase score stuff
		var controlsSave:FlxSave = new FlxSave();
		controlsSave.bind('controls', 'ninjamuffin99');
		controlsSave.data.customControls = keyBinds;
		controlsSave.flush();
	}

	public static function getSetting(setting:String)
	{
		if (settings.exists(setting))
			return settings.get(setting)
		else
			return null;
	}

	// im lazy lol
	public static function getValue(setting:String)
	{
		return getSetting(setting).value;
	}

	public static function setSetting(setting:String, value:Dynamic, ?type:SettingType, ?min:Float, ?max:Float)
	{
		// this is so awesome
		var leSetting:Setting = {
			type: Boolean,
			value: value
		};
		var originalSetting:Setting = settings.get(setting);

		if (type == null && originalSetting != null)
			leSetting.type = originalSetting.type;

		if (min != null)
			leSetting.min = min;
		else if (originalSetting != null)
			leSetting.min = originalSetting.min;
		if (max != null)
			leSetting.max = max;
		else if (originalSetting != null)
			leSetting.max = originalSetting.max;

		settings.set(setting, leSetting);
	}
}
