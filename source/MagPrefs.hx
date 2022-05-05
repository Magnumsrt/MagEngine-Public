package;

import Controls.KeyboardScheme;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;

typedef Setting =
{
	var type:SettingType;
	var value:Dynamic;

	// for string, percent and numbers types
	@:optional var options:Array<String>;
	@:optional var curOption:Int;
	@:optional var decimals:Int;
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
	static final defaultSettings:Map<String, Setting> = [
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
		'cameraMove' => {
			type: Boolean,
			value: true
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
		'noteSplashes' => {
			type: Boolean,
			value: true
		},
		'notesBehindHud' => {
			type: Boolean,
			value: false
		},
		// graphics settings
		#if !html5
		'framerate' => {
			type: Integer,
			value: 60,
			min: 60,
			max: 240
		},
		#end
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
		},
		// other funni shit
		'versionCheck' => {
			type: Boolean,
			value: true
		}
	];
	static var settings:Map<String, Setting>;

	// DON'T SET SOMETHING ON CUSTOMCONTROLS SINCE ITS AUTOMATICALLY USED BY KEYBINDS SHIT!!
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

	static var save:FlxSave;

	public static function load()
	{
		// place shit in a separate save since this is better for don't erase score stuff
		if (save == null)
		{
			save = new FlxSave();
			save.bind('settings', 'ninjamuffin99');
		}

		if (save.data.settings == null)
			settings = defaultSettings;
		else
		{
			settings = save.data.settings;
			for (key => setting in defaultSettings)
				if (!settings.exists(key))
					settings.set(key, setting);
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

	public static function flush()
	{
		save.data.settings = settings;
		save.data.customControls = keyBinds;
		save.flush();
	}

	public static function getSetting(setting:String)
	{
		return settings.get(setting);
	}

	public static function setSetting(setting:String, value:Dynamic, ?type:SettingType, ?min:Float, ?max:Float)
	{
		// this is so awesome
		var leSetting:Setting = {
			type: Boolean,
			value: value
		};
		var defaultSetting:Setting = defaultSettings.get(setting);

		if (type == null && defaultSetting != null)
			leSetting.type = defaultSetting.type;

		if (type == null && defaultSetting != null && defaultSetting.decimals != null)
			leSetting.decimals = defaultSetting.decimals;

		if (min != null)
			leSetting.min = min;
		else if (defaultSetting != null && defaultSetting.min != null)
			leSetting.min = defaultSetting.min;
		if (max != null)
			leSetting.max = max;
		else if (defaultSetting != null && defaultSetting.max != null)
			leSetting.max = defaultSetting.max;

		settings.set(setting, leSetting);
	}

	public static function resetSetting(setting:String)
	{
		var defaultSetting:Setting = defaultSettings.get(setting);
		if (defaultSetting != null)
			settings.set(setting, defaultSetting);
	}

	public static function setOption(setting:String, index:Int)
	{
		var leSetting:Setting = getSetting(setting);
		if (leSetting != null && leSetting.type == String && leSetting.options != null && leSetting.options[index] != null)
		{
			leSetting.curOption = index;
			settings.set(setting, leSetting);
		}
	}

	public static function getValue(setting:String):Dynamic
	{
		var shit:Setting = getSetting(setting);
		if (shit != null)
			return shit.value;
		else
			return null;
	}

	public static function getMinValue(setting:String)
	{
		var leSetting:Setting = getSetting(setting);
		var defaultSetting:Setting = defaultSettings.get(setting);
		if (leSetting != null && leSetting.min != null)
			return leSetting.min;
		else if (defaultSetting != null && defaultSetting.min != null)
			return defaultSetting.min;
		else
			return Math.NaN;
	}

	public static function getMaxValue(setting:String)
	{
		var leSetting:Setting = getSetting(setting);
		var defaultSetting:Setting = defaultSettings.get(setting);
		if (leSetting != null && leSetting.max != null)
			return leSetting.max;
		else if (defaultSetting != null && defaultSetting.max != null)
			return defaultSetting.max;
		else
			return Math.NaN;
	}

	public static function getCurOption(setting:String)
	{
		var leSetting:Setting = getSetting(setting);
		var defaultSetting:Setting = defaultSettings.get(setting);
		if (leSetting != null && leSetting.curOption != null)
			return leSetting.curOption;
		else if (defaultSetting != null && defaultSetting.curOption != null)
			return defaultSetting.curOption;
		else
			return 0;
	}

	public static function getOptions(setting:String)
	{
		var leSetting:Setting = getSetting(setting);
		var defaultSetting:Setting = defaultSettings.get(setting);
		if (leSetting != null && leSetting.options != null)
			return leSetting.options;
		else if (defaultSetting != null && defaultSetting.options != null)
			return defaultSetting.options;
		else
			return null;
	}
}
