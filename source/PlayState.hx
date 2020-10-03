package;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.tile.FlxTilemap;
import flixel.FlxObject;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxState;

import entities.Player;

class PlayState extends FlxState
{
	public static var SpritesheetTexture:FlxAtlasFrames;
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;


	var player:Player;
	override public function create():Void
	{
		bgColor = FlxColor.PURPLE;
		super.create();

		SpritesheetTexture = FlxAtlasFrames.fromTexturePackerJson(AssetPaths.spritesheet__png, AssetPaths.spritesheet__json);
		map = new FlxOgmo3Loader(AssetPaths.map__ogmo, AssetPaths.level1__json);

		walls = map.loadTilemap(AssetPaths.collisions__png, "collisions");
		walls.visible = false;
		walls.setTileProperties(2, FlxObject.ANY);
		walls.setTileProperties(4, FlxObject.UP);

		walls.follow();

		var base:FlxTilemap = map.loadTilemap(AssetPaths.tiles__png, "base");
		add(base);

		map.loadEntities(placeEntities, "entities");



		// player = new Player();
		// add(player);
	}

	private function placeEntities(entity:EntityData)
	{
		switch(entity.name)
		{
			case "player":
				player = new Player(entity.x, entity.y, false);
				//player.setOffsets();
				add(player);
				camera.follow(player, FlxCameraFollowStyle.PLATFORMER, 1);
			default:
		}
	}
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (!walls.overlaps(player))
		{
			player.falling = true;
		} else {
			player.falling = false;
			player.jumping = false;
		}

		FlxG.collide(player, walls);

	}
}
