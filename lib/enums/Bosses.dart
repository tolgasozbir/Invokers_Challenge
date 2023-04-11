import '../extensions/string_extension.dart';
import '../constants/app_strings.dart';

enum Bosses {
  warlock(10000),
  omniknight(15000),
  riki(25000),
  huskar(35000),
  templar(45000),
  anti_mage(55000);

  const Bosses(this._health);

  final double _health;
}

extension bossExtension on Bosses {
  double get getHp => _health;
  String get getImage => '${ImagePaths.bosses}boss_$name.png';
  String get getName => name.replaceAll("_", " ").capitalize();
}