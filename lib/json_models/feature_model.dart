

class Featured {
    bool success;
    List<FeatureDatum> data;
    String message;

    Featured({
        required this.success,
        required this.data,
        required this.message,
    });

    factory Featured.fromJson(Map<String, dynamic> json) => Featured(
        success: json["success"],
        data: List<FeatureDatum>.from(json["data"].map((x) => FeatureDatum.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
    };
}

class FeatureDatum {
    double distance;
    double area;
    int id;
    Description name;
    int salonLevelId;
    int addressId;
    Description description;
    String phoneNumber;
    String mobileNumber;
    double availabilityRange;
    bool available;
    bool featured;
    bool accepted;
    String serviceDesc;
    String? addressDesc;
    String? instagram;
    dynamic facebook;
    dynamic twitter;
    dynamic snapchat;
    dynamic tiktok;
    String homeDesc;
    String descriptionLength;
    int showOnHomePage;
    String tags;
    String? generalNotes;
    String? dailyNotes;
    String? promotions;
    String? dailyNotesLength;
    String? generalNotesLength;
    dynamic bookingMethod;
    DateTime? deletedAt;
    List<dynamic> customFields;
    bool hasMedia;
    int rate;
    bool closed;
    int totalReviews;
    List<Media> media;
    List<AvailabilityHour> availabilityHours;

    FeatureDatum({
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
        required this.instagram,
        required this.facebook,
        required this.twitter,
        required this.snapchat,
        required this.tiktok,
        required this.homeDesc,
        required this.descriptionLength,
        required this.showOnHomePage,
        required this.tags,
        required this.generalNotes,
        required this.dailyNotes,
        required this.promotions,
        required this.dailyNotesLength,
        required this.generalNotesLength,
        required this.bookingMethod,
        required this.deletedAt,
        required this.customFields,
        required this.hasMedia,
        required this.rate,
        required this.closed,
        required this.totalReviews,
        required this.media,
        required this.availabilityHours,
    });

    factory FeatureDatum.fromJson(Map<String, dynamic> json) => FeatureDatum(
        distance: json["distance"]?.toDouble(),
        area: json["area"]?.toDouble(),
        id: json["id"],
        name: Description.fromJson(json["name"]),
        salonLevelId: json["salon_level_id"],
        addressId: json["address_id"],
        description: Description.fromJson(json["description"]),
        phoneNumber: json["phone_number"],
        mobileNumber: json["mobile_number"],
        availabilityRange: json["availability_range"]?.toDouble(),
        available: json["available"],
        featured: json["featured"],
        accepted: json["accepted"],
        serviceDesc: json["service_desc"],
        addressDesc: json["address_desc"],
        instagram: json["instagram"],
        facebook: json["facebook"],
        twitter: json["twitter"],
        snapchat: json["snapchat"],
        tiktok: json["tiktok"],
        homeDesc: json["home_desc"],
        descriptionLength: json["description_length"],
        showOnHomePage: json["show_on_home_page"],
        tags: json["tags"],
        generalNotes: json["general_notes"],
        dailyNotes: json["daily_notes"],
        promotions: json["promotions"],
        dailyNotesLength: json["daily_notes_length"],
        generalNotesLength: json["general_notes_length"],
        bookingMethod: json["booking_method"],
        deletedAt: json["deleted_at"] == null ? null : DateTime.parse(json["deleted_at"]),
        customFields: List<dynamic>.from(json["custom_fields"].map((x) => x)),
        hasMedia: json["has_media"],
        rate: json["rate"],
        closed: json["closed"],
        totalReviews: json["total_reviews"],
        media: List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
        availabilityHours: List<AvailabilityHour>.from(json["availability_hours"].map((x) => AvailabilityHour.fromJson(x))),
    );

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
        "instagram": instagram,
        "facebook": facebook,
        "twitter": twitter,
        "snapchat": snapchat,
        "tiktok": tiktok,
        "home_desc": homeDesc,
        "description_length": descriptionLength,
        "show_on_home_page": showOnHomePage,
        "tags": tags,
        "general_notes": generalNotes,
        "daily_notes": dailyNotes,
        "promotions": promotions,
        "daily_notes_length": dailyNotesLength,
        "general_notes_length": generalNotesLength,
        "booking_method": bookingMethod,
        "deleted_at": deletedAt?.toIso8601String(),
        "custom_fields": List<dynamic>.from(customFields.map((x) => x)),
        "has_media": hasMedia,
        "rate": rate,
        "closed": closed,
        "total_reviews": totalReviews,
        "media": List<dynamic>.from(media.map((x) => x.toJson())),
        "availability_hours": List<dynamic>.from(availabilityHours.map((x) => x.toJson())),
    };
}

class AvailabilityHour {
    int id;
    Day day;
    String startAt;
    String endAt;
    Data data;
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

    factory AvailabilityHour.fromJson(Map<String, dynamic> json) => AvailabilityHour(
        id: json["id"],
        day: dayValues.map[json["day"]]!,
        startAt: json["start_at"],
        endAt: json["end_at"],
        data: Data.fromJson(json["data"]),
        salonId: json["salon_id"],
        deletedAt: json["deleted_at"],
        customFields: List<dynamic>.from(json["custom_fields"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "day": dayValues.reverse[day],
        "start_at": startAt,
        "end_at": endAt,
        "data": data.toJson(),
        "salon_id": salonId,
        "deleted_at": deletedAt,
        "custom_fields": List<dynamic>.from(customFields.map((x) => x)),
    };
}

class Data {
    dynamic en;

    Data({
        required this.en,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        en: json["en"],
    );

    Map<String, dynamic> toJson() => {
        "en": en,
    };
}

enum Day {
    FRIDAY,
    MONDAY,
    SATURDAY,
    SUNDAY,
    THURSDAY,
    TUESDAY,
    WEDNESDAY
}

final dayValues = EnumValues({
    "friday": Day.FRIDAY,
    "monday": Day.MONDAY,
    "saturday": Day.SATURDAY,
    "sunday": Day.SUNDAY,
    "thursday": Day.THURSDAY,
    "tuesday": Day.TUESDAY,
    "wednesday": Day.WEDNESDAY
});

class Description {
    String en;
    String? ar;

    Description({
        required this.en,
        this.ar,
    });

    factory Description.fromJson(Map<String, dynamic> json) => Description(
        en: json["en"],
        ar: json["ar"],
    );

    Map<String, dynamic> toJson() => {
        "en": en,
        "ar": ar,
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

    factory CustomProperties.fromJson(Map<String, dynamic> json) => CustomProperties(
        uuid: json["uuid"],
        userId: json["user_id"],
        generatedConversions: GeneratedConversions.fromJson(json["generated_conversions"]),
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

    factory GeneratedConversions.fromJson(Map<String, dynamic> json) => GeneratedConversions(
        thumb: json["thumb"],
        icon: json["icon"],
    );

    Map<String, dynamic> toJson() => {
        "thumb": thumb,
        "icon": icon,
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