class StateModel {
  List<DataState> data;

  StateModel({
    required this.data,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
        data: List<DataState>.from(
            json["data"].map((x) => DataState.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DataState {
  int id;
  Attributes? attributes;

  DataState({
    required this.id,
    this.attributes,
  });

  factory DataState.fromJson(Map<String, dynamic> json) => DataState(
        id: json["id"],
        attributes: Attributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes?.toJson(),
      };
}

class Attributes {
  String name;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  String code;

  Attributes({
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.code,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        name: json["name"],
        description: json["description"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
        "code": code,
      };
}
