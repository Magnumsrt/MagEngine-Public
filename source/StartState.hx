package;

#if DISCORD
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxState;
import modloader.PolymodHandler;

/**
 * State that manages initiation of settings, mods...
 * 
 * Used at start of the game (logically lol).
 */
class StartState extends FlxState
{
	override function create()
	{
		super.create();

		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.visible = false;

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

		FlxG.signals.preStateCreate.add(function(state:FlxState)
		{
			if (!Std.isOfType(state, PlayState) && !Std.isOfType(state, ChartingState) && !Std.isOfType(state, AnimationDebug))
				Cache.clear();
		});

		PlayerSettings.init();
		FlxG.save.bind('funkin', 'ninjamuffin99');

		MagPrefs.load();
		Highscore.load();

		#if DISCORD
		DiscordClient.initialize();

		lime.app.Application.current.onExit.add(function(exitCode)
		{
			DiscordClient.shutdown();
		});
		#end

		#if MODS
		PolymodHandler.loadMods();
		#end

		#if !html5
		Main.setFramerate(MagPrefs.getValue('framerate'));
		#end
		Main.setFPSDisplay();

		// final shit goes here
		FlxG.switchState(new TitleState());
	}
}
