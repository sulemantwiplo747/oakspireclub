import 'package:bourboneur/Core/Controllers/BlueBooks.dart';

class GroupedCollection {
  String? id;  
  String? type;
  String? count;
  String? price;
  String? image;  
  String? fill;
  String? pricePaid;
  String? createdAt;
  BlueBook? blueBook;

  GroupedCollection({
        this.id,
        this.type,
        this.count,
        this.image,
        this.price,
        this.fill,
        this.pricePaid,
        this.createdAt,
        this.blueBook,
  });

  GroupedCollection.fromJson(json) {
    id = json['id'].toString();    
    type = json['type'];
    createdAt = json['created_at'].toString();
    count = json['count'].toString();    
    image = json['image'];
    blueBook = BlueBook.fromJson(json['bluebook']);
    fill = json['total_fill'];
    pricePaid = json['total_price_paid'];

    price = (int.parse(count!) * int.parse(blueBook!.average!)).toString();
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type": type,
      "count": count,
      "price": price,
      "image": image,
      "total_fill": fill,
      "total_price_paid": pricePaid,
      "created_at": createdAt,
      "bluebook": blueBook?.toJson()
    };
  }
}
