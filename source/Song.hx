package;

import Section.SwagSection;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var bpm:Int;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;
	var validScore:Bool;
	var stage:String;
	var gfVersion:String;
	public var dialoguetoggle:String;
}

class Song
{
	public var song:String;
	public var notes:Array<SwagSection>;
	public var bpm:Int;
	public var needsVoices:Bool = true;
	public var speed:Float = 1;

	public var player1:String = 'bf';
	public var player2:String = 'dad';
	public var stage:String = 'stage';
	public var gfVersion:String = 'gf';
	public var dialoguetoggle:String = 'false';

	public function new(song, notes, bpm)
	{
		this.song = song;
		this.notes = notes;
		this.bpm = bpm;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):SwagSong
		{
			var rawJson = null;
			
			var formattedFolder:String = Paths.formatToSongPath(folder);
			var formattedSong:String = Paths.formatToSongPath(jsonInput);
			var moddyFile:String = Paths.modsong(formattedFolder + '/' + formattedSong);
			if(FileSystem.exists(moddyFile)) {
				rawJson = File.getContent(moddyFile).trim();
			}
	
			if(rawJson == null) {
				#if sys
				rawJson = File.getContent(Paths.json(formattedFolder + '/' + formattedSong)).trim();
				#else
				rawJson = Assets.getText(Paths.json(formattedFolder + '/' + formattedSong)).trim();
				#end
			}
	
			while (!rawJson.endsWith("}"))
			{
				rawJson = rawJson.substr(0, rawJson.length - 1);
				// LOL GOING THROUGH THE BULLSHIT TO CLEAN IDK WHATS STRANGE
			}
	
			// FIX THE CASTING ON WINDOWS/NATIVE
			// Windows???
			// trace(songData);
	
			// trace('LOADED FROM JSON: ' + songData.notes);
			/* 
				for (i in 0...songData.notes.length)
				{
					trace('LOADED FROM JSON: ' + songData.notes[i].sectionNotes);
					// songData.notes[i].sectionNotes = songData.notes[i].sectionNotes
				}
	
					daNotes = songData.notes;
					daSong = songData.song;
					daBpm = songData.bpm; */
	
			var songJson:SwagSong = parseJSONshit(rawJson);
			return songJson;
		}

	public static function parseJSONshit(rawJson:String):SwagSong
	{
		var swagShit:SwagSong = cast Json.parse(rawJson).song;
		swagShit.validScore = true;
		return swagShit;
	}
}
