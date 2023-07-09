class DeleteQuotation {
  String message;

  DeleteQuotation({
    required this.message,
  });

  factory DeleteQuotation.fromJson(Map<String, dynamic> json) =>
      DeleteQuotation(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
