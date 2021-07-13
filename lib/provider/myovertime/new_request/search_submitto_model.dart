class SearchSubmitToModel {
  SearchSubmitToModel({
    this.name,
    this.code,
  });

  String name;
  String code;

  factory SearchSubmitToModel.fromMap(Map<String, dynamic> json) =>
      SearchSubmitToModel(
        name: json["name"] == null ? '' : json["name"],
        code: json["code"] == null ? '' : json["code"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "code": code,
      };
}
