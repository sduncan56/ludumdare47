package entities;

import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.FlxObject;
import flixel.FlxG;

import entities.Seeker;


class Player extends Entity
{
    var yDir:Int = 1;
    var xDir:Int = 1;

    public var falling(default, default):Bool = false;
    public var jumping(default, default):Bool = false;

    var speed(default,null):Float = 100;

    var jumpTimer:FlxTimer = new FlxTimer();
    var extensionTimer:FlxTimer = new FlxTimer();
    var floatTimer:FlxTimer = new FlxTimer();

    public var floorSeeker(default, null):Seeker;
    public var onFloor(default, default):Bool = false;

    var collisionSeekers:FlxGroup = new FlxGroup();



    public function new(x:Float, y:Float, flipped:Bool) {
        super(x, y, flipped, "player/player.png");

        floorSeeker = new Seeker(5, 1, 4, height+1, this);
        collisionSeekers.add(floorSeeker);
        
        FlxG.state.add(collisionSeekers);


    }

    private function move(elapsed:Float)
    {
        if (onFloor)
        {
            velocity.x = 0;
            acceleration.y = 0;
        }                
    
        if (FlxG.keys.anyPressed([UP, W]))
        {
            if (onFloor){
                velocity.y = -300;
                jumpTimer.start(0.1, manageJump, 5);

                jumping = true;
            }
        }
                

        if (FlxG.keys.anyPressed([DOWN, S])) {}
        
        if (FlxG.keys.anyPressed([LEFT, A])) {
            velocity.x = -speed;
        }
        
        if (FlxG.keys.anyPressed([RIGHT, D])) {
            velocity.x = speed;
                
        }
        if (!jumping && !onFloor){
            acceleration.y = 800;
        }
            
    }

    private function manageJump(timer:FlxTimer)
    {
        var downAccel = 300;
        if (FlxG.keys.anyPressed([UP, W]) && velocity.y < 0)
        {
            acceleration.y += downAccel;

        } else {
            acceleration.y += downAccel*2;
            if (timer.progress < 0.2)
                velocity.y += 50;
            // if (timer.progress > 0.5)
            //     acceleration.y += downAccel/5;
        }

        if (timer.loopsLeft == 1)
            jumping = false;
    }

    private function jumpComplete(timer:FlxTimer)
    {

    }

    private function extendJump(timer:FlxTimer)
    {
        if (FlxG.keys.anyPressed([UP, W]))
        {
            jumpTimer.time += 0.1;
        }
    }


    override function update(elapsed:Float) {
   
        move(elapsed);

        super.update(elapsed);
    }


}