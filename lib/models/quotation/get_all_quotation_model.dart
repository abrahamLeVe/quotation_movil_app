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

class QuotationUpdateModel {
  Quotation data;

  QuotationUpdateModel({
    required this.data,
  });

  factory QuotationUpdateModel.fromJson(Map<String, dynamic> json) =>
      QuotationUpdateModel(
        data: Quotation.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Quotation {
  int id;
  PurpleAttributes attributes;

  Quotation({
    required this.id,
    required this.attributes,
  });

  factory Quotation.fromJson(Map<String, dynamic> json) => Quotation(
        id: json["id"],
        attributes: PurpleAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

class PurpleAttributes {
  String name;
  String phone;
  String message;
  String email;
  List<Product> products;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  PdfVoucher pdfVoucher;
  StatusQuotation? statusQuotation;
  String codeQuotation;

  PurpleAttributes({
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
    required this.codeQuotation,
  });

  factory PurpleAttributes.fromJson(Map<String, dynamic> json) =>
      PurpleAttributes(
        name: json["name"],
        phone: json["phone"],
        message: json["message"],
        email: json["email"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        pdfVoucher: PdfVoucher.fromJson(json["pdfVoucher"]),
        statusQuotation: StatusQuotation.fromJson(json["status_quotation"]),
        codeQuotation: json["code_quotation"],
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
        "pdfVoucher": pdfVoucher.toJson(),
        "status_quotation": statusQuotation?.toJson(),
      };
}

class PdfVoucher {
  List<PdfVoucherDatum>? data;

  PdfVoucher({
    this.data,
  });

  factory PdfVoucher.fromJson(Map<String, dynamic> json) => PdfVoucher(
        data: json["data"] == null
            ? []
            : List<PdfVoucherDatum>.from(
                json["data"]!.map((x) => PdfVoucherDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class PdfVoucherDatum {
  int id;
  FluffyAttributes attributes;

  PdfVoucherDatum({
    required this.id,
    required this.attributes,
  });

  factory PdfVoucherDatum.fromJson(Map<String, dynamic> json) =>
      PdfVoucherDatum(
        id: json["id"],
        attributes: FluffyAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

class FluffyAttributes {
  String name;
  dynamic alternativeText;
  dynamic caption;
  dynamic width;
  dynamic height;
  dynamic formats;
  String hash;
  Ext ext;
  Mime mime;
  double size;
  String url;
  dynamic previewUrl;
  Provider provider;
  ProviderMetadata providerMetadata;
  DateTime createdAt;
  DateTime updatedAt;

  FluffyAttributes({
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

  factory FluffyAttributes.fromJson(Map<String, dynamic> json) =>
      FluffyAttributes(
        name: json["name"],
        alternativeText: json["alternativeText"],
        caption: json["caption"],
        width: json["width"],
        height: json["height"],
        formats: json["formats"],
        hash: json["hash"],
        ext: extValues.map[json["ext"]]!,
        mime: mimeValues.map[json["mime"]]!,
        size: json["size"]?.toDouble(),
        url: json["url"],
        previewUrl: json["previewUrl"],
        provider: providerValues.map[json["provider"]]!,
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
        "ext": extValues.reverse[ext],
        "mime": mimeValues.reverse[mime],
        "size": size,
        "url": url,
        "previewUrl": previewUrl,
        "provider": providerValues.reverse[provider],
        "provider_metadata": providerMetadata.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

enum Ext { PDF }

final extValues = EnumValues({".pdf": Ext.PDF});

enum Mime { APPLICATION_PDF }

final mimeValues = EnumValues({"application/pdf": Mime.APPLICATION_PDF});

enum Provider { CLOUDINARY }

final providerValues = EnumValues({"cloudinary": Provider.CLOUDINARY});

class ProviderMetadata {
  String publicId;
  ResourceType resourceType;

  ProviderMetadata({
    required this.publicId,
    required this.resourceType,
  });

  factory ProviderMetadata.fromJson(Map<String, dynamic> json) =>
      ProviderMetadata(
        publicId: json["public_id"],
        resourceType: resourceTypeValues.map[json["resource_type"]]!,
      );

  Map<String, dynamic> toJson() => {
        "public_id": publicId,
        "resource_type": resourceTypeValues.reverse[resourceType],
      };
}

enum ResourceType { IMAGE }

final resourceTypeValues = EnumValues({"image": ResourceType.IMAGE});

class Product {
  int id;
  String name;
  List<Size> size;
  int quantity;
  double? quotationPrice;

  Product({
    required this.id,
    required this.name,
    required this.size,
    required this.quantity,
    this.quotationPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
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
  int? id;
  String val;
  int quantity;
  double? quotationPrice;

  Size({
    this.id,
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

class StatusQuotation {
  Data? data;

  StatusQuotation({
    this.data,
  });

  factory StatusQuotation.fromJson(Map<String, dynamic> json) =>
      StatusQuotation(
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
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;

  DataAttributes({
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  factory DataAttributes.fromJson(Map<String, dynamic> json) => DataAttributes(
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
      };
}

class Meta {
  Pagination? pagination;

  Meta({
    required this.pagination,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        pagination: Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination?.toJson(),
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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
