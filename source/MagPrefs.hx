package;

import Controls.KeyboardScheme;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;

typedef Setting =
{
	var type:SettingType;
	var value:Dynamic;
	// for percent and numbers types
	@:optional var min:Float;
	@:optional var max:Float;
}

enum SettingType
{
	Boolean;
	Integer;
	Float;
	Percent;
	String;
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
		'missesDisplay' => {
			type: Boolean,
			value: true
		},
		'accDisplay' => {
			type: Boolean,
			value: true
		},
		// hit windows
		'sickWindow' => {
			type: Float,
			value: 45
		},
		'goodWindow' => {
			type: Float,
			value: 90
		},
		'badWindow' => {
			type: Float,
			value: 135
		},
		'safeFrames' => {
			type: Float,
			value: 10
		},
		// notes settings
		'cpuNotesGlow' => {
			type: Boolean,
			value: true
		},
		// other settings idk
		'fps' => {
			type: Boolean,
			value: true
		},
		'mem' => {
			type: Boolean,
			value: true
		},
		'memPeak' => {
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

	public static function load()
	{
		// place shit in a separate save since this is better for don't erase score stuff

		var save:FlxSave = new FlxSave();
		save.bind('settings', 'ninjamuffin99');

		if (save.data.settings == null)
			save.data.settings = settings;
		else
		{
			var savedSettings:Map<String, Setting> = save.data.settings;
			for (setting => data in settings)
				if (!savedSettings.exists(setting))
					savedSettings.set(setting, data);
			settings = savedSettings;
		}

		if (save.data.customControls != null)
		{
			keyBinds = save.data.customControls;
			reloadControls();
		}
	}

	// public static function loadDefaultKeys()
	// {
	// 	defaultKeys = keyBinds.copy();
	// }

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

		FlxG.sound.muteKeys = copyKey(keyBinds.get('volume_mute'));
		FlxG.sound.volumeDownKeys = copyKey(keyBinds.get('volume_down'));
		FlxG.sound.volumeUpKeys = copyKey(keyBinds.get('volume_up'));
	}

	public static function save()
	{
		var save:FlxSave = new FlxSave();
		save.bind('settings', 'ninjamuffin99');
		save.data.settings = settings;
		save.data.customControls = keyBinds;
		save.flush();
	}

	public static function getSettingsList()
	{
		var dogshet:Array<String> = [];
		for (k in settings.keys())
			dogshet.push(k);
		return dogshet;
	}

	public static function getSetting(setting:String):Dynamic
	{
		if (settings.exists(setting))
			return settings.get(setting)
		else
			return null;
	}

	public static function getValue(setting:String):Dynamic
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
