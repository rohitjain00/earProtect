
import 'package:shared_preferences/shared_preferences.dart';

class File {

  static SharedPreferences pref;
  static init() async {
    pref = await SharedPreferences.getInstance();
  }

  static syncCounter(List<double> list) {
    pref.setStringList('key', list.map((val) => '$val').toList());
  }
  static retrieveCounter() {
    final list = pref.containsKey('key') ? pref.getStringList('key').map((val) => double.parse(val)).toList() : [];
    return list;
  }

}