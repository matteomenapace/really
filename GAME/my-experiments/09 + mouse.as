// from http://www.tonypa.pri.ee/tbw/tut01.html and following pages
var Map:Array = [[8,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,7],
				  		[3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3],
					    [3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3], 
						[3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3],
						[3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3],
						[3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3],
						[3,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3],
						[3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3],
						[3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3],
						[3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3],
						[3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3],
						[3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3],
						[3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3],
						[3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3],
						[3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3],
						[3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3],						
						[3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3],
						[6,2,2,2,2,4,0,0,0,0,0,5,2,2,2,2,2,2,2,2,9]];
//creates a map, with 0 as "walkable space" and all the other numbers as obstacles
//trace (Map[4][0]);
var game:Object = {tileW:30};
//"game" is an Object that holds functions and properties, instead of having them on the main scene (_root)
//DEBUG game={tileW:30, tileH:30}; //tileH è stata eliminata perché non serve nell'assonometria
//proprietà dell'oggetto "game" sono la larghezza tileW e l'altezza tileH 
//creo una classe per le Tiles (mattonelle) in cui inserisco proprietà condivise, o di default, in modo da non doverle riscrivere ogni volta che inserirò un nuovo tipo specifico di tile
game.TileClass = function() {};
game.TileClass.prototype.walkable = false;
game.TileClass.prototype.frame = 20;
//questa classe che userò come default assegna due valori prototipi alle mattonelle
game.Tile0 = function() {};
game.Tile0.prototype.__proto__ = game.TileClass.prototype;
//eredita le proprietà di default da TileClass
game.Tile0.prototype.walkable = true;
game.Tile0.prototype.frame = 1;
//dopo aver preso le proprietà di default, posso cambiarle
//Tile0 è una funzione dell'oggetto "game" con due proprietà prototipe, che vengono cioè assegnate ad ogni istanza di Tile0
//walkable significa che la mattonella è percorribile dai personaggi del gioco, se true
//frame indica il punto nella timeline del movieclip "tile" dove questa specifica tile si fermerà, e corrisponde a determinati colori, forme, ecc
game.Tile1 = function() {};
game.Tile1.prototype.__proto__ = game.TileClass.prototype;
//eredita le proprietà di default da TileClass
game.Tile1.prototype.frame = 2;
game.Tile2 = function() {};
game.Tile2.prototype.__proto__ = game.TileClass.prototype;
game.Tile2.prototype.frame = 3;
game.Tile3 = function() {};
game.Tile3.prototype.__proto__ = game.TileClass.prototype;
game.Tile3.prototype.frame = 4;
game.Tile4 = function() {};
game.Tile4.prototype.__proto__ = game.TileClass.prototype;
game.Tile4.prototype.frame = 5;
game.Tile5 = function() {};
game.Tile5.prototype.__proto__ = game.TileClass.prototype;
game.Tile5.prototype.frame = 6;
game.Tile6 = function() {};
game.Tile6.prototype.__proto__ = game.TileClass.prototype;
game.Tile6.prototype.frame = 7;
game.Tile7 = function() {};
game.Tile7.prototype.__proto__ = game.TileClass.prototype;
game.Tile7.prototype.frame = 8;
game.Tile8 = function() {};
game.Tile8.prototype.__proto__ = game.TileClass.prototype;
game.Tile8.prototype.frame = 9;
game.Tile9 = function() {};
game.Tile9.prototype.__proto__ = game.TileClass.prototype;
game.Tile9.prototype.frame = 10;
game.Tile10 = function() {};
game.Tile10.prototype.__proto__ = game.TileClass.prototype;
game.Tile10.prototype.frame = 11;

// declare a "char" object (is it on the _root, right?), which means the main character for the game, xtile and ytile are tiles where the character center is set at the beginning
// char={xtile:2, ytile:1, speed:4, width:16, height:16}; //codice copiato dal tutorial
char={xtile:7, ytile:1, speed:4, moving:false, width:20, height:20};
// funzione che crea la vera e propria mappa sullo schermo
function buildMap(map) {
	_root.attachMovie("mouse", "mouse", 2);
	// attachs mouse cursor
	_root.attachMovie("empty", "tiles",1);
	// "creates" the movie clip where all tiles will be stored
	// the attachMovie command will look for movie clip with linkage name "empty" in the library. It will then make a new instance of this movie clip on the stage and give this new mc the name "tiles"
	// l'ultimo numero fra parentesi è il valore di profondità Z (depth, da -16384 a 1048575) che viene assegnato all'oggetto...numero basso=stare sotto, numero+alto=stare sopra
	_root.tiles.attachMovie("empty", "back", 0);
	// attach an empty movie clip to hold background tiles, quelle "walkable" la cui profondità è 0, mentre "tiles" ha profondità 1 e quindi starà sopra, coprirà l'oggetto movie cilp "back"
	game.clip = _root.tiles;
	//la proprietà "clip" dell'oggetto game assume il valore di "tiles", che si trova nella sorgente _root
	//if we ever need to place tiles somewhere else, we only have to rename this line and not go through all the code
	game.clip._x = 520;
	game.clip._y = 170;
	//posiziona l'oggetto clip sullo schermo in modo da essere ben visibile e centrato, sono parametri che bisogna settare a mano...
	var mapWidth = map[0].length;
	// first element of the map array is another array [1, 1, 1, 1, 1, 1, 1, 1] and mapWidth will have the value of its length or number of elements.
	var mapHeight = map.length;
	//In the same way mapHeight will have the value of map.length, which is the number of rows in the map array.
	for (var i = 0; i<mapHeight; ++i) {
		for (var j = 0; j<mapWidth; ++j) {
			var name = "t_"+i+"_"+j;
			//sets a name to be given to each tile, dove "i" indica la coordinata Y (altezza,height) e "j" la coordinata X (larghezza, width)
			game[name] = new game["Tile"+map[i][j]] ();
			//stores into the object "game" a lot of new Tiles, a cui assegna i valori di quello specifico punto della mappa (se ad esempio la mappa in quel punto è 0 allora il clip assume le proprietà prototipe della classe Tile0 (vedi all'inizio del codice)
			if (game[name].walkable) {
				var clip = game.clip.back;
			} else {
				var clip = game.clip;
			} // la variabile clip (interna alla funzione) può assumere le proprietà di game.clip.back (che verrà assegnata se la mattonella è walkable, quindi in background); oppure di game.clip, che verra assegnato se la mattonella è una barriera
			game[name].depth = (j+i)*game.tileW/2*300+(j-i)*game.tileW+1;
			/*
			calcola la depth dell'oggetto game[name]: 
			j e i sono le coordinate relative (in mattonelle) dell'oggetto; j è la coordinata verticale e i quella orizzontale
			moltiplicate per le misure delle mattonelle (tileW:30, che diventa 15 in verticale perché in assonometria l'asse y è schiacciato)
			moltiplicato per 300 per l'asse verticale (probabilmente per ottenere un range di profondità ampio...forse potrebbe essere un altro numero)
			alla fine viene aggiunto 1 per evitare che ci siano oggetti su depth 0
			*/
			clip.attachMovie("tile", name, game[name].depth); //assegna la depth appena calcolata al movie clip corrente
			clip[name]._x = (j-i)*game.tileW;
			clip[name]._y = (j+i)*game.tileW/2;
			// posiziona la tile sulle coordinate applicando l'assonometria (asse y schiacciato)
			// notare la differenza tra ._x in cui c'è una sottrazione (j-i: larghezza-altezza) mentre in ._y si sommano (regole assonometriche)
			clip[name].gotoAndStop(game[name].frame);
			// sends the current tile mc to correct frame, according to the properties set in the classes Tile0, Tile1 and so on
		}
	}			
	var ob=char;
	//crea una variabile ob (interna alla funzione, quindi non dovrebbe intaccare variabili con lo stesso nome posizionate in altre funzioni)
	//la variabile ob assume le proprietà dell'oggetto char, dichiarato sopra
	ob.x = ob.xtile*game.tileW;
	ob.y = ob.ytile*game.tileW;
	//calcola la posizione iniziale dell'oggetto in coordinate assolute
	ob.xiso = ob.x-ob.y;
	ob.yiso = (ob.x+ob.y)/2;
	// due nuove proprietà (xiso e yiso) che calcolano la posizione dell'oggetto in vista assonometrica secondo lo stesso principio delle funzioni sopra: (x-y) per la larghezza, (x+y)/2 per l'altezza
	ob.depthshift = (game.tileW-ob.height)/2; 
	ob.depth = (ob.yiso-ob.depthshift)*300+ob.xiso+1;
	/* 
	formula per calcolare la depth da assegnare all'oggetto/personaggio...
	il principio della profondità è che più è alto il numero relativo di una tile (o di un personaggio) più in basso a destra si troverà nella distorsione assonometrica
	però la sua profondità dovra essere tale da risultare in primo piano (quindi depth alta (primo piano) >> numero alto);
	come sopra ricorre il numero 300 e l'aggiunta di 1 alla fine 
	al posto di (j+i)*game.tileW/2 ho però (ob.yiso-ob.depthshift) 
	cioè al posto della somma delle coordinate relative moltiplicata per le dimensioni della tile (che mi dà il suo "grado di vicinanza-lontananza" in assonometria: infatti una tile lontana avrà i e j basse tipo 0 e 0, mentre una tile in basso a sinistra sulla mappa ortogonale avrà i e j alti tipo 8 e 9)
	ho la coordinata assonometrica (yiso) a cui viene sottratto il valore della variabile depthshift (cioè?)
	depthshift è la metà della differenza fra una mattonella e le dimensioni dell'oggetto, nel nostro caso è uguale a 5 ((30-20)/2))
	boh
	*/
	game.clip.attachMovie("char", "char", ob.depth);
	// adds the character mc from the library to the "game" object
	ob.clip = game.clip.char;
	// ob.clip assume le proprietà dell'oggetto game.clip.char che ho appena estratto dalla library
	ob.clip._x = ob.xiso;
	ob.clip._y = ob.yiso;
	ob.clip.gotoAndStop(ob.frame);
	// places "char" at the right isometric coordinates and plays the right frame for it, according to the ob properties (siccome ob assume le proprietà del movieclip "char", in base alla direzione da seguire lo posizionerà sul giusto frame di visualizzazione)
}

function moveChar(ob) {
	// is char in the center of a tile? cioè, il punto di riferimento (registration point?) di ob deve corrispondere al punto di riferimento di una tile qualsiasi sulla mappa (perché?)
	if ((ob.x)%game.tileW == 0 and (ob.y)%game.tileW == 0) { //ottengo il RESTO delle divisioni fra coordinate di ob e dimensioni delle tile...se il resto è ZERO significa che le coordinate di ob coincidono con uno dei punti di registrazione delle tile sparse sulla mappa
		// calculate the tile where chars center is; .x si usa per oggetti
		ob.xtile = Math.floor(ob.x/game.tileW); // the floor is the closest integer that is less than or equal to the specified number or expression
		ob.ytile = Math.floor(ob.y/game.tileW); // era tileH nel codice originale, ma in questo file non abbiamo la proprietà tileH...
		// determine directions
		// right
		if (game["t_"+ob.ytile+"_"+(ob.xtile+1)].walkable and game.targetx>ob.xtile) { //targetx e targety sono variabili dichiarate nella funzione getTarget, e rappresentano in sostanza le coordinate del mouse...
			// game.targetx>ob.xtile significa che la tile che clicco con il mouse è maggiore di quella su cui si trova l'oggetto al momento, quindi più a destra nella mappa
			ob.dirx = 1;
			ob.diry = 0;
			// left
		} else if (game["t_"+ob.ytile+"_"+(ob.xtile-1)].walkable and game.targetx<ob.xtile) {
			ob.dirx = -1;
			ob.diry = 0;
			// down: più un oggetto è in basso sullo schermo, maggiore è la sua coordinata Y (per il sistema d riferimento stupido di Flash dove l'origine è in alto a sinistra
		} else if (game["t_"+(ob.ytile+1)+"_"+ob.xtile].walkable and game.targety>ob.ytile) {
			ob.dirx = 0;
			ob.diry = 1;
			// up
		} else if (game["t_"+(ob.ytile-1)+"_"+ob.xtile].walkable and game.targety<ob.ytile) {
			ob.dirx = 0;
			ob.diry = -1;
			// none
		} else {
			ob.moving = false;
			return; // if the return statement is used alone, it returns undefined
		}
	}
	ob.y += ob.speed*ob.diry;
	ob.x += ob.speed*ob.dirx;
	// calculates the new coordinates for moving ob, depending on speed and direction
	ob.xiso = ob.x-ob.y;
	ob.yiso = (ob.x+ob.y)/2;
	// calculates the updated position in isometric view
	ob.clip._x = ob.xiso;
	ob.clip._y = ob.yiso;
	// updates "char" position on screen
	// posiziono l'oggetto ob.clip secondo le coordinate appena calcolate (notare che ob è un oggetto "universale" perché non è direttamente legato ad un movieclip, quindi questa funzione può essere applicata anche ad altri elemneti del gioco, per muoverli
	ob.depth = (ob.yiso-ob.depthshift)*300+(ob.xiso)+1;
	ob.clip.swapDepths(ob.depth);
	// calcolo della depth dell'oggetto, secondo la solita formula già vista nella funzione buildMap
	// aggiorno la depth dell'oggetto clip sullo schermo attraverso il comando swapDepth (scambia profondità)
	ob.clip.gotoAndStop(dirx+diry*2+3);
    // questa formula stupidissima calcola il frame a cui il clip "char" (character nella libreria) deve andare per mostrare l'immagine o il clip del personaggio nella giusta direzione
    // ad esempio: DESTRA > dirx=1, diry=0 => gotoAndStop(1+0+3)=gotoAndStop(4)
    // ad esempio: SINISTRA > dirx=-1, diry=0 => gotoAndStop(-1+0+3)=gotoAndStop(2)  
	return (true); //valore che mi potrebbe servire per altre funzioni
}
function getTarget() {
	// user must click on a walkable tile to trigger this function
	if (game["t_"+game.ymouse+"_"+game.xmouse].walkable) {
		// updates target tile
		game.targetx = game.xmouse;
		game.targety = game.ymouse;
		// "moving" property of char (ob) is set to true >> movement enabled
		char.moving = true;
	}
}
function work() {
	// converts mouse coordinates from isometric back to normal
	var ymouse = ((2*game.clip._ymouse-game.clip._xmouse)/2);
	var xmouse = (game.clip._xmouse+ymouse);
	/*
	EXPLANATION
	(1) xiso=x-y
	(2) yiso=(x+y)/2
	in order to find out what tile has been clicked we need to extract the variables "x" and "y" from those equations, so:
	from (1) x=xiso+y
	now replacing the equation for x into the second line:
	from (2) yiso=(xiso+y+y)/2
	which can be rewritten couple of times:
	yiso=(xiso+2*y)/2
	2*yiso=xiso+2*y
	2*y=2*yiso-xiso
	y=(2*yiso-xiso)/2
	at the end we have two lines that calculate "tile coordinates" (come in t_4_1) in isometric space from the screen coordinates:
	(3) y=(2*yiso-xiso)/2
	(4) x=xiso+y
*/
	// find on which tile mouse is
	game.ymouse = Math.round(ymouse/game.tileW);
	game.xmouse = Math.round(xmouse/game.tileW)-1;
	// place mouse mc in isometric distortion
	_root.mouse._x = (game.xmouse-game.ymouse)*game.tileW+game.clip._x;
	_root.mouse._y = (game.xmouse+game.ymouse)*game.tileW/2;
	var ob = char;
	//assegna ad ob le proprietà dell'oggetto char
	// move char
	if (!ob.moving) { // ! è l'esatto opposto di ==, cioè verifica l'ineguaglianza fra due espressioni...in questo caso la sintassi completa sarebbe (ob.moving!=true) ma dato che la condizione di default per true-false è true, se io scrivo if (ob.moving) è come scrivere if (ob.moving==true)
		// stop walk animation
		ob.clip.char.gotoAndStop(1);
		// prova.. ob.clip.char.stop();
	} else {
		moveChar(ob);
		// walk animation
		ob.clip.char.play();
	}
}

//chiamata per la funzione che costruisce la mappa all'inizio del gioco, o ogni volta che viene chiamata da un bottone ad esempio	
buildMap(Map); //codice che funziona
//buildMap(_root["Map"]);
stop();



