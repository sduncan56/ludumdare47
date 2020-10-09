package;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import flixel.system.debug.DebuggerUtil;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.tile.FlxTilemap;
import flixel.FlxObject;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxState;

import entities.Player;
import entities.LoopController;
import entities.Portal;
import entities.Entity;

class PlayState extends FlxState
{
	public static var SpritesheetTexture:FlxAtlasFrames;
	//var map:FlxOgmo3Loader;


	var player:Player;
	var loopControllers:FlxGroup = new FlxGroup();
	var portals:FlxGroup = new FlxGroup();


	var levels:List<Level> = new List<Level>();

	var curLevel:Level;

	var shiftEntitiesList:List<Entity> = new List<Entity>();

	var gameCamera:ScrollerCamera;

	var deathWall:Entity;


	override public function create():Void
	{
		super.create();

		gameCamera = new ScrollerCamera();
		FlxG.cameras.remove(FlxG.camera);
		FlxG.cameras.add(gameCamera);
		FlxG.camera = gameCamera;

		SpritesheetTexture = FlxAtlasFrames.fromTexturePackerJson(AssetPaths.spritesheet__png, AssetPaths.spritesheet__json);

		deathWall = new Entity(0, 0, false, "barrier.png");
		add(deathWall);
		gameCamera.deathWall = deathWall;

		loadLevel(AssetPaths.map__ogmo, AssetPaths.level1__json);

		//  FlxG.debugger.visible = true;
		//  FlxG.debugger.drawDebug = true;

		
		bgColor = FlxColor.CYAN;

	}

	private function loadCollisionMap(ogmoData:FlxOgmo3Loader):FlxTilemap
	{
		var colMap:FlxTilemap = ogmoData.loadTilemap(AssetPaths.collisions__png, "collisions");
		colMap.visible = false;
		colMap.setTileProperties(1, FlxObject.ANY);
		colMap.setTileProperties(2, FlxObject.UP);

		return colMap;
	}

	private function loadLevel(ogmoFile:String, levelFile:String)
		{

			var ogmoData = new FlxOgmo3Loader(ogmoFile, levelFile);

            curLevel = new Level();
	
			curLevel.walls = loadCollisionMap(ogmoData);
			add(curLevel.walls);
	
			//curLevel.walls.follow();

			var bg4:FlxTilemap = ogmoData.loadTilemap(AssetPaths.tiles__png, "bg4");
			bg4.scrollFactor.set(0,1);
			curLevel.bgLayers.add(bg4);

			var bg3:FlxTilemap = ogmoData.loadTilemap(AssetPaths.tiles__png, "bg3");
			bg3.scrollFactor.set(0, 1);
			curLevel.bgLayers.add(bg3);

			var bg2:FlxTilemap = ogmoData.loadTilemap(AssetPaths.tiles__png, "bg2");


			var bg1:FlxTilemap = ogmoData.loadTilemap(AssetPaths.tiles__png, "bg1");
			bg1.scrollFactor.set(0.9,1);
			curLevel.bgLayers.add(bg1);



	
			var base:FlxTilemap = ogmoData.loadTilemap(AssetPaths.tiles__png, "base");
			curLevel.base = base;
			add(base);



			curLevel.loopsRequired = ogmoData.getLevelValue("LoopsRequired");
			curLevel.levelNumber = ogmoData.getLevelValue("LevelNumber"); 

			curLevel.scrollSpeed = ogmoData.getLevelValue("ScrollSpeed");

			curLevel.height = base.height;
			curLevel.width = base.width;

			FlxG.worldBounds.width = curLevel.width*2;
			FlxG.camera.setScrollBounds(0, curLevel.width*2, 0, curLevel.height);

			curLevel.ogmoData = ogmoData;
			ogmoData.loadEntities(placeEntities, "entities");
			

			levels.add(curLevel);

			createMapDuplicate();

			insert(0, curLevel.bgLayers);




		}


	private function createMapDuplicate()
	{
		var loopedBase:FlxTilemap = curLevel.ogmoData.loadTilemap(AssetPaths.tiles__png, "base");
		var loopedWalls:FlxTilemap = loadCollisionMap(curLevel.ogmoData);
		loopedBase.x = curLevel.width+1;
		loopedWalls.x = curLevel.width+1;
		
		insert(0,loopedBase);
		insert(0, loopedWalls);

		curLevel.loopedBase = loopedBase;
		curLevel.loopedWalls = loopedWalls;

		curLevel.loopReady = true;
	}

	private function placeEntities(entity:EntityData)
	{
		switch(entity.name)
		{
			case "player":
				player = new Player(entity.x, entity.y, false);
				add(player);
				camera.follow(player, FlxCameraFollowStyle.LOCKON, 1);
			
		        curLevel.startPos = new FlxPoint(entity.x, entity.y);	
			case "loopwall":
				var loopController = new LoopController(entity.x, entity.y, "loopwall.png");
				add(loopController);
				loopControllers.add(loopController);
				loopController.moves = false;
			case "vertportal":
				var portal = new Portal(entity.x, entity.y, false, "vertbreakpt.png");
				portal.goToLevelNo = entity.values.gotolvlno;
				add(portal);
				portals.add(portal);
				if (portal.x < curLevel.width)
					shiftEntitiesList.push(portal);

			default:
		}
	}

	private function collidePlayerWithMap(player:Player, map:FlxTilemap)
	{	
		if (!FlxG.collide(map, player))
		{
			player.falling = true;
		} else {
			player.falling = false;
			player.jumping = false;
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);


		if (curLevel.loopReady && player.x > curLevel.width)
		{
			collidePlayerWithMap(player, curLevel.loopedWalls);
		} else
		{
			collidePlayerWithMap(player, curLevel.walls);

		}

		FlxG.overlap(player, portals, enteredPortal);
		FlxG.overlap(player, deathWall, hitDeathWall);

		gameCamera.velocity.x = curLevel.scrollSpeed;


		FlxG.camera.setScrollBounds(FlxG.camera.scroll.x, curLevel.width*2, 0, curLevel.height);

		//shift entities forward if they need to be seen in the looped section
		for (entity in shiftEntitiesList)
		{
			if (entity.x < FlxG.camera.scroll.x)
			{
				entity.x += curLevel.width;
			}
		}

		//shift entities back after the loop
		if (FlxG.camera.scroll.x > curLevel.width-1)
		{
			player.x -= curLevel.width;
			for (entity in shiftEntitiesList)
			{
				entity.x -= curLevel.width;
			}
			deathWall.x -= curLevel.width;
			FlxG.camera.setScrollBounds(0, curLevel.width*2, 0, curLevel.height);

		}

	}

	public function cleanLevel()
	{
		player.kill();
		remove(player);
		for (p in portals)
		{
			remove(p);
		}
		portals.clear();

		curLevel.base.kill();
		remove(curLevel.base);
		curLevel.walls.kill();
		remove(curLevel.walls);
		curLevel.loopedBase.kill();
		remove(curLevel.loopedBase);
		curLevel.loopedWalls.kill();
		remove(curLevel.loopedWalls);

		curLevel.bgLayers.kill();
		remove(curLevel.bgLayers);

		gameCamera.scroll.x = 0;
		deathWall.x = 0;
	}

	private function enteredPortal(player:Player, portal:Portal)
	{
		cleanLevel();

		loadLevel(AssetPaths.map__ogmo, "assets/map/level"+portal.goToLevelNo+".json");

	}

	private function hitDeathWall(player:Player, wall:Entity)
	{
		cleanLevel();

		if (curLevel.levelNumber == 1)
		{
			FlxG.switchState(new GameOverState());
		} else {
			loadLevel(AssetPaths.map__ogmo, "assets/map/level"+(curLevel.levelNumber-1)+".json");
		}


	}


}
