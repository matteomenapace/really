// number of characters, lo dichairo qui in una variabile (costante in realtà) così se decido di metterne di più basta cambiare questo numero
var characters_number = 4;
// i protagonisti selezionati per una conversazione
var selected_a:Object;
var selected_b:Object;
// creates an OBJECT named "CHARACTERS" with a class of prototype properties
var characters:Object = {};
characters.characterClass = function() {
	characters.characterClass.prototype.name = "";
	characters.characterClass.prototype.passive_active = Number(0);
	characters.characterClass.prototype.intro_extroverted = Number(0);
	// characters.characterClass.prototype.winner = new Boolean();
	characters.characterClass.prototype.fair = true;
	characters.characterClass.prototype.trustful = true;
	characters.characterClass.prototype.excited_calm = Number(0);
	characters.characterClass.prototype.sad_happy = Number(0);
};
//
// creates several characters and displays their properties on screen
function create_characters(how_many_characters:Number) {
	for (var i = 1; i<=how_many_characters; i++) {
		var character_name:String = "character"+i;
		characters[character_name] = new characters.characterClass();
		characters[character_name].name = character_name;
		var current_character = characters[character_name];
		_root.attachMovie("tab_mc", character_name, this.getNextHighestDepth());
		current_character.onScreen = _root[character_name];
		with (current_character.onScreen) {
			_x = _width*(i-1)+200;
			// _y +=title_mc._height;
			title_mc.name_txt = "character";
			title_mc.dynamic_txt = i;
			passive_active.name_txt = "passive>active";
			passive_active.moving_bar._width = _root.psychoValue_to_number(current_character.passive_active);
			intro_extroverted.name_txt = "intro>extroverted";
			intro_extroverted.moving_bar._width = _root.psychoValue_to_number(current_character.intro_extroverted);
			fair.name_txt = "unfair>fair";
			fair.moving_bar._width = _root.boolean_to_number(current_character.fair);
			trustful.name_txt = "distrustful>trustful ";
			trustful.moving_bar._width = _root.boolean_to_number(current_character.trustful);
			excited_calm.name_txt = "excited>calm";
			excited_calm.moving_bar._width = _root.psychoValue_to_number(current_character.excited_calm);
			sad_happy.name_txt = "sad>happy";
			sad_happy.moving_bar._width = _root.psychoValue_to_number(current_character.sad_happy);
		}
	}
}
create_characters(characters_number);
//
// funzione per estrarre un numero intero a caso compreso fra 0 e n 
function pick_random(n:Number) {
	var r = Math.round(Math.random()*n);
	return r;
}
//
//funzioni per convertire lunghezze (delle barre) in numeri o boolean, e viceversa
function boolean_to_number(b:Boolean) {
	var n = Math.round(Math.random()*50);
	if (b == false) {
		return n;
	} else if (b == true) {
		n += 50;
		return n;
	}
}
function number_to_boolean(n:Number) {
	var b:Boolean;
	if (n<=50) {
		b = false;
		return b;
	} else if (n>50) {
		b = true;
		return b;
	}
}
function number_to_psychoValue(n:Number) {
	var p:Number;
	if (n<=33) {
		p = 0;
		return p;
	} else if (n>33 && n<=66) {
		p = 1;
		return p;
	} else {
		p = 2;
		return p;
	}
}
function psychoValue_to_number(p:Number) {
	var n = Math.round(Math.random()*33);
	switch (p) {
	case 0 :
		return n;
		break;
	case 1 :
		n += 33;
		return n;
		break;
	case 2 :
		n += 67;
		return n;
		break;
	}
}
//
// button to trigger updating check 
update_mc.dynamic_txt = "update check 1.1";
update_mc.btn.onRelease = function() {
	_root.write_in("characters.character1.passive_active = "+characters.character1.passive_active);
};
//
// calculates the "mood_match" (how similar are two characters' moods)
function mood_match(a:Object, b:Object) {
	// condizioni per stabilire la differenza di valori excited_calm e sad_happy
	// gli if sono necessari per non avere valori negativi (-1 o -2)
	if (a.excited_calm>=b.excited_calm) {
		var excited_calm_difference = a.excited_calm-b.excited_calm;
	} else {
		var excited_calm_difference = b.excited_calm-a.excited_calm;
	}
	if (a.sad_happy>=b.sad_happy) {
		var sad_happy_difference = a.sad_happy-b.sad_happy;
	} else {
		var sad_happy_difference = b.sad_happy-a.sad_happy;
	}
	var mood_match_outcome:Number = excited_calm_difference+sad_happy_difference;
	_root.write_in("mood_match between "+a.name+" and "+b.name+" is "+mood_match_outcome);
	return mood_match_outcome;
}
//
// button to trigger mood_match function between characters 1 and 2
mood_match_mc.dynamic_txt = "mood match 1-2";
mood_match_mc.btn.onRelease = function() {
	mood_match(characters.character1, characters.character2);
};
/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
// funzione CHIAVE del codice
// different behaviours (topics of conversation) triggered by a different mood_match
function conversation(a:Object, b:Object, how_many_characters:Number) {
	_root.write_in("\nconversation between "+a.name+" and "+b.name);
	_root.write_in("\"winner\" of a conversation is the most active and extroverted of the two");
	// stabilisce chi è il "winner", cioè chi dei due è più attivo e estroverso, e di conseguenza il "loser"
	var winner:Object;
	var loser:Object;
	var victim:Object = {name:""};
	// la vittima designata delle conversazioni fra winner e loser
	var rnd:Number = _root.pick_random(1);
	// crea un numero intero casuale <=1, quindi 0 o 1
	var rnd_winner:Number = _root.pick_random(1);
	var rnd_loser:Number = _root.pick_random(1);
	var rnd_victim:Number = _root.pick_random(1);
	if (a.passive_active+a.intro_extroverted>b.passive_active+b.intro_extroverted) {
		winner = a;
		loser = b;
	} else if (a.passive_active+a.intro_extroverted<b.passive_active+b.intro_extroverted) {
		winner = b;
		loser = a;
	} else {
		// nel caso di pareggio...
		_root.write_in("random winner coming...");
		//restituisce un numero casuale intero <2 ( quindi 0 o 1)
		switch (rnd) {
		case 0 :
			winner = a;
			loser = b;
			break;
		case 1 :
			winner = b;
			loser = a;
			break;
		}
	}
	_root.write_in("the winner is "+winner.name);
	//_root.write_in("winner.passive_active = "+winner.passive_active);
	//_root.write_in("winner.intro_extroverted = "+winner.intro_extroverted);
	var a_b_mood_match:Number = _root.mood_match(a, b);
	// _root.write_in("mood match between the two is "+a_b_mood_match+"\n");
	switch (a_b_mood_match) {
		/////////////////////////////////////////////////////
		/////////////////////////////////////////////////////
		/////////////////////////////////////////////////////
		/////////////////////////////////////////////////////
	case 0 :
		// la conversazione tratta di loro due, e può influenzare solo il loro mood
		if (winner.fair) {
			// se il winner è fair vanno d'accordo
			if (winner.trustful) {
				//se "si fida" il suo mood cambierà, altrimenti no
				switch (rnd_winner) {
				case 0 :
					if (winner.excited_calm<2) {
						winner.excited_calm++;
						_root.write_in("winner.excited_calm has been set to "+winner.excited_calm);
						_root[winner.name].excited_calm.moving_bar._width = _root.psychoValue_to_number(winner.excited_calm);
					}
					break;
				case 1 :
					if (winner.sad_happy<2) {
						winner.sad_happy++;
						_root.write_in("winner.sad_happy has been set to "+winner.sad_happy);
						_root[winner.name].sad_happy.moving_bar._width = _root.psychoValue_to_number(winner.sad_happy);
					}
					break;
				}
			}
			if (loser.trustful) {
				switch (rnd_loser) {
				case 0 :
					if (loser.excited_calm<2) {
						loser.excited_calm++;
						_root.write_in("loser.excited_calm has been set to "+loser.excited_calm);
						_root[loser.name].excited_calm.moving_bar._width = _root.psychoValue_to_number(loser.excited_calm);
					}
					break;
				case 1 :
					if (loser.sad_happy<2) {
						loser.sad_happy++;
						_root.write_in("loser.sad_happy has been set to "+loser.sad_happy);
						_root[loser.name].sad_happy.moving_bar._width = _root.psychoValue_to_number(loser.sad_happy);
					}
					break;
				}
			}
		} else {
			// se il winner è non è fair non vanno d'accordo, quindi il loro mood ne risente negativamente
			if (winner.trustful) {
				//se "si fida" il suo mood cambierà, altrimenti no
				switch (rnd_winner) {
				case 0 :
					if (winner.excited_calm>0) {
						winner.excited_calm--;
						_root.write_in("winner.excited_calm has been set to "+winner.excited_calm);
						_root[winner.name].excited_calm.moving_bar._width = _root.psychoValue_to_number(winner.excited_calm);
					}
					break;
				case 1 :
					if (winner.sad_happy>0) {
						winner.sad_happy--;
						_root.write_in("winner.sad_happy has been set to "+winner.sad_happy);
						_root[winner.name].sad_happy.moving_bar._width = _root.psychoValue_to_number(winner.sad_happy);
					}
					break;
				}
			}
			if (loser.trustful) {
				switch (rnd_loser) {
				case 0 :
					if (loser.excited_calm>0) {
						loser.excited_calm--;
						_root.write_in("loser.excited_calm has been set to "+loser.excited_calm);
						_root[loser.name].excited_calm.moving_bar._width = _root.psychoValue_to_number(loser.excited_calm);
					}
					break;
				case 1 :
					if (loser.sad_happy>0) {
						loser.sad_happy--;
						_root.write_in("loser.sad_happy has been set to "+loser.sad_happy);
						_root[loser.name].sad_happy.moving_bar._width = _root.psychoValue_to_number(loser.sad_happy);
					}
					break;
				}
			}
		}
		break;
		/////////////////////////////////////////////////////
		/////////////////////////////////////////////////////
		/////////////////////////////////////////////////////
		/////////////////////////////////////////////////////			
	case 1 :
		// la conversazione tratta di un altro (victim) e influenza il suo mood
		victim.name = a.name;
		// inizializzo il nome della vittima in modo da farlo entrare nel ciclo while
		// while serve per fare in modo che la vittima non sia uno fra a e b, ma un terzo
		while (victim.name == a.name || victim.name == b.name) {
			random_character_number = _root.pick_random(how_many_characters-1)+1;
			// numero random compreso tra 0 e (how_many_characters-1), a cui va aggiunto 1 per avere un numero tra 1 e how_many_characters
			victim.name = "character"+random_character_number;
			// _root.write_in (victim.name); //fine
		}
		victim = _root.characters[victim.name];
		_root.write_in("victim of this conversation is "+victim.name+" and its sad_happy value is currently "+victim.sad_happy+" right?");
		if (winner.fair && victim.trustful) {
			// se il winner è fair parlano bene della vittima
			// se la vittima "si fida" allora il suo mood cambierà
			switch (rnd_victim) {
			case 0 :
				if (victim.excited_calm<2) {
					victim.excited_calm++;
					_root.write_in("victim.excited_calm has been set to "+victim.excited_calm);
					_root[victim.name].excited_calm.moving_bar._width = _root.psychoValue_to_number(victim.excited_calm);
				}
				break;
			case 1 :
				if (victim.sad_happy<2) {
					victim.sad_happy++;
					_root.write_in("victim.sad_happy has been set to "+victim.sad_happy);
					_root[victim.name].sad_happy.moving_bar._width = _root.psychoValue_to_number(victim.sad_happy);
				}
				break;
			}
		}
		if (!winner.fair && victim.trustful) {
			// se il winner è unfair parlano male della vittima
			// se la vittima "si fida" allora il suo mood cambierà
			switch (rnd_victim) {
			case 0 :
				if (victim.excited_calm>0) {
					victim.excited_calm--;
					_root.write_in("victim.excited_calm has been set to "+victim.excited_calm);
					_root[victim.name].excited_calm.moving_bar._width = _root.psychoValue_to_number(victim.excited_calm);
				}
				break;
			case 1 :
				if (victim.sad_happy>0) {
					victim.sad_happy--;
					_root.write_in("victim.sad_happy has been set to "+victim.sad_happy);
					_root[victim.name].sad_happy.moving_bar._width = _root.psychoValue_to_number(victim.sad_happy);
				}
				break;
			}
		}
		break;
		/////////////////////////////////////////////////////
		/////////////////////////////////////////////////////
		/////////////////////////////////////////////////////
		/////////////////////////////////////////////////////			
	case 2 :
		_root.write_in("small talk: nothing happens...");
		break;
		/////////////////////////////////////////////////////
		/////////////////////////////////////////////////////
		/////////////////////////////////////////////////////
		/////////////////////////////////////////////////////			
	case 3 :
		// la conversazione tratta della situazione generale e influenza un character a caso nel suo valore di excited_calm
		random_character_number = _root.pick_random(how_many_characters-1)+1;
		// numero random compreso tra 0 e (how_many_characters-1), a cui va aggiunto 1 per avere un numero tra 1 e how_many_characters
		victim.name = "character"+random_character_number;
		victim = _root.characters[victim.name];
		_root.write_in("victim of this conversation is "+victim.name+" and its sad_happy value is currently "+victim.sad_happy+" right?");
		if (winner.fair && victim.trustful && victim.excited_calm<2) {
			victim.excited_calm++;
			_root.write_in("victim.excited_calm has been set to "+victim.excited_calm);
			_root[victim.name].excited_calm.moving_bar._width = _root.psychoValue_to_number(victim.excited_calm);
		} else if (!winner.fair && victim.trustful && victim.excited_calm>0) {
			victim.excited_calm--;
			_root.write_in("victim.excited_calm has been set to "+victim.excited_calm);
			_root[victim.name].excited_calm.moving_bar._width = _root.psychoValue_to_number(victim.excited_calm);
		}
		break;
		/////////////////////////////////////////////////////
		/////////////////////////////////////////////////////
		/////////////////////////////////////////////////////
		/////////////////////////////////////////////////////			
	case 4 :
		// la conversazione tratta del winner e influenza il suo sad_happy
		if (winner.fair && winner.trustful && winner.sad_happy<2) {
			winner.sad_happy++;
			_root.write_in("winner.sad_happy has been set to "+winner.sad_happy);
			_root[winner.name].sad_happy.moving_bar._width = _root.psychoValue_to_number(winner.sad_happy);
		} else if (!winner.fair && winner.trustful && winner.sad_happy>0) {
			winner.sad_happy--;
			_root.write_in("winner.sad_happy has been set to "+winner.sad_happy);
			_root[winner.name].sad_happy.moving_bar._width = _root.psychoValue_to_number(winner.sad_happy);
		}
		break;
	}
	_root.write_in("");
}
// conversation between 1 and 2, fixed, boring, not dynamic
conversation12_mc.dynamic_txt = "conversation 1-2";
conversation12_mc.btn.onRelease = function() {
	conversation(_root.characters.character1, _root.characters.character2, characters_number);
};
// conversation between selectable characters, dynamic yeah
conversation_mc.dynamic_txt = "conversation";
for (var i = 1; i<=4; i++) {
	conversation_mc[i].dynamic_txt = "character "+i;
}
conversation_mc.btn.onRelease = function() {
	conversation(_root.selected_a, _root.selected_b, _root.characters_number);
};
// function for writing in the "what is going on" box
function write_in(msg:String) {
	_root.what_is_going_on.text += msg+"\n";
	//prints the msg (whatever it is) on screen and then goes to a new line (\n)
	_root.what_is_going_on.scroll += 10;
	// scrolls the text down so that we can read the last lines
}
