package modloader;

#if MODS
import modloader.ModList;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;

class ModsMenuOption extends FlxTypedGroup<FlxSprite>
{
	public var text:Alphabet;
	public var icon:ModIcon;

	public var enabled:Bool = false;

	public var row:Int = 0;

	public var name:String = "-";
	public var value:String = "Template Mod";

	public static var enableButton:FlxButton;

	public static var disableButton:FlxButton;

	public function new(name:String = "-", value:String = "Template Mod", row:Int = 0)
	{
		super();

		this.name = name;
		this.value = value;
		this.row = row;

		var scale:Float = Math.min(9.2 / (name.length), 1);
		text = new Alphabet(0, 0 + (row * 100), name, true, false, 0.05, scale);
		text.isMenuItem = true;
		text.targetY = row;
		add(text);

		icon = new ModIcon(value);
		icon.sprTracker = text;
		add(icon);

		enabled = ModList.modList.get(value);

		FlxG.mouse.visible = true;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (enabled)
			text.color = FlxColor.GREEN;
		else
			text.color = FlxColor.RED;
	}
}
#end
