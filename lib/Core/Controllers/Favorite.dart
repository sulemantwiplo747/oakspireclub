import 'package:bourboneur/Core/Controllers/BlueBooks.dart';
import 'package:bourboneur/Core/Controllers/User.dart';

class Favorite {
  String? id;
  BlueBook? blueBook;  
  String? createdAt;

  Favorite({
    this.id,
    this.blueBook,
    this.createdAt
  });

  Favorite.fromJson(json) {
    id = json['id'].toString();    
    blueBook = BlueBook.fromJson(json['bluebook']);   
    createdAt = json['created_at'].toString();
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "bluebook": blueBook?.toJson(),    
      "created_at": createdAt,
    };
  }
}
