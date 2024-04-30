class ContactModel {
  List<Contact> data;
  Meta meta;

  ContactModel({
    required this.data,
    required this.meta,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        data: List<Contact>.from(json["data"].map((x) => Contact.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class Contact {
  int id;
  ContactAttributes attributes;

  Contact({
    required this.id,
    required this.attributes,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json["id"],
        attributes: ContactAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

class ContactAttributes {
  String name;
  String email;
  String phone;
  String message;
  String? responseContact;
  bool stateMessage;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  String title;
  int rating;
  ContactType contactType;

  ContactAttributes({
    required this.name,
    required this.email,
    required this.phone,
    required this.message,
    required this.responseContact,
    required this.stateMessage,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.title,
    required this.rating,
    required this.contactType,
  });

  factory ContactAttributes.fromJson(Map<String, dynamic> json) =>
      ContactAttributes(
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        message: json["message"],
        responseContact: json["responseContact"],
        stateMessage: json["stateMessage"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        title: json["title"],
        rating: json["rating"],
        contactType: ContactType.fromJson(json["contact_type"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone": phone,
        "message": message,
        "responseContact": responseContact,
        "stateMessage": stateMessage,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
        "title": title,
        "rating": rating,
        "contact_type": contactType.toJson(),
      };
}

class ContactType {
  Data data;

  ContactType({
    required this.data,
  });

  factory ContactType.fromJson(Map<String, dynamic> json) => ContactType(
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
  String? description;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;

  DataAttributes({
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  factory DataAttributes.fromJson(Map<String, dynamic> json) => DataAttributes(
        name: json["name"],
        description: json["description"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
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
