fscommand("allowscale", false);
fscommand("allowscale", false);
// our map is 2-dimensional array
myMap1 = [[1, 1, 1, 1, 1, 1, 1, 1], [1, 0, 0, 0, 0, 0, 0, 1], [1, 0, 1, 0, 0, 0, 0, 1], [1, 0, 0, 0, 0, 1, 0, 1], [1, 0, 0, 0, 0, 0, 0, 1], [1, 1, 1, 1, 1, 1, 1, 1]];
// declare game object that holds info
game = {tileW:30, tileH:30};
// walkable tile
game.Tile0 = function () { };
game.Tile0.prototype.walkable = true;
game.Tile0.prototype.frame = 1;
// wall tile
game.Tile1 = function () { };
game.Tile1.prototype.walkable = false;
game.Tile1.prototype.frame = 2;
// declare char object, xtile and ytile are tile where chars center is
char = {xtile:2, ytile:1, speed:2, moving:false, width:16, height:16};
// building the world
function buildMap(map) {
	// attach mouse cursor
	_root.attachMovie("mouse", "mouse", 2);
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
function moveChar(ob) {
	// is char in the center of tile
	if ((ob.x)%game.tileW == 0 and (ob.y)%game.tileW == 0) {
		// calculate the tile where chars center is
		ob.xtile = Math.floor(ob.x/game.tileW);
		ob.ytile = Math.floor(ob.y/game.tileH);
		// choose direction
		// right
		if (game["t_"+ob.ytile+"_"+(ob.xtile+1)].walkable and game.targetx>ob.xtile) {
			ob.dirx = 1;
			ob.diry = 0;
			// left
		} else if (game["t_"+ob.ytile+"_"+(ob.xtile-1)].walkable and game.targetx<ob.xtile) {
			ob.dirx = -1;
			ob.diry = 0;
			// up
		} else if (game["t_"+(ob.ytile+1)+"_"+ob.xtile].walkable and game.targety>ob.ytile) {
			ob.dirx = 0;
			ob.diry = 1;
			// down
		} else if (game["t_"+(ob.ytile-1)+"_"+ob.xtile].walkable and game.targety<ob.ytile) {
			ob.dirx = 0;
			ob.diry = -1;
			// none
		} else {
			ob.moving = false;
			return;
		}
	}
	// move
	ob.y += ob.speed*ob.diry;
	ob.x += ob.speed*ob.dirx;
	// calculate position in isometric view
	ob.xiso = ob.x-ob.y;
	ob.yiso = (ob.x+ob.y)/2;
	// update char position
	ob.clip._x = ob.xiso;
	ob.clip._y = ob.yiso;
	// calculate depth
	ob.depth = (ob.yiso-ob.depthshift)*300+(ob.xiso)+1;
	ob.clip.swapDepths(ob.depth);
	// face the direction
	ob.clip.gotoAndStop(ob.dirx+ob.diry*2+3);
	return (true);
}
function getTarget() {
	// must click on walkable tile
	if (game["t_"+game.ymouse+"_"+game.xmouse].walkable) {
		// update target tile
		game.targetx = game.xmouse;
		game.targety = game.ymouse;
		// get moving
		char.moving = true;
	}
}
function work() {
	// convert mouse coordinates from isometric back to normal
	var ymouse = ((2*game.clip._ymouse-game.clip._xmouse)/2);
	var xmouse = (game.clip._xmouse+ymouse);
	// find on which tile mouse is
	game.ymouse = Math.round(ymouse/game.tileW);
	game.xmouse = Math.round(xmouse/game.tileW)-1;
	// place mouse mc
	_root.mouse._x = (game.xmouse-game.ymouse)*game.tileW+game.clip._x;
	_root.mouse._y = (game.xmouse+game.ymouse)*game.tileW/2;
	var ob = char;
	// move char
	if (!ob.moving) {
		// stop walk animation
		ob.clip.char.gotoAndStop(1);
	} else {
		moveChar(ob);
		// walk animation
		ob.clip.char.play();
	}
}
// make the map
buildMap(_root["myMap1"]);
stop();
