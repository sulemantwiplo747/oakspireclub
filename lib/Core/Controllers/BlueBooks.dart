class BlueBook {
  String? id;  
  String? image;  
  String? bottleName;  
  String? average;
  String? low;
  String? high;
  String? status;  

  BlueBook({
      this.id,
      this.bottleName,
      this.average,
      this.low,
      this.high,
      this.status,
      this.image
    });

  BlueBook.fromJson(json) {
    id = json['id'].toString();
    bottleName = json['bottle_name'];
    average = json['average'].toString();    
    low = json['low'].toString();
    high = json['high'].toString();
    status = json['status'];
    image = json['image'];     
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "bottle_name": bottleName,
      "average": average,
      "low": low,
      "high": high,
      "status": status,
      "image": image
    };
  }
}
