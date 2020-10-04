package entities;

import flixel.FlxObject;
import flixel.FlxSprite;

class Entity extends FlxSprite
{
    public function new(x:Float,y:Float, flipped:Bool, frameName)
        {
            super(x,y);
        
            frames = PlayState.SpritesheetTexture;

            animation.frameName = frameName;

            var tx = PlayState.SpritesheetTexture.getByName(animation.frameName);
            width = tx.frame.width;
            offset.x = tx.offset.x;
            height = tx.frame.height;
            offset.y += tx.offset.y;


            if (!flipped)
                facing = FlxObject.RIGHT;
            else {
                facing = FlxObject.LEFT;
                flipX = true;
            }

        }
    
}
