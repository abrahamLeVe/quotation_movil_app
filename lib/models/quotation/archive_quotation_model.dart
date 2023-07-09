class ArchiveQuotation {
  Data data;

  ArchiveQuotation({
    required this.data,
  });

  factory ArchiveQuotation.fromJson(Map<String, dynamic> json) =>
      ArchiveQuotation(
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
  List<Product> products;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic publishedAt;
  String codeQuotation;

  Data({
    required this.id,
    required this.name,
    required this.phone,
    required this.message,
    required this.email,
    required this.products,
    required this.createdAt,
    required this.updatedAt,
    this.publishedAt,
    required this.codeQuotation,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        message: json["message"],
        email: json["email"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"],
        codeQuotation: json["code_quotation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "message": message,
        "email": email,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt,
        "code_quotation": codeQuotation,
      };
}

class Product {
  int id;
  String name;
  List<Size> size;
  int quantity;
  double? quotationPrice;

  Product({
    required this.id,
    required this.name,
    required this.size,
    required this.quantity,
    this.quotationPrice,
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
