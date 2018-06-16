McDONALD'S VIDEOGAME 
frame 4 ("gioco")

stop();
_global.zona = "agricoltura";
_global.running = true;
with (brand) {
	alimentarista = false;
	politico = false;
	climatologo = false;
	ispettore = false;
	topolino = false;
	bambini = false;
	alimentazione = false;
	terzomondo = false;
}
ormoni = false;
farineanimali = false;
scarti = false;
stagioni.gotoAndStop(4);
timeabs = 0;
//settimane assolute dall'inizio del gioco
//faccio partire il loop ambientale
_root.loopAmbiente.start(0, 999);
_root.prova = 0;
_root.pianomenu.attachMovie("menucontestuale", "menucontestuale", 1000);
_root.pianomenu.attachMovie("menulavoratore", "menulavoratore", 10);
_root.pianomenu.menulavoratore._visible = false;
bilancio = _root.STR_INIZIO_ATTIVITA+"\n";
//array con il saldo
stat = new Array();
stat.push(soldi);
bilanci = new Array();
bilanci.push(_root.STR_INIZIO_ATTIVITA);
//per evitare la duplicazione di intervalli
clearInterval(weekInterval);
time = TIME;
weekInterval = setInterval(everyweek, time);
interfaccia = 0;
Listener = new Object();
Listener.onMouseUp = function() {
	if (_root.interfaccia == 0) {
		//resetSelections();
		deselezionaall();
	}
};
Mouse.addListener(Listener);
function everyweek() {
	//non tutto si può inizializzare all'istante
	//perciò aspetto un attimo
	if (timeabs == 1) {
		for (i=0; i<_root.VACCHE_INIZIALI; i++) {
			nuovavacca();
		}
	}
	timeabs++;
	/*limitatore velocità
	devo sempre assicurare che 5 frames possano essere eseguiti
	perciò se l'intervallo time è troppo breve e la macchina non ci sta
	dietro lo diminuisco*/
	//aspetto che entri a regime
	if (timeabs>3) {
		if (fps.dp.text != undefined) {
			velocitaMax = 5/fps.dp.text*1000;
		}
		clearInterval(weekInterval);
		weekInterval = setInterval(everyweek, time);
		//trace(timeabs);
	}
	//correggo l'intervallo se è troppo breve per la macchina 
	if (time<velocitaMax && velocitaMax != undefined) {
		time = velocitaMax+100;
		clearInterval(weekInterval);
		weekInterval = setInterval(everyweek, time);
	}
	//retail 
	aggiornafrigo();
	aggiornapanini();
	muovipostazioni();
	if (_root.affluenza>0) {
		nuoviclienti(_root.affluenza);
	}
	if (retail.fila1.clienti>0 && panini>0 && retail.cassa1.attiva == true) {
		//se non capita zero su motivazione * costante
		if (random(retail.cassa1.motivazione*_root.MOLTIPLICATORE_MOTIVAZIONE) != 0) {
			scorrifila.call(retail.fila1);
		} else {
			retail.cassa1.omino.braccia.gotoAndPlay("fermo");
			retail.cassa1.omino.faccia.bocca.gotoAndPlay("sbadiglio");
		}
	}
	if (retail.fila2.clienti>0 && panini>0 && retail.cassa2.attiva == true) {
		//se non capita zero su motivazione * costante
		if (random(retail.cassa2.motivazione*_root.MOLTIPLICATORE_MOTIVAZIONE) != 0) {
			scorrifila.call(retail.fila2);
		} else {
			retail.cassa2.omino.braccia.gotoAndPlay("fermo");
			retail.cassa2.omino.faccia.bocca.gotoAndPlay("sbadiglio");
		}
		//retail.cassa2.gotoAndPlay(1);
	}
	if (retail.fila3.clienti>0 && panini>0 && retail.cassa3.attiva == true) {
		//se non capita zero su motivazione * costante
		if (random(retail.cassa3.motivazione*_root.MOLTIPLICATORE_MOTIVAZIONE) != 0) {
			scorrifila.call(retail.fila3);
		} else {
			retail.cassa3.omino.braccia.gotoAndPlay("fermo");
			retail.cassa3.omino.faccia.bocca.gotoAndPlay("sbadiglio");
		}
	}
	week++;
	if (week>=4) {
		month++;
		week = 0;
		everymonth();
	}
	//cambio stagione 
	if ((month == 2) && (week == 3)) {
		spring();
	} else if ((month == 5) && (week == 3)) {
		summer();
	} else if ((month == 8) && (week == 3)) {
		fall();
	} else if ((month == 11) && (week == 3)) {
		winter();
	}
	//conteggio vacche 
	contavacche();
	//sorteggia la salute
	salutevacche();
	//sincronizzazione frames
	allevamento.tritacarne.gotoAndPlay(1);
	//}
}
function everymonth() {
	if (month>=12) {
		month = 0;
		year++;
		absyear++;
		//ogni anno l'aspettativa di guadagno degli azionisti aumenta
		if (_root.MIN_GUADAGNO<_root.MAX_GUADAGNO) {
			_root.MIN_GUADAGNO += _root.ASPETTATIVA;
		}
		//ogni cinque anni resetto i bilanci 
		if (absyear != 0 && absyear%_root.MAX_YEAR == 0) {
			//absyear=0;
			periodo += _root.MAX_YEAR;
			for (i=0; i<_root.MAX_YEAR*12; i++) {
				_root.bilanci.shift();
				_root.stat.shift();
			}
		}
	}
	//calcolo il num vacche 
	vacchefuture = _root.calcolavacche();
	soiafutura = _root.calcolasoia();
	///////////////////
	//GESTIONE BILANCIO
	str_month = MESI[month];
	bilanci.push(bilancio);
	bilancio = STR_BILANCIO+str_month+" "+year+"\n\n";
	bilancio += STR_ENTRATE+": ";
	bilancio += entrate+"\n";
	bilancio += STR_USCITE+": ";
	bilancio += uscite+"\n";
	guadagno = entrate-uscite;
	bilancio += STR_GUADAGNO+": "+guadagno+"\n";
	//gestione CDA
	allarme_output = "";
	//la stringa che pilota l'omino
	//il guadagno non è sufficiente
	if (guadagno<MIN_GUADAGNO) {
		allarme_cda += ALLARMISMO_CDA;
	} else if (guadagno<0) {
		allarme_cda += ALLARMISMO_CDA*2;
	} else if (allarme_cda>0) {
		allarme_cda -= ALLARMISMO_CDA;
	}
	//l'allarme è troppo 
	if (allarme_cda>=MAX_ALLARME) {
		//lo blocco al massimo
		allarme_cda = MAX_ALLARME;
		allarme_output = STR_CRESCITA;
	}
	if (soldi<BANCAROTTA/2) {
		allarme_output += STR_CONTO;
	}
	if (soldi<=BANCAROTTA) {
		gameOver();
	}
	if (guadagno>=0) {
		_root.brand.schermo.gotoAndStop("su");
	} else {
		_root.brand.schermo.gotoAndStop("giu");
	}
	if (allarme_output != "") {
		_root.brand.relatore.gotoAndPlay("allarme");
		_root.alm_brand.gotoAndPlay("on");
		_root.brand.az1.testa.gotoAndStop("incazzato");
		_root.brand.az2.testa.gotoAndStop("incazzato");
		_root.brand.az3.testa.gotoAndStop("incazzato");
		_root.brand.az4.testa.gotoAndStop("incazzato");
	} else {
		_root.brand.relatore.gotoAndPlay(1);
		_root.alm_brand.gotoAndStop("off");
		_root.brand.az1.testa.gotoAndStop("felice");
		_root.brand.az2.testa.gotoAndStop("felice");
		_root.brand.az3.testa.gotoAndStop("felice");
		_root.brand.az4.testa.gotoAndStop("felice");
	}
	bilancio += STR_SALDO+": "+soldi+"$\n\n";
	entrate = 0;
	uscite = 0;
	bilancio += STR_DETTAGLI+":\n";
	//spese mensili
	speseMensili();
	//aggiorno array
	stat.push(soldi);
	///////////////////////
	//scalo i boicottaggi
	if (sindacatiPicchetto>0) {
		sindacatiPicchetto--;
	}
	if (noglobalBoicott>0) {
		noglobalBoicott--;
	}
	if (ecologistiBoicott>0) {
		ecologistiBoicott--;
	}
	//e la società civile? 
	calcolaDissenso();
	//calcola numero di clienti
	calcolaAffluenza();
	//gestione esternalita
	desertificazione();
	calcolafertilita();
	surriscaldamento();
	famecitta();
	ingrassovacche();
	//quelle all'ingrasso
	///////////////////////
	//gestione motivazione
	//più passa il tempo più è probabile che
	//i lavoratori si rompano il cazzo
	//randomizzo solo una volta per non appesantire
	rnd = random(SFIDUCIA);
	switch (rnd) {
	case 1 :
		if (retail.linea1.attiva == true && retail.linea1.motivazione>1) {
			retail.linea1.motivazione--;
		}
		break;
	case 2 :
		if (retail.linea2.attiva == true && retail.linea2.motivazione>1) {
			retail.linea2.motivazione--;
		}
		break;
	case 3 :
		if (retail.linea3.attiva == true && retail.linea3.motivazione>1) {
			retail.linea3.motivazione--;
		}
		break;
	case 4 :
		if (retail.cassa1.attiva == true && retail.cassa1.motivazione>1) {
			retail.cassa1.motivazione--;
		}
		break;
	case 5 :
		if (retail.cassa2.attiva == true && retail.cassa2.motivazione>1) {
			retail.cassa2.motivazione--;
		}
		break;
	case 6 :
		if (retail.cassa3.attiva == true && retail.cassa3.motivazione>1) {
			retail.cassa3.motivazione--;
		}
		break;
	}
	//////////////////////////////
	//gestione vacche agricoltura
	for (j=1; j<TOT_TILES; j++) {
		//ingrassa quelle esistenti
		if (piano["tile"+j].tipo == "allevamento") {
			//vacca1
			if ((piano["tile"+j].vacca1._currentframe>=25) || (piano["tile"+j].vacca1._currentframe<5)) {
				piano["tile"+j].vacca1.play();
			} else if (piano["tile"+j].vacca1._visible == true) {
				piano["tile"+j].vacca1.nextFrame();
			}
			//vacca2 
			if ((piano["tile"+j].vacca2._currentframe>=25) || (piano["tile"+j].vacca2._currentframe<5)) {
				piano["tile"+j].vacca2.play();
			} else if (piano["tile"+j].vacca2._visible == true) {
				piano["tile"+j].vacca2.nextFrame();
			}
			//vacca3 
			if ((piano["tile"+j].vacca3._currentframe>=25) || (piano["tile"+j].vacca3._currentframe<5)) {
				piano["tile"+j].vacca3.play();
			} else if (piano["tile"+j].vacca3._visible == true) {
				piano["tile"+j].vacca3.nextFrame();
			}
		}
	}
}
//funzioni di stagione
function spring() {
	stagioni.gotoAndStop(1);
	season = STR_SPRING;
	flagm = false;
	//flag per non far partire più suoni
	for (i=1; i<TOT_TILES; i++) {
		if (piano["tile"+i].tipo == "soia") {
			piano["tile"+i].gotoAndPlay("soiamietitura");
			if (zona == "agricoltura") {
				flagm = true;
			}
		}
		if (piano["tile"+i].tipo == "grano") {
			piano["tile"+i].gotoAndPlay("granomietitura");
			if (zona == "agricoltura") {
				flagm = true;
			}
		}
	}
	if (flagm) {
		_root.suonoMietitura.start(0, 5);
	}
}
function summer() {
	stagioni.gotoAndStop(2);
	season = STR_SUMMER;
	for (i=1; i<TOT_TILES; i++) {
		if (piano["tile"+i].tipo == "soia") {
			piano["tile"+i].gotoAndPlay("soiariposo");
			//fertilita da 0 a 180
			m = RENDITA_SOIA+(piano["tile"+i].fertilita/DIVISORE_FERTILITA);
			if (piano["tile"+i].ogm == true) {
				m *= MOLTIPLICATORE_OGM;
			}
			if (scarti == true) {
				m *= MOLTIPLICATORE_SCARTI;
			}
			m = Math.round(m);
			mangime += m;
			gestionecisterna();
			//refrescia cisterna
		}
		if (piano["tile"+i].tipo == "grano") {
			piano["tile"+i].gotoAndPlay("granoriposo");
		}
	}
}
function fall() {
	stagioni.gotoAndStop(3);
	season = STR_FALL;
	ar = false;
	//flag almeno un campo da arare
	//per ogni tile
	for (i=1; i<TOT_TILES; i++) {
		//se è verdone	
		if ((piano["tile"+i]._currentframe>45) && (piano["tile"+i].tipo == "soia")) {
			piano["tile"+i].gotoAndPlay("soiaaratura");
		}
		if (piano["tile"+i].tipo == "attesagrano") {
			piano["tile"+i].tipo = "grano";
		}
		if (piano["tile"+i].tipo == "grano") {
			piano["tile"+i].gotoAndPlay("granoaratura");
		}
	}
}
function winter() {
	stagioni.gotoAndStop(4);
	season = STR_WINTER;
	for (i=1; i<TOT_TILES; i++) {
		//se sono gia stati predisposti ora diventano effettivi
		if ((piano["tile"+i].tipo == "attesasoia") && (piano["tile"+i].nuovoutilizzo == undefined)) {
			piano["tile"+i].tipo = "soia";
		}
		if (piano["tile"+i].tipo == "soia") {
			//se non è nell'animazione aratura
			piano["tile"+i].gotoAndPlay("soiacrescita");
		}
		if (piano["tile"+i].tipo == "grano") {
			piano["tile"+i].gotoAndPlay("granocrescita");
		}
	}
}
//funzione help
function help(testo, costo, tipo) {
	_root.interfaccia = 1;
	_root.testohelp = testo;
	_root.menu.help._visible = true;
	if (costo == undefined) {
		_root.testocosto = "";
		_root.menu.help.mascheraCosto._visible = false;
	} else {
		//se c'è il mese
		if (tipo == "mese") {
			_root.menu.help.mascheraCosto.gotoAndStop("mese");
		} else {
			_root.menu.help.mascheraCosto.gotoAndStop("tantum");
		}
		_root.testocosto = "$ "+costo;
		_root.menu.help.mascheraCosto._visible = true;
	}
	//visualizzo il costo 
}
//cancellahelp
function nohelp() {
	_root.interfaccia = 0;
	_root.menu.help._visible = false;
}
/*
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
////////////////////////////////AGRICOLTURA////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
*/
//funzioni matematiche
function calcolavacche() {
	v = 0;
	for (i=1; i<_root.TOT_TILES; i++) {
		if (piano["tile"+i].tipo == "allevamento") {
			v += piano["tile"+i].intensita;
		}
	}
	return v;
}
///////////////////////
function calcolasoia() {
	s = 0;
	for (i=1; i<_root.TOT_TILES; i++) {
		if ((piano["tile"+i].tipo == "soia") || (piano["tile"+i].tipo == "attesasoia")) {
			s += 1;
		}
		//piano["tile"+i].fertilita*RENDITA_SOIA; 
	}
	return s;
}
//assegno le funzioni ai tasti
/*//giorno più veloce
ffwd.onRelease = function(){ 

if(_root.velocita!="MAX")
{		
_root.suonoDit.start();
_root.velocita="MAX";
time=_root.velocitaMax;
_root.ffwd.gotoAndPlay("roll");
_root.normal.gotoAndStop("spento");
clearInterval(weekInterval);
weekInterval = setInterval(everyweek, time);
}
}*/
bott_pausa.onRelease = function() {
	if (_root.velocita != "PAUSA") {
		_root.suonoDit.start();
		_root.velocita = "PAUSA";
		_root.bott_pausa.gotoAndStop("pausa");
		_root.normal.gotoAndStop("spento");
		_root.suonoBeep.setVolume(0);
		pausa();
	}
};
//giorno più lento
normal.onRelease = function() {
	if (_root.velocita != "NORMAL") {
		_root.suonoDit.start();
		_root.velocita = "NORMAL";
		_root.normal.gotoAndPlay("roll");
		_root.bott_pausa.gotoAndStop("play");
		riprendi();
		if (suoni) {
			_root.suonoBeep.setVolume(100);
		}
		/*time=_root.velocitaMax*2;
		clearInterval(weekInterval);
		weekInterval = setInterval(everyweek, time);*/ 
	}
};
//main menu
bottMenu.onRelease = function() {
	pianofinestre.finestraMenu._visible = true;
};
pianofinestre.finestraMenu.tutorial.onRelease = function() {
	_root.tutorial.gotoAndStop(1);
	_root.tutorial._visible = true;
	_root.pianofinestre.finestraMenu._visible = false;
	_root.suonoBeep.setVolume(0);
	pausa();
};
pianofinestre.finestraMenu.continueGame.onRelease = function() {
	_root.pianofinestre.finestraMenu._visible = false;
};
pianofinestre.finestraMenu.quit.onRelease = function() {
	_root.gotoAndStop("menu");
};
finestraGameOver.quit.onRelease = function() {
	_root.gotoAndStop("menu");
};
pianofinestre.finestraMenu.sound.onLoad = function() {
	if (suoni) {
		this.scrittaSuoni.gotoAndStop("on");
	} else {
		this.scrittaSuoni.gotoAndStop("off");
	}
};
pianofinestre.finestraMenu.sound.onRelease = function() {
	if (suoni) {
		_root.suonoBeep.setVolume(0);
		_global.suoni = false;
		pianofinestre.finestraMenu.scrittaSuoni.gotoAndStop("off");
	} else {
		_root.suonoBeep.setVolume(100);
		_global.suoni = true;
		_root.pianofinestre.finestraMenu.scrittaSuoni.gotoAndStop("on");
	}
};
bottMenu.onRelease = function() {
	pianofinestre.finestraMenu._visible = true;
};
//
function pausa() {
	if (running) {
		//_root.suonoBeep.setVolume(0);
		clearInterval(weekInterval);
		_global.running = false;
	}
}
function riprendi() {
	if (!running) {
		weekInterval = setInterval(everyweek, time);
		_global.running = true;
	}
}
///////////////////////////////////////////////////////////
//funzione che resetta le selezioni
function resetSelections() {
	_root.pianomenu.menucontestuale._visible = false;
	_root.piano.tastoinfo._visible = false;
	_root.piano.tastomare._visible = false;
	_root.piano.tastocorrompi._visible = false;
	_root.piano.citta2.selezione.gotoAndStop("off");
	_root.piano.citta1.selezione.gotoAndStop("off");
	if (piano._visible == true) {
		_root.menu.gotoAndStop("nulla");
	}
	//tiles 
	for (i=1; i<TOT_TILES; i++) {
		piano["tile"+i].selezione.gotoAndStop("off");
		//piano["tile"+i].menu._visible=false;
	}
	//tiles speciali
	piano.citta1.selezione.gotoAndStop("off");
	piano.citta2.selezione.gotoAndStop("off");
	piano.mare.selezione.gotoAndStop("off");
	piano.tilecorrente = "nessuno";
}
function contextMenu(tile, tipo) {
	_root.pianomenu.menucontestuale._visible = true;
	_root.pianomenu.menucontestuale.gotoAndStop(tipo);
	//gestione suoni
	//
	if (tipo == "foresta" && (_root.suonoForesta.position == _root.suonoForesta.duration || _root.suonoForesta.position == 0)) {
		_root.suonoForesta.start();
	} else if (tipo == "villaggio" && (_root.suonoVillaggio.position == _root.suonoVillaggio.duration || _root.suonoVillaggio.position == 0)) {
		_root.suonoVillaggio.start();
	} else if (tipo == "deserto" && (_root.suonoDeserto.position == _root.suonoDeserto.duration || _root.suonoDeserto.position == 0)) {
		_root.suonoDeserto.start();
	}
	//interruttore ogm 
	if (_root.piano[tile].ogm == true) {
		_root.pianomenu.menucontestuale.tastoogm.gotoAndStop("on");
	} else {
		_root.pianomenu.menucontestuale.tastoogm.gotoAndStop("off");
	}
	if (tile == "tile20" || tile == "tile19") {
		_root.pianomenu.menucontestuale._x = piano[tile]._x+piano[tile]._width;
		_root.pianomenu.menucontestuale._y = -piano[tile]._y-30;
		if (tipo == "allevamento") {
			_root.pianomenu.menucontestuale.gotoAndStop("allevamento2");
		}
		if (tipo == "soia" || tipo == "attesasoia") {
			_root.pianomenu.menucontestuale.gotoAndStop("soia2");
		}
	} else if (tile == "tile9") {
		_root.pianomenu.menucontestuale._x = 2;
		_root.pianomenu.menucontestuale._y = piano[tile]._y+80;
		if (tipo == "allevamento") {
			_root.pianomenu.menucontestuale.gotoAndStop("allevamento3");
		}
		if (tipo == "soia" || tipo == "attesasoia") {
			_root.pianomenu.menucontestuale.gotoAndStop("soia3");
		}
	} else {
		_root.pianomenu.menucontestuale._x = piano[tile]._x+piano[tile]._width/2+2;
		_root.pianomenu.menucontestuale._y = piano[tile]._y+22;
	}
	if ((tipo == "allevamento") && ((tile == "tile13") || (tile == "tile6"))) {
		_root.pianomenu.menucontestuale.gotoAndStop("allevamento4");
	}
	if ((tipo == "soia" || tipo == "attesasoia") && ((tile == "tile13") || (tile == "tile6"))) {
		_root.pianomenu.menucontestuale.gotoAndStop("soia4");
	}
	//piano[tile].menu.gotoAndStop(tipo); 
}
//********************************
//FUNZIONI ESTERNALITA AMBIENTALI
//********************************
function creagrano(tile) {
	if (tile.tipo == "vuoto") {
		tile.tipo = "attesagrano";
		tile.gotoAndStop("granovuoto");
		_root.campidigrano++;
	}
}
//famecittà
function famecitta() {
	//if(_root.campidigrano<2)
	//{
	//le provviste sono scarse
	//perciò vedo se ci sono dei campi da coltivare a grano
	//fra quelli vicini alla citta
	creagrano(_root.piano.tile9);
	creagrano(_root.piano.tile12);
	creagrano(_root.piano.tile15);
	creagrano(_root.piano.tile18);
	//}
	//rivitalizzo la citta
	if ((_root.campidigrano>0) && (_root.piano.citta1._currentframe != 1)) {
		_root.piano.citta1.play();
		_root.piano.citta2.play();
	}
	if (_root.campidigrano>2) {
		_root.statocitta = _root.STR_FELICE;
	} else if (_root.campidigrano == 2) {
		_root.statocitta = _root.STR_SCARSO;
	} else if (_root.campidigrano == 1) {
		_root.statocitta = _root.STR_ALLARMANTE;
	} else if ((_root.campidigrano == 0) && (_root.piano.citta1._currentframe == 1)) {
		_root.statocitta = _root.STR_DISABITATA;
		_root.piano.citta1.gotoAndPlay(2);
		_root.piano.citta2.gotoAndPlay(2);
	}
}
//surriscaldamento
function surriscaldamento() {
	//ogni volta che abbatto una foresta innalzo il livello dell'acqua
	//conto le foreste
	f = 0;
	for (i=1; i<TOT_TILES; i++) {
		if (piano["tile"+i].tipo == "foresta") {
			f++;
		}
	}
	//tre livelli verbali
	if (f>=_root.FORESTE_MAX) {
		riscaldamento = 0;
	} else if (f>=_root.FORESTE_MEDIE) {
		riscaldamento = 2;
	} else if (f>=_root.FORESTE_POCHE) {
		riscaldamento = 3;
	} else if (f<_root.FORESTE_POCHE) {
		riscaldamento = 4;
	}
	_root.livello += riscaldamento;
	//l'acqua va dall'1 al 10	
	if ((_root.livello>0) && (_root.livello<=1000)) {
		frameoceano = Math.round(_root.livello/100);
		piano.mare.oceano.gotoAndStop(frameoceano);
		_root.calottepolari = 100-(frameoceano*10);
		_root.calottepolari += "%";
	}
}
//desertificazione
function desertificazione() {
	//cambia valori a seconda della coltivazione
	for (i=1; i<TOT_TILES; i++) {
		if (piano["tile"+i].tipo == "allevamento") {
			//la fertilità diminuisce in base all'intensità dell'allevamento
			piano["tile"+i].fertilita -= piano["tile"+i].intensita-1;
			//TEST
		} else if (piano["tile"+i].tipo == "soia") {
			//per la soia dimimnuisce di 1
			//piano["tile"+i].fertilita--;
		} else if (piano["tile"+i].tipo == "vuoto") {
			//se vuoto aumenta
			if (piano["tile"+i].fertilita<_root.FERTILITA_MAX) {
				piano["tile"+i].fertilita += 2;
			}
		}
		///cambia frame 
		/*
		0 20
		20 40
		40 60
		60 80
		80 100
		100 120
		120 140
		140 180
		*/
		f = piano["tile"+i].fertilita;
		if (f>120) {
			piano["tile"+i].terreno.gotoAndStop(1);
		} else if ((f>100) && (f<120)) {
			piano["tile"+i].terreno.gotoAndStop(2);
		} else if ((f>80) && (f<100)) {
			piano["tile"+i].terreno.gotoAndStop(3);
		} else if ((f>60) && (f<80)) {
			piano["tile"+i].terreno.gotoAndStop(4);
		} else if ((f>40) && (f<60)) {
			piano["tile"+i].terreno.gotoAndStop(5);
		} else if ((f>20) && (f<40)) {
			piano["tile"+i].terreno.gotoAndStop(6);
		} else if ((f>0) && (f<20)) {
			piano["tile"+i].terreno.gotoAndStop(7);
		} else if (f<=0) {
			if (piano["tile"+i].tipo != "deserto") {
				//se è una coltivazione il tile diventa vuoto
				//altrimenti rimangono gli scheletrini
				if (piano["tile"+i].tipo != "allevamento") {
					piano["tile"+i].gotoAndStop("vuoto");
				}
				//se nel menu è ancora selezionato 
				if (tilecorrente == "tile"+i) {
					contextMenu("tile"+i, "deserto");
				}
				//_root.menu.gotoAndStop("deserto"); 
				piano["tile"+i].tipo = "deserto";
				piano["tile"+i].terreno.gotoAndStop(8);
				if (piano["tile"+i].vacca1._visible == true) {
					piano["tile"+i].vacca1.gotoAndStop("morta");
				}
				if (piano["tile"+i].vacca2._visible == true) {
					piano["tile"+i].vacca2.gotoAndStop("morta");
				}
				if (piano["tile"+i].vacca3._visible == true) {
					piano["tile"+i].vacca3.gotoAndStop("morta");
				}
			}
		}
	}
}
//corrompi il sindaco di san jose
function corrompisindaco() {
	_root.STR_CORRUZIONE = _root.STR_CORROTTO;
	_root.sindacocorrotto = true;
	spendi(COSTO_SINDACO, HLP_CORROMPISINDACO);
}
//crea allevamento
function creaallevamento() {
	//se è foresta abbatte e aspetta a cambiare
	if (piano[_root.tilecorrente].tipo == "foresta") {
		piano[_root.tilecorrente].nuovoutilizzo = "allevamento";
		piano[_root.tilecorrente].gotoAndPlay("abbattimento");
		startLoop("abbattimento", _root.tilecorrente);
		contextMenu(_root.tilecorrente, "forestaattesa");
		//_root.menu.gotoAndStop("forestaattesa");
		spendi(COSTO_PASCOLOFORESTA, VOCE_PASCOLOFORESTA);
		//dissenso ecologico
		_root.ecologisti += ECOLOGISTI_FORESTE;
		_root.noglobal += NOGLOBAL_FORESTE;
	} else if (piano[_root.tilecorrente].tipo == "villaggio") {
		piano[_root.tilecorrente].nuovoutilizzo = "allevamento";
		piano[_root.tilecorrente].gotoAndPlay("incendio");
		contextMenu(_root.tilecorrente, "villaggioattesa");
		spendi(COSTO_PASCOLOFORESTA, VOCE_PASCOLOVILLAGGIO);
		noglobal += NOGLOBAL_VILLAGGIO;
		startLoop("abbattimento", _root.tilecorrente);
		//_root.menu.gotoAndStop("villaggioattesa");
	} else {
		if ((piano[_root.tilecorrente].tipo == "grano") || (piano[_root.tilecorrente].tipo == "attesagrano")) {
			_root.campidigrano--;
		}
		piano[_root.tilecorrente].tipo = "allevamento";
		piano[_root.tilecorrente].gotoAndStop("allevamento");
		_root.fertilita = piano[_root.tilecorrente].fertilita-80;
		calcolafertilita();
		_root.menu.gotoAndStop("allevamento");
		//piano[_root.tilecorrente].menu.gotoAndStop("allevamento");
		contextMenu(_root.tilecorrente, "nulla");
		piano[_root.tilecorrente].selezione.gotoAndPlay("roll");
		spendi(COSTO_PASCOLO, VOCE_PASCOLO);
	}
	//contextMenu(_root.tilecorrente, "nulla");
}
//crea soia
function creasoia() {
	//se è foresta abbatte e aspetta a cambiare
	if (piano[_root.tilecorrente].tipo == "foresta") {
		startLoop("abbattimento", _root.tilecorrente);
		piano[_root.tilecorrente].nuovoutilizzo = "attesasoia";
		piano[_root.tilecorrente].gotoAndPlay("abbattimento");
		//piano[_root.tilecorrente].menu.gotoAndStop("forestaattesa");
		contextMenu(_root.tilecorrente, "forestaattesa");
		spendi(COSTO_SOIAFORESTA, VOCE_SOIAFORESTA);
		//dissenso ecologico
		ecologisti += ECOLOGISTI_FORESTE;
		noglobal += NOGLOBAL_FORESTE;
	} else if (piano[_root.tilecorrente].tipo == "villaggio") {
		startLoop("abbattimento", _root.tilecorrente);
		piano[_root.tilecorrente].nuovoutilizzo = "attesasoia";
		piano[_root.tilecorrente].gotoAndPlay("incendio");
		//piano[_root.tilecorrente].menu.gotoAndStop("villaggioattesa");
		contextMenu(_root.tilecorrente, "villaggioattesa");
		spendi(COSTO_SOIAFORESTA, VOCE_SOIAVILLAGGIO);
		noglobal += NOGLOBAL_VILLAGGIO;
	} else {
		if ((piano[_root.tilecorrente].tipo == "grano") || (piano[_root.tilecorrente].tipo == "attesagrano")) {
			_root.campidigrano--;
		}
		piano[_root.tilecorrente].tipo = "attesasoia";
		_root.menu.gotoAndStop("attesasoia");
		piano[_root.tilecorrente].gotoAndPlay("soiasemina");
		if (zona == "agricoltura") {
			startLoop("aratura", _root.tilecorrente);
		}
		//		piano[_root.tilecorrente].nuovoutilizzo="attesasoia"; 
		//piano[_root.tilecorrente].menu.gotoAndStop("soiavuoto");
		contextMenu(_root.tilecorrente, "nulla");
		piano[_root.tilecorrente].selezione.gotoAndPlay("roll");
		spendi(COSTO_SOIA, VOCE_SOIA);
	}
	//_root.menu.gotoAndStop("attesasoia");
}
//aumentavacche
function aumentavacche() {
	if (piano[_root.tilecorrente].intensita<3) {
		piano[_root.tilecorrente].intensita++;
	}
	nascitavacche(piano[_root.tilecorrente].intensita);
}
//diminuiscivacche
function diminuiscivacche() {
	if (piano[_root.tilecorrente].intensita>0) {
		piano[_root.tilecorrente].intensita--;
	}
	nascitavacche(piano[_root.tilecorrente].intensita);
}
//nascitavacche
function nascitavacche(numero) {
	if (numero == 0) {
		piano[_root.tilecorrente].vacca1._visible = false;
		piano[_root.tilecorrente].vacca2._visible = false;
		piano[_root.tilecorrente].vacca3._visible = false;
	}
	if (numero == 1) {
		if (piano[_root.tilecorrente].vacca1._visible == false) {
			piano[_root.tilecorrente].vacca1._visible = true;
			piano[_root.tilecorrente].vacca1.gotoAndPlay(1);
		}
		piano[_root.tilecorrente].vacca2._visible = false;
		piano[_root.tilecorrente].vacca3._visible = false;
	}
	if (numero == 2) {
		if (piano[_root.tilecorrente].vacca2._visible == false) {
			piano[_root.tilecorrente].vacca2._visible = true;
			piano[_root.tilecorrente].vacca2.gotoAndPlay(1);
		}
		piano[_root.tilecorrente].vacca3._visible = false;
	}
	if (numero == 3) {
		if (piano[_root.tilecorrente].vacca3._visible == false) {
			piano[_root.tilecorrente].vacca3._visible = true;
			piano[_root.tilecorrente].vacca3.gotoAndPlay(1);
		}
	}
}
//vendi terreno
function vendi() {
	if (piano[_root.tilecorrente].tipo="allevamento") {
		guadagna(COSTO_PASCOLO/2);
	} else {
		guadagna(COSTO_SOIA/2);
	}
	piano[_root.tilecorrente].gotoAndStop("vuoto");
	//_root.menu.gotoAndStop("vuoto");
	contextMenu(_root.tilecorrente, "nulla");
	piano[_root.tilecorrente].tipo = "vuoto";
}
function calcolafertilita() {
	if (piano[_root.tilecorrente].fertilita>100) {
		_root.fertilita = 100;
	} else {
		_root.fertilita = piano[_root.tilecorrente].fertilita;
	}
	_root.fertilita += "%";
}
///////////////////////////////////////////////////////////
//inizializzazione dei tiles
resetSelections();
for (i=1; i<TOT_TILES; i++) {
	piano["tile"+i].fertilita = FERTILITA_MAX;
	//funzione press
	piano["tile"+i].areaattiva.onPress = function() {
		if (this._parent.selezione._currentframe<=13) {
			//_root.resetSelections();
			//this._parent.menu._visible=true;
			//this._parent.menu.goto=true;
			this._parent.selezione.gotoAndPlay("on");
			//_root.select(this._parent._name, this._parent.tipo );
			nometile = this._parent._name;
			tipotile = this._parent.tipo;
			_root.tilecorrente = nometile;
			_root.tipotilecorrente = tipotile;
			calcolafertilita();
			//non è in abbattimento
			if ((piano[nometile].nuovoutilizzo == undefined)) {
				//se è grano è corrotto
				if ((tipotile != "grano" && tipotile != "attesagrano") || _root.sindacocorrotto == true) {
					contextMenu(nometile, tipotile);
				}
				//piano[nometile].menu.gotoAndStop(tipotile); 
			}
			_root.menu.gotoAndStop(tipotile);
		} else if ((this._parent.selezione._currentframe>13)) {
			_root.pianomenu.menucontestuale._visible = false;
			//this._parent.menu._visible=false;
			this._parent.selezione.gotoAndPlay("roll");
			_root.tilecorrente = "nessuno";
			_root.menu.gotoAndStop("nulla");
		}
		//riclicca --> deselect 
	};
	///funzione rollover
	piano["tile"+i].areaattiva.onRollOver = function() {
		if (_root.tilecorrente == this._parent._name) {
			//ovvero scompare il menu e rirolla
			this._parent.selezione.gotoAndPlay("roll");
		} else {
			_root.resetSelections();
			_root.tilecorrente = "nessuno";
		}
		if (this._parent.selezione._currentframe == 27) {
			this._parent.selezione.gotoAndPlay("roll");
			//_root.interfaccia=1;
		}
	};
	/*
	///funzione rollout
	piano["tile"+i].areaattiva.onDragOut = piano["tile"+i].areaattiva.onReleaseOutside = piano["tile"+i].areaattiva.onRollOut = function(){ 
	//_root.interfaccia=0;
	
	if(_root.interfaccia==0)	{
	this._parent.selezione.gotoAndStop("off");
	this._parent.menu._visible=false;
	}
	}*/
}
/*
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
////////////////////////////////ALLEVAMENTO////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
*/
inizializzavacche();
inizializzavacche();
for (i=1; i<MAX_VACCHE+1; i++) {
	allevamento["vacca"+i].presente = 0;
}
function nuovavacca() {
	if (vacche>=MAX_VACCHE) {
		trace("errore troppe vacche");
	} else {
		//c'e' spazio in ingrasso
		vacche++;
		//inserisci la nuova vacca in una casella a caso
		collocata = false;
		while (collocata == false) {
			//maniera ultradispendiosa per collocare le vacche
			temp = random(MAX_VACCHE)+1;
			if (allevamento["vacca"+temp].presente == 0) {
				allevamento["vacca"+temp].play();
				allevamento["vacca"+temp].presente = 1;
				allevamento["vacca"+temp].peso = PESO_INIZIALE;
				allevamento["vacca"+temp].bse = false;
				allevamento["vacca"+temp].malata = false;
				collocata = true;
			}
		}
		//carica valori
		//genera nome
		l = NOMI_VACCHE.length;
		allevamento["vacca"+temp].nome = NOMI_VACCHE[random(l)];
		allevamento["vacca"+temp].salute = STR_SALUTE_OK;
		//le vacche non sono tutte uguali ed ingrassano ad un ritmo diverso
		rand = random(3);
		if (rand == 0) {
			allevamento["vacca"+temp].appetito = INGRASSO_MENSILE1;
		} else if (rand == 1) {
			allevamento["vacca"+temp].appetito = INGRASSO_MENSILE2;
		} else if (rand == 2) {
			allevamento["vacca"+temp].appetito = INGRASSO_MENSILE3;
		}
	}
}
//gestione mensile delle vacche
function ingrassovacche() {
	for (i=1; i<MAX_VACCHE+1; i++) {
		//se esiste
		if (allevamento["vacca"+i].presente == 1) {
			//con ormoni ingrassano di un punto in più
			//se c'è cibo ingrassa
			if (mangime>0) {
				if (ormoni == true) {
					allevamento["vacca"+i].peso += allevamento["vacca"+i].appetito+BONUS_ORMONI;
				} else {
					allevamento["vacca"+i].peso += allevamento["vacca"+i].appetito;
				}
			}
			//senno dimagrisci 
			if (mangime<=0) {
				allevamento["vacca"+i].peso -= allevamento["vacca"+i].appetito;
				if (allevamento["vacca"+i].peso<PESO_MINIMO) {
					allevamento["vacca"+i].gotoAndPlay("morto");
				}
				//allevamento["vacca"+i].peso=PESO_INIZIALE; 
			}
			//cambia frame di ciccia 
			curr = allevamento["vacca"+i]._currentframe;
			//se è in fase ingrasso
			if ((curr>=12) && (curr<=27)) {
				///14 sono il numero di frame frames
				f = Math.round(((allevamento["vacca"+i].peso-PESO_INIZIALE)*14)/(PESO_FINALE-PESO_INIZIALE));
				if (allevamento["vacca"+i].peso>PESO_INIZIALE) {
					allevamento["vacca"+i].gotoAndStop(f+12);
				} else {
					allevamento["vacca"+i].gotoAndStop(12);
				}
				if (mangime>0) {
					mangime -= CIBO_MENSILE;
				} else {
					mangime = 0;
				}
				gestionecisterna();
			}
			if (allevamento["vacca"+i].peso>=PESO_FINALE) {
				//aumenta hamburger nel clip mucca
				allevamento["vacca"+i].play();
			}
		}
	}
	//aggiorno il pesocorrente
	pesocorrente = allevamento[vaccacorrente].peso;
}
function gestionecisterna() {
	//30 per la cronaca è il numero di frames della cisterna 
	//scarti industriali
	if (scarti == true) {
		allevamento.scarti.play();
	}
	f = Math.round((mangime*30)/MAX_MANGIME);
	allevamento.cist.gotoAndStop(f+1);
	if (f<=3) {
		allevamento.mangiatoia1.gotoAndStop(f+1);
		allevamento.mangiatoia2.gotoAndStop(f+1);
		allevamento.sirenacisterna.gotoAndPlay("on");
	} else {
		allevamento.sirenacisterna.gotoAndStop("off");
	}
}
function selezionavacca() {
	//nomeclip è la vacca corrente
	nomecorrente = STR_VACCA+" "+allevamento[vaccacorrente].nome;
	pesocorrente = allevamento[vaccacorrente].peso;
	salutecorrente = allevamento[vaccacorrente].salute;
	//dovrò aggiornare in caso di cambiamento
	menu.gotoAndStop("vacca");
}
function abbatti() {
	//cambia frame di ciccia
	f = allevamento[vaccacorrente]._currentframe;
	//se è in fase ingrasso cioè non durante un'animazione
	if ((f>=12) && (f<=27)) {
		//allevamento[vaccacorrente].presente==0;
		allevamento[vaccacorrente].lanciafiamme.play();
		allevamento[vaccacorrente].presente = 0;
		allevamento[vaccacorrente].peso = 0;
		allevamento[vaccacorrente].bse = false;
		allevamento[vaccacorrente].malata = false;
	}
	//else 
	//trace("errore: beep");
}
allevamento.tritacarne.onEnterFrame = function() {
	if ((this._currentframe == 1) && (_root.hamburgerdafare>0)) {
		//questi scaleranno
		//_root.hamburger+=3;
		//questi no
		_root.hamburgerfatti++;
		//questi sono quelli che mancano per le vacche macellate
		_root.hamburgerdafare -= 3;
		if (_root.hamburgerdafare<0) {
			_root.hamburgerdafare = 0;
		}
		//fa partire il primo ham libero 
		if (_root.allevamento.hamburger1._currentframe == _root.allevamento.hamburger1._totalframes) {
			_root.allevamento.hamburger1.play();
		} else if (_root.allevamento.hamburger2._currentframe == _root.allevamento.hamburger2._totalframes) {
			_root.allevamento.hamburger2.play();
		} else if (_root.allevamento.hamburger3._currentframe == _root.allevamento.hamburger3._totalframes) {
			_root.allevamento.hamburger3.play();
		} else if (_root.allevamento.hamburger4._currentframe == _root.allevamento.hamburger4._totalframes) {
			_root.allevamento.hamburger4.play();
		} else if (_root.allevamento.hamburger5._currentframe == _root.allevamento.hamburger5._totalframes) {
			_root.allevamento.hamburger5.play();
		} else if (_root.allevamento.hamburger6._currentframe == _root.allevamento.hamburger6._totalframes) {
			_root.allevamento.hamburger6.play();
		} else if (_root.allevamento.hamburger7._currentframe == _root.allevamento.hamburger7._totalframes) {
			_root.allevamento.hamburger7.play();
		} else if (_root.allevamento.hamburger8._currentframe == _root.allevamento.hamburger8._totalframes) {
			_root.allevamento.hamburger8.play();
		}
	}
};
//deseleziona vacche e tutto
function deselezionaall() {
	_root.allevamento.tastoscarti._visible = false;
	_root.allevamento.tastoormoni._visible = false;
	_root.allevamento.tastofarine._visible = false;
	for (i=1; i<MAX_VACCHE+1; i++) {
		allevamento["vacca"+i].selezione.gotoAndStop("off");
	}
	allevamento.cisterna.selezione.gotoAndStop("off");
	allevamento.macina.selezione.gotoAndStop("off");
	if (allevamento._visible == true) {
		_root.menu.gotoAndStop("nullaall");
	}
}
//gestione malattie per ogni vacca e per ogni periodo di tempo
function salutevacche() {
	//può diventare muccapazza o malata
	//più la sicurezza è alta più difficile che si ammali
	//RISCHIO_MALATTIA=500;
	sicurezza = RISCHIOMALATTIA-vacche;
	//trace("RISCHIO "+RISCHIO_MALATTIA);
	//trace("vacche "+vacche);
	if (scarti == true) {
		sicurezza -= RISCHIOSCARTI;
	}
	if (ormoni == true) {
		sicurezza -= RISCHIOORMONI;
	}
	//guarda se ci sono OGM 
	ogm = 0;
	for (t=1; t<TOT_TILES; t++) {
		if (piano["tile"+t].ogm == true) {
			ogm++;
		}
	}
	sicurezza -= ogm*RISCHIOOGM;
	if ((farineanimali == true) && (mangime>0)) {
		sicurezzabse = RISCHIOBSE-epidemia*MOLTIPLICATOREEPIDEMIA;
	} else {
		sicurezzabse = undefined;
	}
	epidemia = 0;
	//trace("sicurezza "+sicurezza);
	if (sicurezzabse<10) {
		sicurezzabse = 10;
	}
	if (sicurezza<10) {
		sicurezza = 10;
	}
	//destino in azione		 
	for (i=1; i<MAX_VACCHE+1; i++) {
		if ((allevamento["vacca"+i].presente == 1) && (allevamento["vacca"+i].bse == true)) {
			epidemia++;
		}
		if ((allevamento["vacca"+i].presente == 1) && (allevamento["vacca"+i].malata != true) && (allevamento["vacca"+i].bse != true)) {
			destino = random(sicurezza);
			//trace(destino);
			if (destino == 0) {
				allevamento["vacca"+i].malata = true;
				allevamento["vacca"+i].salute = STR_MALATA;
				allevamento["vacca"+i].testa.gotoAndPlay("malata");
			} else if (sicurezzabse != undefined) {
				destino = random(sicurezzabse);
				if (destino == 0) {
					allevamento["vacca"+i].bse = true;
					allevamento["vacca"+i].salute = STR_BSE;
					allevamento["vacca"+i].testa.gotoAndPlay("muccapazza");
					//epidemia++;
				}
			}
			//se ci sono in ballo farine animali 
		}
	}
}
function contavacche() {
	_root.vacche = 0;
	for (i=1; i<MAX_VACCHE+1; i++) {
		if (allevamento["vacca"+i].presente == 1) {
			_root.vacche++;
		}
	}
}
function allarmiallevamento() {
	allarmeallevamento = "";
	allarmemalattia = false;
	allarmebse = false;
	//controllo numero vacche
	if (vacche>=MAX_VACCHE-3) {
		allarmeallevamento += ALLARME_TROPPEVACCHE;
	}
	if (vacche<=0) {
		allarmeallevamento += ALLARME_NOVACCHE;
	}
	//mangime finito 
	if (mangime<200) {
		allarmeallevamento += ALLARME_MANGIMESCARSO;
	}
	//troppo mangime 
	if (mangime>=MAX_MANGIME) {
		allarmeallevamento += ALLARME_TROPPOMANGIME;
	}
	//controlla malattie e bse 
	for (i=1; i<MAX_VACCHE+1; i++) {
		if ((allevamento["vacca"+i].presente == 1) && (allevamento["vacca"+i].bse == true)) {
			allarmebse = true;
		}
		if ((allevamento["vacca"+i].presente == 1) && (allevamento["vacca"+i].malata == true)) {
			allarmemalattia = true;
		}
	}
	if (allarmemalattia) {
		allarmeallevamento += ALLARME_MALATTIA;
	}
	if (allarmebse) {
		allarmeallevamento += ALLARME_BSE;
	}
	return allarmeallevamento;
}
/*
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
////////////////////////////////RETAIL ////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
*/
inizializzafile();
inizializzalavoratori();
function inizializzalavoratori() {
	retail.linea1.attiva = false;
	retail.linea1.gotoAndStop("vuota");
	retail.linea2.attiva = false;
	retail.linea2.gotoAndStop("vuota");
	retail.linea3.attiva = false;
	retail.linea3.gotoAndStop("vuota");
	retail.cassa1.attiva = false;
	retail.cassa1.gotoAndStop("vuota");
	retail.cassa2.attiva = false;
	retail.cassa2.gotoAndStop("vuota");
	retail.cassa3.attiva = false;
	retail.cassa3.gotoAndStop("vuota");
}
function inizializzafile() {
	retail.fila1.clienti = -1;
	retail.fila2.clienti = -1;
	retail.fila3.clienti = -1;
	for (i=0; i<MAXCLIENTI; i++) {
		retail.fila1["c"+i]._visible = false;
		retail.fila2["c"+i]._visible = false;
		retail.fila3["c"+i]._visible = false;
	}
}
//crea clienti (settimanale)
function nuoviclienti(nuovi) {
	//cl=nuovi;
	//n1=n2=n3=0;
	fila1 = fila2=fila3=0;
	attive = new Array();
	if (retail.cassa1.attiva == true) {
		attive.push("fila1");
	}
	if (retail.cassa2.attiva == true) {
		attive.push("fila2");
	}
	if (retail.cassa3.attiva == true) {
		attive.push("fila3");
	}
	//se ce ne è almeno una attiva 
	if (nuovi>0 && attive.length>0) {
		meglio = attive[0];
		if ((_root[attive[1]] != undefined) && (_root.retail[attive[1]].clienti<_root.retail[meglio].clienti)) {
			meglio = attive[1];
		}
		if ((_root[attive[2]] != undefined) && (_root.retail[attive[2]].clienti<_root.retail[meglio].clienti)) {
			meglio = attive[2];
		}
		_root[meglio] += nuovi;
	}
	//setto le visibilita 
	for (i=1; i<=MAXCLIENTI; i++) {
		//è un nuovo arrivato
		if ((i>retail.fila1.clienti) && (i<=retail.fila1.clienti+fila1)) {
			//randomizzo i nuovi arrivati
			retail.fila1["c"+i].cliente.capelli.gotoAndStop(random(retail.fila1["c"+i].cliente.capelli._totalframes)+1);
			retail.fila1["c"+i].cliente.pelle.gotoAndStop(random(retail.fila1["c"+i].cliente.pelle._totalframes)+1);
			retail.fila1["c"+i].cliente.gambe.gotoAndStop(random(retail.fila1["c"+i].cliente.gambe._totalframes)+1);
			retail.fila1["c"+i].cliente.gambe.passi.gotoAndStop(1);
			retail.fila1["c"+i].cliente.corpo.gotoAndStop(random(retail.fila1["c"+i].cliente.corpo._totalframes)+1);
			retail.fila1["c"+i]._visible = true;
		}
		if (i>retail.fila1.clienti+fila1) {
			retail.fila1["c"+i]._visible = false;
		}
	}
	for (i=1; i<=MAXCLIENTI; i++) {
		//è un nuovo arrivato
		if ((i>retail.fila2.clienti) && (i<=retail.fila2.clienti+fila2)) {
			//randomizzo i nuovi arrivati
			retail.fila2["c"+i].cliente.capelli.gotoAndStop(random(retail.fila2["c"+i].cliente.capelli._totalframes)+1);
			retail.fila2["c"+i].cliente.pelle.gotoAndStop(random(retail.fila2["c"+i].cliente.pelle._totalframes)+1);
			retail.fila2["c"+i].cliente.gambe.gotoAndStop(random(retail.fila2["c"+i].cliente.gambe._totalframes)+1);
			retail.fila2["c"+i].cliente.gambe.passi.gotoAndStop(1);
			retail.fila2["c"+i].cliente.corpo.gotoAndStop(random(retail.fila2["c"+i].cliente.corpo._totalframes)+1);
			retail.fila2["c"+i]._visible = true;
		}
		if (i>retail.fila2.clienti+fila2) {
			retail.fila2["c"+i]._visible = false;
		}
	}
	for (i=1; i<=MAXCLIENTI; i++) {
		//è un nuovo arrivato
		if ((i>retail.fila3.clienti) && (i<=retail.fila3.clienti+fila3)) {
			//randomizzo i nuovi arrivati
			retail.fila3["c"+i].cliente.capelli.gotoAndStop(random(retail.fila3["c"+i].cliente.capelli._totalframes)+1);
			retail.fila3["c"+i].cliente.pelle.gotoAndStop(random(retail.fila3["c"+i].cliente.pelle._totalframes)+1);
			retail.fila3["c"+i].cliente.gambe.gotoAndStop(random(retail.fila3["c"+i].cliente.gambe._totalframes)+1);
			retail.fila3["c"+i].cliente.gambe.passi.gotoAndStop(1);
			retail.fila3["c"+i].cliente.corpo.gotoAndStop(random(retail.fila3["c"+i].cliente.corpo._totalframes)+1);
			retail.fila3["c"+i]._visible = true;
		}
		if (i>retail.fila3.clienti+fila3) {
			retail.fila3["c"+i]._visible = false;
		}
	}
	//li sommo ai clienti delle file
	if (retail.fila1.clienti+fila1<=MAXCLIENTI) {
		retail.fila1.clienti += fila1;
	} else {
		retail.fila1.clienti = MAXCLIENTI;
	}
	if (retail.fila2.clienti+fila2<=MAXCLIENTI) {
		retail.fila2.clienti += fila2;
	} else {
		retail.fila2.clienti = MAXCLIENTI;
	}
	if (retail.fila3.clienti+fila3<=MAXCLIENTI) {
		retail.fila3.clienti += fila3;
	} else {
		retail.fila3.clienti = MAXCLIENTI;
	}
}
//chiamata da ogni fila
function scorrifila() {
	panini--;
	this["ominoservito"+r].play();
	for (i=1; i<=this.clienti; i++) {
		//if(this["c"+i]._currentframe==1)
		//this["c"+i].gotoAndStop(1);
		if (this["c"+i]._visible == true) {
			this["c"+i].gotoAndPlay(1);
		} else {
			this["c"+i].gotoAndStop(1);
		}
	}
	if (this.clienti>0) {
		this.clienti--;
	}
	//	this["c"+this.clienti]._visible=false; 
}
//quando la fila ha effettuato lo scorrimento
function creacliente() {
	this.r++;
	if (this.r>=_root.CLIENTISERVITI) {
		this.r = 0;
		this["ominoservito"+_root.CLIENTISERVITI].removeMovieClip();
	}
	this.attachMovie("ominoservito", "ominoservito"+this.r, -_root.CLIENTISERVITI-this.r);
	this["ominoservito"+this.r]._x = this["c1"]._x-30;
	this["ominoservito"+this.r]._y = this["c1"]._y-15;
	this["ominoservito"+this.r].cliente.capelli.gotoAndStop(this.c1.cliente.capelli._currentframe);
	this["ominoservito"+this.r].cliente.pelle.gotoAndStop(this.c1.cliente.pelle._currentframe);
	this["ominoservito"+this.r].cliente.gambe.gotoAndStop(this.c1.cliente.gambe._currentframe);
	this["ominoservito"+this.r].cliente.corpo.gotoAndStop(this.c1.cliente.corpo._currentframe);
	this["ominoservito"+r].cliente.gambe.passi.gotoAndStop(1);
	guadagna(PREZZO_HAMBURGER);
	for (i=1; i<=this.clienti; i++) {
		this["c"+i].cliente.capelli.gotoAndStop(this["c"+(i+1)].cliente.capelli._currentframe);
		this["c"+i].cliente.pelle.gotoAndStop(this["c"+(i+1)].cliente.pelle._currentframe);
		this["c"+i].cliente.gambe.gotoAndStop(this["c"+(i+1)].cliente.gambe._currentframe);
		this["c"+i].cliente.corpo.gotoAndStop(this["c"+(i+1)].cliente.corpo._currentframe);
	}
}
function muovipostazioni() {
	for (l=1; l<=3; l++) {
		if (_root.hamburger>0) {
			if (retail["linea"+l].attiva == true) {
				//la motivazione del dipendente va da 1 a 3
				//meno è motivato più possibilità ci sono che salti il giro
				//se non capita zero su motivazione * costante
				if (random(_root.retail["linea"+l].motivazione*_root.MOLTIPLICATORE_MOTIVAZIONE) != 0) {
					retail["linea"+l].gotoAndPlay(1);
					_root.hamburger--;
					_root.panini++;
				} else {
					retail["linea"+l].omino.braccia.gotoAndStop("fermo");
					retail["linea"+l].omino.faccia.bocca.gotoAndPlay("sbadiglio");
				}
			}
		}
	}
}
function aggiornafrigo() {
	decine = Math.floor(_root.hamburger/10);
	unita = _root.hamburger-decine*10;
	for (i=1; i<=4; i++) {
		if (decine == i-1) {
			retail.frigo["ham"+i].gotoAndStop(unita+1);
		} else if (decine>=i) {
			retail.frigo["ham"+i].gotoAndStop(11);
		} else if (decine<i) {
			retail.frigo["ham"+i].gotoAndStop(1);
		}
	}
}
function aggiornapanini() {
	if (panini<=9) {
		retail.scivolopanini.gotoAndStop(panini-1);
	}
}
function resetretail() {
	retail.linea1.selezione.gotoAndStop("off");
	retail.linea2.selezione.gotoAndStop("off");
	retail.linea3.selezione.gotoAndStop("off");
	retail.cassa1.selezione.gotoAndStop("off");
	retail.cassa2.selezione.gotoAndStop("off");
	retail.cassa3.selezione.gotoAndStop("off");
	retail.manager.selezione.gotoAndStop("off");
	retail.manager.tastoinfo._visible = false;
	pianomenu.menulavoratore._visible = false;
	_root.menu.gotoAndStop("nullaretail");
}
function assumi() {
	resetretail();
	_root.menu.gotoAndStop("dipendente");
	_root.str_motivazione = eval("_root.STR_MOT"+MAX_MOTIVAZIONE);
	_root.retail[postazione].spilla = false;
	_root.retail[postazione].mobbing = false;
	_root.retail[postazione].attiva = true;
	_root.retail[postazione].gotoAndStop("inizio");
	_root.nohelp();
	_root.retail[postazione].motivazione = MAX_MOTIVAZIONE;
}
function licenzia() {
	resetretail();
	sindacati += SINDACATI_LICENZIAMENTO;
	_root.retail["fila"+postazione.charAt(5)].clienti = -1;
	_root.retail[postazione].attiva = false;
	_root.retail[postazione].gotoAndStop("vuota");
	_root.nohelp();
}
function controllaretail() {
	allarmeretail = "";
	num = 0;
	som = 0;
	//la motivazione dei lavoratori è bassa?
	if (retail.linea1.attiva == true) {
		num++;
		som += retail.linea1.motivazione;
	}
	if (retail.linea2.attiva == true) {
		num++;
		som += retail.linea2.motivazione;
	}
	if (retail.linea3.attiva == true) {
		num++;
		som += retail.linea3.motivazione;
	}
	if (retail.cassa1.attiva == true) {
		num++;
		som += retail.cassa1.motivazione;
	}
	if (retail.cassa2.attiva == true) {
		num++;
		som += retail.cassa2.motivazione;
	}
	if (retail.cassa3.attiva == true) {
		num++;
		som += retail.cassa3.motivazione;
	}
	if (num>2 && som/num<2.5) {
		allarmeretail = ALLARME_MOTIVAZIONE;
	}
	//non ci sono hamburger 
	if (hamburger<3) {
		allarmeretail += ALLARME_MACELLAZIONE;
	} else if (hamburger>MAX_HAMBURGER-10) {
		allarmeretail += ALLARME_FRIGO;
	}
	//c'è la fila 
	if (attive.length<3 && ((retail.fila1.clienti>=MAXCLIENTI-1) || (retail.fila2.clienti>=MAXCLIENTI-1) || (retail.fila3.clienti>=MAXCLIENTI-1))) {
		allarmeretail += ALLARME_FILA;
		if (panini<=2) {
			allarmeretail += ALLARME_GRILLMEN;
		} else {
			allarmeretail += ALLARME_CASSE;
		}
	}
	return allarmeretail;
}
function premia() {
	_root.retail[postazione].spilla = true;
	_root.pianomenu.menulavoratore.spilla._visible = false;
	if (random(RANDOM_SPILLA) == 0) {
		_root.retail[postazione].motivazione = MAX_MOTIVAZIONE;
	}
}
function mobbizza() {
	sindacati += SINDACATI_MOBBING;
	_root.retail[postazione].mobbing = true;
	_root.pianomenu.menulavoratore.mobbing._visible = false;
	if (random(RANDOM_MOBBING) == 0) {
		_root.retail[postazione].motivazione = MAX_MOTIVAZIONE;
	}
}
/*
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// BRAND ////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
*/
function resetbrand() {
	brand.pubblicita.gotoAndStop("off");
	brand.pr.gotoAndStop("off");
	brand.cda.gotoAndStop("off");
	brand.tastipubblicita._visible = false;
	brand.tasticda._visible = false;
	brand.tastipr._visible = false;
	_root.menu.gotoAndStop("nullabrand");
}
/*
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// INTERFACCIA///////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
*/
IDfinestra = 0;
function nuovaFinestra(titolo, txt, img, tipo) {
	//controllo se è aperta
	aperta = false;
	for (i=1; i<=IDfinestra && aperta == false; i++) {
		if (_root.pianofinestre[i].titolo.text != titolo) {
			aperta = false;
		} else {
			aperta = i;
		}
	}
	//se non aperta apro
	if (aperta == false) {
		IDfinestra++;
		_root.pianofinestre.attachMovie("finestra", IDfinestra, IDfinestra, {_x:ROOT_X/2, _y:ROOT_Y/2});
		_root.pianofinestre[IDfinestra].corpo.onPress = function() {
			this._parent.swapDepths(_root.pianofinestre.getNextHighestDepth()-1);
		};
		_root.pianofinestre[IDfinestra].barra.onPress = function() {
			this._parent.swapDepths(_root.pianofinestre.getNextHighestDepth()-1);
			startDrag(this._parent, false, this._parent._width/2, this._parent._height/2, 665-this._parent._width/2, 380+this._parent._height/2-30);
		};
		_root.pianofinestre[IDfinestra].barra.onRelease = function() {
			stopDrag();
		};
		_root.pianofinestre[IDfinestra].xbutton.onRelease = function() {
			removeMovieClip(this._parent);
		};
		_root.pianofinestre[IDfinestra].titolo.text = titolo;
		_root.pianofinestre[IDfinestra].testo.text = txt;
		_root.pianofinestre[IDfinestra].img.gotoAndStop(img);
		//se di messaggio
		if ((tipo == undefined) || (tipo == 1)) {
			_root.pianofinestre[IDfinestra].gotoAndStop("statica");
		} else {
			if ((tipo == 2) || (tipo == 4)) {
				_root.pianofinestre[IDfinestra].gotoAndStop("conferma");
			}
			if ((tipo == 3) || (tipo == 5)) {
				_root.pianofinestre[IDfinestra].gotoAndStop("annulla");
			}
			_root.pianofinestre[IDfinestra].tasto.onRelease = function() {
				if (tipo == 2) {
					_root.brand.tastipr[img].gotoAndStop("on");
					_root.brand[img] = true;
					removeMovieClip(this._parent);
				}
				if (tipo == 3) {
					_root.brand.tastipr[img].gotoAndStop("off");
					_root.brand[img] = false;
					removeMovieClip(this._parent);
				}
				if (tipo == 4) {
					_root.brand.tastipubblicita[img].gotoAndStop("on");
					_root.brand[img] = true;
					removeMovieClip(this._parent);
				}
				if (tipo == 5) {
					_root.brand.tastipubblicita[img].gotoAndStop("off");
					_root.brand[img] = false;
					removeMovieClip(this._parent);
				}
			};
		}
		//se interattiva ok/cancel 
	} else {
		//_root.pianofinestre[aperta].titolo.text=titolo;
		_root.pianofinestre[aperta].testo.text = txt;
	}
	// se aperta aggiorno il testo nel caso non sia una costante 
}
/////////////////////////////////
function spendi(somma, voce) {
	if (_root.soldi>=somma) {
		spiaSoldi.gotoAndPlay("verde");
	} else {
		spiaSoldi.gotoAndPlay("rosso");
	}
	_root.soldi -= somma;
	_root.uscite += somma;
	if (voce != undefined) {
		_root.bilancio += voce+": "+somma+"$\n";
	}
}
function guadagna(somma) {
	_root.soldi += somma;
	_root.entrate += somma;
}
function speseMensili() {
	//spese ogm
	q = 0;
	p = 0;
	s = 0;
	for (i=1; i<TOT_TILES; i++) {
		if (piano["tile"+i].tipo == "allevamento") {
			p++;
		}
		if (piano["tile"+i].tipo == "soia") {
			s++;
		}
		//ogm 
		if (piano["tile"+i].ogm == true) {
			q++;
		}
	}
	if (q>0) {
		spendi(COSTO_OGM*q, VOCE_OGM);
	}
	if (p>0) {
		spendi(COSTO_PASCOLO_MESE*p, VOCE_PASCOLO_MANUTENZIONE);
	}
	if (s>0) {
		spendi(COSTO_SOIA_MESE*s, VOCE_SOIA_MANUTENZIONE);
	}
	//spese pr 
	if (brand.alimentarista) {
		spendi(COSTO_ALIMENTARISTA, ALIMENTARISTA_TITOLO);
	}
	if (brand.politico) {
		spendi(COSTO_POLITICO, POLITICO_TITOLO);
	}
	if (brand.climatologo) {
		spendi(COSTO_CLIMATOLOGO, CLIMATOLOGO_TITOLO);
	}
	if (brand.ispettore) {
		spendi(COSTO_ISPETTORE, ISPETTORE_TITOLO);
	}
	if (brand.topolino) {
		spendi(COSTO_TOPOLINO, TOPOLINO_TITOLO);
	}
	if (brand.bambini) {
		spendi(COSTO_BAMBINI, BAMBINI_TITOLO);
	}
	if (brand.alimentazione) {
		spendi(COSTO_ALIMENTAZIONE, ALIMENTAZIONE_TITOLO);
	}
	if (brand.terzomondo) {
		spendi(COSTO_TERZOMONDO, TERZOMONDO_TITOLO);
	}
	//salari 
	q = 0;
	if (retail.cassa1.attiva) {
		q++;
	}
	if (retail.cassa2.attiva) {
		q++;
	}
	if (retail.cassa3.attiva) {
		q++;
	}
	if (retail.linea1.attiva) {
		q++;
	}
	if (retail.linea2.attiva) {
		q++;
	}
	if (retail.linea3.attiva) {
		q++;
	}
	spendi(COSTO_CREW*q, VOCE_STIPENDI);
	if (ormoni == true) {
		spendi(COSTO_ORMONI, VOCE_ORMONI);
	}
}
//////////////////////////
function calcolaDissenso() {
	/*///////////////////////////////////////////
	il dissenso è percentuale su queste categorie
	ecologisti
	noglobal
	consumatori
	sindacati
	obesi
	///////////////////////////////////////////*/
	for (i=1; i<TOT_TILES; i++) {
		if (piano["tile"+i].fertilita<_root.FERTILITA_ALLARME) {
			ecologisti += ECOLOGISTI_DESERTIFICAZIONE;
		}
		if (piano["tile"+i].ogm == true) {
			consumatori += CONSUMATORI_OGM;
		}
	}
	//if(statocitta==STR_DISABITATA)
	//noglobal+=NOGLOBAL_CITTA;
	if (statocitta == STR_DISABITATA) {
		noglobal += NOGLOBAL_CITTA*3;
	} else if (statocitta == STR_ALLARMANTE) {
		noglobal += NOGLOBAL_CITTA*2;
	} else if (statocitta == STR_SCARSO) {
		noglobal += NOGLOBAL_CITTA;
	}
	if (brand.bambini) {
		noglobal += NOGLOBAL_PUBBLICITA;
	}
	//gli obesi iniziano ad essere un problema se ci sono troppi clienti 
	if (affluenza>=2) {
		obesi += OBESI_CRESCITA;
	}
	if (affluenza<2) {
		obesi -= OBESI_DECRESCITA;
	}
	//contromisure pr 
	if (brand.climatologo) {
		ecologisti -= CLIMATOLOGO_EFFICACIA;
	}
	if (brand.politico) {
		noglobal -= POLITICO_EFFICACIA;
		sindacati -= POLITICO_EFFICACIA;
	}
	////////////////\\\\\\\\\\\\\\\\\\\ 
	//AGGIUNGERE ALTRI EFFETTI POSITIVI
	/////////////////\\\\\\\\\\\\\\\\\\\
	if (brand.ispettore) {
		consumatori -= ISPETTORE_EFFICACIA;
	}
	if (brand.terzomondo) {
		noglobal -= TERZOMONDO_EFFICACIA;
	}
	if (brand.alimentazione) {
		obesi -= ALIMENTAZIONE_EFFICACIA;
	}
	//il dissenso dei sindacati 
	//è fatto di soli eventi che non si devono ripetere troppo spesso
	//quindi scala automaticamente
	sindacati -= SINDACATI_DECRESCITA;
	if (sindacati<0) {
		sindacati = 0;
	} else if (sindacati<20) {
		sindacatiProtesta = false;
	} else if (sindacati>50 && sindacati<100) {
		//avverti se non l'hai gia fatto
		if (!sindacatiProtesta) {
			nuovaFinestra(SINDACATI, SINDACATI_ALLARME, "sindacati");
			_root.suonoAllarme.start();
		}
		sindacatiProtesta = true;
	} else if (sindacati>=100) {
		sindacati = 19;
		nuovaFinestra(SINDACATI, SINDACATI_PROTESTA, "sindacati");
		_root.suonoAllarme.start();
		//incazzati
		sindacatiPicchetto = SINDACATI_PICCHETTO;
	}
	//se sotto il livello di guardia l'allarme rientra 
	if (obesi<0) {
		obesi = 0;
	} else if (obesi<20) {
		obesiProtesta = false;
	} else if (obesi>50 && obesi<100) {
		//avverti se non l'hai gia fatto
		if (!obesiProtesta) {
			nuovaFinestra(OBESI, OBESI_ALLARME, "obesi");
			_root.suonoAllarme.start();
		}
		obesiProtesta = true;
	} else if (obesi>=100) {
		obesi = 0;
		nuovaFinestra(OBESI, OBESI_PROTESTA+"\n"+VOCE_OBESI_MULTA+": "+OBESI_MULTA, "obesi");
		_root.suonoAllarme.start();
		//incazzati
		spendi(OBESI_MULTA, VOCE_OBESI_MULTA);
	}
	//se sotto il livello di guardia l'allarme rientra 
	if (ecologisti<0) {
		ecologisti = 0;
	} else if (ecologisti<20) {
		ecologistiProtesta = false;
	} else if (ecologisti>50 && ecologisti<100) {
		//avverti se non l'hai gia fatto
		if (!ecologistiProtesta) {
			nuovaFinestra(ECOLOGISTI, ECOLOGISTI_ALLARME, "ecologisti");
			_root.suonoAllarme.start();
		}
		ecologistiProtesta = true;
	} else if (ecologisti>=100) {
		ecologisti = 19;
		nuovaFinestra(ECOLOGISTI, ECOLOGISTI_PROTESTA, "ecologisti");
		_root.suonoAllarme.start();
		//incazzati
		ecologistiBoicott = ECOLOGISTI_BOICOTT;
	}
	//se sotto il livello di guardia l'allarme rientra 
	if (noglobal<0) {
		noglobal = 0;
	} else if (noglobal<20) {
		noglobalProtesta = false;
	} else if (noglobal>50 && noglobal<100) {
		//avverti se non l'hai gia fatto
		if (!noglobalProtesta) {
			nuovaFinestra(NOGLOBAL, NOGLOBAL_ALLARME, "noglobal");
			_root.suonoAllarme.start();
		}
		noglobalProtesta = true;
	} else if (noglobal>=100) {
		noglobal = 10;
		nuovaFinestra(NOGLOBAL, NOGLOBAL_PROTESTA, "noglobal");
		_root.suonoAllarme.start();
		//incazzati
		noglobalBoicott = NOGLOBAL_BOICOTT;
	}
	//se sotto il livello di guardia l'allarme rientra 
	if (consumatori<0) {
		consumatori = 0;
	} else if (consumatori<20) {
		consumatoriProtesta = false;
	} else if (consumatori>50 && consumatori<100) {
		//avverti se non l'hai gia fatto
		if (!consumatoriProtesta) {
			nuovaFinestra(CONSUMATORI, CONSUMATORI_ALLARME, "consumatori");
			_root.suonoAllarme.start();
		}
		consumatoriProtesta = true;
	} else if (consumatori>=100) {
		consumatori = 0;
		nuovaFinestra(CONSUMATORI, CONSUMATORI_PROTESTA+"\n"+VOCE_CONSUMATORI_MULTA+": "+CONSUMATORI_MULTA, "consumatori");
		_root.suonoAllarme.start();
		//incazzati
		spendi(CONSUMATORI_MULTA, VOCE_CONSUMATORI_MULTA);
	}
	//se sotto il livello di guardia l'allarme rientra 
	if (consumatori<0) {
		consumatori = 0;
	}
}
///////////////////////////
function calcolaAffluenza() {
	affluenza = 1;
	if (brand.topolino) {
		affluenza += 2;
	}
	if (brand.bambini) {
		affluenza += 1;
	}
	if (brand.alimentazione) {
		affluenza += 1;
	}
	if (brand.terzomondo) {
		affluenza += 1;
	}
	//boicottaggi in corso 
	if (sindacatiPicchetto>0) {
		affluenza = 0;
	}
	if (noglobalBoicott>0 && affluenza>0) {
		affluenza--;
	}
	if (ecologistiBoicott>0 && affluenza>0) {
		affluenza--;
	}
}
///////////////////////CDA
//statistiche dall'anno tot alla fine
function disegnaStat() {
	for (i=0, maxy=0, miny=0; i<stat.length; i++) {
		if (stat[i]>maxy) {
			maxy = stat[i];
		}
		if (stat[i]<miny) {
			miny = stat[i];
		}
	}
	with (_root.pianofinestre.finestra_stat.piano) {
		//piano delle statistiche
		//_root.PIANO_X
		//_root.PIANO_Y
		ux = (_root.PIANO_X-_root.CORNICE)/_root.stat.length;
		uy = _root.PIANO_Y/(_root.maxy+Math.abs(_root.miny));
		zero = _root.miny*uy;
		_root.pianofinestre.finestra_stat.piano.attachMovie("piano", "grafico", 1, {_x:0, _y:0});
		_root.pianofinestre.finestra_stat.piano.createEmptyMovieClip("grafico", -10);
		grafico.lineStyle(3, _root.COL_ASSI, 100);
		//asse x
		grafico.moveTo(0, zero);
		grafico.lineTo(_root.ASSE_X-_root.CORNICE, zero);
		grafico.attachMovie("freccia_y", "freccia_y", 200, {_x:_root.ASSE_X-_root.CORNICE, _y:zero});
		//asse y
		grafico.moveTo(0, 0);
		grafico.lineTo(0, -_root.ASSE_Y+_root.CORNICE);
		grafico.attachMovie("freccia_x", "freccia_x", 201, {_x:0, _y:-_root.ASSE_Y+_root.CORNICE});
		if (_root.periodo == 0) {
			grafico.moveTo(0, -(_root.SOLDI_INIZIALI*uy)+zero);
		}
		for (i=0; i<stat.length; i++) {
			x = i*ux;
			y = -(stat[i]*uy)+zero;
			grafico.lineStyle(5, _root.COL_LINEA, 100);
			grafico.lineTo(x, y);
			grafico.attachMovie("punto", "punto"+i, i+1000, {_x:x, _y:y});
			grafico["punto"+i].i = i;
			grafico["punto"+i].onRollOver = function() {
				this.gotoAndStop("roll");
				_root.help(_root.STR_PUNTO);
			};
			grafico["punto"+i].onRollOut = function() {
				this.gotoAndStop(1);
				_root.nohelp();
			};
			//i primi due mesi non li considero
			if (i>1) {
				grafico["punto"+i].onPress = function() {
					_root.nuovaFinestra(_root.STR_ARCHIVIO, _root.bilanci[this.i], "cda");
				};
			} else {
				grafico["punto"+i].onPress = function() {
					_root.nuovaFinestra(_root.STR_ARCHIVIO, _root.STR_INIZIO_ATTIVITA+"\n", "cda");
				};
			}
			//linee
			//metto la data ogni anno
			if (i%12 == 0) {
				grafico.createTextField("mytext"+i, i+10000, x, zero-15, 30, 20);
				grafico["mytext"+i].text = _root.periodo+_root.YEAR+i/12;
				grafico["mytext"+i].setTextFormat(_root.myformat);
			}
			if (i != 0) {
				grafico.lineStyle(1, _root.COL_RIGHE, 100);
				grafico.moveTo(x, y);
				grafico.lineTo(x, zero);
				grafico.moveTo(x, y);
			}
		}
	}
}
//voglio che degli eventi facciano partire dei loop
//che non si sovrappongono
function startLoop(linkage, id) {
	loop.stop(linkage);
	loop = new Sound();
	loop.attachSound(linkage);
	loop.start(0, 10);
	//creo una variabile a cui associo il tile che ha generato l'ultimo suono di quel tipo
	_root["ultimo"+linkage] = id;
}
function stopLoop(linkage, id) {
	if (_root["ultimo"+linkage] == id) {
		loop.stop(linkage);
	}
}
function gameOver() {
	if (!finestraGameOver._visible) {
		//fermo il tempo
		stopAllSounds();
		pausa();
		finestraGameOver._visible = true;
		finestraGameOver.play();
		_global.zona = "gameover";
		_root.loopAmbiente.stop();
		//faccio comparire la finestra
		//_root.suonoGameOver.start();
	}
}



20


