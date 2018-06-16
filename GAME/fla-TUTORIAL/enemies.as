// our map is 2-dimensional array
myMap1 = [[1, 1, 1, 1, 1, 1, 1, 1], [1, 0, 0, 0, 1, 0, 0, 1], [1, 0, 1, 0, 0, 0, 0, 1], [1, 0, 0, 0, 0, 1, 0, 1], [1, 0, 0, 1, 0, 0, 0, 2], [1, 1, 1, 1, 1, 1, 1, 1]];
myMap2 = [[1, 1, 1, 1, 1, 1, 1, 1], [1, 0, 0, 0, 0, 0, 0, 1], [1, 0, 1, 0, 0, 0, 0, 1], [1, 0, 0, 0, 0, 1, 0, 1], [3, 0, 0, 0, 0, 0, 0, 1], [1, 1, 1, 1, 1, 1, 1, 1]];
// declare game object that holds info
game = {tileW:30, tileH:30, currentMap:1};
// walkable tile
game.Tile0 = function () { };
game.Tile0.prototype.walkable = true;
game.Tile0.prototype.frame = 1;
// wall tile
game.Tile1 = function () { };
game.Tile1.prototype.walkable = false;
game.Tile1.prototype.frame = 2;
// door object prototype
game.Doors = function (newmap, newcharx, newchary) { this.newmap = newmap;this.newcharx = newcharx;this.newchary = newchary;};
game.Doors.prototype.walkable = true;
game.Doors.prototype.frame = 3;
game.Doors.prototype.door = true;
// door tiles
// make those tiles from the door object passing newmap, newcharx and newchary
game.Tile2 = function () { };
game.Tile2.prototype = new game.Doors(2, 1, 4);
game.Tile3 = function () { };
game.Tile3.prototype = new game.Doors(1, 6, 4);
// declare enemies
// enemies array is in the order [enemy type, xtile, ytile]
myEnemies = [[0], [[1, 6, 1]], [[2, 1, 3]]];
// declare enemie types
game.Enemyp1 = function () { };
game.Enemyp1.prototype.xMove = 0;
game.Enemyp1.prototype.yMove = 1;
game.Enemyp1.prototype.speed = 2;
game.Enemyp1.prototype.turning = 5;
game.Enemyp2 = function () { };
game.Enemyp2.prototype.xMove = 1;
game.Enemyp2.prototype.yMove = 0;
game.Enemyp2.prototype.speed = 2;
game.Enemyp2.prototype.turning = 5;
// declare char object, xtile and ytile are tile where chars center is
char = {xtile:2, ytile:1, speed:4};
// building the world
function buildMap(map) {
	// attach empty mc to hold all the tiles and char
	_root.attachMovie("empty", "tiles", 1);
	// declare clip in the game object
	game.clip = _root.tiles;
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
			// attach tile mc and place it
			game.clip.attachMovie("tile", name, i*100+j*2);
			game.clip[name]._x = (j*game.tileW);
			game.clip[name]._y = (i*game.tileH);
			// send tile mc to correct frame
			game.clip[name].gotoAndStop(game[name].frame);
		}
	}
	// add enemies
	var enemies = myEnemies[game.currentMap];
	// save the number of enemies on stage
	game.currentEnemies = enemies.length;
	for (var i = 0; i<game.currentEnemies; ++i) {
		// name of new enemy
		var name = "enemy"+i;
		// make new enemy object in the game
		game[name] = new game["Enemyp"+enemies[i][0]]();
		// add enemy to the stage
		game.clip.attachMovie("enemy"+enemies[i][0], name, 10001+i);
		// declare clip in the enemy object
		game[name].clip = game.clip[name];
		// add start position, width and height to new enemy from enemies array
		game[name].xtile = enemies[i][1];
		game[name].ytile = enemies[i][2];
		game[name].width = game.clip[name]._width/2;
		game[name].height = game.clip[name]._height/2;
		// calculate starting position
		game[name].x = (game[name].xtile*game.tileW)+game.tileW/2;
		game[name].y = (game[name].ytile*game.tileH)+game.tileH/2;
		// place enemy mc
		game[name].clip._x = game[name].x;
		game[name].clip._y = game[name].y;
	}
	// add the character mc
	game.clip.attachMovie("char", "char", 10000);
	// declare clip in the game object
	char.clip = game.clip.char;
	// calculate starting position
	char.x = (char.xtile*game.tileW)+game.tileW/2;
	char.y = (char.ytile*game.tileH)+game.tileH/2;
	// add char dimensions to char object, half of clips width and height
	char.width = char.clip._width/2;
	char.height = char.clip._height/2;
	// place char mc
	char.clip._x = char.x;
	char.clip._y = char.y;
	char.clip.gotoAndStop(char.frame);
}
function changeMap(ob) {
	// change the map
	var name = "t_"+ob.ytile+"_"+ob.xtile;
	game.currentMap = game[name].newMap;
	ob.ytile = game[name].newchary;
	ob.xtile = game[name].newcharx;
	// remember which way char is facing
	ob.frame = ob.clip._currentframe;
	buildMap(_root["myMap"+game.currentMap]);
}
function getMyCorners(x, y, ob) {
	// find corner points
	ob.downY = Math.floor((y+ob.height-1)/game.tileH);
	ob.upY = Math.floor((y-ob.height)/game.tileH);
	ob.leftX = Math.floor((x-ob.width)/game.tileW);
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
			ob.y = ob.ytile*game.tileH+ob.height;
		}
	}
	// if going down
	if (diry == 1) {
		if (ob.downleft and ob.downright) {
			ob.y += ob.speed*diry;
		} else {
			ob.y = (ob.ytile+1)*game.tileH-ob.height;
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
			ob.x = ob.xtile*game.tileW+ob.width;
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
	// update char position
	ob.clip._x = ob.x;
	ob.clip._y = ob.y;
	// face the direction
	ob.clip.gotoAndStop(dirx+diry*2+3);
	// calculate the tile where chars center is
	ob.xtile = Math.floor(ob.clip._x/game.tileW);
	ob.ytile = Math.floor(ob.clip._y/game.tileH);
	// check for door
	if (game["t_"+ob.ytile+"_"+ob.xtile].door and ob == _root.char) {
		// make new map
		changeMap(ob);
	}
	return (true);
}
function enemyBrain() {
	// loop through all enemies currently on stage
	for (var i = 0; i<game.currentEnemies; ++i) {
		// name of new enemy
		var name = "enemy"+i;
		var ob = game[name];
		// check if enemy will hit the wall
		getMyCorners(ob.x+ob.speed*ob.xMove, ob.y+ob.speed*ob.yMove, ob);
		if (ob.downleft and ob.upleft and ob.downright and ob.upright and random(100)>ob.turning) {
			// move enemy
			moveChar(ob, ob.xMove, ob.yMove);
		} else {
			// change enemy direction
			if (ob.xMove == 0) {
				ob.xMove = random(2)*2-1;
				ob.yMove = 0;
				getMyCorners(ob.x+ob.speed*ob.xMove, ob.y+ob.speed*ob.yMove, ob);
				if (!ob.downleft or !ob.upleft or !ob.downright or !ob.upright) {
					ob.xMove = -ob.xMove;
				}
			} else {
				ob.xMove = 0;
				ob.yMove = random(2)*2-1;
				getMyCorners(ob.x+ob.speed*ob.xMove, ob.y+ob.speed*ob.yMove, ob);
				if (!ob.downleft or !ob.upleft or !ob.downright or !ob.upright) {
					ob.yMove = -ob.yMove;
				}
			}
		}
		// check if we have collision with hero
		var xdist = ob.x-char.x;
		var ydist = ob.y-char.y;
		if (Math.sqrt(xdist*xdist+ydist*ydist)<ob.width+char.width) {
			// end the game
			removeMovieClip(_root.tiles);
			_root.gotoAndPlay(1);
		}
	}
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
	_root.enemyBrain();
}
// make the map
buildMap(_root["myMap"+game.currentMap]);
stop();
