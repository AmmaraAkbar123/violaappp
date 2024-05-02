
class Mydata {
  bool success;
  Data data;
  String message;

  Mydata({
    required this.success,
    required this.data,
    required this.message,
  });

  factory Mydata.fromJson(Map<String, dynamic> json) => Mydata(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  int currentPage;
  List<Datum> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String nextPageUrl;
  String path;
  String perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  Data({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"] as int? ?? 0,
        data: (json["data"] as List<dynamic>?)
                ?.map((x) => Datum.fromJson(x as Map<String, dynamic>))
                .toList() ??
            [],
        firstPageUrl: json["first_page_url"] as String? ?? '',
        from: json["from"] as int? ?? 0,
        lastPage: json["last_page"] as int? ?? 0,
        lastPageUrl: json["last_page_url"] as String? ?? '',
        nextPageUrl: json["next_page_url"] as String? ?? '',
        path: json["path"] as String? ?? '',
        perPage: json["per_page"] as String? ?? '',
        prevPageUrl: json["prev_page_url"] as String?,
        to: json["to"] as int? ?? 0,
        total: json["total"] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Datum {
  double distance;
  double area;
  int id;
  Description name;
  int salonLevelId;
  int addressId;
  Description description;
  String phoneNumber;
  String mobileNumber;
  int availabilityRange;
  bool available;
  bool featured;
  bool accepted;
  String serviceDesc;
  String addressDesc;
  String homeDesc;
  String descriptionLength;
  int showOnHomePage;
  String tags;
  bool hasMedia;
  int rate;
  bool closed;
  int totalReviews;
  List<Media> media;
  List<AvailabilityHour> availabilityHours;
  String bookingMethod;

  String generalNotes;
  String dailyNotes;
  String promotions;
  String dailyNotesLength;
  String generalNotesLength;


  Datum({
    required this.distance,
    required this.area,
    required this.id,
    required this.name,
    required this.salonLevelId,
    required this.addressId,
    required this.description,
    required this.phoneNumber,
    required this.mobileNumber,
    required this.availabilityRange,
    required this.available,
    required this.featured,
    required this.accepted,
    required this.serviceDesc,
    required this.addressDesc,
    required this.homeDesc,
    required this.descriptionLength,
    required this.showOnHomePage,
    required this.tags,
    required this.hasMedia,
    required this.rate,
    required this.closed,
    required this.totalReviews,
    required this.media,
    required this.availabilityHours,
    required this.bookingMethod,

    required this.generalNotes,
    required this.dailyNotes,
    required this.promotions,
    required this.dailyNotesLength,
    required this.generalNotesLength,
  
    
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
 
  return Datum(
    distance: (json["distance"] as num?)?.toDouble() ?? 0.0,
    area: (json["area"] as num?)?.toDouble() ?? 0.0,
    id: json["id"] as int? ?? 0,
    name: Description.fromJson(json["name"] as Map<String, dynamic>? ?? {'en': 'No name'}),
    salonLevelId: json["salon_level_id"] as int? ?? 0,
    addressId: json["address_id"] as int? ?? 0,
    description: Description.fromJson(json["description"] as Map<String, dynamic>? ?? {'en': 'No description'}),
    phoneNumber: json["phone_number"] as String? ?? '',
    mobileNumber: json["mobile_number"] as String? ?? '',
    availabilityRange: json["availability_range"] as int? ?? 0,
    available: json["available"] as bool? ?? false,
    featured: json["featured"] as bool? ?? false,
    accepted: json["accepted"] as bool? ?? false,
    serviceDesc: json["service_desc"] as String? ?? '',
    addressDesc: json["address_desc"] as String? ?? '',
    homeDesc: json["home_desc"] as String? ?? '',
    descriptionLength: json["description_length"] as String? ?? '',
    showOnHomePage: json["show_on_home_page"] as int? ?? 0,
    tags: json["tags"] as String? ?? '',
    hasMedia: json["has_media"] as bool? ?? false,
    rate: json["rate"] as int? ?? 0,
    closed: json["closed"] as bool? ?? false,
    totalReviews: json["total_reviews"] as int? ?? 0,
    media: (json["media"] as List<dynamic>?)
        ?.map((x) => Media.fromJson(x as Map<String, dynamic>))
        .toList() ?? [],
    availabilityHours: (json["availability_hours"] as List<dynamic>?)
        ?.map((x) => AvailabilityHour.fromJson(x as Map<String, dynamic>))
        .toList() ?? [],
    bookingMethod: json["booking_method"] as String? ?? '',
    generalNotes: json["general_notes"] as String? ?? '',
    dailyNotes: json["daily_notes"] as String? ?? '',
    promotions: json["promotions"] as String? ?? '',

    dailyNotesLength: json["daily_notes_length"] as String? ?? '',
    generalNotesLength: json["general_notes_length"] as String? ?? '',
  );
}


  Map<String, dynamic> toJson() => {
        "distance": distance,
        "area": area,
        "id": id,
        "name": name.toJson(),
        "salon_level_id": salonLevelId,
        "address_id": addressId,
        "description": description.toJson(),
        "phone_number": phoneNumber,
        "mobile_number": mobileNumber,
        "availability_range": availabilityRange,
        "available": available,
        "featured": featured,
        "accepted": accepted,
        "service_desc": serviceDesc,
        "address_desc": addressDesc,
        "home_desc": homeDesc,
        "description_length": descriptionLength,
        "show_on_home_page": showOnHomePage,
        "tags": tags,
        "has_media": hasMedia,
        "rate": rate,
        "closed": closed,
        "total_reviews": totalReviews,
        "media": List<dynamic>.from(media.map((x) => x.toJson())),
        "availability_hours":
            List<dynamic>.from(availabilityHours.map((x) => x.toJson())),
        "booking_method": bookingMethod,

        "general_notes": generalNotes,
        "daily_notes": dailyNotes,
        "promotions": promotions,
        
        "daily_notes_length": dailyNotesLength,
        "general_notes_length": generalNotesLength,

      };
}

class AvailabilityHour {
  int id;
  String day;
  String startAt;
  String endAt;
  Description data;
  int salonId;
  dynamic deletedAt;
  List<dynamic> customFields;

  AvailabilityHour({
    required this.id,
    required this.day,
    required this.startAt,
    required this.endAt,
    required this.data,
    required this.salonId,
    required this.deletedAt,
    required this.customFields,
  });

  factory AvailabilityHour.fromJson(Map<String, dynamic> json) =>
      AvailabilityHour(
        id: json["id"],
        day: json["day"],
        startAt: json["start_at"],
        endAt: json["end_at"],
        data: Description.fromJson(json["data"]),
        salonId: json["salon_id"],
        deletedAt: json["deleted_at"],
        customFields: List<dynamic>.from(json["custom_fields"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "day": day,
        "start_at": startAt,
        "end_at": endAt,
        "data": data.toJson(),
        "salon_id": salonId,
        "deleted_at": deletedAt,
        "custom_fields": List<dynamic>.from(customFields.map((x) => x)),
      };
}

class Description {
  String en;

  Description({required this.en});

  factory Description.fromJson(Map<String, dynamic> json) {
    return Description(en: json['en'] as String? ?? "Default Description");
  }

  Map<String, dynamic> toJson() => {
    'en': en,
  };
}

class Media {
  int id;
  String name;
  CustomProperties customProperties;
  String cover;
  String url;
  String thumb;
  String icon;
  String formatedSize;

  Media({
    required this.id,
    required this.name,
    required this.customProperties,
    required this.cover,
    required this.url,
    required this.thumb,
    required this.icon,
    required this.formatedSize,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        id: json["id"],
        name: json["name"],
        customProperties: CustomProperties.fromJson(json["custom_properties"]),
        cover: json["cover"],
        url: json["url"],
        thumb: json["thumb"],
        icon: json["icon"],
        formatedSize: json["formated_size"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "custom_properties": customProperties.toJson(),
        "cover": cover,
        "url": url,
        "thumb": thumb,
        "icon": icon,
        "formated_size": formatedSize,
      };
}

class CustomProperties {
  String uuid;
  int userId;
  GeneratedConversions generatedConversions;

  CustomProperties({
    required this.uuid,
    required this.userId,
    required this.generatedConversions,
  });

  factory CustomProperties.fromJson(Map<String, dynamic> json) =>
      CustomProperties(
        uuid: json["uuid"],
        userId: json["user_id"],
        generatedConversions:
            GeneratedConversions.fromJson(json["generated_conversions"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "user_id": userId,
        "generated_conversions": generatedConversions.toJson(),
      };
}

class GeneratedConversions {
  bool thumb;
  bool icon;

  GeneratedConversions({
    required this.thumb,
    required this.icon,
  });

  factory GeneratedConversions.fromJson(Map<String, dynamic> json) =>
      GeneratedConversions(
        thumb: json["thumb"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "thumb": thumb,
        "icon": icon,
      };
}