// To parse this JSON data, do
//
//     final priceModel = priceModelFromJson(jsonString);

import 'dart:convert';

PriceModel priceModelFromJson(String str) =>
    PriceModel.fromJson(json.decode(str));

String priceModelToJson(PriceModel data) => json.encode(data.toJson());

class PriceModel {
  List<PriceModelData> data;
  Meta meta;

  PriceModel({
    required this.data,
    required this.meta,
  });

  factory PriceModel.fromJson(Map<String, dynamic> json) => PriceModel(
        data: List<PriceModelData>.from(
            json["data"].map((x) => PriceModelData.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class PriceModelData {
  int id;
  PurpleAttributes attributes;

  PriceModelData({
    required this.id,
    required this.attributes,
  });

  factory PriceModelData.fromJson(Map<String, dynamic> json) => PriceModelData(
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
  String description;
  String slug;
  int rating;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  Thumbnail thumbnail;
  Brand brand;
  Prices prices;

  PurpleAttributes({
    required this.name,
    required this.description,
    required this.slug,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.thumbnail,
    required this.brand,
    required this.prices,
  });

  factory PurpleAttributes.fromJson(Map<String, dynamic> json) =>
      PurpleAttributes(
        name: json["name"],
        description: json["description"],
        slug: json["slug"],
        rating: json["rating"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        thumbnail: Thumbnail.fromJson(json["thumbnail"]),
        brand: Brand.fromJson(json["brand"]),
        prices: Prices.fromJson(json["prices"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "slug": slug,
        "rating": rating,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
        "thumbnail": thumbnail.toJson(),
        "brand": brand.toJson(),
        "prices": prices.toJson(),
      };
}

class Brand {
  Dat? data;

  Brand({
    required this.data,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        data: json["data"] == null ? null : Dat.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Dat {
  int id;
  FluffyAttributes attributes;

  Dat({
    required this.id,
    required this.attributes,
  });

  factory Dat.fromJson(Map<String, dynamic> json) => Dat(
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
  String? slug;
  String? description;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  String? code;

  FluffyAttributes({
    required this.name,
    this.slug,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    this.code,
  });

  factory FluffyAttributes.fromJson(Map<String, dynamic> json) =>
      FluffyAttributes(
        name: json["name"],
        slug: json["slug"],
        description: json["description"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "description": description,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
        "code": code,
      };
}

class Prices {
  List<PricesDatum> data;

  Prices({
    required this.data,
  });

  factory Prices.fromJson(Map<String, dynamic> json) => Prices(
        data: List<PricesDatum>.from(
            json["data"].map((x) => PricesDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class PricesDatum {
  int id;
  TentacledAttributes attributes;

  PricesDatum({
    required this.id,
    required this.attributes,
  });

  factory PricesDatum.fromJson(Map<String, dynamic> json) => PricesDatum(
        id: json["id"],
        attributes: TentacledAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

class TentacledAttributes {
  String name;
  double value;
  double discount;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  ProductColors productColors;
  Size size;

  TentacledAttributes({
    required this.name,
    required this.value,
    required this.discount,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.productColors,
    required this.size,
  });

  factory TentacledAttributes.fromJson(Map<String, dynamic> json) =>
      TentacledAttributes(
        name: json["name"],
        value: json["value"]?.toDouble(),
        discount: json["discount"]?.toDouble(),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        productColors: ProductColors.fromJson(json["product_colors"]),
        size: Size.fromJson(json["size"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
        "discount": discount,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
        "product_colors": productColors.toJson(),
        "size": size.toJson(),
      };
}

class ProductColors {
  List<Dat> data;

  ProductColors({
    required this.data,
  });

  factory ProductColors.fromJson(Map<String, dynamic> json) => ProductColors(
        data: List<Dat>.from(json["data"].map((x) => Dat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Size {
  SizeData? data;

  Size({
    required this.data,
  });

  factory Size.fromJson(Map<String, dynamic> json) => Size(
        data: json["data"] == null ? null : SizeData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class SizeData {
  int id;
  StickyAttributes attributes;

  SizeData({
    required this.id,
    required this.attributes,
  });

  factory SizeData.fromJson(Map<String, dynamic> json) => SizeData(
        id: json["id"],
        attributes: StickyAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

class StickyAttributes {
  String name;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  double value;

  StickyAttributes({
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.value,
  });

  factory StickyAttributes.fromJson(Map<String, dynamic> json) =>
      StickyAttributes(
        name: json["name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        value: json["value"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
        "value": value,
      };
}

class Thumbnail {
  ThumbnailData data;

  Thumbnail({
    required this.data,
  });

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
        data: ThumbnailData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class ThumbnailData {
  int id;
  IndigoAttributes attributes;

  ThumbnailData({
    required this.id,
    required this.attributes,
  });

  factory ThumbnailData.fromJson(Map<String, dynamic> json) => ThumbnailData(
        id: json["id"],
        attributes: IndigoAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

class IndigoAttributes {
  String name;
  dynamic alternativeText;
  dynamic caption;
  int width;
  int height;
  Formats formats;
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

  IndigoAttributes({
    required this.name,
    required this.alternativeText,
    required this.caption,
    required this.width,
    required this.height,
    required this.formats,
    required this.hash,
    required this.ext,
    required this.mime,
    required this.size,
    required this.url,
    required this.previewUrl,
    required this.provider,
    required this.providerMetadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IndigoAttributes.fromJson(Map<String, dynamic> json) =>
      IndigoAttributes(
        name: json["name"],
        alternativeText: json["alternativeText"],
        caption: json["caption"],
        width: json["width"],
        height: json["height"],
        formats: Formats.fromJson(json["formats"]),
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
        "formats": formats.toJson(),
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

enum Ext { WEBP }

final extValues = EnumValues({".webp": Ext.WEBP});

class Formats {
  Small small;
  Small thumbnail;

  Formats({
    required this.small,
    required this.thumbnail,
  });

  factory Formats.fromJson(Map<String, dynamic> json) => Formats(
        small: Small.fromJson(json["small"]),
        thumbnail: Small.fromJson(json["thumbnail"]),
      );

  Map<String, dynamic> toJson() => {
        "small": small.toJson(),
        "thumbnail": thumbnail.toJson(),
      };
}

class Small {
  Ext ext;
  String url;
  String hash;
  Mime mime;
  String name;
  dynamic path;
  double size;
  int width;
  int height;
  ProviderMetadata providerMetadata;
  int? sizeInBytes;

  Small({
    required this.ext,
    required this.url,
    required this.hash,
    required this.mime,
    required this.name,
    required this.path,
    required this.size,
    required this.width,
    required this.height,
    required this.providerMetadata,
    this.sizeInBytes,
  });

  factory Small.fromJson(Map<String, dynamic> json) => Small(
        ext: extValues.map[json["ext"]]!,
        url: json["url"],
        hash: json["hash"],
        mime: mimeValues.map[json["mime"]]!,
        name: json["name"],
        path: json["path"],
        size: json["size"]?.toDouble(),
        width: json["width"],
        height: json["height"],
        providerMetadata: ProviderMetadata.fromJson(json["provider_metadata"]),
        sizeInBytes: json["sizeInBytes"],
      );

  Map<String, dynamic> toJson() => {
        "ext": extValues.reverse[ext],
        "url": url,
        "hash": hash,
        "mime": mimeValues.reverse[mime],
        "name": name,
        "path": path,
        "size": size,
        "width": width,
        "height": height,
        "provider_metadata": providerMetadata.toJson(),
        "sizeInBytes": sizeInBytes,
      };
}

enum Mime { IMAGE_WEBP }

final mimeValues = EnumValues({"image/webp": Mime.IMAGE_WEBP});

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

enum Provider { CLOUDINARY }

final providerValues = EnumValues({"cloudinary": Provider.CLOUDINARY});

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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
