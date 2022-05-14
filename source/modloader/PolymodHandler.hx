package modloader;

#if MODS
import polymod.Polymod;

class PolymodHandler
{
	public static var metadataArrays:Array<String> = [];

	public static function loadMods()
	{
		loadModMetadata();
		Polymod.init({
			modRoot: 'mods/',
			framework: OPENFL,
			dirs: ModList.getActiveMods(metadataArrays),
			errorCallback: onError,
			frameworkParams: {
				assetLibraryPaths: [
					'videos' => 'videos',
					'shared' => 'shared',
					'songs' => 'songs',
					'fonts' => 'fonts',
					'week2' => 'week2',
					'week3' => 'week3',
					'week4' => 'week4',
					'week5' => 'week5',
					'week6' => 'week6'
				]
			}
		});
	}

	public static function loadModMetadata()
	{
		metadataArrays = [];
		var tempArray:Array<ModMetadata> = Polymod.scan('mods/', '*.*.*', onError);
		for (metadata in tempArray)
		{
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
