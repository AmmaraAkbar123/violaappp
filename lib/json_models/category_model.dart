class Category {
    int id;
    dynamic name;
    String color;
    dynamic description;  
    int order;
    bool featured;
    dynamic parentId;
    String orderByNumber;
    dynamic deletedAt;
    List<dynamic> customFields;
    bool hasMedia;
    List<dynamic> media;

    Category({
        required this.id,
        this.name,
        required this.color,
        this.description,
        required this.order,
        required this.featured,
        this.parentId,
        required this.orderByNumber,
        this.deletedAt,
        required this.customFields,
        required this.hasMedia,
        required this.media,
    });

    factory Category.fromJson(Map<String, dynamic> json) {
        return Category(
            id: json['id'],
            name: json['name'] is Map ? json['name']['en'] : json['name'],
            color: json['color'],
            description: json['description'] is Map ? json['description']['en'] : json['description'],
            order: json['order'],
            featured: json['featured'],
            parentId: json['parent_id'],
            orderByNumber: json['order_by_number'],
            deletedAt: json['deleted_at'],
            customFields: json['custom_fields'] ?? [],
            hasMedia: json['has_media'],
            media: json['media'] ?? [],
        );
    }
}