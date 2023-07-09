class GetDetailsQuotation {
  Data data;
  Meta meta;

  GetDetailsQuotation({
    required this.data,
    required this.meta,
  });

  factory GetDetailsQuotation.fromJson(Map<String, dynamic> json) =>
      GetDetailsQuotation(
        data: Data.fromJson(json["data"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "meta": meta.toJson(),
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
  String phone;
  String message;
  String email;
  List<ProductDeail> products;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  String codeQuotation;
  PdfVoucher pdfVoucher;
  PdfVoucher statusQuotation;

  DataAttributes({
    required this.name,
    required this.phone,
    required this.message,
    required this.email,
    required this.products,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.codeQuotation,
    required this.pdfVoucher,
    required this.statusQuotation,
  });

  factory DataAttributes.fromJson(Map<String, dynamic> json) => DataAttributes(
        name: json["name"],
        phone: json["phone"],
        message: json["message"],
        email: json["email"],
        products: List<ProductDeail>.from(
            json["products"].map((x) => ProductDeail.fromJson(x))),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        codeQuotation: json["code_quotation"],
        pdfVoucher: PdfVoucher.fromJson(json["pdfVoucher"]),
        statusQuotation: PdfVoucher.fromJson(json["status_quotation"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "message": message,
        "email": email,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
        "code_quotation": codeQuotation,
        "pdfVoucher": pdfVoucher.toJson(),
        "status_quotation": statusQuotation.toJson(),
      };
}

class PdfVoucher {
  List<Datum>? data;

  PdfVoucher({
    this.data,
  });

  factory PdfVoucher.fromJson(Map<String, dynamic> json) => PdfVoucher(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  DatumAttributes attributes;

  Datum({
    required this.id,
    required this.attributes,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        attributes: DatumAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

class DatumAttributes {
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
  DateTime createdAt;
  DateTime updatedAt;

  DatumAttributes({
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
    required this.createdAt,
    required this.updatedAt,
  });

  factory DatumAttributes.fromJson(Map<String, dynamic> json) =>
      DatumAttributes(
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
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
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

class ProductDeail {
  int id;
  String name;
  List<Size> size;
  int quantity;
  double? quotationPrice;

  ProductDeail({
    required this.id,
    required this.name,
    required this.size,
    required this.quantity,
    this.quotationPrice,
  });

  factory ProductDeail.fromJson(Map<String, dynamic> json) => ProductDeail(
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
  int id;
  String val;
  int quantity;
  double? quotationPrice;

  Size({
    required this.id,
    required this.val,
    required this.quantity,
    this.quotationPrice,
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

class Meta {
  Meta();

  factory Meta.fromJson(Map<String, dynamic> json) => Meta();

  Map<String, dynamic> toJson() => {};
}
