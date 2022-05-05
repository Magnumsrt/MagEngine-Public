package;

import flixel.math.FlxMath;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * FPS class extension to display memory usage.
 * @author Kirill Poletaev
 */
class FPSCounter extends TextField
{
	private var currentFPS:Int;

	private var cacheCount:Int = 0;
	private var currentTime:Float = 0;
	private var times:Array<Float> = [];

	private var memPeak:Float = 0;

	public var showFPS:Bool = true;
	public var showMEM:Bool = true;
	public var showMEMPeak:Bool = true;

	public function new(inX:Float = 10.0, inY:Float = 10.0, inCol:Int = 0x000000)
	{
		super();

		x = inX;
		y = inY;

		selectable = false;
		defaultTextFormat = new TextFormat("_sans", 12, inCol);
		text = "FPS: ";

		width = 150;
		height = 70;
	}

	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
			times.shift();

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);

		if (visible && currentCount != cacheCount)
		{
			text = "";
			if (showFPS)
				text += "FPS: " + times.length + "\n";

			#if openfl
			var mem:Float = Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000, 1));
			if (mem > memPeak)
				memPeak = mem;

			if (showMEM)
				text += "MEM: " + mem + " MB\n";
			if (showMEMPeak)
				text += "MEM peak: " + memPeak + " MB";
			#end
		}

		cacheCount = currentCount;
	}
}
