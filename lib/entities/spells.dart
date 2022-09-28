import 'dart:math';
import 'package:dota2_invoker/constants/app_strings.dart';
import 'package:dota2_invoker/models/spell.dart';

enum MainSkills {quas, wex, exort, invoke}

extension mainSkillsExtension on MainSkills {
  String get getImage => '${ImagePaths.main}/invoker_${this.name}.png';
}

enum Skills {
  invoker_cold_snap,
  invoker_ghost_walk,
  invoker_ice_wall,
  invoker_emp,
  invoker_tornado,
  invoker_alacrity,
  invoker_deafening_blast,
  invoker_sun_strike,
  invoker_forge_spirit,
  invoker_chaos_meteor,
}

class Spells {

  static Spells? _instance;
  static Spells get instance {
    if (_instance != null) {
      return _instance!;
    }
    _instance = Spells._();
    return _instance!;
  }

  Spells._();

  Spells();

  Spell _tempSpell = Spell("images/spells/invoker_alacrity.png",["w","w","e"]);
  Random _rnd = Random();

  List<Spell> _spellList = [
    Spell("images/spells/invoker_cold_snap.png",        ["q","q","q"]),
    Spell("images/spells/invoker_ghost_walk.png",       ["q","q","w"]),
    Spell("images/spells/invoker_ice_wall.png",         ["q","q","e"]),
    Spell("images/spells/invoker_emp.png",              ["w","w","w"]),
    Spell("images/spells/invoker_tornado.png",          ["w","w","q"]),
    Spell("images/spells/invoker_alacrity.png",         ["w","w","e"]),
    Spell("images/spells/invoker_deafening_blast.png",  ["q","w","e"]),
    Spell("images/spells/invoker_sun_strike.png",       ["e","e","e"]),
    Spell("images/spells/invoker_forge_spirit.png",     ["e","e","q"]),
    Spell("images/spells/invoker_chaos_meteor.png",     ["e","e","w"]),
  ];

  Spell get getRandomSpell{
    Spell rndSpell = _spellList[_rnd.nextInt(_spellList.length)];
    do {
      rndSpell = _spellList[_rnd.nextInt(_spellList.length)];
    } while (_tempSpell == rndSpell);

    _tempSpell = rndSpell;
    return rndSpell;
  }

  List<String> get getSpellImagePaths => _spellList.map((e) => e.image).toList();


}