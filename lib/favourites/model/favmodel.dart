import 'package:hive/hive.dart';
part 'favmodel.g.dart';

@HiveType(typeId: 0)
class FavModel extends HiveObject {
  @HiveField(0)
  String quote;

  @HiveField(1)
  String author;

  FavModel({required this.quote, required this.author});
}
