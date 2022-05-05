package modloader;

#if sys
import sys.io.File;
import openfl.display.BitmapData;

class ModIcon extends AttachedSprite
{
	public function new(modId:String)
	{
		super();

		loadGraphic(BitmapData.fromBytes(File.getBytes(Sys.getCwd() + 'mods/' + modId + '/meta.png')), false, 0, 0, false, modId);

		setGraphicSize(150, 150);
		scrollFactor.set();
		antialiasing = true;
	}
}
#end
