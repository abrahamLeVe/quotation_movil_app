class PaymentModel {
  List<Payment> data;
  Meta meta;

  PaymentModel({
    required this.data,
    required this.meta,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        data: List<Payment>.from(json["data"].map((x) => Payment.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class Payment {
  int id;
  PaymentAttributes attributes;

  Payment({
    required this.id,
    required this.attributes,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        attributes: PaymentAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

class PaymentAttributes {
  String paymentId;
  double amount;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  Cotizacion user;
  Cotizacion cotizacion;

  PaymentAttributes({
    required this.paymentId,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.user,
    required this.cotizacion,
  });

  factory PaymentAttributes.fromJson(Map<String, dynamic> json) =>
      PaymentAttributes(
        paymentId: json["payment_id"],
        amount: json["amount"].toDouble(),
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        user: Cotizacion.fromJson(json["user"]),
        cotizacion: Cotizacion.fromJson(json["cotizacion"]),
      );

  Map<String, dynamic> toJson() => {
        "payment_id": paymentId,
        "amount": amount,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
        "user": user.toJson(),
        "cotizacion": cotizacion.toJson(),
      };
}

class Cotizacion {
  Data? data;

  Cotizacion({
    required this.data,
  });

  factory Cotizacion.fromJson(Map<String, dynamic> json) => Cotizacion(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  int id;
  DataAttributes attributes;

  Data({
    required this.id,
    required this.attributes,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        attributes: DataAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

class DataAttributes {
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  String email;
  String name;
  String direction;
  String phone;
  int dayLimit;
  String? details;
  String notes;
  DateTime dateLimit;
  String codeStatus;
  List<Product> products;
  String tipeDoc;
  Location location;
  String numDoc;

  DataAttributes({
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

  factory DataAttributes.fromJson(Map<String, dynamic> json) => DataAttributes(
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
  int discount;
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
        id: json["id"], // Asegúrate de que "id" siempre viene como un entero
        size: json["size"],
        slug: json["slug"],
        title: json["title"],
        value: json["value"].toDouble(), // Asegura la conversión a double
        colors: List<ColorElement>.from(
            json["colors"].map((x) => ColorElement.fromJson(x))),
        discount: (json["discount"] as num)
            .toInt(), // Si discount podría venir como double
        quantity: (json["quantity"] as num)
            .toInt(), // Si quantity podría venir como double
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
  ColorAttributes attributes;

  ColorColor({
    required this.id,
    required this.attributes,
  });

  factory ColorColor.fromJson(Map<String, dynamic> json) => ColorColor(
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
