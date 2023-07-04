// To parse this JSON data, do
//
//     final sizeModel = sizeModelFromJson(jsonString);

import 'dart:convert';

SizeModel sizeModelFromJson(String str) => SizeModel.fromJson(json.decode(str));

String sizeModelToJson(SizeModel data) => json.encode(data.toJson());

class SizeModel {
  List<Size> data;
  Meta meta;

  SizeModel({
    required this.data,
    required this.meta,
  });

  factory SizeModel.fromJson(Map<String, dynamic> json) => SizeModel(
        data: List<Size>.from(json["data"].map((x) => Size.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class SizeUpdateModel {
  Size data;

  SizeUpdateModel({
    required this.data,
  });

  factory SizeUpdateModel.fromJson(Map<String, dynamic> json) =>
      SizeUpdateModel(
        data: Size.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Size {
  int id;
  SizeAttributes attributes;

  Size({
    required this.id,
    required this.attributes,
  });

  factory Size.fromJson(Map<String, dynamic> json) => Size(
        id: json["id"],
        attributes: SizeAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

class SizeAttributes {
  double? quotationPrice;
  String val;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  Product product;

  SizeAttributes({
    this.quotationPrice,
    required this.val,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.product,
  });

  factory SizeAttributes.fromJson(Map<String, dynamic> json) =>
      SizeAttributes(
        quotationPrice: json["quotation_price"]?.toDouble(),
        val: json["val"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        product: Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "quotation_price": quotationPrice,
        "val": val,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
        "product": product.toJson(),
      };
}

class Product {
  Data data;

  Product({
    required this.data,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
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
  String name;
  dynamic subtitle;
  String description;
  String slug;
  dynamic quotationPrice;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;

  DataAttributes({
    required this.name,
    this.subtitle,
    required this.description,
    required this.slug,
    this.quotationPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  factory DataAttributes.fromJson(Map<String, dynamic> json) => DataAttributes(
        name: json["name"],
        subtitle: json["subtitle"],
        description: json["description"],
        slug: json["slug"],
        quotationPrice: json["quotation_price"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "subtitle": subtitle,
        "description": description,
        "slug": slug,
        "quotation_price": quotationPrice,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
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
