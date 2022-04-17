package;

import hscript.Expr.Error;
import flixel.FlxBasic;
import sys.io.File;
import hscript.Parser;
import haxe.Json;
import Discord.DiscordClient;
import hscript.Interp;

class Script
{
	public static final Function_Stop:Int = 1;
	public static final Function_Continue:Int = 0;

	private static var interp:Interp;

	public var path:String;

	public function new(path:String)
	{
		this.path = path;

		if (interp == null)
		{
			interp = new Interp();

			// callbacks
			interp.variables.set("add", function(Object:FlxBasic)
			{
				return PlayState.instance.add(Object);
			});
			interp.variables.set("remove", function(Object:FlxBasic, Splice:Bool = false)
			{
				return PlayState.instance.remove(Object, Splice);
			});

			// variables
			interp.variables.set("Function_Stop", Function_Stop);
			interp.variables.set("Function_Continue", Function_Continue);
			interp.variables.set("PlayState", PlayState);
			interp.variables.set("MusicBeatState", MusicBeatState);
			interp.variables.set("MusicBeatSubstate", MusicBeatSubstate);
			interp.variables.set("Conductor", Conductor);
			interp.variables.set("DiscordClient", DiscordClient);
			interp.variables.set("WiggleEffectType", WiggleEffect.WiggleEffectType);
			interp.variables.set("FlxBasic", flixel.FlxBasic);
			// interp.variables.set("MidSongEvent", Song.MidSongEvent);
			interp.variables.set("FlxCamera", flixel.FlxCamera);
			interp.variables.set("ChromaticAberration", shaders.ChromaticAberration);
			interp.variables.set("FlxG", flixel.FlxG);
			interp.variables.set("FlxGame", flixel.FlxGame);
			interp.variables.set("FlxObject", flixel.FlxObject);
			interp.variables.set("FlxColor", flixel.FlxSprite);
			interp.variables.set("FlxSprite", flixel.FlxSprite);
			interp.variables.set("FlxState", flixel.FlxState);
			interp.variables.set("FlxSubState", flixel.FlxSubState);
			interp.variables.set("FlxGridOverlay", flixel.addons.display.FlxGridOverlay);
			interp.variables.set("FlxTrail", flixel.addons.effects.FlxTrail);
			interp.variables.set("FlxTrailArea", flixel.addons.effects.FlxTrailArea);
			interp.variables.set("FlxEffectSprite", flixel.addons.effects.chainable.FlxEffectSprite);
			interp.variables.set("FlxWaveEffect", flixel.addons.effects.chainable.FlxWaveEffect);
			interp.variables.set("FlxTransitionableState", flixel.addons.transition.FlxTransitionableState);
			interp.variables.set("FlxAtlas", flixel.graphics.atlas.FlxAtlas);
			interp.variables.set("FlxAtlasFrames", flixel.graphics.frames.FlxAtlasFrames);
			interp.variables.set("FlxTypedGroup", flixel.group.FlxGroup.FlxTypedGroup);
			interp.variables.set("Math", Math);
			interp.variables.set("FlxMath", flixel.math.FlxMath);
			interp.variables.set("FlxPoint", flixel.math.FlxPoint);
			interp.variables.set("FlxRect", flixel.math.FlxRect);
			interp.variables.set("FlxSound", flixel.system.FlxSound);
			interp.variables.set("FlxText", flixel.text.FlxText);
			interp.variables.set("FlxEase", flixel.tweens.FlxEase);
			interp.variables.set("FlxTween", flixel.tweens.FlxTween);
			interp.variables.set("FlxBar", flixel.ui.FlxBar);
			interp.variables.set("FlxCollision", flixel.util.FlxCollision);
			interp.variables.set("FlxSort", flixel.util.FlxSort);
			interp.variables.set("FlxStringUtil", flixel.util.FlxStringUtil);
			interp.variables.set("FlxTimer", flixel.util.FlxTimer);
			interp.variables.set("Json", Json);
			interp.variables.set("Assets", lime.utils.Assets);
			interp.variables.set("ShaderFilter", openfl.filters.ShaderFilter);
			interp.variables.set("Exception", haxe.Exception);
			interp.variables.set("Lib", openfl.Lib);
			interp.variables.set("OpenFlAssets", openfl.utils.Assets);
			#if sys
			interp.variables.set("File", File);
			interp.variables.set("FileSystem", sys.FileSystem);
			interp.variables.set("FlxGraphic", flixel.graphics.FlxGraphic);
			interp.variables.set("BitmapData", openfl.display.BitmapData);
			#end
			interp.variables.set("ModsMenu", modloader.ModsMenu);
			interp.variables.set("MagPrefs", MagPrefs);
			interp.variables.set("Song", Song);
			interp.variables.set("Song", Song);
			interp.variables.set("Character", Character);
			interp.variables.set("Boyfriend", Boyfriend);
			interp.variables.set("Note", Note);
			interp.variables.set("StrumNote", StrumNote);
			interp.variables.set("NoteSplash", NoteSplash);
			interp.variables.set("Section", Section);
			interp.variables.set("AttachedSprite", AttachedSprite);
			interp.variables.set("HealthIcon", HealthIcon);
			interp.variables.set("Alphabet", Alphabet);
			interp.variables.set("CoolUtil", CoolUtil);
			interp.variables.set("controls", PlayerSettings.player1.controls);
			interp.variables.set("Paths", Paths);
		}

		var parser:Parser = new Parser();
		parser.allowJSON = true;
		parser.allowTypes = true;
		try
		{
			interp.execute(parser.parseString(File.getContent(path)));
			trace('loaded script ' + path);
		}
		catch (e:Error)
		{
			trace('parsing error at line ' + parser.line + ' for script ' + path);
		}
	}

	public function call(functionToCall:String, ?params:Array<Dynamic>):Dynamic
	{
		if (interp == null)
			return null;

		if (interp.variables.exists(functionToCall))
		{
			var functionH = interp.variables.get(functionToCall);
			if (params == null)
			{
				var result = null;
				result = functionH();
				return result;
			}
			else
			{
				var result = null;
				result = Reflect.callMethod(null, functionH, params);
				return result;
			}
		}

		return null;
	}
}
