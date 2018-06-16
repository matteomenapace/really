// our map is 2-dimensional array
myMap1 = [[1, 1, 1, 1, 1, 1, 1, 1], [1, 0, 0, 0, 0, 1, 0, 1], [1, 0, 1, 0, 0, 1, 0, 1], [1, 0, 0, 0, 1, 0, 0, 1], [1, 0, 1, 0, 0, 0, 1, 1], [1, 1, 1, 1, 1, 1, 1, 1]];
// declare game object that holds info
game = {tileW:30};
// walkable tile
game.Tile0 = function () { };
game.Tile0.prototype.walkable = true;
game.Tile0.prototype.frame = 1;
// wall tile
game.Tile1 = function () { };
game.Tile1.prototype.walkable = false;
game.Tile1.prototype.frame = 2;
// declare char object, xtile and ytile are tile where chars center is
char = {xtile:1, ytile:1, speed:5, width:16, height:16};
// building the world
function buildMap(map) {
	// attach empty mc to hold all the tiles and char
	_root.attachMovie("empty", "tiles", 1);
	// attach empty mc to hold background tiles
	_root.tiles.attachMovie("empty", "back", 0);
	// declare clip in the game object
	game.clip = _root.tiles;
	game.clip._x = 150;
	// get map dimensions
	var mapWidth = map[0].length;
	var mapHeight = map.length;
	// loop to place tiles on stage
	for (var i = 0; i<mapHeight; ++i) {
		for (var j = 0; j<mapWidth; ++j) {
			// name of new tile
			var name = "t_"+i+"_"+j;
			// make new tile object in the game
			game[name] = new game["Tile"+map[i][j]]();
			if (game[name].walkable) {
				var clip = game.clip.back;
			} else {
				var clip = game.clip;
			}
			// calculate depth
			game[name].depth = (j+i)*game.tileW/2*300+(j-i)*game.tileW+1;
			// attach tile mc and place it
			clip.attachMovie("tile", name, game[name].depth);
			clip[name]._x = (j-i)*game.tileW;
			clip[name]._y = (j+i)*game.tileW/2;
			// send tile mc to correct frame
			clip[name].gotoAndStop(game[name].frame);
		}
	}
	var ob = char;
	// calculate starting position
	ob.x = ob.xtile*game.tileW;
	ob.y = ob.ytile*game.tileW;
	// calculate position in isometric view
	ob.xiso = ob.x-ob.y;
	ob.yiso = (ob.x+ob.y)/2;
	// calculate depth
	ob.depthshift = (game.tileW-ob.height)/2;
	ob.depth = (ob.yiso-ob.depthshift)*300+ob.xiso+1;
	// add the character mc
	game.clip.attachMovie("char", "char", ob.depth);
	// declare clip in the game object
	ob.clip = game.clip.char;
	// place char mc
	ob.clip._x = ob.xiso;
	ob.clip._y = ob.yiso;
	ob.clip.gotoAndStop(ob.frame);
}
function getMyCorners(x, y, ob) {
	// find corner points
	ob.downY = Math.floor((y+ob.height-1)/game.tileW);
	ob.upY = Math.floor((y)/game.tileW);
	ob.leftX = Math.floor((x)/game.tileW);
	ob.rightX = Math.floor((x+ob.width-1)/game.tileW);
	// check if they are walls
	ob.upleft = game["t_"+ob.upY+"_"+ob.leftX].walkable;
	ob.downleft = game["t_"+ob.downY+"_"+ob.leftX].walkable;
	ob.upright = game["t_"+ob.upY+"_"+ob.rightX].walkable;
	ob.downright = game["t_"+ob.downY+"_"+ob.rightX].walkable;
}
function moveChar(ob, dirx, diry) {
	// vertical movement
	// where are our edges?
	// first we look for y movement, so x is old
	getMyCorners(ob.x, ob.y+ob.speed*diry, ob);
	// move got dammit... and check for collisions.
	// going up
	if (diry == -1) {
		if (ob.upleft and ob.upright) {
			// no wall in the way, move on
			ob.y += ob.speed*diry;
		} else {
			// hit the wall, place char near the wall
			ob.y = ob.ytile*game.tileW;
		}
	}
	// if going down
	if (diry == 1) {
		if (ob.downleft and ob.downright) {
			ob.y += ob.speed*diry;
		} else {
			ob.y = (ob.ytile+1)*game.tileW-ob.height;
		}
	}
	// horisontal movement
	// changing x with speed and taking old y
	getMyCorners(ob.x+ob.speed*dirx, ob.y, ob);
	// if going left
	if (dirx == -1) {
		if (ob.downleft and ob.upleft) {
			ob.x += ob.speed*dirx;
		} else {
			ob.x = ob.xtile*game.tileW;
		}
	}
	// if going right
	if (dirx == 1) {
		if (ob.upright and ob.downright) {
			ob.x += ob.speed*dirx;
		} else {
			ob.x = (ob.xtile+1)*game.tileW-ob.width;
		}
	}
	// calculate position in isometric view
	ob.xiso = ob.x-ob.y;
	ob.yiso = (ob.x+ob.y)/2;
	// update char position
	ob.clip._x = ob.xiso;
	ob.clip._y = ob.yiso;
	// face the direction
	ob.clip.gotoAndStop(dirx+diry*2+3);
	// calculate the tile where chars center is
	ob.xtile = Math.floor(ob.x/game.tileW);
	ob.ytile = Math.floor(ob.y/game.tileW);
	// calculate depth
	ob.depth = (ob.yiso-ob.depthshift)*300+(ob.xiso)+1;
	ob.clip.swapDepths(ob.depth);
	return (true);
}
function detectKeys() {
	var ob = _root.char;
	var keyPressed = false;
	if (Key.isDown(Key.RIGHT)) {
		keyPressed = _root.moveChar(ob, 1, 0);
	} else if (Key.isDown(Key.LEFT)) {
		keyPressed = _root.moveChar(ob, -1, 0);
	} else if (Key.isDown(Key.UP)) {
		keyPressed = _root.moveChar(ob, 0, -1);
	} else if (Key.isDown(Key.DOWN)) {
		keyPressed = _root.moveChar(ob, 0, 1);
	}
	// walk animation
	if (!keyPressed) {
		ob.clip.char.gotoAndStop(1);
	} else {
		ob.clip.char.play();
	}
}
// make the map
buildMap(_root["myMap1"]);
stop();
