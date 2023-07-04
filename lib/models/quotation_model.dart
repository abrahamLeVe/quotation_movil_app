// import 'dart:convert';

// QuotationModel quotationModelFromJson(String str) =>
//     QuotationModel.fromJson(json.decode(str));

// String quotationModelToJson(QuotationModel data) => json.encode(data.toJson());

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
      };
}

class PdfVoucher {
  List<PdfVoucherDatum> data;

  PdfVoucher({
    required this.data,
  });

  factory PdfVoucher.fromJson(Map<String, dynamic> json) => PdfVoucher(
        data: List<PdfVoucherDatum>.from(
            json["data"].map((x) => PdfVoucherDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
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
  String ext;
  String mime;
  double size;
  String url;
  dynamic previewUrl;
  String provider;
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

class Product {
  int id;
  String name;
  List<Size> size;
  int quantity;
  int? quotationPrice;

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
        quotationPrice: json["quotation_price"],
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
  int quotationPrice;

  Size({
    required this.id,
    required this.val,
    required this.quantity,
    required this.quotationPrice,
  });

  factory Size.fromJson(Map<String, dynamic> json) => Size(
        id: json["id"],
        val: json["val"],
        quantity: json["quantity"],
        quotationPrice: json["quotation_price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "val": val,
        "quantity": quantity,
        "quotation_price": quotationPrice,
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
