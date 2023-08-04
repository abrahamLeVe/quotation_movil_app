class UpdateQuotation {
  Data data;

  UpdateQuotation({
    required this.data,
  });

  factory UpdateQuotation.fromJson(Map<String, dynamic> json) =>
      UpdateQuotation(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  int id;
  String name;
  String phone;
  String message;
  String email;
  String? codeQuotation;
  List<Product> products;

  Data({
    required this.id,
    required this.name,
    required this.phone,
    required this.message,
    required this.email,
    this.codeQuotation,
    required this.products,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        message: json["message"],
        email: json["email"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

   Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "email": email,
        "message": message,
        "codeQuotation": codeQuotation,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
  int id;
  String name;

  List<Size> size;
  int quantity;
  double quotationPrice;

  Product({
    required this.id,
    required this.name,
    required this.size,
    required this.quantity,
    required this.quotationPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        size: List<Size>.from(json["size"].map((x) => Size.fromJson(x))),
        quantity: json["quantity"],
        quotationPrice: json["quotation_price"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "size": List<dynamic>.from(size.map((x) => x.toJson())),
        "quantity": quantity,
        "quotation_price": quotationPrice,
      };
}

class Size {
  int id;
  String val;
  int quantity;
  double quotationPrice;

  Size({
    required this.id,
    required this.val,
    required this.quantity,
    required this.quotationPrice,
  });

  factory Size.fromJson(Map<String, dynamic> json) => Size(
        id: json["id"],
        val: json["val"],
        quantity: json["quantity"],
        quotationPrice: json["quotation_price"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "val": val,
        "quantity": quantity,
        "quotation_price": quotationPrice,
      };
}
