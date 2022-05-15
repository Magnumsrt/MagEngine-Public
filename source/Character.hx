package;

import flixel.util.FlxTimer;
import openfl.utils.Assets;
import animateatlas.AtlasFrameMaker;
import flixel.util.FlxColor;
import haxe.Json;
import flixel.FlxSprite;

using StringTools;

// im using these things a lot lol
typedef SwagCharacter =
{
	var animations:Array<SwagAnimation>;
	var image:String;
	var icon:String;
	var healthbarColor:Array<Int>;
	var position:Array<Float>;
	var cameraPosition:Array<Float>;
	var singDuration:Float;
	var scale:Float;
	var flipX:Bool;
	var flipY:Bool;
}

typedef SwagAnimation =
{
	var anim:String;
	var name:String;
	var offsets:Array<Int>;
	var loop:Bool;
}

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Float>> = [];
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String;

	public var hasMissAnimations:Bool = false;
	public var danceIdle:Bool = false;

	public var singDuration:Float = 4;

	public var barColor:FlxColor = FlxColor.BLACK;

	public var positionArray:Array<Float> = [0, 0];
	public var cameraPosition:Array<Float> = [0, 0];

	public var idleTimer:FlxTimer;
	public var heyTimer:Float = 0;
	public var specialAnim:Bool = false;

	var checkHold:Bool = false;

	public var icon:String;

	public var camMoveArray:Array<Float> = [0, 0];
	public var camMoveAdd:Float = 15;

	public var stunned:Bool = false;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);
		changeCharacter(character, isPlayer);
		dance();
	}

	public function changeCharacter(character:String, isPlayer:Bool = false)
	{
		if (character == curCharacter)
			return;

		curCharacter = character;
		this.isPlayer = isPlayer;

		antialiasing = true;

		// some reset lol
		singDuration = 4;
		idleTimer = null;
		heyTimer = 0;
		specialAnim = false;
		checkHold = false;

		animOffsets.clear();
		stunned = false;

		positionArray = [0, 0];
		cameraPosition = [0, 0];

		var isHardcoded:Bool = true;

		switch (curCharacter)
		{
			case 'gf':
				frames = Paths.getSparrowAtlas('characters/GF_assets');

				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				barColor = FlxColor.fromRGB(165, 0, 77);

			case 'gf-christmas':
				frames = Paths.getSparrowAtlas('characters/gfChristmas');

				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				barColor = 0xA5004D;

				icon = 'gf';

			case 'gf-car':
				frames = Paths.getSparrowAtlas('characters/gfCar');

				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				barColor = FlxColor.fromRGB(165, 0, 77);

			case 'gf-pixel':
				frames = Paths.getSparrowAtlas('characters/gfPixel');

				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				barColor = FlxColor.fromRGB(165, 0, 77);
				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

				cameraPosition = [-20, 80];

				antialiasing = false;

			case 'dad':
				// DAD ANIMATION LOADING CODE
				frames = Paths.getSparrowAtlas('characters/DADDY_DEAREST');

				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				singDuration = 6.1;
				barColor = 0xFFaf66ce;

			case 'spooky':
				frames = Paths.getSparrowAtlas('characters/spooky_kids_assets');

				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				barColor = 0xFFd57e00;

				positionArray = [0, 200];

			case 'mom':
				frames = Paths.getSparrowAtlas('characters/Mom_Assets');

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				barColor = 0xFFd8558e;

			case 'mom-car':
				frames = Paths.getSparrowAtlas('characters/momCar');

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByIndices('idle-loop', "Mom Idle", [10, 11, 12, 13], "", 24, true);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				barColor = 0xFFd8558e;

				icon = 'mom';

			case 'monster':
				frames = Paths.getSparrowAtlas('characters/Monster_Assets');

				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				barColor = 0xFFf3ff6e;

				positionArray = [0, 100];

			case 'monster-christmas':
				frames = Paths.getSparrowAtlas('characters/monsterChristmas');

				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				barColor = 0xFFf3ff6e;

				positionArray = [0, 130];

				icon = 'monster';

			case 'pico':
				frames = Paths.getSparrowAtlas('characters/Pico_FNF_assetss');

				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				}

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				positionArray = [0, 300];

				barColor = 0xFFb7d855;
				flipX = true;

			case 'bf':
				frames = Paths.getSparrowAtlas('characters/BOYFRIEND');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				barColor = 0xFF31b0d1;
				flipX = true;

				positionArray = [0, 350];
			case 'bf-christmas':
				frames = Paths.getSparrowAtlas('characters/bfChristmas');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				barColor = 0xFF31b0d1;
				flipX = true;

				positionArray = [0, 350];

				icon = 'bf';
			case 'bf-car':
				frames = Paths.getSparrowAtlas('characters/bfCar');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByIndices('idle-loop', 'BF idle dance', [8, 9, 10, 11, 12, 13, 14], "", 24, true);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				barColor = 0xFF31b0d1;
				flipX = true;

				positionArray = [0, 350];

				icon = 'bf';
			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('characters/bfPixel');

				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				barColor = 0xFF31b0d1;

				positionArray = [0, 350];
				cameraPosition = [50, -60];

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;

			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bfPixelsDEAD');

				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);

				playAnim('firstDeath');
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				barColor = 0xFF31b0d1;
				flipX = true;

			case 'senpai':
				frames = Paths.getSparrowAtlas('characters/senpai');

				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				barColor = 0xFFffaa6f;
				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				positionArray = [0, 350];
				cameraPosition = [50, -60];

				positionArray = [150, 360];
				cameraPosition = [-240, -330];

				icon = 'senpai-pixel';

				antialiasing = false;
			case 'senpai-angry':
				frames = Paths.getSparrowAtlas('characters/senpai');

				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				barColor = 0xFFffaa6f;
				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				positionArray = [150, 360];
				cameraPosition = [-240, -330];

				icon = 'senpai-pixel';

				antialiasing = false;

			case 'spirit':
				frames = Paths.getPackerAtlas('characters/spirit');

				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				barColor = 0xFFff3c6e;

				positionArray = [-150, 100];

				icon = 'spirit-pixel';

				antialiasing = false;

			case 'parents-christmas':
				frames = Paths.getSparrowAtlas('characters/mom_dad_christmas_assets');

				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);
				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				barColor = 0xFF9a00f8;

				positionArray = [-500, 0];

				icon = 'parents';

			default:
				var parsedJson:SwagCharacter = cast Json.parse(Assets.getText(Paths.getPath('characters/' + curCharacter + '.json', TEXT)));

				flipX = parsedJson.flipX;
				flipY = parsedJson.flipY;

				setGraphicSize(Std.int(width * parsedJson.scale));
				updateHitbox();

				positionArray = parsedJson.position;
				cameraPosition = parsedJson.cameraPosition;

				singDuration = parsedJson.singDuration;

				icon = parsedJson.icon;
				barColor = FlxColor.fromRGB(parsedJson.healthbarColor[0], parsedJson.healthbarColor[1], parsedJson.healthbarColor[2]);

				if (Paths.fileExists(Paths.modFolder("images/characters/") + parsedJson.image + ".json"))
					frames = AtlasFrameMaker.construct(Paths.modFolder("characters/") + parsedJson.image);
				else if (parsedJson.animations != null && parsedJson.animations.length > 0)
				{
					frames = Paths.getSparrowAtlas(parsedJson.image);
					for (anim in parsedJson.animations)
					{
						if (anim.offsets != null && anim.offsets.length > 1)
							addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
						animation.addByPrefix('' + anim.anim, '' + anim.name, 24, !!anim.loop);
					}
				}

				isHardcoded = false;
		}

		if (isHardcoded)
			loadOffsetFromFile(curCharacter);

		if (icon == null)
			icon = curCharacter;

		for (anim in PlayState.singAnimations)
		{
			if (animation.getByName(anim + 'miss') != null)
			{
				hasMissAnimations = true;
				break;
			}
		}
		recalculateDanceIdle();

		if (isPlayer)
			flipX = !flipX;
	}

	override function update(elapsed:Float)
	{
		if (!debugMode && animation.curAnim != null)
		{
			if (heyTimer > 0)
			{
				heyTimer -= elapsed;
				if (heyTimer <= 0)
				{
					if (specialAnim && animation.curAnim.name == 'hey' || animation.curAnim.name == 'cheer')
					{
						specialAnim = false;
						dance();
					}
					heyTimer = 0;
				}
			}
			else if (specialAnim && animation.curAnim.finished)
			{
				specialAnim = false;
				dance();
			}

			if (checkHold)
			{
				var controls:Controls = CoolUtil.getControls();
				var controlHoldArray:Array<Bool> = [controls.NOTE_LEFT, controls.NOTE_DOWN, controls.NOTE_UP, controls.NOTE_RIGHT];
				if (PlayState.cpuControlled || !controlHoldArray.contains(true))
				{
					dance();
					checkHold = false;
				}
			}

			if (animation.curAnim.finished && animation.getByName(animation.curAnim.name + '-loop') != null)
				playAnim(animation.curAnim.name + '-loop');
		}

		super.update(elapsed);
	}

	public function loadOffsetFromFile(character:String)
	{
		var offset:Array<String> = CoolUtil.coolTextFile(Paths.getPath('images/characters/' + character + 'Offsets.txt', TEXT, null));
		for (i in 0...offset.length)
		{
			var data:Array<String> = offset[i].split(' ');
			addOffset(data[0], Std.parseInt(data[1]), Std.parseInt(data[2]));
		}
	}

	public var danced:Bool = false;

	public function dance()
	{
		if (!debugMode && !specialAnim)
		{
			if (danceIdle)
			{
				danced = !danced;

				if (danced)
					playAnim('danceRight');
				else
					playAnim('danceLeft');
			}
			else if (animation.getByName('idle') != null)
				playAnim('idle');
		}
	}

	public function startIdle(holdCheck:Bool = false)
	{
		var time:Float = Conductor.stepCrochet * 0.001 * singDuration;
		var callback = function(tmr:FlxTimer)
		{
			if (holdCheck)
				checkHold = true;
			if (!checkHold
				&& animation.curAnim != null
				&& animation.curAnim.name.startsWith('sing')
				&& !animation.curAnim.name.endsWith('miss'))
				dance();
		};

		if (idleTimer == null)
			idleTimer = new FlxTimer().start(time, callback);
		else
		{
			idleTimer.onComplete = callback;
			idleTimer.reset(time);
		}
	}

	public function beatDance(?curBeat:Int)
	{
		if ((curBeat == null || curBeat % danceEveryNumBeats == 0)
			&& animation.curAnim.name != null
			&& !animation.curAnim.name.startsWith("sing")
			&& !stunned)
			dance();
	}

	public function hey(time:Float = 0.6)
	{
		playAnim('hey', true);
		specialAnim = true;
		heyTimer = time;
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0)
	{
		specialAnim = false;
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
			offset.set(daOffset[0], daOffset[1]);
		else
			offset.set(0, 0);

		if (curCharacter.startsWith('gf'))
		{
			if (AnimName == 'singLEFT')
				danced = true;
			else if (AnimName == 'singRIGHT')
				danced = false;

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
				danced = !danced;
		}

		if (!AnimName.endsWith('miss'))
		{
			camMoveArray = [0, 0];
			if (AnimName.startsWith('singLEFT'))
				camMoveArray = [-camMoveAdd, 0];
			if (AnimName.startsWith('singDOWN'))
				camMoveArray = [0, camMoveAdd];
			if (AnimName.startsWith('singUP'))
				camMoveArray = [0, -camMoveAdd];
			if (AnimName.startsWith('singRIGHT'))
				camMoveArray = [camMoveAdd, 0];
		}
	}

	public var danceEveryNumBeats:Int = 2;

	public function recalculateDanceIdle()
	{
		var lastDanceIdle:Bool = danceIdle;
		danceIdle = animation.getByName('danceLeft') != null && animation.getByName('danceRight') != null;

		if (lastDanceIdle != danceIdle)
		{
			var calc:Float = danceEveryNumBeats;
			if (danceIdle)
				calc /= 2;
			else
				calc *= 2;

			danceEveryNumBeats = Math.round(Math.max(calc, 1));
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
