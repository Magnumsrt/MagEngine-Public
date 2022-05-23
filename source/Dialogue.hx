package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class Dialogue extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogueList:Array<String> = [];

	var dialogue:Alphabet;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	// TODO: draw a hand select lol
	var bgFade:FlxSprite;

	public function new(dialogueList:Array<String>)
	{
		super();

		FlxG.sound.playMusic(Paths.music('breakfast'), 0);
		FlxG.sound.music.fadeIn(1, 0, 0.5);

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(0, 350);
		box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
		box.animation.addByPrefix('normal', 'speech bubble normal', 24);
		box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
		// box.setGraphicSize(Std.int(box.width * 0.9));
		// box.updateHitbox();
		box.antialiasing = true;

		this.dialogueList = dialogueList;

		portraitLeft = new FlxSprite(-20, 40).loadGraphic(Paths.image('lol'));
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(0, 40).loadGraphic(Paths.image('week54prototype'));
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;

		box.animation.play('normalOpen');
		add(box);

		box.screenCenter(X);
		box.x += 25;
		portraitLeft.screenCenter(X);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (!isEnding)
		{
			if (CoolUtil.getControls().ACCEPT && dialogueStarted == true)
			{
				FlxG.sound.play(Paths.sound('clickText'), 0.8);

				if (dialogueList[1] == null && dialogueList[0] != null)
				{
					isEnding = true;

					FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						dialogue.alpha -= 1 / 5;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
				else
				{
					dialogueList.remove(dialogueList[0]);
					startDialogue();
				}
			}
		}

		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();

		if (dialogue != null)
		{
			dialogue.killTheTimer();
			dialogue.kill();
			remove(dialogue, true);
		}
		dialogue = new Alphabet(30, box.y + 55, dialogueList[0], false, true, 0, 0.7);
		add(dialogue);

		switch (curCharacter)
		{
			case 'dad':
				box.flipX = true;
				portraitRight.visible = false;
				if (!portraitLeft.visible)
					portraitLeft.visible = true;
			case 'bf':
				box.flipX = false;
				portraitLeft.visible = false;
				if (!portraitRight.visible)
					portraitRight.visible = true;
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
