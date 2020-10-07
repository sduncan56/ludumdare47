import flixel.group.FlxGroup;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.tile.FlxTilemap;
import flixel.math.FlxPoint;



class Level
{
    public var name(default, default):String;
    public var startPos(default, default):FlxPoint;
    public var loopsCompleted(default, default):Int = 0;
    public var loopsRequired(default, default):Int;
    public var levelNumber(default, default):Int;
    public var scrollSpeed(default, default):Float;

    public var walls(default, default):FlxTilemap;
    public var base(default, default):FlxTilemap;
    public var bgLayers(default, default):FlxGroup = new FlxGroup();
    // public var bg1(default, default):FlxTilemap;
    // public var bg2(default, default):FlxTilemap;
    // public

    public var ogmoData(default, default):FlxOgmo3Loader;
    public var width(default, default):Float;
    public var height(default, default):Float;
    public var loopReady(default, default):Bool = false;

    public var loopedBase(default, default):FlxTilemap = null;
    public var loopedWalls(default, default):FlxTilemap = null;

    public function new()
    {

    }

}