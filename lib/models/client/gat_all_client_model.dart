class ClientModel {
  int id;
  String username;
  String email;
  String provider;
  bool confirmed;
  bool blocked;
  DateTime createdAt;
  DateTime updatedAt;
  bool observer;
  Role role;
  List<Quotation> quotations;
  List<dynamic> payments;

  ClientModel({
    required this.id,
    required this.username,
    required this.email,
    required this.provider,
    required this.confirmed,
    required this.blocked,
    required this.createdAt,
    required this.updatedAt,
    required this.observer,
    required this.role,
    required this.quotations,
    required this.payments,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        provider: json["provider"],
        confirmed: json["confirmed"],
        blocked: json["blocked"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        observer: json["observer"],
        role: Role.fromJson(json["role"]),
        quotations: List<Quotation>.from(
            json["quotations"].map((x) => Quotation.fromJson(x))),
        payments: List<dynamic>.from(json["payments"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "provider": provider,
        "confirmed": confirmed,
        "blocked": blocked,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "observer": observer,
        "role": role.toJson(),
        "quotations": List<dynamic>.from(quotations.map((x) => x.toJson())),
        "payments": List<dynamic>.from(payments.map((x) => x)),
      };
}

class Quotation {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? publishedAt;
  String email;
  String name;
  String direction;
  String phone;
  int dayLimit;
  dynamic details;
  String? notes;
  DateTime dateLimit;
  String codeStatus;
  List<Product> products;
  String tipeDoc;
  Location location;
  String numDoc;

  Quotation({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.email,
    required this.name,
    required this.direction,
    required this.phone,
    required this.dayLimit,
    required this.details,
    required this.notes,
    required this.dateLimit,
    required this.codeStatus,
    required this.products,
    required this.tipeDoc,
    required this.location,
    required this.numDoc,
  });

  factory Quotation.fromJson(Map<String, dynamic> json) => Quotation(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        email: json["email"],
        name: json["name"],
        direction: json["direction"],
        phone: json["phone"],
        dayLimit: json["dayLimit"],
        details: json["details"],
        notes: json["notes"],
        dateLimit: DateTime.parse(json["dateLimit"]),
        codeStatus: json["codeStatus"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
        tipeDoc: json["tipe_doc"],
        location: Location.fromJson(json["location"]),
        numDoc: json["num_doc"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt?.toIso8601String(),
        "email": email,
        "name": name,
        "direction": direction,
        "phone": phone,
        "dayLimit": dayLimit,
        "details": details,
        "notes": notes,
        "dateLimit":
            "${dateLimit.year.toString().padLeft(4, '0')}-${dateLimit.month.toString().padLeft(2, '0')}-${dateLimit.day.toString().padLeft(2, '0')}",
        "codeStatus": codeStatus,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "tipe_doc": tipeDoc,
        "location": location.toJson(),
        "num_doc": numDoc,
      };
}

class Location {
  String distrito;
  String provincia;
  String departamento;

  Location({
    required this.distrito,
    required this.provincia,
    required this.departamento,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        distrito: json["distrito"],
        provincia: json["provincia"],
        departamento: json["departamento"],
      );

  Map<String, dynamic> toJson() => {
        "distrito": distrito,
        "provincia": provincia,
        "departamento": departamento,
      };
}

class Product {
  int id;
  String? size;
  String slug;
  String title;
  double value;
  List<ColorElement> colors;
  double discount;
  int quantity;
  String pictureUrl;

  Product({
    required this.id,
    required this.size,
    required this.slug,
    required this.title,
    required this.value,
    required this.colors,
    required this.discount,
    required this.quantity,
    required this.pictureUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        size: json["size"],
        slug: json["slug"],
        title: json["title"],
        value: json["value"]?.toDouble(),
        colors: List<ColorElement>.from(
            json["colors"].map((x) => ColorElement.fromJson(x))),
        discount: json["discount"]?.toDouble(),
        quantity: json["quantity"],
        pictureUrl: json["picture_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "size": size,
        "slug": slug,
        "title": title,
        "value": value,
        "colors": List<dynamic>.from(colors.map((x) => x.toJson())),
        "discount": discount,
        "quantity": quantity,
        "picture_url": pictureUrl,
      };
}

class ColorElement {
  int id;
  ColorColor color;
  int quantity;

  ColorElement({
    required this.id,
    required this.color,
    required this.quantity,
  });

  factory ColorElement.fromJson(Map<String, dynamic> json) => ColorElement(
        id: json["id"],
        color: ColorColor.fromJson(json["color"]),
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "color": color.toJson(),
        "quantity": quantity,
      };
}

class ColorColor {
  int id;
  Attributes attributes;

  ColorColor({
    required this.id,
    required this.attributes,
  });

  factory ColorColor.fromJson(Map<String, dynamic> json) => ColorColor(
        id: json["id"],
        attributes: Attributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

class Attributes {
  String code;
  String name;
  DateTime createdAt;
  DateTime updatedAt;
  String description;
  DateTime publishedAt;

  Attributes({
    required this.code,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.description,
    required this.publishedAt,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        code: json["code"],
        name: json["name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        description: json["description"],
        publishedAt: DateTime.parse(json["publishedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "description": description,
        "publishedAt": publishedAt.toIso8601String(),
      };
}

class Role {
  int id;
  String name;
  String description;
  String type;
  DateTime createdAt;
  DateTime updatedAt;

  Role({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        type: json["type"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "type": type,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
