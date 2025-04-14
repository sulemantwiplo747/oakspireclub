import 'package:bourboneur/Core/Controllers/BlueBooks.dart';
import 'package:bourboneur/Core/Controllers/User.dart';

class Rating {
  String? id;
  BlueBook? blueBook;
  String? nose;
  String? palate;
  String? finish;
  String? notes;
  String? createdAt;

  Rating({
        this.id,
        this.blueBook,
        this.nose,
        this.palate,
        this.finish,
        this.notes,        
        this.createdAt
  });

  Rating.fromJson(json) {
    id = json['id'].toString();    
    blueBook = BlueBook.fromJson(json['bluebook']);
    nose = json['nose'].toString();
    palate = json['palate'].toString();
    finish = json['finish'].toString();
    notes = json['notes'].toString();
    createdAt = json['created_at'].toString();
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "bluebook": blueBook?.toJson(),
      "nose" : nose,
      "palate" : palate,
      "finish" : finish,
      "notes" : notes,
      "created_at": createdAt,
    };
  }
}
