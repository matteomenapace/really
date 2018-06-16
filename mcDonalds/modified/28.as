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