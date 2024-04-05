class QuotationModel {
  List<Quotation> data;
  Meta meta;

  QuotationModel({
    required this.data,
    required this.meta,
  });

  factory QuotationModel.fromJson(Map<String, dynamic> json) => QuotationModel(
        data: List<Quotation>.from(
            json["data"].map((x) => Quotation.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class Quotation {
  int id;
  QuotationAttributes attributes;

  Quotation({
    required this.id,
    required this.attributes,
  });

  factory Quotation.fromJson(Map<String, dynamic> json) => Quotation(
        id: json["id"],
        attributes: QuotationAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

class QuotationAttributes {
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  String email;
  String name;
  String direction;
  String phone;
  int dayLimit;
  String? details;
  dynamic notes;
  DateTime dateLimit;
  String codeStatus;
  List<Product> products;
  String tipeDoc;
  Location location;
  String numDoc;
  User user;
  StateQ state;

  QuotationAttributes({
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
    required this.user,
    required this.state,
  });

  factory QuotationAttributes.fromJson(Map<String, dynamic> json) =>
      QuotationAttributes(
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
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
        user: User.fromJson(json["user"]),
        state: StateQ.fromJson(json["state"]),
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
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
        "user": user.toJson(),
        "state": state.toJson(),
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

class StateQ {
  ColorClass data;

  StateQ({
    required this.data,
  });

  factory StateQ.fromJson(Map<String, dynamic> json) => StateQ(
        data: ColorClass.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class User {
  UserData data;

  User({
    required this.data,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        data: UserData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class UserData {
  int id;
  PurpleAttributes attributes;

  UserData({
    required this.id,
    required this.attributes,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        attributes: PurpleAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

class PurpleAttributes {
  String username;
  String email;
  String provider;
  bool confirmed;
  bool blocked;
  DateTime createdAt;
  DateTime updatedAt;

  PurpleAttributes({
    required this.username,
    required this.email,
    required this.provider,
    required this.confirmed,
    required this.blocked,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PurpleAttributes.fromJson(Map<String, dynamic> json) =>
      PurpleAttributes(
        username: json["username"],
        email: json["email"],
        provider: json["provider"],
        confirmed: json["confirmed"],
        blocked: json["blocked"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "provider": provider,
        "confirmed": confirmed,
        "blocked": blocked,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class Meta {
  Pagination pagination;

  Meta({
    required this.pagination,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        pagination: Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination.toJson(),
      };
}

class Pagination {
  int page;
  int pageSize;
  int pageCount;
  int total;

  Pagination({
    required this.page,
    required this.pageSize,
    required this.pageCount,
    required this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        page: json["page"],
        pageSize: json["pageSize"],
        pageCount: json["pageCount"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "pageSize": pageSize,
        "pageCount": pageCount,
        "total": total,
      };
}
