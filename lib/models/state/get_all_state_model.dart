import 'package:pract_01/models/quotation/get_all_quotation_model.dart';

class StateAllModel {
  Data data;

  StateAllModel({
    required this.data,
  });

  factory StateAllModel.fromJson(Map<String, dynamic> json) => StateAllModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Cotizaciones {
  List<Quotation> data;

  Cotizaciones({
    required this.data,
  });

  factory Cotizaciones.fromJson(Map<String, dynamic> json) => Cotizaciones(
        data: List<Quotation>.from(
            json["data"].map((x) => Quotation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DataAttributes {
  String name;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  String code;
  Cotizaciones? cotizaciones;

  DataAttributes({
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.code,
    this.cotizaciones,
  });

  factory DataAttributes.fromJson(Map<String, dynamic> json) => DataAttributes(
        name: json["name"],
        description: json["description"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        code: json["code"],
        cotizaciones: json["cotizaciones"] == null
            ? null
            : Cotizaciones.fromJson(json["cotizaciones"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
        "code": code,
        "cotizaciones": cotizaciones?.toJson(),
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
