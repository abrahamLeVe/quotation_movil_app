class UpdateQuotationModel {
  DataQuotation data;

  UpdateQuotationModel({
    required this.data,
  });

  factory UpdateQuotationModel.fromJson(Map<String, dynamic> json) =>
      UpdateQuotationModel(
        data: DataQuotation.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class DataQuotation {
  int id;
  String name;
  String phone;
  String message;
  String email;
  List<ProductUpdate> products;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  List<PdfVoucher> pdfVoucher;
  dynamic statusQuotation;
  dynamic createdBy;
  dynamic updatedBy;
  String codeQuotation;

  DataQuotation({
    required this.id,
    required this.name,
    required this.phone,
    required this.message,
    required this.email,
    required this.products,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.pdfVoucher,
    this.statusQuotation,
    this.createdBy,
    this.updatedBy,
    required this.codeQuotation,
  });

  factory DataQuotation.fromJson(Map<String, dynamic> json) => DataQuotation(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        message: json["message"],
        email: json["email"],
        products: List<ProductUpdate>.from(
            json["products"].map((x) => ProductUpdate.fromJson(x))),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        pdfVoucher: List<PdfVoucher>.from(
            json["pdfVoucher"].map((x) => PdfVoucher.fromJson(x))),
        statusQuotation: json["status_quotation"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        codeQuotation: json["code_quotation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "message": message,
        "email": email,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
        "pdfVoucher": List<dynamic>.from(pdfVoucher.map((x) => x.toJson())),
        "status_quotation": statusQuotation,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "code_quotation": codeQuotation,
      };
}

class PdfVoucher {
  int id;
  String name;
  dynamic alternativeText;
  dynamic caption;
  dynamic width;
  dynamic height;
  dynamic formats;
  String hash;
  String ext;
  String mime;
  double size;
  String url;
  dynamic previewUrl;
  String provider;
  ProviderMetadata providerMetadata;
  String folderPath;
  DateTime createdAt;
  DateTime updatedAt;

  PdfVoucher({
    required this.id,
    required this.name,
    this.alternativeText,
    this.caption,
    this.width,
    this.height,
    this.formats,
    required this.hash,
    required this.ext,
    required this.mime,
    required this.size,
    required this.url,
    this.previewUrl,
    required this.provider,
    required this.providerMetadata,
    required this.folderPath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PdfVoucher.fromJson(Map<String, dynamic> json) => PdfVoucher(
        id: json["id"],
        name: json["name"],
        alternativeText: json["alternativeText"],
        caption: json["caption"],
        width: json["width"],
        height: json["height"],
        formats: json["formats"],
        hash: json["hash"],
        ext: json["ext"],
        mime: json["mime"],
        size: json["size"]?.toDouble(),
        url: json["url"],
        previewUrl: json["previewUrl"],
        provider: json["provider"],
        providerMetadata: ProviderMetadata.fromJson(json["provider_metadata"]),
        folderPath: json["folderPath"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "alternativeText": alternativeText,
        "caption": caption,
        "width": width,
        "height": height,
        "formats": formats,
        "hash": hash,
        "ext": ext,
        "mime": mime,
        "size": size,
        "url": url,
        "previewUrl": previewUrl,
        "provider": provider,
        "provider_metadata": providerMetadata.toJson(),
        "folderPath": folderPath,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class ProviderMetadata {
  String publicId;
  String resourceType;

  ProviderMetadata({
    required this.publicId,
    required this.resourceType,
  });

  factory ProviderMetadata.fromJson(Map<String, dynamic> json) =>
      ProviderMetadata(
        publicId: json["public_id"],
        resourceType: json["resource_type"],
      );

  Map<String, dynamic> toJson() => {
        "public_id": publicId,
        "resource_type": resourceType,
      };
}

class ProductUpdate {
  int id;
  String name;
  List<Size> size;
  int quantity;
  double quotationPrice;

  ProductUpdate({
    required this.id,
    required this.name,
    required this.size,
    required this.quantity,
    required this.quotationPrice,
  });

  factory ProductUpdate.fromJson(Map<String, dynamic> json) => ProductUpdate(
        id: json["id"],
        name: json["name"],
        size: List<Size>.from(json["size"].map((x) => Size.fromJson(x))),
        quantity: json["quantity"],
        quotationPrice: json["quotation_price"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "size": List<dynamic>.from(size.map((x) => x.toJson())),
        "quantity": quantity,
        "quotation_price": quotationPrice,
      };
}

class Size {
  dynamic id;
  String val;
  int quantity;
  double quotationPrice;

  Size({
    this.id,
    required this.val,
    required this.quantity,
    required this.quotationPrice,
  });

  factory Size.fromJson(Map<String, dynamic> json) => Size(
        id: json["id"],
        val: json["val"],
        quantity: json["quantity"],
        quotationPrice: json["quotation_price"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "val": val,
        "quantity": quantity,
        "quotation_price": quotationPrice,
      };
}
