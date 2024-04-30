class UpdateContactModel {
  UpdateContact data;

  UpdateContactModel({
    required this.data,
  });

  factory UpdateContactModel.fromJson(Map<String, dynamic> json) =>
      UpdateContactModel(
        data: UpdateContact.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class UpdateContact {
  int id;
  String responseContact;
  bool stateMessage;
  dynamic publishedAt;

  UpdateContact({
    required this.id,
    required this.responseContact,
    required this.stateMessage,
    required this.publishedAt,
  });

  factory UpdateContact.fromJson(Map<String, dynamic> json) => UpdateContact(
        id: json["id"],
        responseContact: json["responseContact"],
        stateMessage: json["stateMessage"],
        publishedAt: json["publishedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "responseContact": responseContact,
        "stateMessage": stateMessage,
        "publishedAt": publishedAt,
      };
}
