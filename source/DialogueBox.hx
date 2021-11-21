package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	public static var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;
	var dropText:FlxText;


	public var finishThing:Void->Void;
	
	var portraitLeft:FlxSprite;
	var portraitLeft1:FlxSprite;
	var portraitLeft2:FlxSprite;
	var portraitLeft3:FlxSprite;
	var portraitLeft4:FlxSprite;
	var portraitLeft5:FlxSprite;
	var portraitLeft6:FlxSprite;
	var portraitLeft7:FlxSprite;
	var portraitLeft8:FlxSprite;
	var portraitLeft9:FlxSprite;
	var portraitLeft10:FlxSprite;
	var portraitLeft11:FlxSprite;
	var portraitLeft12:FlxSprite;
	var portraitLeft13:FlxSprite;
	var portraitLeft14:FlxSprite;
	var portraitLeft15:FlxSprite;
	var portraitLeft16:FlxSprite;
	var portraitLeft17:FlxSprite;
	var portraitLeft18:FlxSprite;
	var portraitLeft19:FlxSprite;
	var portraitLeft20:FlxSprite;

	var portraitRight:FlxSprite;
	var portraitRight1:FlxSprite;
	var portraitRight2:FlxSprite;
	var portraitRight3:FlxSprite;
	var portraitRight4:FlxSprite;
	var portraitRight5:FlxSprite;
	var portraitRight6:FlxSprite;
	var portraitRight7:FlxSprite;
	var portraitRight8:FlxSprite;
	var portraitRight9:FlxSprite;
	var portraitRight10:FlxSprite;
	var portraitRight11:FlxSprite;
	var portraitRight12:FlxSprite;
	var portraitRight13:FlxSprite;
	var portraitRight14:FlxSprite;
	var portraitRight15:FlxSprite;
	var portraitRight16:FlxSprite;
	var portraitRight17:FlxSprite;
	var portraitRight18:FlxSprite;
	var portraitRight19:FlxSprite;
	var portraitRight20:FlxSprite;



	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}
		

		
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

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);

		    default:
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('customdialogue/dialogueBox-notpixel');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24, true);
				box.width = 200;
				box.height = 200;
				box.x = -100;
				box.y = 375;
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		portraitLeft = new FlxSprite(-20, 40);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
		portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;
		
		portraitLeft1 = new FlxSprite(155, FlxG.height - 510);
		portraitLeft1.frames = Paths.getSparrowAtlas('customdialogue/customcharonePort');
		portraitLeft1.animation.addByPrefix('enter', 'BF portrait enter', 24, true);
		portraitLeft1.antialiasing = true;
		portraitLeft1.updateHitbox();
		portraitLeft1.scrollFactor.set();
		add(portraitLeft1);
		portraitLeft1.visible = false;

		portraitLeft2 = new FlxSprite(155, FlxG.height - 510);
		portraitLeft2.frames = Paths.getSparrowAtlas('customdialogue/customchartwoPort');
		portraitLeft2.animation.addByPrefix('enter', 'BF portrait enter', 24, true);
		portraitLeft2.antialiasing = true;
		portraitLeft2.updateHitbox();
		portraitLeft2.scrollFactor.set();
		add(portraitLeft2);
		portraitLeft2.visible = false;

		portraitLeft3 = new FlxSprite(155, FlxG.height - 510);
		portraitLeft3.frames = Paths.getSparrowAtlas('customdialogue/customcharthreePort');
		portraitLeft3.animation.addByPrefix('enter', 'BF portrait enter', 24, true);
		portraitLeft3.antialiasing = true;
		portraitLeft3.updateHitbox();
		portraitLeft3.scrollFactor.set();
		add(portraitLeft3);
		portraitLeft3.visible = false;

		portraitLeft4 = new FlxSprite(155, FlxG.height - 510);
		portraitLeft4.frames = Paths.getSparrowAtlas('customdialogue/customcharfourPort');
		portraitLeft4.animation.addByPrefix('enter', 'BF portrait enter', 24, true);
		portraitLeft4.antialiasing = true;
		portraitLeft4.updateHitbox();
		portraitLeft4.scrollFactor.set();
		add(portraitLeft4);
		portraitLeft4.visible = false;

		portraitLeft5 = new FlxSprite(155, FlxG.height - 510);
		portraitLeft5.frames = Paths.getSparrowAtlas('customdialogue/customcharfivePort');
		portraitLeft5.animation.addByPrefix('enter', 'BF portrait enter', 24, true);
		portraitLeft5.antialiasing = true;
		portraitLeft5.updateHitbox();
		portraitLeft5.scrollFactor.set();
		add(portraitLeft5);
		portraitLeft5.visible = false;

		portraitLeft6 = new FlxSprite(155, FlxG.height - 510);
		portraitLeft6.frames = Paths.getSparrowAtlas('customdialogue/customcharsixPort');
		portraitLeft6.animation.addByPrefix('enter', 'BF portrait enter', 24, true);
		portraitLeft6.antialiasing = true;
		portraitLeft6.updateHitbox();
		portraitLeft6.scrollFactor.set();
		add(portraitLeft6);
		portraitLeft6.visible = false;

		portraitLeft7 = new FlxSprite(155, FlxG.height - 510);
		portraitLeft7.frames = Paths.getSparrowAtlas('customdialogue/customcharsevenPort');
		portraitLeft7.animation.addByPrefix('enter', 'BF portrait enter', 24, true);
		portraitLeft7.antialiasing = true;
		portraitLeft7.updateHitbox();
		portraitLeft7.scrollFactor.set();
		add(portraitLeft7);
		portraitLeft7.visible = false;

		portraitLeft8 = new FlxSprite(155, FlxG.height - 510);
		portraitLeft8.frames = Paths.getSparrowAtlas('customdialogue/customchareightPort');
		portraitLeft8.animation.addByPrefix('enter', 'BF portrait enter', 24, true);
		portraitLeft8.antialiasing = true;
		portraitLeft8.updateHitbox();
		portraitLeft8.scrollFactor.set();
		add(portraitLeft8);
		portraitLeft8.visible = false;

		portraitLeft9 = new FlxSprite(155, FlxG.height - 510);
		portraitLeft9.frames = Paths.getSparrowAtlas('customdialogue/customcharninePort');
		portraitLeft9.animation.addByPrefix('enter', 'BF portrait enter', 24, true);
		portraitLeft9.antialiasing = true;
		portraitLeft9.updateHitbox();
		portraitLeft9.scrollFactor.set();
		add(portraitLeft9);
		portraitLeft9.visible = false;

		portraitLeft10 = new FlxSprite(155, FlxG.height - 510);
		portraitLeft10.frames = Paths.getSparrowAtlas('customdialogue/customchartenPort');
		portraitLeft10.animation.addByPrefix('enter', 'BF portrait enter', 24, true);
		portraitLeft10.antialiasing = true;
		portraitLeft10.updateHitbox();
		portraitLeft10.scrollFactor.set();
		add(portraitLeft10);
		portraitLeft10.visible = false;

		portraitLeft11 = new FlxSprite(155, FlxG.height - 510);
		portraitLeft11.frames = Paths.getSparrowAtlas('customdialogue/customcharelevenPort');
		portraitLeft11.animation.addByPrefix('enter', 'BF portrait enter', 24, true);
		portraitLeft11.antialiasing = true;
		portraitLeft11.updateHitbox();
		portraitLeft11.scrollFactor.set();
		add(portraitLeft11);
		portraitLeft11.visible = false;

		portraitLeft12 = new FlxSprite(155, FlxG.height - 510);
		portraitLeft12.frames = Paths.getSparrowAtlas('customdialogue/customchartwelvePort');
		portraitLeft12.animation.addByPrefix('enter', 'BF portrait enter', 24, true);
		portraitLeft12.antialiasing = true;
		portraitLeft12.updateHitbox();
		portraitLeft12.scrollFactor.set();
		add(portraitLeft12);
		portraitLeft12.visible = false;

		portraitLeft13 = new FlxSprite(155, FlxG.height - 510);
		portraitLeft13.frames = Paths.getSparrowAtlas('customdialogue/customcharthirteenPort');
		portraitLeft13.animation.addByPrefix('enter', 'BF portrait enter', 24, true);
		portraitLeft13.antialiasing = true;
		portraitLeft13.updateHitbox();
		portraitLeft13.scrollFactor.set();
		add(portraitLeft13);
		portraitLeft13.visible = false;

		portraitLeft14 = new FlxSprite(155, FlxG.height - 510);
		portraitLeft14.frames = Paths.getSparrowAtlas('customdialogue/customcharfourteenPort');
		portraitLeft14.animation.addByPrefix('enter', 'BF portrait enter', 24, true);
		portraitLeft14.antialiasing = true;
		portraitLeft14.updateHitbox();
		portraitLeft14.scrollFactor.set();
		add(portraitLeft14);
		portraitLeft14.visible = false;

		portraitLeft15 = new FlxSprite(155, FlxG.height - 510);
		portraitLeft15.frames = Paths.getSparrowAtlas('customdialogue/customcharfifteenPort');
		portraitLeft15.animation.addByPrefix('enter', 'BF portrait enter', 24, true);
		portraitLeft15.antialiasing = true;
		portraitLeft15.updateHitbox();
		portraitLeft15.scrollFactor.set();
		add(portraitLeft15);
		portraitLeft15.visible = false;

		portraitLeft16 = new FlxSprite(155, FlxG.height - 510);
		portraitLeft16.frames = Paths.getSparrowAtlas('customdialogue/customcharsixteenPort');
		portraitLeft16.animation.addByPrefix('enter', 'BF portrait enter', 24, true);
		portraitLeft16.antialiasing = true;
		portraitLeft16.updateHitbox();
		portraitLeft16.scrollFactor.set();
		add(portraitLeft16);
		portraitLeft16.visible = false;

		portraitLeft17 = new FlxSprite(155, FlxG.height - 510);
		portraitLeft17.frames = Paths.getSparrowAtlas('customdialogue/customcharseventeenPort');
		portraitLeft17.animation.addByPrefix('enter', 'BF portrait enter', 24, true);
		portraitLeft17.antialiasing = true;
		portraitLeft17.updateHitbox();
		portraitLeft17.scrollFactor.set();
		add(portraitLeft17);
		portraitLeft17.visible = false;

		portraitLeft18 = new FlxSprite(155, FlxG.height - 510);
		portraitLeft18.frames = Paths.getSparrowAtlas('customdialogue/customchareighteenPort');
		portraitLeft18.animation.addByPrefix('enter', 'BF portrait enter', 24, true);
		portraitLeft18.antialiasing = true;
		portraitLeft18.updateHitbox();
		portraitLeft18.scrollFactor.set();
		add(portraitLeft18);
		portraitLeft18.visible = false;

		portraitLeft19 = new FlxSprite(155, FlxG.height - 510);
		portraitLeft19.frames = Paths.getSparrowAtlas('customdialogue/customcharnineteenPort');
		portraitLeft19.animation.addByPrefix('enter', 'BF portrait enter', 24, true);
		portraitLeft19.antialiasing = true;
		portraitLeft19.updateHitbox();
		portraitLeft19.scrollFactor.set();
		add(portraitLeft19);
		portraitLeft19.visible = false;

		portraitLeft20 = new FlxSprite(155, FlxG.height - 510);
		portraitLeft20.frames = Paths.getSparrowAtlas('customdialogue/customchartwentyPort');
		portraitLeft20.animation.addByPrefix('enter', 'BF portrait enter', 24, true);
		portraitLeft20.antialiasing = true;
		portraitLeft20.updateHitbox();
		portraitLeft20.scrollFactor.set();
		add(portraitLeft20);
		portraitLeft20.visible = false;


	

		portraitRight = new FlxSprite(0, 40);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;

		portraitRight2 = new FlxSprite(800, FlxG.height - 520);
		portraitRight2.frames = Paths.getSparrowAtlas('customdialogue/boyfriendPort');
		portraitRight2.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitRight2.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight2.updateHitbox();
		portraitRight2.scrollFactor.set();
		add(portraitRight2);
		portraitRight2.visible = false;
		
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);



		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.setFormat(Paths.font("funkin.otf"), 50);
		dropText.color = FlxColor.GRAY;
		add(dropText);
	
		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.setFormat(Paths.font("funkin.otf"), 50);
		swagDialogue.color = FlxColor.BLACK;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);
		
		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}


	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI

		if (PlayState.SONG.song.toLowerCase() == 'senpai'){
	     	dropText.setFormat(Paths.font("pixel.otf"), 32);
			dropText.color = 0xFFD89494;
			swagDialogue.setFormat(Paths.font("pixel.otf"), 32);
			swagDialogue.color = 0xFF3F2021;
		}
		if (PlayState.SONG.song.toLowerCase() == 'roses'){
			portraitLeft.visible = false;
	     	dropText.setFormat(Paths.font("pixel.otf"), 32);
			dropText.color = 0xFFD89494;
			swagDialogue.setFormat(Paths.font("pixel.otf"), 32);
			swagDialogue.color = 0xFF3F2021;
		}
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
			swagDialogue.setFormat(Paths.font("pixel.otf"), 32);
		}
		

		dropText.text = swagDialogue.text;

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

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

    function startDialogue():Void
	{

		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{

			case 'dad':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}

			case 'dad1':
				portraitRight2.visible = false;
				if (!portraitLeft1.visible)
				{
					portraitLeft1.visible = true;
					portraitLeft1.animation.play('enter');
				}
				case 'dad2':
				portraitRight2.visible = false;
				if (!portraitLeft2.visible)
				{
					portraitLeft2.visible = true;
					portraitLeft2.animation.play('enter');
				}
				case 'dad3':
				portraitRight2.visible = false;
				if (!portraitLeft3.visible)
				{
					portraitLeft3.visible = true;
					portraitLeft3.animation.play('enter');
				}
				case 'dad4':
				portraitRight2.visible = false;
				if (!portraitLeft4.visible)
				{
					portraitLeft4.visible = true;
					portraitLeft4.animation.play('enter');
				}
				case 'dad5':
				portraitRight2.visible = false;
				if (!portraitLeft5.visible)
				{
					portraitLeft5.visible = true;
					portraitLeft5.animation.play('enter');
				}
				case 'dad6':
				portraitRight2.visible = false;
				if (!portraitLeft6.visible)
				{
					portraitLeft6.visible = true;
					portraitLeft6.animation.play('enter');
				}
				case 'dad7':
				portraitRight2.visible = false;
				if (!portraitLeft7.visible)
				{
					portraitLeft7.visible = true;
					portraitLeft7.animation.play('enter');
				}
				case 'dad8':
				portraitRight2.visible = false;
				if (!portraitLeft8.visible)
				{
					portraitLeft8.visible = true;
					portraitLeft8.animation.play('enter');
				}
				case 'dad9':
				portraitRight2.visible = false;
				if (!portraitLeft9.visible)
				{
					portraitLeft9.visible = true;
					portraitLeft9.animation.play('enter');
				}
				case 'dad10':
				portraitRight2.visible = false;
				if (!portraitLeft10.visible)
				{
					portraitLeft10.visible = true;
					portraitLeft10.animation.play('enter');
				}
				case 'dad11':
				portraitRight2.visible = false;
				if (!portraitLeft11.visible)
				{
					portraitLeft11.visible = true;
					portraitLeft11.animation.play('enter');
				}
				case 'dad12':
				portraitRight2.visible = false;
				if (!portraitLeft12.visible)
				{
					portraitLeft12.visible = true;
					portraitLeft12.animation.play('enter');
				}
				case 'dad13':
				portraitRight2.visible = false;
				if (!portraitLeft13.visible)
				{
					portraitLeft13.visible = true;
					portraitLeft13.animation.play('enter');
				}
				case 'dad14':
				portraitRight2.visible = false;
				if (!portraitLeft14.visible)
				{
					portraitLeft14.visible = true;
					portraitLeft14.animation.play('enter');
				}
				case 'dad15':
				portraitRight2.visible = false;
				if (!portraitLeft15.visible)
				{
					portraitLeft15.visible = true;
					portraitLeft15.animation.play('enter');
				}

				case 'dad16':
				portraitRight2.visible = false;
				if (!portraitLeft16.visible)
				{
					portraitLeft16.visible = true;
					portraitLeft16.animation.play('enter');
				}
				case 'dad17':
				portraitRight2.visible = false;
				if (!portraitLeft17.visible)
				{
					portraitLeft17.visible = true;
					portraitLeft17.animation.play('enter');
				}
				case 'dad18':
				portraitRight2.visible = false;
				if (!portraitLeft18.visible)
				{
					portraitLeft18.visible = true;
					portraitLeft18.animation.play('enter');
				}
				case 'dad19':
				portraitRight2.visible = false;
				if (!portraitLeft19.visible)
				{
					portraitLeft19.visible = true;
					portraitLeft19.animation.play('enter');
				}
				case 'dad20':
				portraitRight2.visible = false;
				if (!portraitLeft20.visible)
				{
					portraitLeft20.visible = true;
					portraitLeft20.animation.play('enter');
				}
			case 'bf':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
				case 'bf1':
				portraitLeft1.visible = false;
				if (!portraitRight2.visible)
				{
					portraitRight2.visible = true;
					portraitRight2.animation.play('enter');
				}
				case 'bf2':
				portraitLeft2.visible = false;
				if (!portraitRight2.visible)
				{
					portraitRight2.visible = true;
					portraitRight2.animation.play('enter');
				}
				case 'bf3':
				portraitLeft3.visible = false;
				if (!portraitRight2.visible)
				{
					portraitRight2.visible = true;
					portraitRight2.animation.play('enter');
				}
				case 'bf4':
				portraitLeft4.visible = false;
				if (!portraitRight2.visible)
				{
					portraitRight2.visible = true;
					portraitRight2.animation.play('enter');
				}
				case 'bf5':
				portraitLeft5.visible = false;
				if (!portraitRight2.visible)
				{
					portraitRight2.visible = true;
					portraitRight2.animation.play('enter');
				}
				case 'bf6':
				portraitLeft6.visible = false;
				if (!portraitRight2.visible)
				{
					portraitRight2.visible = true;
					portraitRight2.animation.play('enter');
				}
				case 'bf7':
				portraitLeft7.visible = false;
				if (!portraitRight2.visible)
				{
					portraitRight2.visible = true;
					portraitRight2.animation.play('enter');
				}
				case 'bf8':
				portraitLeft8.visible = false;
				if (!portraitRight2.visible)
				{
					portraitRight2.visible = true;
					portraitRight2.animation.play('enter');
				}
				case 'bf9':
				portraitLeft9.visible = false;
				if (!portraitRight2.visible)
				{
					portraitRight2.visible = true;
					portraitRight2.animation.play('enter');
				}
				case 'bf10':
				portraitLeft10.visible = false;
				if (!portraitRight2.visible)
				{
					portraitRight2.visible = true;
					portraitRight2.animation.play('enter');
				}
				case 'bf11':
				portraitLeft11.visible = false;
				if (!portraitRight2.visible)
				{
					portraitRight2.visible = true;
					portraitRight2.animation.play('enter');
				}
				case 'bf12':
				portraitLeft12.visible = false;
				if (!portraitRight2.visible)
				{
					portraitRight2.visible = true;
					portraitRight2.animation.play('enter');
				}
				case 'bf13':
				portraitLeft13.visible = false;
				if (!portraitRight2.visible)
				{
					portraitRight2.visible = true;
					portraitRight2.animation.play('enter');
				}
				case 'bf14':
				portraitLeft14.visible = false;
				if (!portraitRight2.visible)
				{
					portraitRight2.visible = true;
					portraitRight2.animation.play('enter');
				}
				case 'bf15':
				portraitLeft15.visible = false;
				if (!portraitRight2.visible)
				{
					portraitRight2.visible = true;
					portraitRight2.animation.play('enter');
				}
				case 'bf16':
				portraitLeft16.visible = false;
				if (!portraitRight2.visible)
				{
					portraitRight2.visible = true;
					portraitRight2.animation.play('enter');
				}
				case 'bf17':
				portraitLeft17.visible = false;
				if (!portraitRight2.visible)
				{
					portraitRight2.visible = true;
					portraitRight2.animation.play('enter');
				}

				case 'bf18':
				portraitLeft18.visible = false;
				if (!portraitRight2.visible)
				{
					portraitRight2.visible = true;
					portraitRight2.animation.play('enter');
				}
				case 'bf19':
				portraitLeft19.visible = false;
				if (!portraitRight2.visible)
				{
					portraitRight2.visible = true;
					portraitRight2.animation.play('enter');
				}
				case 'bf20':
				portraitLeft20.visible = false;
				if (!portraitRight2.visible)
				{
					portraitRight2.visible = true;
					portraitRight2.animation.play('enter');
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
