class User {
  String? id;
  String? name;
  String? email;
  String? packageId;
  String? customerId;
  String? paymentMethodId;
  String? status;
  String? packageType;
  String? packagePrice;
  String? subscriptionType;
  String? lastPaymentMethod;
  String? subscriptionStatus;
  String? isFree;

  User(
      {this.id,
      this.name,
      this.email,
      this.packageId,
      this.paymentMethodId,
      this.customerId,
      this.status,
      this.packageType,
      this.packagePrice,
      this.subscriptionType,
      this.lastPaymentMethod,
      this.subscriptionStatus,
      this.isFree});

  User.fromJson(json) {
    id = json['id'].toString();
    name = json['name'];
    email = json['email'];
    packageId =
        json['package_id'] != null ? json['package_id'].toString() : null;
    paymentMethodId = json['payment_method_id'];
    customerId = json['customer_id'];
    status = json['status'];
    packageType = json['package_type'];
    packagePrice = json['package_price'];
    subscriptionType = json['subscription_type'];
    lastPaymentMethod = json['last_payment_method'];
    subscriptionStatus = json['subscription_status'];
    isFree = json['is_free'].toString();
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "package_id": packageId,
      "customer_id": customerId,
      "payment_method_id": paymentMethodId,
      "status": status,
      "package_type": packageType,
      "package_price": packagePrice,
      "subscription_type": subscriptionType,
      "last_payment_method": lastPaymentMethod,
      "subscription_status": subscriptionStatus,
      'is_free': isFree
    };
  }
}
