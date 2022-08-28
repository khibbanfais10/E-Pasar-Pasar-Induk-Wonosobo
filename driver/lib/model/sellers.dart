class Sellers {
  String? penjualUID;
  String? penjualName;
  String? penjualAvatarUrl;
  String? penjualEmail;

  Sellers({
    this.penjualUID,
    this.penjualName,
    this.penjualAvatarUrl,
    this.penjualEmail,
  });

  Sellers.fromJson(Map<String, dynamic> json) {
    penjualUID = json["penjualUID"];
    penjualName = json["penjualName"];
    penjualAvatarUrl = json["sellerAvatarUrl"];
    penjualEmail = json["penjualEmail"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["penjualUID"] = this.penjualUID;
    data["penjualName"] = this.penjualName;
    data["sellerAvatarUrl"] = this.penjualAvatarUrl;
    data["penjualEmail"] = this.penjualEmail;
    return data;
  }
}
