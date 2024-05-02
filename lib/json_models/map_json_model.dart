class SalonResponse {
  final bool success;
  final SalonData data;
  final String message;

  SalonResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory SalonResponse.fromJson(Map<String, dynamic> json) {
    return SalonResponse(
      success: json['success'],
      data: SalonData.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class SalonData {
  final int id;
  final Name name;
  final int salonLevelId;
  final int addressId;
  final Description description;
  final String phoneNumber;
  final String mobileNumber;
  final int availabilityRange;
  final bool available;
  final bool featured;
  final bool accepted;
  final String serviceDesc;
  final String addressDesc;
  final String? instagram;
  final String? facebook;
  final String? twitter;
  final String? snapchat;
  final String? tiktok;
  final String homeDesc;
  final String descriptionLength;
  final int showOnHomePage;
  final String tags;
  final String? generalNotes;
  final String? dailyNotes;
  final String? promotions;
  final String dailyNotesLength;
  final String generalNotesLength;
  final String? bookingMethod;
  final DateTime? deletedAt;
  final List<dynamic> customFields;
  final bool hasMedia;
  final int rate;
  final bool closed;
  final int totalReviews;
  final Address address;
  final List<dynamic> media;
  final List<AvailabilityHour> availabilityHours;

  SalonData({
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
    this.instagram,
    this.facebook,
    this.twitter,
    this.snapchat,
    this.tiktok,
    required this.homeDesc,
    required this.descriptionLength,
    required this.showOnHomePage,
    required this.tags,
    this.generalNotes,
    this.dailyNotes,
    this.promotions,
    required this.dailyNotesLength,
    required this.generalNotesLength,
    this.bookingMethod,
    this.deletedAt,
    required this.customFields,
    required this.hasMedia,
    required this.rate,
    required this.closed,
    required this.totalReviews,
    required this.address,
    required this.media,
    required this.availabilityHours,
  });

  factory SalonData.fromJson(Map<String, dynamic> json) {
    return SalonData(
      id: json['id'],
      name: Name.fromJson(json['name']),
      salonLevelId: json['salon_level_id'],
      addressId: json['address_id'],
      description: Description.fromJson(json['description']),
      phoneNumber: json['phone_number'],
      mobileNumber: json['mobile_number'],
      availabilityRange: json['availability_range'],
      available: json['available'],
      featured: json['featured'],
      accepted: json['accepted'],
      serviceDesc: json['service_desc'],
      addressDesc: json['address_desc'],
      instagram: json['instagram'],
      facebook: json['facebook'],
      twitter: json['twitter'],
      snapchat: json['snapchat'],
      tiktok: json['tiktok'],
      homeDesc: json['home_desc'],
      descriptionLength: json['description_length'],
      showOnHomePage: json['show_on_home_page'],
      tags: json['tags'],
      generalNotes: json['general_notes'],
      dailyNotes: json['daily_notes'],
      promotions: json['promotions'],
      dailyNotesLength: json['daily_notes_length'],
      generalNotesLength: json['general_notes_length'],
      bookingMethod: json['booking_method'],
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      customFields: json['custom_fields'],
      hasMedia: json['has_media'],
      rate: json['rate'],
      closed: json['closed'],
      totalReviews: json['total_reviews'],
      address: Address.fromJson(json['address']),
      media: json['media'],
      availabilityHours: List<AvailabilityHour>.from(json['availability_hours'].map((x) => AvailabilityHour.fromJson(x))),
    );
  }
}

class Name {
  final String en;

  Name({
    required this.en,
  });

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      en: json['en'],
    );
  }
}

class Description {
  final String en;

  Description({
    required this.en,
  });

  factory Description.fromJson(Map<String, dynamic> json) {
    return Description(
      en: json['en'],
    );
  }
}

class Address {
  final int id;
  final dynamic description;
  final String address;
  final double latitude;
  final double longitude;
  final dynamic defaultVal;
  final int userId;
  final dynamic deletedAt;
  final dynamic city;
  final List<dynamic> customFields;

  Address({
    required this.id,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.defaultVal,
    required this.userId,
    required this.deletedAt,
    required this.city,
    required this.customFields,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      description: json['description'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      defaultVal: json['default'],
      userId: json['user_id'],
      deletedAt: json['deleted_at'],
      city: json['city'],
      customFields: json['custom_fields'],
    );
  }
}

class AvailabilityHour {
  final int id;
  final String day;
  final String startAt;
  final String endAt;
  final dynamic data;
  final int salonId;
  final dynamic deletedAt;
  final List<dynamic> customFields;

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

  factory AvailabilityHour.fromJson(Map<String, dynamic> json) {
    return AvailabilityHour(
      id: json['id'],
      day: json['day'],
      startAt: json['start_at'],
      endAt: json['end_at'],
      data: json['data'],
      salonId: json['salon_id'],
      deletedAt: json['deleted_at'],
      customFields: json['custom_fields'],
    );
  }
}
