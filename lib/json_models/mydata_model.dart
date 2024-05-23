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
        success: json["success"] ?? false,
        data: json["data"] != null
            ? Data.fromJson(json["data"])
            : throw Exception('Data is null'),
        message: json["message"] ?? "",
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
  String? firstPageUrl; // Made nullable
  int from;
  int lastPage;
  String? lastPageUrl; // Made nullable
  String? nextPageUrl; // Made nullable
  String path;
  String perPage;
  String? prevPageUrl; // Made nullable
  int to;
  int total;

  Data({
    required this.currentPage,
    required this.data,
    this.firstPageUrl, // Nullable
    required this.from,
    required this.lastPage,
    this.lastPageUrl, // Nullable
    this.nextPageUrl, // Nullable
    required this.path,
    required this.perPage,
    this.prevPageUrl, // Nullable
    required this.to,
    required this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json['current_page'] as int,
        data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
        firstPageUrl: json['first_page_url'] as String?, // Handling nullable
        from: json['from'] as int,
        lastPage: json['last_page'] as int,
        lastPageUrl: json['last_page_url'] as String?,
        nextPageUrl: json['next_page_url'] as String?,
        path: json['path'] as String,
        perPage: json['per_page'] as String,
        prevPageUrl: json['prev_page_url'] as String?,
        to: json['to'] as int,
        total: json['total'] as int,
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
  final double latitude;
  final double longitude;

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
    required this.latitude,
    required this.longitude,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
        latitude: (json['latitude'] ?? 0).toDouble(),
        longitude: (json['longitude'] ?? 0).toDouble(),
        distance: (json["distance"] as num?)?.toDouble() ?? 0.0,
        area: (json["area"] as num?)?.toDouble() ?? 0.0,
        id: (json["id"] as num?)?.toInt() ?? 0,
        name: Description.fromJson(json["name"] as Map<String, dynamic>?),
        salonLevelId: (json["salon_level_id"] as num?)?.toInt() ?? 0,
        addressId: (json["address_id"] as num?)?.toInt() ?? 0,
        description:
            Description.fromJson(json["description"] as Map<String, dynamic>?),
        phoneNumber: json["phone_number"] as String? ?? '',
        mobileNumber: json["mobile_number"] as String? ?? '',
        availabilityRange: (json["availability_range"] as num?)?.toInt() ?? 0,
        available: json["available"] as bool? ?? false,
        featured: json["featured"] as bool? ?? false,
        accepted: json["accepted"] as bool? ?? false,
        serviceDesc: json["service_desc"] as String? ?? '',
        addressDesc: json["address_desc"] as String? ?? '',
        homeDesc: json["home_desc"] as String? ?? '',
        descriptionLength: json["description_length"] as String? ?? '',
        showOnHomePage: (json["show_on_home_page"] as num?)?.toInt() ?? 0,
        tags: json["tags"] as String? ?? '',
        hasMedia: json["has_media"] as bool? ?? false,
        rate: (json["rate"] as num?)?.toInt() ?? 0,
        closed: json["closed"] as bool? ?? false,
        totalReviews: (json["total_reviews"] as num?)?.toInt() ?? 0,
        media: (json["media"] as List<dynamic>?)
                ?.map((x) => Media.fromJson(x as Map<String, dynamic>))
                .toList() ??
            [],
        availabilityHours: (json["availability_hours"] as List<dynamic>?)
                ?.map(
                    (x) => AvailabilityHour.fromJson(x as Map<String, dynamic>))
                .toList() ??
            [],
        bookingMethod: json["booking_method"] as String? ?? '',
        generalNotes: json["general_notes"] as String? ?? '',
        dailyNotes: json["daily_notes"] as String? ?? '',
        promotions: json["promotions"] as String? ?? '',
        dailyNotesLength: json["daily_notes_length"] as String? ?? '',
        generalNotesLength: json["general_notes_length"] as String? ?? '');
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
    this.deletedAt,
    required this.customFields,
  });

  factory AvailabilityHour.fromJson(Map<String, dynamic> json) {
    return AvailabilityHour(
      id: (json["id"] as num?)?.toInt() ??
          0, // Ensuring id is safely converted to int
      day: json["day"] as String? ?? '', // Default to empty string if null
      startAt:
          json["start_at"] as String? ?? '', // Default to empty string if null
      endAt: json["end_at"] as String? ?? '', // Default to empty string if null
      data: json["data"] != null
          ? Description.fromJson(json["data"] as Map<String, dynamic>)
          : Description(en: 'N/A'), // Handling null for nested Description
      salonId:
          (json["salon_id"] as num?)?.toInt() ?? 0, // Safely converting to int
      deletedAt: json[
          "deleted_at"], // Directly assigning dynamic, no conversion needed
      customFields: json["custom_fields"] != null
          ? List<dynamic>.from(json["custom_fields"].map((x) => x))
          : [], // Handling potentially null list
    );
  }

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

  factory Description.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Description(en: 'N/A');
    }
    return Description(en: json['en'] as String? ?? 'N/A');
  }

  Map<String, dynamic> toJson() {
    return {
      'en': en,
    };
  }
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

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: (json["id"] as num?)?.toInt() ?? 0, // Ensures safe int conversion
      name: json["name"] as String? ?? '', // Defaults to empty string if null
      customProperties: json["custom_properties"] != null
          ? CustomProperties.fromJson(
              json["custom_properties"] as Map<String, dynamic>)
          : CustomProperties
              .defaultProperties(), // Handle null with a default instance
      cover: json["cover"] as String? ?? '', // Defaults to empty string if null
      url: json["url"] as String? ?? '', // Defaults to empty string if null
      thumb: json["thumb"] as String? ?? '', // Defaults to empty string if null
      icon: json["icon"] as String? ?? '', // Defaults to empty string if null
      formatedSize: json["formated_size"] as String? ??
          '', // Defaults to empty string if null
    );
  }

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

  // Factory constructor for creating an instance from JSON
  factory CustomProperties.fromJson(Map<String, dynamic> json) =>
      CustomProperties(
        uuid: json["uuid"] as String? ?? 'default-uuid', // Default UUID if null
        userId: (json["user_id"] as num?)?.toInt() ??
            0, // Safe cast to int, default to 0 if null
        generatedConversions: json["generated_conversions"] != null
            ? GeneratedConversions.fromJson(
                json["generated_conversions"] as Map<String, dynamic>)
            : GeneratedConversions.defaultConversions(), // Use default if null
      );

  // Method to create a default instance of CustomProperties
  static CustomProperties defaultProperties() {
    return CustomProperties(
      uuid: 'default-uuid',
      userId: 0,
      generatedConversions: GeneratedConversions.defaultConversions(),
    );
  }

  // Method to convert to JSON format
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

  // Factory constructor for parsing from JSON
  factory GeneratedConversions.fromJson(Map<String, dynamic> json) =>
      GeneratedConversions(
        thumb: json["thumb"] as bool? ?? false, // Default to false if null
        icon: json["icon"] as bool? ?? false, // Default to false if null
      );

  // Method to create a default instance of GeneratedConversions
  static GeneratedConversions defaultConversions() {
    return GeneratedConversions(
      thumb: false,
      icon: false,
    );
  }

  // Method to convert to JSON format
  Map<String, dynamic> toJson() => {
        "thumb": thumb,
        "icon": icon,
      };
}
