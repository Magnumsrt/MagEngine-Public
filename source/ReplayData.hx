package;

typedef ReplayFile =
{
	var songFile:String;
	var hits:Array<Hit>;
}

typedef Hit =
{
	var key:Int;
	var time:Float;
}

class ReplayData
{
	public var hits:Array<Hit> = [];

    public function new(songFile:String) {
        
    }
}
