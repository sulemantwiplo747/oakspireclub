import 'package:bourboneur/Core/Controllers/BlueBooks.dart';

class Collection {
  String? id;  
  String? type;  
  String? createdAt;
  String? fill;
  String? image;
  String? pricePaid;
  BlueBook? blueBook;  

  Collection({
        this.id,
        this.type,
        this.createdAt,
        this.fill,
        this.image,
        this.pricePaid,
        this.blueBook,
  });

  Collection.fromJson(json) {
    id = json['id'].toString();    
    type = json['type'];
    fill = json['fill'];
    image = json['image']?.toString();
    pricePaid = json['price_paid'];
    createdAt = json['created_at'].toString();
    blueBook = BlueBook.fromJson(json['bluebook']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type": type,
      "created_at": createdAt,
      "price_paid": pricePaid,
      "fill": fill,
      "image": image,
      "bluebook": blueBook?.toJson()
    };
  }
}
