package;

import lime.app.Application;
import flixel.FlxG;
import haxe.CallStack;
import haxe.CallStack.StackItem;
import openfl.events.UncaughtErrorEvent;
import flixel.graphics.FlxGraphic;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	// You can pretty much ignore everything from here on - your code should go in your states.
	var fpsCounter:FPSCounter;

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
			removeEventListener(Event.ADDED_TO_STAGE, init);

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		#if sys
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#end

		#if !debug
		initialState = TitleState;
		#end

		FlxGraphic.defaultPersist = true;

		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));

		MagPrefs.load();

		#if !html5
		setFramerate(MagPrefs.getValue('framerate'));
		#end

		#if !mobile
		fpsCounter = new FPSCounter(10, 3, 0xffffff);
		addChild(fpsCounter);
		setFPSDisplay();
		#end

		FlxG.mouse.visible = false;
	}

	public static function setFramerate(input:Int)
	{
		if (input > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = input;
			FlxG.drawFramerate = input;
		}
		else
		{
			FlxG.drawFramerate = input;
			FlxG.updateFramerate = input;
		}
	}

	public static function setFPSDisplay()
	{
		var leMain:Main = cast Lib.current.getChildAt(0);
		leMain.toggleFPS(MagPrefs.getValue('fps'));
		leMain.toggleMem(MagPrefs.getValue('mem'));
		leMain.toggleMemPeak(MagPrefs.getValue('memPeak'));
	}

	public function toggleFPS(value:Bool)
	{
		if (fpsCounter != null)
			fpsCounter.showFPS = value;
	}

	public function toggleMem(value:Bool)
	{
		if (fpsCounter != null)
			fpsCounter.showMEM = value;
	}

	public function toggleMemPeak(value:Bool)
	{
		if (fpsCounter != null)
			fpsCounter.showMEMPeak = value;
	}

	#if sys
	function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = '';
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + ' (line " + line + ")\n';
				default:
					Sys.println(stackItem);
			}
		}

		errMsg += "\nUncaught Error: " + e.error;

		Sys.println(errMsg);

		Application.current.window.alert(errMsg, 'Error!');

		Sys.exit(1);
	}
	#end
}
