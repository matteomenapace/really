// from http://www.tonypa.pri.ee/tbw/tut01.html and following pages
var map1:Array = [[8, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 7], [3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3], [3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3], [3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3], [3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3], [3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3], [3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3], [3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3], [3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3], [3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3], [3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3], [3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3], [3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3], [3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3], [3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3], [3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3], [3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3], [6, 2, 2, 2, 2, 4, 0, 0, 0, 0, 0, 5, 2, 2, 2, 2, 2, 2, 2, 2, 9]];
//creates a map, with 0 as "walkable space" and all the other numbers as obstacles
var map2:Array = [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]];
var game:Object = {tileW:30};
//"game" is an Object that holds functions and properties, instead of having them on the main scene (_root)
//DEBUG game={tileW:30, tileH:30}; //tileH è stata eliminata perché non serve nell'assonometria
//proprietà dell'oggetto "game" sono la larghezza tileW e l'altezza tileH 
//creo una classe per le Tiles (mattonelle) in cui inserisco proprietà condivise, o di default, in modo da non doverle riscrivere ogni volta che inserirò un nuovo tipo specifico di tile
game.TileClass = function() {
};
game.TileClass.prototype.walkable = false;
game.TileClass.prototype.frame = 20;
//questa classe che userò come default assegna due valori prototipi alle mattonelle
game.Tile0 = function() {
};
game.Tile0.prototype.__proto__ = game.TileClass.prototype;
//eredita le proprietà di default da TileClass
game.Tile0.prototype.walkable = true;
game.Tile0.prototype.frame = 1;
//dopo aver preso le proprietà di default, posso cambiarle
//Tile0 è una funzione dell'oggetto "game" con due proprietà prototipe, che vengono cioè assegnate ad ogni istanza di Tile0
//walkable significa che la mattonella è percorribile dai personaggi del gioco, se true
//frame indica il punto nella timeline del movieclip "tile" dove questa specifica tile si fermerà, e corrisponde a determinati colori, forme, ecc
game.Tile1 = function() {
};
game.Tile1.prototype.__proto__ = game.TileClass.prototype;
//eredita le proprietà di default da TileClass
game.Tile1.prototype.frame = 2;
game.Tile2 = function() {
};
game.Tile2.prototype.__proto__ = game.TileClass.prototype;
game.Tile2.prototype.frame = 3;
game.Tile3 = function() {
};
game.Tile3.prototype.__proto__ = game.TileClass.prototype;
game.Tile3.prototype.frame = 4;
game.Tile4 = function() {
};
game.Tile4.prototype.__proto__ = game.TileClass.prototype;
game.Tile4.prototype.frame = 5;
game.Tile5 = function() {
};
game.Tile5.prototype.__proto__ = game.TileClass.prototype;
game.Tile5.prototype.frame = 6;
game.Tile6 = function() {
};
game.Tile6.prototype.__proto__ = game.TileClass.prototype;
game.Tile6.prototype.frame = 7;
game.Tile7 = function() {
};
game.Tile7.prototype.__proto__ = game.TileClass.prototype;
game.Tile7.prototype.frame = 8;
game.Tile8 = function() {
};
game.Tile8.prototype.__proto__ = game.TileClass.prototype;
game.Tile8.prototype.frame = 9;
game.Tile9 = function() {
};
game.Tile9.prototype.__proto__ = game.TileClass.prototype;
game.Tile9.prototype.frame = 10;
game.Tile10 = function() {
};
game.Tile10.prototype.__proto__ = game.TileClass.prototype;
game.Tile10.prototype.frame = 11;
// funzione che compone la vera e propria mappa sullo schermo
function buildMap(map) {
	_root.attachMovie("empty", "tiles", 1);
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
	for (var i = 0; i<mapHeight; i++) {
		for (var j = 0; j<mapWidth; j++) {
			var tileName = "t_"+i+"_"+j;
			//sets a name to be given to each tile, dove "i" indica la coordinata Y (altezza,height) e "j" la coordinata X (larghezza, width)
			game[tileName] = new game["Tile"+map[i][j]]();
			//stores into the object "game" a lot of new Tiles, a cui assegna i valori di quello specifico punto della mappa (se ad esempio la mappa in quel punto è 0 allora il clip assume le proprietà prototipe della classe Tile0 (vedi all'inizio del codice)
			if (game[tileName].walkable) {
				var clip = game.clip.back;
			} else {
				var clip = game.clip;
			}
			// la variabile clip (interna alla funzione) può assumere le proprietà di game.clip.back (che verrà assegnata se la mattonella è walkable, quindi in background); oppure di game.clip, che verra assegnato se la mattonella è una barriera
			game[tileName].depth = (j+i)*game.tileW/2*300+(j-i)*game.tileW+1;
			/*
			calcola la depth dell'oggetto game[tileName]: 
			j e i sono le coordinate relative (in mattonelle) dell'oggetto; j è la coordinata verticale e i quella orizzontale
			moltiplicate per le misure delle mattonelle (tileW:30, che diventa 15 in verticale perché in assonometria l'asse y è schiacciato)
			moltiplicato per 300 per l'asse verticale (probabilmente per ottenere un range di profondità ampio...forse potrebbe essere un altro numero)
			alla fine viene aggiunto 1 per evitare che ci siano oggetti su depth 0
			*/
			clip.attachMovie("tile", tileName, game[tileName].depth);
			//assegna la depth appena calcolata al movie clip corrente
			clip[tileName]._x = (j-i)*game.tileW;
			clip[tileName]._y = (j+i)*game.tileW/2;
			// posiziona la tile sulle coordinate applicando l'assonometria (asse y schiacciato)
			// notare la differenza tra ._x in cui c'è una sottrazione (j-i: larghezza-altezza) mentre in ._y si sommano (regole assonometriche)
			clip[tileName].gotoAndStop(game[tileName].frame);
			// sends the current tile mc to correct frame, according to the properties set in the classes Tile0, Tile1 and so on
		}
	}
}
game.CharacterClass = function() {
};
game.CharacterClass.prototype.xtile = 0;
game.CharacterClass.prototype.ytile = 0;
game.CharacterClass.prototype.speed = 5;
//speed accettabili: 1,2,3,5,6 ecc purché sottomultipli di 30, cioè 30:speed deve essere un intero
game.CharacterClass.prototype.turning = 1;
// valore che determina il grado di "infermezza" dei characters...
game.CharacterClass.prototype.moving = false;
game.CharacterClass.prototype.width = 20;
game.CharacterClass.prototype.height = 20;
game.CharacterClass.prototype.select = false;
game.CharacterClass.prototype.xMove = 0;
game.CharacterClass.prototype.yMove = 0;
// xMove e yMove sono due proprietà che indicano le direzioni in cui si muovono i personaggi quando non sono controllati dall'utente
//classe di proprietà prototipe da assegnare ai characters successivamente
var character:Object = {};
// declare a "character" object (it is on the _root, right?), which means the main characters for the game, xtile and ytile are tiles where the character center is set by default
//funzione che importa e posiziona i characters sullo schermo
function createCharacters(ob, map, charTotal) {
	for (var i = 1; i<=charTotal; i++) {
		var charName = "character_"+i;
		//t race (charName);
		character[charName] = new game["CharacterClass"]();
		// l'oggetto character assume le proprietà della classe CharacterClass
		//trace (character[charName].xMove); // 0	
		var ob = character[charName];
		//trace (ob.xtile); // 0 at this stage
		//crea una variabile ob (la dichiarazione VAR fa si che ob sia interna alla funzione, quindi non dovrebbe intaccare variabili con lo stesso nome posizionate in altre funzioni)
		//la variabile ob assume le proprietà dell'oggetto character, dichiarato sopra
		ob.xtile = 1+Math.round(Math.random()*(map[0].length-3));
		//dispone l'oggetto character in maniera casuale sullo stage
		ob.ytile = 1+Math.round(Math.random()*(map.length-3));
		//il numero casuale viene generato da 0 a map.length/map[0].length - 3...perché? 2 sono le tile di confine (su-giù e dx-sx), e 1 è la tile che aggiungo all'inizio dell'espressione, quindi 2+1=3
		//trace ("map(x)="+map[0].length+"  map(y)="+map.length);
		//trace("xtile="+ob.xtile+"  ytile="+ob.ytile); 
		ob.x = ob.xtile*game.tileW;
		ob.y = ob.ytile*game.tileW;
		//trace (ob.y);
		//calcola la posizione iniziale dell'oggetto in coordinate assolute
		ob.xiso = ob.x-ob.y;
		ob.yiso = (ob.x+ob.y)/2;
		//trace (ob.yiso);
		// due nuove proprietà (xiso e yiso) che calcolano la posizione dell'oggetto in vista assonometrica secondo lo stesso principio delle funzioni sopra: (x-y) per la larghezza, (x+y)/2 per l'altezza
		ob.depthshift = (game.tileW-ob.height)/2;
		ob.depth = (ob.yiso-ob.depthshift)*300+ob.xiso+1;
		//trace ("ob.yiso="+ob.yiso+"  ob.xiso="+ob.xiso+"  ob.depth="+ob.depth);
		//trace (character[charName].xiso);
		/* 
		formula per calcolare la depth da assegnare all'oggetto/personaggio...
		il principio della profondità è che più è alto il numero relativo di una tile (o di un personaggio) più in basso a destra si troverà nella distorsione assonometrica
		però la sua profondità dovra essere tale da risultare in primo piano (quindi depth alta (primo piano) >> numero alto);
		come sopra ricorre il numero 300 e l'aggiunta di 1 alla fine 
		al posto di (j+i)*game.tileW/2 ho però (ob.yiso-ob.depthshift) 
		cioè al posto della somma delle coordinate relative moltiplicata per le dimensioni della tile (che mi dà il suo "grado di vicinanza-lontananza" in assonometria: infatti una tile lontana avrà i e j basse tipo 0 e 0, mentre una tile in basso a sinistra sulla mappa ortogonale avrà i e j alti tipo 8 e 9)
		ho la coordinata assonometrica (yiso) a cui viene sottratto il valore della variabile depthshift (cioè?)
		depthshift è la metà della differenza fra una mattonella e le dimensioni dell'oggetto, nel nostro caso è uguale a 5 ((30-20)/2))
		boh...
		*/
		game.clip.attachMovie("char"+i, charName, ob.depth);
		ob.clip = game.clip[charName];
		// ob.clip assume le proprietà dell'oggetto game.clip.charName che ho appena estratto dalla library
		ob.clip._x = ob.xiso;
		ob.clip._y = ob.yiso;
		ob.clip.gotoAndStop(ob.frame);
		// places "charName" at the right isometric coordinates and plays the right frame for it, according to the ob properties (siccome ob assume le proprietà del movieclip "char", in base alla direzione da seguire lo posizionerà sul giusto frame di visualizzazione)
	}
}
var currentCharacter = 0;
// dichiara la variabile che deve essere pubblica, ma appena il gioco viene lanciato il numero sarà cambiato
function swapCharacters(ob, charTotal) {
	var oldCharacter = _root.currentCharacter;
	// il valore corrente viene trasferito ad una nuova variabile che chiamo OLD, perché il suo valore rappresenterà il vecchio "currentCharacter"
	ob = character["character_"+oldCharacter];
	//ob assume le proprietà del character "uscente"
	removeMovieClip(ob.clip.selectedCube);
	// toglie il cubetto che indica il character attivo
	ob.select = false;
	//ob.speed = 6;
	// cambia la proprietà "select" da true a false, in modo che il character "sappia" di non essere più selezionato 
	/*var newCharacter = 1+Math.round(Math.random()*(charTotal-1)); // genera un numero casuale per il nuovo character
	while (oldCharacter == newCharacter) {
	newCharacter = 1+Math.round(Math.random()*(charTotal-1)); // ripete la generazione di un numero casuale finché il nuovo valore non è diverso dal vecchio 
	}*/
	var newCharacter = 1+random(charTotal);
	// genera un numero casuale per il nuovo character; da 0 a 4 e poi aggiunge 1, quindi da 1 a 5
	while (oldCharacter == newCharacter) {
		var newCharacter = 1+random(charTotal);
		// ripete la generazione di un numero casuale finché il nuovo valore non è diverso dal vecchio 
	}
	_root.currentCharacter = newCharacter;
	//assegna il nuovo valore alla variabile pubblica
	// trace("character_"+_root.currentCharacter);
	ob = character["character_"+newCharacter];
	//ob assume le proprietà del nuovo character in carica
	ob.clip.attachMovie("selected", "selectedCube", ob.depth+1);
	//gli attacca il cubetto di selezione in modo da avere un feedback visivo del nuovo character in carica
	ob.select = true;
	//ob.speed = 6;
	// cambia la proprietà "select" da false a true, in modo che il character "sappia" di essere selezionato 
	//trace ("character_"+currentCharacter+" is selected");
}
function getMyCorners(x, y, ob) {
	//ob.downY = Math.floor((y+ob.height-1)/game.tileH); //codice originale
	ob.downY = Math.floor((y+ob.height-1)/game.tileW);
	//ob.upY = Math.floor((y-ob.height)/game.tileH); //codice originale
	ob.upY = Math.floor((y)/game.tileW);
	//ob.leftX = Math.floor((x-ob.width)/game.tileW); //codice originale
	ob.leftX = Math.floor((x)/game.tileW);
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
// quindi in sostanza, praticamente, diciamo che, insomma, questa funzione rileva ad ogni movimento di un oggetto lo "status" delle mattonelle adiacenti, in modo da prevedere se il prossimo movimento sarà libero o se invece c'è una qualche barriera
//funzione che determina i movimenti di un personaggio
function moveChar(ob, dirx, diry) {
	getMyCorners(ob.x, ob.y+ob.speed*diry, ob);
	//chiama la funzione getMyCorners, che rileva i potenziali punti di collisione attorno al personaggio
	//le prime due condizioni sono dedicate alle collisioni verticali
	//giù=1, su=-1
	if (diry == -1) {
		//cioè se il personaggio sta andando in su
		if (ob.upleft and ob.upright) {
			//se gli angoli superiori destro e sinistro sono true, cioè liberi di essere calpestati ("walkable")
			ob.y += ob.speed*diry;
		} else {
			ob.y = ob.ytile*game.tileW;
			//+ob.height nel tutorial...
		}
		//permette all'oggetto "ob" di spostarsi in su 
		//posiziona l'oggetto "ob" sul confine superiore invalicabile
	}
	if (diry == 1) {
		// se si muove verso il basso...come al solito Flash ha un sistema di riferimento X-Y dove l'origine è in alto a sinistra, quindi le coordinate verticali sono "ribaltate" rispetto all'intuito per cui più Y è alta più appunto il punro relativo è in alto: in Flash è il contrario
		if (ob.downleft and ob.downright) {
			ob.y += ob.speed*diry;
		} else {
			ob.y = (ob.ytile+1)*game.tileW-ob.height;
		}
	}
	//le altre due condizioni sono dedicate alle collisioni orizzontali                  
	//destra=1, sinistra=-1
	getMyCorners(ob.x+ob.speed*dirx, ob.y, ob);
	if (dirx == -1) {
		// sta andando a sinistra
		if (ob.downleft and ob.upleft) {
			ob.x += ob.speed*dirx;
		} else {
			ob.x = ob.xtile*game.tileW;
			// +ob.width nel tutorial (che però non era in assonometria)
		}
	}
	if (dirx == 1) {
		// sta andando a destra
		if (ob.upright and ob.downright) {
			ob.x += ob.speed*dirx;
		} else {
			ob.x = (ob.xtile+1)*game.tileW-ob.width;
		}
	}
	ob.xiso = ob.x-ob.y;
	ob.yiso = (ob.x+ob.y)/2;
	// calculates the updated position in isometric view
	ob.clip._x = ob.xiso;
	ob.clip._y = ob.yiso;
	// updates "char" position on screen
	// posiziono l'oggetto ob.clip secondo le coordinate appena calcolate (notare che ob è un oggetto "universale" perché non è direttamente legato ad un movieclip, quindi questa funzione può essere applicata anche ad altri elemneti del gioco, per muoverli
	ob.clip.gotoAndStop(dirx+diry*2+3);
	// questa formula stupidissima calcola il frame su cui l'oggetto (nella sua istanza "clip" che appare a schermo) deve posizionarsi per mostrare l'immagine o il clip del personaggio nella giusta direzione
	// ad esempio: DESTRA > dirx=1, diry=0 => gotoAndStop(1+0+3)=gotoAndStop(4)
	// ad esempio: SINISTRA > dirx=-1, diry=0 => gotoAndStop(-1+0+3)=gotoAndStop(2)  
	ob.xtile = Math.floor(ob.x/game.tileW);
	ob.ytile = Math.floor(ob.y/game.tileW);
	//come si presenta il codice nel vecchio tutorial
	//ob.xtile = Math.floor(ob.clip._x/game.tileW);
	//ob.ytile = Math.floor(ob.clip._y/game.tileW);
	//la mia versione dei fatti...
	// calcolo le nuove coordinate relative (su quale mattonella "tile" si trova attualmente) dell'oggetto "ob", dividendo le sue nuove coordinate per larghezza/lunghezza di una mattonella (che è l'unità di misura del gioco fondamentalmente)
	ob.depth = (ob.yiso-ob.depthshift)*300+(ob.xiso)+1;
	ob.clip.swapDepths(ob.depth);
	// calcolo della depth dell'oggetto, secondo la solita formula già vista nella funzione buildMap
	// aggiorno la depth dell'oggetto clip sullo schermo attraverso il comando swapDepth (scambia profondità)
	return (true);
	// valore di ritorno della funzione, che nella detectKeys viene assegnato alla variabile keyPressed
}
function characterBrain(charTotal) {
	// loop through all characters currently on stage
	for (var i = 1; i<=charTotal; i++) {
		var charName = "character_"+i;
		var ob = character[charName];
		// trace (charName+" selected? "+ob.select);
		if (!ob.select) {
			//ob non deve essere sotto il controllo attivo dell'utente, quindi la sua proprietà "select" deve essere false
			//trace (charName+" selected? "+ob.select);
			getMyCorners(ob.x+ob.speed*ob.xMove, ob.y+ob.speed*ob.yMove, ob);
			// controlla se le mattonelle adiacenti permettono di spostarsi liberamente o se ci sono ostacoli. NB: controlla solo mattonelle non persone (posso aggiungere la proprietà walkable anche ai characters, no?)
			if (ob.downleft and ob.upleft and ob.downright and ob.upright and random(200)>ob.turning) {
				// se il terreno è libero in tutte le direzioni e la proprietà turning (3 per default, ma andrà resa dinamica) è inferiore al numero casuale generato da 0 a 99
				// turning rappresenta il valore di "infermezza" dell'oggeto in movimento...se turning è alto l'oggetto continuerà a cambiare direzione, mentre se è basso sarà più sciolto e deciso nei movimenti (interesting...)
				// moves character
				moveChar(ob, ob.xMove, ob.yMove);
			} else if (ob.xMove == 0) {
				ob.xMove = random(2)*2-1;
				// random(2) significa che si prende un numero intero casuale 0 <= r < 2; quindi 0 o 1; *2-1 in modo da avere 2 possibilità: 1 e -1 che equivalgono a due direzioni opposte
				ob.yMove = 0;
				getMyCorners(ob.x+ob.speed*ob.xMove, ob.y+ob.speed*ob.yMove, ob);
				if (!ob.downleft or !ob.upleft or !ob.downright or !ob.upright) {
					ob.xMove = -ob.xMove;
				}
				moveChar(ob, ob.xMove, ob.yMove);
			} else {
				ob.xMove = 0;
				ob.yMove = random(2)*2-1;
				getMyCorners(ob.x+ob.speed*ob.xMove, ob.y+ob.speed*ob.yMove, ob);
				if (!ob.downleft or !ob.upleft or !ob.downright or !ob.upright) {
					ob.yMove = -ob.yMove;
				}
				moveChar(ob, ob.xMove, ob.yMove);
			}
		}
		// va notato che uno dei due xMove o yMove deve essere sempre 0, altrimenti avrei lo sgradevole effetto di oggetti che si muovono diagonalmente           
		//il prossimo ciclo for valuta se ci sono delle collisioni fra gli oggetti in movimento
		//è interno ad un altro ciclo for (vedi sopra), ed inoltre essendo la prima condizione j=i faccio in modo che non faccia confronti incrociati tipo 1>2--2>1 ed alleggerisco flashPlayer
		//for (var j = i; j<=charTotal; j++) {
		for (var j = i; j<=charTotal; j++) {
			var otherCharName = "character_"+j;
			var other = character[otherCharName];
			//other assume le proprietà del character corrispondente a quel nome 
			var distanza_sicurezza = 0;
			if (otherCharName != charName) {
				// devo evitare che venga calcolata la distanza di un character da se stesso, con conseguente impallamento dei characters 
				var xdist = ob.x-other.x;
				//distanza orizzontale
				var ydist = ob.y-other.y;
				// distanza verticale
				var distance = Math.sqrt(Math.pow(xdist, 2)+Math.pow(ydist, 2));
				// teorema del vecchio fantasmagorico Pitagora
				// if (j==1 and i==3) {trace(distance)}
				if (distance<(ob.width+other.width+distanza_sicurezza)) {
					ob.xMove = -ob.xMove;
					ob.yMove = -ob.yMove;
					//ob.xMove = 0;
					//ob.yMove = 0;
					other.xMove = -other.xMove;
					other.yMove = -other.yMove;
				}
			}
		}
	}
}
function detectKeys() {
	var ob = _root.character["character_"+_root.currentCharacter];
	//sets a variable "ob" to point to _root.char, where all the info about the character is stored (see line 34)
	var keyPressed = false;
	//variable keyPressed is used to check if in the end of the function some arrow keys have been pressed or not
	//four if statements for 4 directions
	if (Key.isDown(Key.RIGHT)) {
		keyPressed = moveChar(ob, 1, 0);
		//calls the function moveChar using 3 arguments. First argument is the variable "ob" (line 82), that points to our char object. Last two arguments are always set -1, 1 or 0. Those determine if we should move the character horizontally by changing its x coordinate (second argument) or vertically by changing the y coordinate (third argument)
		//sets the return value of moveChar function to the variable keyPressed: if any of the arrow keys are pressed, variable keyPressed will be set to true.
	} else if (Key.isDown(Key.LEFT)) {
		keyPressed = moveChar(ob, -1, 0);
	} else if (Key.isDown(Key.UP)) {
		keyPressed = moveChar(ob, 0, -1);
	} else if (Key.isDown(Key.DOWN)) {
		keyPressed = moveChar(ob, 0, 1);
	}
	_root.characterBrain(7);
	//per ora i personaggi sono 7, ma questo numero deve diventare una variabile da aggiornare dinamicamente
}
//chiamata per la funzione che costruisce la mappa all'inizio del gioco, o ogni volta che viene chiamata da un bottone ad esempio	
buildMap(map2);
createCharacters(ob, map2, 7);
swapCharacters(ob, 7);
stop();
