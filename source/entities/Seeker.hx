package entities;

import flixel.FlxObject;

class Seeker extends FlxObject
{
    public var xOffset:Float;
    public var yOffset:Float;
    public var target:Entity;

    override public function new(width:Float, height:Float, 
                                 xOffset:Float, yOffset:Float,
                                 target:Entity) 
    {
        this.xOffset = xOffset;
        this.yOffset = yOffset;
        this.target = target;

        super(target.x+xOffset, target.y+yOffset, width, height);
    }

    override function update(elapsed:Float) {

        x = target.x+xOffset;
        y = target.y + yOffset;
        super.update(elapsed);


    }
}