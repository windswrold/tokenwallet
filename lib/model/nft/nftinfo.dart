class NFTIPFSInfo {
  String? name;
  String? description;
  String? image;
  String? imageBase64;

  NFTIPFSInfo({this.name, this.description, this.image, this.imageBase64});

  static NFTIPFSInfo fromJson(Map<String, dynamic> json) {
    return NFTIPFSInfo(
      name: json["name"] ?? '',
      description: json["description"] ?? '',
      image: json["image"] ?? '',
    );
  }
}
