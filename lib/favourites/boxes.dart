import 'package:hive/hive.dart';
import 'package:quotes/favourites/model/favmodel.dart';

class Boxes {
  static Box<FavModel> getData() => Hive.box<FavModel>("favquotes");
}