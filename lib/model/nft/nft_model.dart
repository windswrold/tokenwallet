class NFTModel {
  final String? chainTypeName;
  final String? contractAddress;
  final String? contractName;
  final List? nftId;
  final String? nftTypeName;
  final String? url;

  NFTModel(
      {this.chainTypeName,
      this.contractAddress,
      this.contractName,
      this.nftId,
      this.nftTypeName,
      this.url});

  static NFTModel fromJson(Map<String, dynamic> json) {
    return NFTModel(
      chainTypeName: json["chainTypeName"] ?? '',
      contractAddress: json["contractAddress"] ?? '',
      contractName: json["contractName"] ?? '',
      nftId: json["nftId"] as List,
      nftTypeName: json["nftTypeName"] ?? '',
      url: json["url"] ?? '',
    );
  }
}
