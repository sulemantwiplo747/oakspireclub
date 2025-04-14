import 'package:bourboneur/Core/Controllers/BlueBooks.dart';

class Collection {
  String? id;  
  String? type;  
  String? createdAt;
  BlueBook? blueBook;  

  Collection({
        this.id,
        this.type,
        this.createdAt,
        this.blueBook,
  });

  Collection.fromJson(json) {
    id = json['id'].toString();    
    type = json['type'];
    createdAt = json['created_at'].toString();
    blueBook = BlueBook.fromJson(json['bluebook']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type": type,
      "created_at": createdAt,
      "bluebook": blueBook?.toJson()
    };
  }
}
