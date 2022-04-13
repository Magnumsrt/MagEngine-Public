package;

import haxe.Timer;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * FPS class extension to display memory usage.
 * @author Kirill Poletaev
 */
class FPSCounter extends TextField
{
	private var times:Array<Float>;

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
		times = [];

		addEventListener(Event.ENTER_FRAME, onEnter);

		width = 150;
		height = 70;
	}

	private function onEnter(_)
	{
		var now = Timer.stamp();
		times.push(now);

		while (times[0] < now - 1)
			times.shift();

		var mem:Float = Math.round(System.totalMemory / 1024 / 1024 * 100) / 100;
		if (mem > memPeak)
			memPeak = mem;

		if (visible)
		{
			text = "";
			if (showFPS)
				text += "FPS: " + times.length + "\n";
			if (showMEM)
				text += "MEM: " + mem + " MB\n";
			if (showMEMPeak)
				text += "MEM peak: " + memPeak + " MB";
		}
	}
}
