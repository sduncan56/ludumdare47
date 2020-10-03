package entities;

import flixel.FlxSprite;

class Entity extends FlxSprite
{
    public function new(x:Float,y:Float, flipped:Bool)
        {
            super(x,y);
        
            frames = PlayState.SpritesheetTexture;

        }
    
}
