package entities;

import flixel.FlxObject;
import flixel.FlxG;


class Player extends Entity
{
    var yDir:Int = 1;
    var xDir:Int = 1;

    public var falling(default, default):Bool = false;
    public var jumping(default, default):Bool = false;

    var speed(default,null):Float = 200;

    public function new(x:Float, y:Float, flipped:Bool) {
        super(x, y, flipped, "player/player.png");



    }

    private function move(elapsed:Float)
    {
        if (!jumping)            
            velocity.x = 0;
                
    
        if (!falling) {
            if (FlxG.keys.anyPressed([UP, W]) && isTouching(FlxObject.FLOOR)){
                velocity.y = -300;
                jumping = true;
                
            }
            if (FlxG.keys.anyPressed([DOWN, S])) {}
        
            if (FlxG.keys.anyPressed([LEFT, A])) {
                velocity.x = -speed;
            }
        
            if (FlxG.keys.anyPressed([RIGHT, D])) {
                velocity.x = speed;
                
            }
        } else {
            acceleration.y = 1000;
        }
            
    }
    override function update(elapsed:Float) {
   
        move(elapsed);


        super.update(elapsed);
    }


}