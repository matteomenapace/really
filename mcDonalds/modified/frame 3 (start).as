stopAllSounds();
//variabili merci///////////////////////////////
SOLDI_INIZIALI = 50000;
soldi = SOLDI_INIZIALI;
soia = 2000;
//già mangime
hamburger = 100;
//nel negozio
hamburgerfatti = 50;
hamburgerdafare = 0;
panini = 0;
affluenza = 1;
allevamento_tutorial = true;
retail_tutorial = true;
brand_tutorial = true;
entrate = 0;
uscite = 0;
MAX_HAMBURGER = 500;
//costanti agricole///////////////////////////////
vacche = 0;
soia = 0;
RENDITA_SOIA = 200;
//kg che rende un tile di soia
FERTILITA_MAX = 180;
//scende da 1 a 3 al mese
DIVISORE_FERTILITA = 2;
//fertilita da 0 a 180 / divisore
FERTILITA_ALLARME = 50;
//gli ecologisti iniziano ad accorgersene
MOLTIPLICATORE_OGM = 1.4;
MOLTIPLICATORE_SCARTI = 1.2;
//in 5 anni di allevamento è deserto
FORESTE_MAX = 7;
FORESTE_MEDIE = 5;
FORESTE_POCHE = 3;
livello = 0;
riscaldamento = 0;
calottepolari = 100;
sindacocorrotto = false;
campidigrano = 4;
vacchefuture = 0;
soiafutura = 0;
//costanti costi///////////////////////////////
COSTO_TERRENO = 100;
COSTO_FORESTA = 60;
//costanti ingrasso
VACCHE_INIZIALI = 3;
MAX_VACCHE = 20;
PESO_INIZIALE = 500;
PESO_FINALE = 1000;
INGRASSO_MENSILE1 = 40;
INGRASSO_MENSILE2 = 50;
INGRASSO_MENSILE3 = 60;
BONUS_ORMONI = 60;
PESO_MINIMO = 300;
//poi muore
BONUS_FARINE = 30;
HAMBURGER_VACCA = 30;
CIBO_MENSILE = 30;
MAX_MANGIME = 3000;
///////////////////////////////////////
//rischio ovvero ogni settimana si sorteggia
//se si ammala una vacca
RISCHIOMALATTIA = 400;
//rischio iniziale cioè 1 su tot
//
RISCHIOSCARTI = 80;
RISCHIOORMONI = 80;
RISCHIOOGM = 10;
//unitario per campi GM
MOLTIPLICATOREEPIDEMIA = 10;
RISCHIOBSE = 200;
_root.mangime = 1000;
TOT_TILES = 20+1;
//variabili temporali///////////////////////////
YEAR = 2000;
week = 1;
//giorno iniziale
month = 0;
//mese iniziale
year = YEAR;
//anno iniziale
season = STR_WINTER;
//stagione iniziale
TIME = 1000;
//intervallo iniziale (variabile)
TIMESTEP = 100;
//di quanto cambia quando cambia l'intervallo
TIMEMIN = 300;
//intervallo minimo
TIMEMAX = 2000;
//intervallo massimo
CLIENTISERVITI = 15;
MAXCLIENTI = 8;
CONSUMATORI_MULTA = 6000;
OBESI_MULTA = 9000;
//costanti interfaccia
IDfinestra = 99999;
ROOT_X = 660;
ROOT_Y = 410;
//piano delle statistiche
ASSE_X = 400;
ASSE_Y = 200;
COL_ASSI = "0xBB674A";
COL_LINEA = "0x6F0000";
COL_RIGHE = "0xE3C2B7";
PIANO_X = 400;
PIANO_Y = 170;
CORNICE = 20;
//massimo degli anni disegnati nel grafico
MAX_YEAR = 5;
//anno di partenza per disegnare le stat
periodo = 0;
//numero anni assoluti
absyear = 0;
//formato del testo
myformat = new TextFormat();
myformat.color = 0xff0000;
myformat.font = "Arial";
myformat.size = 10;
tile = "tile1";
//PREZZI
//una tantum
COSTO_SOIA = 10000;
COSTO_PASCOLO = 5000;
COSTO_SINDACO = 10000;
COSTO_SOIAFORESTA = 8000;
COSTO_PASCOLOFORESTA = 3000;
//mensili
COSTO_SOIA_MESE = 150;
COSTO_PASCOLO_MESE = 150;
COSTO_OGM = 20;
COSTO_ORMONI = 10;
COSTO_CREW = 400;
COSTO_ALIMENTARISTA = 200;
COSTO_POLITICO = 300;
COSTO_CLIMATOLOGO = 200;
COSTO_ISPETTORE = 200;
COSTO_TOPOLINO = 900;
COSTO_BAMBINI = 500;
COSTO_ALIMENTAZIONE = 600;
COSTO_TERZOMONDO = 600;
//prezzo hamburger
PREZZO_HAMBURGER = 600;
//tre livelli?
MAX_MOTIVAZIONE = 4;
//uno su x va a segno
RANDOM_SPILLA = 3;
//uno su x va a segno
RANDOM_MOBBING = 3;
//se capita da 1 a sei diminuisce la motivazione del lavoratore
//ogni mese
SFIDUCIA = 30;
//efficienza dipendenti + è alta - falliscono
MOLTIPLICATORE_MOTIVAZIONE = 10;
//dissenso
ecologisti = 0;
noglobal = 0;
consumatori = 0;
sindacati = 0;
obesi = 0;
//toglie dissenso al mese
CLIMATOLOGO_EFFICACIA = 2;
POLITICO_EFFICACIA = 2;
ISPETTORE_EFFICACIA = 6;
ALIMENTARISTA_EFFICACIA = 6;
//costanti dissenso
ECOLOGISTI_FORESTE = 45;
//ogni abbattimento
ECOLOGISTI_DESERTIFICAZIONE = 1;
//ogni campo in desertificazione !!!al mese!!!
NOGLOBAL_CITTA = 1;
//la citta è ridotta alla fame ogni mese
NOGLOBAL_PUBBLICITA = 0.5;
NOGLOBAL_VILLAGGIO = 45;
//per l'abbattimento
NOGLOBAL_FORESTE = 10;
//per l'abbattimento
CONSUMATORI_OGM = 1;
//al mese per campo
CONSUMATORI_MALATA = 15;
//vacca malata macellata
CONSUMATORI_BSE = 35;
//mucca pazza macellata
SINDACATI_DECRESCITA = 1;
//quanto decresce al mese
SINDACATI_LICENZIAMENTO = 20;
SINDACATI_MOBBING = 10;
OBESI_CRESCITA = 2;
OBESI_DECRESCITA = 1;
TERZOMONDO_EFFICACIA = 2;
ALIMENTAZIONE_EFFICACIA = 2;
//CDA
MIN_GUADAGNO = 400;
//il cda inizia ad incazzarsi
MAX_GUADAGNO = 2500;
//massimo ragionevole di guadagno al mese
ASPETTATIVA = 80;
//ogni anno aumenta il min guadagno
BANCAROTTA = -30000;
ALLARMISMO_CDA = 1;
//incr / decr al mese
MAX_ALLARME = 10;
//massimo per cui salta l'omino
allarme_cda = 0;
//variabile
NOGLOBAL_BOICOTT = 12;
//mesi boicottaggio
ECOLOGISTI_BOICOTT = 12;
//mesi boicottaggio
SINDACATI_PICCHETTO = 6;
//mesi picchetto
