import 'dart:convert';

List<Information> informationFromJson(String str) => List<Information>.from(
    json.decode(str).map((x) => Information.fromJson(x)));

String informationToJson(List<Information> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Information {
  String? id;
  String? name;
  String? avatar;
  int? createdAt;

  Information({
    this.id,
    this.name,
    this.avatar,
    this.createdAt,
  });

  factory Information.fromJson(Map<String, dynamic> json) => Information(
        id: json["id"],
        name: json["name"],
        avatar: json["avatar"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "avatar": avatar,
        "createdAt": createdAt,
      };
}
