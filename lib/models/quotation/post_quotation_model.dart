class UpdateQuotation {
  UpdateQuotationData data;

  UpdateQuotation({
    required this.data,
  });

  factory UpdateQuotation.fromJson(Map<String, dynamic> json) =>
      UpdateQuotation(
        data: UpdateQuotationData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class UpdateQuotationData {
  int id;
  UpdateQuotationAtributes attributes;

  UpdateQuotationData({
    required this.id,
    required this.attributes,
  });

  factory UpdateQuotationData.fromJson(Map<String, dynamic> json) =>
      UpdateQuotationData(
        id: json["id"],
        attributes: UpdateQuotationAtributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

class UpdateQuotationAtributes {
  dynamic notes;
  String codeStatus;
  List<Product> products;
  int state;

  UpdateQuotationAtributes({
    required this.notes,
    required this.codeStatus,
    required this.products,
    required this.state,
  });

  factory UpdateQuotationAtributes.fromJson(Map<String, dynamic> json) =>
      UpdateQuotationAtributes(
        notes: json["notes"],
        codeStatus: json["codeStatus"],
        state: json["state"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "notes": notes,
        "codeStatus": codeStatus,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "state": state,
      };
}

class Product {
  int id;
  String? size;
  String slug;
  String title;
  double value;
  List<Color> colors;
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
        colors: List<Color>.from(json["colors"].map((x) => Color.fromJson(x))),
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

class Color {
  int id;
  ColorClass color;
  int quantity;

  Color({
    required this.id,
    required this.color,
    required this.quantity,
  });

  factory Color.fromJson(Map<String, dynamic> json) => Color(
        id: json["id"],
        color: ColorClass.fromJson(json["color"]),
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "color": color.toJson(),
        "quantity": quantity,
      };
}

class ColorClass {
  int id;
  ColorAttributes attributes;

  ColorClass({
    required this.id,
    required this.attributes,
  });

  factory ColorClass.fromJson(Map<String, dynamic> json) => ColorClass(
        id: json["id"],
        attributes: ColorAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

class ColorAttributes {
  String code;
  String name;
  DateTime createdAt;
  DateTime updatedAt;
  String description;
  DateTime publishedAt;

  ColorAttributes({
    required this.code,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.description,
    required this.publishedAt,
  });

  factory ColorAttributes.fromJson(Map<String, dynamic> json) =>
      ColorAttributes(
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

class State {
  ColorClass data;

  State({
    required this.data,
  });

  factory State.fromJson(Map<String, dynamic> json) => State(
        data: ColorClass.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}
