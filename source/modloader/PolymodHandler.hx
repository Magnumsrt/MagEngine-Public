package modloader;

#if MODS
import polymod.Polymod;

class PolymodHandler
{
	static var metadataArrays:Array<String> = [];

	public static function init()
	{
		ModList.load();
		loadModMetadata();
		Polymod.init({
			modRoot: "mods/",
			dirs: ModList.getActiveMods(metadataArrays),
			errorCallback: onError,
			frameworkParams: {
				assetLibraryPaths: [
					"shared" => "shared",
					"songs" => "songs",
					"fonts" => "fonts",
					"week2" => "week2",
					"week3" => "week3",
					"week4" => "week4",
					"week5" => "week5",
					"week6" => "week6"
				]
			}
		});
	}

	public static function loadModMetadata()
	{
		metadataArrays = [];
		var tempArray = Polymod.scan("mods/", "*.*.*", onError);
		for (metadata in tempArray)
		{
			trace("found mod: " + metadata.id);
			metadataArrays.push(metadata.id);
			ModList.modMetadatas.set(metadata.id, metadata);
		}
	}

	static function onError(error:PolymodError)
	{
		if (error.severity == ERROR)
			trace(error.message);
	}
}
#end
