// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

// import 'dart:convert';

// ProductModel productModelFromJson(String str) =>
//     ProductModel.fromJson(json.decode(str));

// String productModelToJson(ProductModel data) => json.encode(data.toJson());



class ProductModel {
  List<Product> data;
  Meta meta;

  ProductModel({
    required this.data,
    required this.meta,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        data: List<Product>.from(json["data"].map((x) => Product.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class ProductUpdateModel {
  Product data;

  ProductUpdateModel({
    required this.data,
  });

  factory ProductUpdateModel.fromJson(Map<String, dynamic> json) =>
      ProductUpdateModel(
        data: Product.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Product {
  int id;
  PurpleAttributes attributes;

  Product({
    required this.id,
    required this.attributes,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
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
  dynamic subtitle;
  String description;
  String slug;
  double? quotationPrice;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  Image image;
  Thumbnail thumbnail;
  Categories categories;
  ProductSizes productSizes;

  PurpleAttributes({
    required this.name,
    this.subtitle,
    required this.description,
    required this.slug,
    this.quotationPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.image,
    required this.thumbnail,
    required this.categories,
    required this.productSizes,
  });

  factory PurpleAttributes.fromJson(Map<String, dynamic> json) =>
      PurpleAttributes(
        name: json["name"],
        subtitle: json["subtitle"],
        description: json["description"],
        slug: json["slug"],
        quotationPrice: json["quotation_price"]?.toDouble(),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        image: Image.fromJson(json["image"]),
        thumbnail: Thumbnail.fromJson(json["thumbnail"]),
        categories: Categories.fromJson(json["categories"]),
        productSizes: ProductSizes.fromJson(json["product_sizes"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "subtitle": subtitle,
        "description": description,
        "slug": slug,
        "quotation_price": quotationPrice,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
        "image": image.toJson(),
        "thumbnail": thumbnail.toJson(),
        "categories": categories.toJson(),
        "product_sizes": productSizes.toJson(),
      };
}

class Categories {
  List<CategoriesDatum> data;

  Categories({
    required this.data,
  });

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        data: List<CategoriesDatum>.from(
            json["data"].map((x) => CategoriesDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CategoriesDatum {
  int id;
  FluffyAttributes attributes;

  CategoriesDatum({
    required this.id,
    required this.attributes,
  });

  factory CategoriesDatum.fromJson(Map<String, dynamic> json) =>
      CategoriesDatum(
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
  String slug;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;

  FluffyAttributes({
    required this.name,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  factory FluffyAttributes.fromJson(Map<String, dynamic> json) =>
      FluffyAttributes(
        name: json["name"],
        slug: json["slug"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
      };
}

class Image {
  List<ImageDatum> data;

  Image({
    required this.data,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        data: List<ImageDatum>.from(
            json["data"].map((x) => ImageDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ImageDatum {
  int id;
  TentacledAttributes attributes;

  ImageDatum({
    required this.id,
    required this.attributes,
  });

  factory ImageDatum.fromJson(Map<String, dynamic> json) => ImageDatum(
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
  dynamic alternativeText;
  dynamic caption;
  int width;
  int height;
  PurpleFormats formats;
  String hash;
  Ext ext;
  Mime mime;
  double size;
  String url;
  dynamic previewUrl;
  String provider;
  ProviderMetadata providerMetadata;
  DateTime createdAt;
  DateTime updatedAt;

  TentacledAttributes({
    required this.name,
    this.alternativeText,
    this.caption,
    required this.width,
    required this.height,
    required this.formats,
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

  factory TentacledAttributes.fromJson(Map<String, dynamic> json) =>
      TentacledAttributes(
        name: json["name"],
        alternativeText: json["alternativeText"],
        caption: json["caption"],
        width: json["width"],
        height: json["height"],
        formats: PurpleFormats.fromJson(json["formats"]),
        hash: json["hash"],
        ext: extValues.map[json["ext"]]!,
        mime: mimeValues.map[json["mime"]]!,
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
        "formats": formats.toJson(),
        "hash": hash,
        "ext": extValues.reverse[ext],
        "mime": mimeValues.reverse[mime],
        "size": size,
        "url": url,
        "previewUrl": previewUrl,
        "provider": provider,
        "provider_metadata": providerMetadata.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

enum Ext { WEBP }

final extValues = EnumValues({".webp": Ext.WEBP});

class PurpleFormats {
  Small large;
  Small small;
  Small medium;
  Small thumbnail;

  PurpleFormats({
    required this.large,
    required this.small,
    required this.medium,
    required this.thumbnail,
  });

  factory PurpleFormats.fromJson(Map<String, dynamic> json) => PurpleFormats(
        large: Small.fromJson(json["large"]),
        small: Small.fromJson(json["small"]),
        medium: Small.fromJson(json["medium"]),
        thumbnail: Small.fromJson(json["thumbnail"]),
      );

  Map<String, dynamic> toJson() => {
        "large": large.toJson(),
        "small": small.toJson(),
        "medium": medium.toJson(),
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

  Small({
    required this.ext,
    required this.url,
    required this.hash,
    required this.mime,
    required this.name,
    this.path,
    required this.size,
    required this.width,
    required this.height,
    required this.providerMetadata,
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

class ProductSizes {
  List<ProductSizesDatum> data;

  ProductSizes({
    required this.data,
  });

  factory ProductSizes.fromJson(Map<String, dynamic> json) => ProductSizes(
        data: List<ProductSizesDatum>.from(
            json["data"].map((x) => ProductSizesDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ProductSizesDatum {
  int id;
  StickyAttributes attributes;

  ProductSizesDatum({
    required this.id,
    required this.attributes,
  });

  factory ProductSizesDatum.fromJson(Map<String, dynamic> json) =>
      ProductSizesDatum(
        id: json["id"],
        attributes: StickyAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

class StickyAttributes {
  double? quotationPrice;
  String val;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;

  StickyAttributes({
    this.quotationPrice,
    required this.val,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  factory StickyAttributes.fromJson(Map<String, dynamic> json) =>
      StickyAttributes(
        quotationPrice: json["quotation_price"]?.toDouble(),
        val: json["val"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "quotation_price": quotationPrice,
        "val": val,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
      };
}

class Thumbnail {
  Data data;

  Thumbnail({
    required this.data,
  });

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
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
  dynamic alternativeText;
  dynamic caption;
  int width;
  int height;
  FluffyFormats formats;
  String hash;
  Ext ext;
  Mime mime;
  double size;
  String url;
  dynamic previewUrl;
  String provider;
  ProviderMetadata providerMetadata;
  DateTime createdAt;
  DateTime updatedAt;

  DataAttributes({
    required this.name,
    this.alternativeText,
    this.caption,
    required this.width,
    required this.height,
    required this.formats,
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

  factory DataAttributes.fromJson(Map<String, dynamic> json) => DataAttributes(
        name: json["name"],
        alternativeText: json["alternativeText"],
        caption: json["caption"],
        width: json["width"],
        height: json["height"],
        formats: FluffyFormats.fromJson(json["formats"]),
        hash: json["hash"],
        ext: extValues.map[json["ext"]]!,
        mime: mimeValues.map[json["mime"]]!,
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
        "formats": formats.toJson(),
        "hash": hash,
        "ext": extValues.reverse[ext],
        "mime": mimeValues.reverse[mime],
        "size": size,
        "url": url,
        "previewUrl": previewUrl,
        "provider": provider,
        "provider_metadata": providerMetadata.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class FluffyFormats {
  Small small;
  Small thumbnail;

  FluffyFormats({
    required this.small,
    required this.thumbnail,
  });

  factory FluffyFormats.fromJson(Map<String, dynamic> json) => FluffyFormats(
        small: Small.fromJson(json["small"]),
        thumbnail: Small.fromJson(json["thumbnail"]),
      );

  Map<String, dynamic> toJson() => {
        "small": small.toJson(),
        "thumbnail": thumbnail.toJson(),
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
