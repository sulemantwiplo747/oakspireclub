import 'package:bourboneur/Core/Controllers/BlueBooks.dart';

class GroupedCollection {
  String? id;  
  String? type;
  String? count;
  String? price;
  String? createdAt;
  BlueBook? blueBook;

  GroupedCollection({
        this.id,
        this.type,
        this.count,
        this.price,
        this.createdAt,
        this.blueBook,
  });

  GroupedCollection.fromJson(json) {
    id = json['id'].toString();    
    type = json['type'];
    createdAt = json['created_at'].toString();
    count = json['count'].toString();    
    blueBook = BlueBook.fromJson(json['bluebook']);

    price = (int.parse(count!) * int.parse(blueBook!.high!)).toString();
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type": type,
      "count": count,
      "price": price,
      "created_at": createdAt,
      "bluebook": blueBook?.toJson()
    };
  }
}
