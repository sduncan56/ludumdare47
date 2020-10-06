import flixel.math.FlxVelocity;
import flixel.math.FlxPoint;
import flixel.FlxCamera;


class ScrollerCamera extends FlxCamera
{

    public var velocity(default, default):FlxPoint = new FlxPoint();
    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        var velocityDelta = 0.5 * (FlxVelocity.computeVelocity(velocity.x, 0, 0, 100, elapsed) - velocity.x);
		velocity.x += velocityDelta;
		var delta = velocity.x * elapsed;
		velocity.x += velocityDelta;
		scroll.x += delta;


    }
}