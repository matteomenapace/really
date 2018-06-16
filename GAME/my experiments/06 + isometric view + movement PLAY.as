//from http://www.tonypa.pri.ee/tbw/tut01.html and following pages
var Map:Array = [[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
				  		[1,0,0,2,0,0,0,0,0,0,0,4,0,0,0,0,0,1],
					    [1,0,0,1,0,0,0,0,0,0,0,4,1,0,0,0,0,1], 
						[1,0,0,1,0,0,0,0,0,0,0,2,0,0,0,0,0,1],
						[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
						[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
						[1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1],
						[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
						[1,0,0,0,0,0,0,0,3,2,0,0,0,0,0,0,0,1],
						[1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
						[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
						[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
						[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
						[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]];
//creates a 8x6 map, with 1 as a "border" and 0 as "walkable space"
//trace (Map[4][0]);
//"game" is an Object that holds functions and properties, instead of having them on the main scene (_root)
var game:Object = {tileW:30};
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

// declare a "char" object (is it on the _root, right?), which means the main character for the game, xtile and ytile are tiles where the character center is set at the beginning
//char = {xtile:2, ytile:1, speed:2};
//char={xtile:2, ytile:1, speed:4, width:16, height:16}; //codice copiato dal tutorial
char={xtile:2, ytile:1, speed:4, width:20, height:20};
//funzione che crea la vera e propria mappa sullo schermo
function buildMap(map) {
	_root.attachMovie("empty", "tiles",1);
	//Now the attachMovie command will look for movie clip with linkage name "empty" in the library. It will then make a new instance of this movie clip on the stage and give this new mc the name "tiles"
	//cosa è d, e perché incrementa? è il valore di profondità Z (depth, da -16384 a 1048575) che viene assegnato all'oggetto...numero basso=stare sotto, numero+alto=stare sopra
	_root.tiles.attachMovie("empty", "back", 0);
	// attach an empty movie clip to hold background tiles, la cui profondità è 0, mentre "tiles" ha profondità 1 e quindi starà sopra, coprirà l'oggetto movie clp "back"
	game.clip = _root.tiles;
	//la proprietà "clip" dell'oggetto game assume il valore di "tiles", che si trova nella sorgente _root
	//if we ever need to place tiles somewhere else, we only have to rename this line and not go through all the code
	game.clip._x = 150;
	//posiziona l'oggetto clip sul punto orizzontale 150...hmmm
	var mapWidth = map[0].length;
	//First element of map array is another array [1, 1, 1, 1, 1, 1, 1, 1] and mapWidth will have the value of its length or number of elements.
	var mapHeight = map.length;
	//In the same way mapHeight will have the value of map.length, which is the number of rows in the map array.
	for (var i = 0; i<mapHeight; ++i) {
		for (var j = 0; j<mapWidth; ++j) {
			var name = "t_"+i+"_"+j;
			//sets a name to be given to each tile
			game[name] = new game["Tile"+map[i][j]] ();
			//stores into the object "game" a lot of new Tiles, a cui assegna i valori di quello specifico pnto della mappa (se ad esempio la mappa in quel punto è 0 allora il clip assume le proprietà prototipe della classe Tile0 (vedi all'inizio del codice)
			if (game[name].walkable) {
				var clip = game.clip.back;
			} else {
				var clip = game.clip;
			} //crea due nuove proprietà variabili all'interno dell'oggetto game...una è game.clip.back(che verrà assegnata se la mattonella è walkable); l'altra è game.clip che verra assegnato se la mattonella è una barriera
			game[name].depth = (j+i)*game.tileW/2*300+(j-i)*game.tileW+1;
			/*
			calcola la depth dell'oggetto game[name]: 
			j e i sono le coordinate relative (in mattonelle) dell'oggetto
			moltiplicate per le misure delle mattonelle (tileW:30, che diventa 15 in verticale perché in assonometria l'asse y è schiacciato)
			moltiplicato per 300 per l'asse verticale (probabilmente per ottenere un range di profondità ampio...forse potrebbe un altro numero)
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
	//calcola la posizione iniziale dell'oggetto in coordinate assolute, di default xtile è 2 e ytile 1
	ob.xiso = ob.x-ob.y;
	ob.yiso = (ob.x+ob.y)/2;
	// due nuove proprietà (xiso e yiso) che calcolano la posizione dell'oggetto in vista assonometrica secondo lo stesso principio delle funzioni sopra (x-y per la larghezza; (x+y)/2 per l'altezza
	ob.depthshift = (game.tileW-ob.height)/2; 
	ob.depth = (ob.yiso-ob.depthshift)*300+ob.xiso+1;
	/* 
	formula per calcolare la depth da assegnare all'oggetto/personaggio...
	il principio della profondità è che più è alto il numero relativo di una tile (o di un personaggio) più in basso a destra si troverà nella distorsione assonometrica
	però la sua profondità dovra essere tale da risultare in primo piano (quindi depth >> numero alto);
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
	// ob.clip assume le proprietà dell'oggetto gam.clip.char che ho appena estratto dalla library
	ob.clip._x = ob.xiso;
	ob.clip._y = ob.yiso;
	ob.clip.gotoAndStop(ob.frame);
	// places "char" at the right isometric coordinates and plays the right frame for it, according to the ob properties (siccome ob assume le proprietà del movieclip "char", in base alla direzione da seguire lo posizionerà sul giusto frame di visualizzazione)
}

function getMyCorners (x, y, ob) {
	//ob.downY = Math.floor((y+ob.height-1)/game.tileH); //codice originale
	ob.downY = Math.floor((y+ob.height-1)/game.tileW);
	//ob.upY = Math.floor((y-ob.height)/game.tileH); //codice originale
	ob.upY = Math.floor((y)/game.tileW); 
	//ob.leftX = Math.floor((x-ob.width)/game.tileW); //codice originale
	ob.leftX = Math.floor((x)/game.tileW)
	//ob.rightX = Math.floor((x+ob.width-1)/game.tileW); //codice originale
	ob.rightX = Math.floor((x+ob.width-1)/game.tileW);
	// crea delle nuove proprietà che rilevano le dimensioni del personaggio (oggetto "ob") e calcolano il suo potenziale movimento nelle 4 direzioni
	// Math.floor è l'approssimazione al numero intero più basso, ad esempio 2.84685 diventa 2
	// x e y rappresentano la posizione corrente dell'oggetto "ob": aggiungendo o togliendo metà delle larghezza/lunghezza del clip associato all'oggetto "ob", e poi dividendo il tutto per la larghezza/altezza di una mattonella ottengo i "nomi"(coordinate relative) delle tile che l'oggetto ha attorno a sè
	ob.upleft = game["t_"+ob.upY+"_"+ob.leftX].walkable;
	ob.downleft = game["t_"+ob.downY+"_"+ob.leftX].walkable;
	ob.upright = game["t_"+ob.upY+"_"+ob.rightX].walkable;
	ob.downright = game["t_"+ob.downY+"_"+ob.rightX].walkable;
	// crea nuove proprietà all'oggetto ob, a cui vengono assegnate le proprietà "walkable" (true o false) rilevate dalle mattonelle (tiles) attorno al personaggio
}
// quindi in sostanza, praticamente, diciamo che, insomma, questa funzione rileva ad ogni movimento del personaggio lo "status" delle mattonelle adiacenti, in modo da prevedere se il prossimo movimento sarà libero o se invece c'è una qualche barriera

// la prossima funzione stabilisce i valori dei movimenti da compiere (velocità, coordinate); questa funzione verrà chiamata dalla funzione detectKeys (riga 82)
// gli argomenti della funzione sono la variabile ob, definita sopra, e le direzioni dirx e diry 
// la versione seguente tiene conto delle mattonelle attorno al personaggio e stabilisce se può passarci sopra o meno
function moveChar(ob, dirx, diry) {
  getMyCorners (ob.x, ob.y+ob.speed*diry, ob);
  //chiama la funzione getMyCorners, che rileva i potenziali punti di collisione attorno al personaggio
  //le prime due condizioni sono dedicate alle collisioni verticali
  //giù=1, su=-1
  if (diry == -1)/*cioè se il personaggio sta andando in su*/ {
    if (ob.upleft and ob.upright)/*se gli angoli superiori destro e sinistro sono true, cioè liberi di essere calpestati ("walkable")*/ 
	{ob.y += ob.speed*diry;} //permette all'oggetto "ob" di spostarsi in su
	else {ob.y = ob.ytile*game.tileW;} //posiziona l'oggetto "ob" sul confine superiore invalicabile
  }
  if (diry == 1) {/*se si muove verso il basso*/
    if (ob.downleft and ob.downright) {ob.y += ob.speed*diry;} 
	else {ob.y = (ob.ytile+1)*game.tileW-ob.height;}
  }
  //le altre due condizioni sono dedicate alle collisioni orizzontali
  //destra=1, sinistra=-1
  getMyCorners (ob.x+ob.speed*dirx, ob.y, ob);
  if (dirx == -1) /*sta andando a sinistra*/{
    if (ob.downleft and ob.upleft) {ob.x += ob.speed*dirx;} 
	else {ob.x = ob.xtile*game.tileW;}
  }
  if (dirx == 1) /*sta andando a destra*/{
    if (ob.upright and ob.downright) {ob.x += ob.speed*dirx;} 
	else {ob.x = (ob.xtile+1)*game.tileW-ob.width;}
  }
	ob.xiso = ob.x-ob.y;
	ob.yiso = (ob.x+ob.y)/2;
	// calculates the updated position in isometric view
	ob.clip._x = ob.xiso;
	ob.clip._y = ob.yiso;
	// updates "char" position on screen
	// posiziono l'oggetto ob.clip secondo le coordinate appena calcolate (notare che ob è un oggetto "universale" perché non è direttamente legato ad un movieclip, quindi questa funzione può essere applicata anche ad altri elemneti del gioco, per muoverli
	ob.clip.gotoAndStop(dirx+diry*2+3);
    // questa formula stupidissima calcola il frame a cui il clip "char" (character nella libreria) deve andare per mostrare l'immagine o il clip del personaggio nella giusta direzione
    // ad esempio: DESTRA > dirx=1, diry=0 => gotoAndStop(1+0+3)=gotoAndStop(4)
    // ad esempio: SINISTRA > dirx=-1, diry=0 => gotoAndStop(-1+0+3)=gotoAndStop(2)  
	ob.xtile = Math.floor(ob.x/game.tileW);
	ob.ytile = Math.floor(ob.y/game.tileW);
    // calcolo le nuove coordinate relative (su quale mattonella "tile" si trova attualmente) dell'oggetto "ob", dividendo le sue nuove coordinate per larghezza/lunghezza di una mattonella (che è l'unità di misura del gioco fondamentalmente)
	ob.depth = (ob.yiso-ob.depthshift)*300+(ob.xiso)+1;
	ob.clip.swapDepths(ob.depth);
	// calcolo della depth dell'oggetto, secondo la solita formula già vista nella funzione buildMap
	// aggiorno la depth dell'oggetto clip sullo schermo attraverso il comando swapDepth (scambia profondità)
	return (true);
	// valore id ritorno della funzione, che nella detectKeys viene assegnato alla variabile keyPressed
} 
//funzione che assegna i movimenti al personaggio in base ai tasti premuti
function detectKeys() {
  var ob = _root.char; //sets a variable "ob" to point to _root.char, where all the info about the character is stored (see line 34)
  var keyPressed = false; //variable keyPressed is used check if in the end of the function some arrow keys have been pressed or not
  //four if statements for 4 directions
  if (Key.isDown(Key.RIGHT)) {
    keyPressed=_root.moveChar(ob, 1, 0);
	//calls the function moveChar using 3 arguments. First argument is the variable "ob" (line 82), that points to our char object. Last two arguments are always set -1, 1 or 0. Those determine if we should move the character horizontally by changing its x coordinate (second argument) or vertically by changing the y coordinate (third argument)
 	//sets the return value of moveChar function to the variable keyPressed: if any of the arrow keys are pressed, variable keyPressed will be set to true.
 } else if (Key.isDown(Key.LEFT)) {
     keyPressed=_root.moveChar(ob, -1, 0);
  } else if (Key.isDown(Key.UP)) {
    keyPressed=_root.moveChar(ob, 0, -1);
  } else if (Key.isDown(Key.DOWN)) {
    keyPressed=_root.moveChar(ob, 0, 1); 
  }
  //next will check if variable keyPressed is false, meaning no arrow keys has been pressed, in which case the animation of the character stops, using gotoAndStop(1)
  if (!keyPressed) {
    ob.clip.char.gotoAndStop(1);
  } else {
    ob.clip.char.play(); //if variable keyPressed is however true, we continue to play the movement animation
  }
}

//chiamata per la funzione che costruisce la mappa all'inizio del gioco, o ogni volta che viene chiamata da un bottone ad esempio	
//buildMap(Map); codice che funziona
buildMap(_root["Map"]);
stop();



