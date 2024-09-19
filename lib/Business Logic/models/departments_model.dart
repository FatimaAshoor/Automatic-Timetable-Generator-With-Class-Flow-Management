class DepartmentModel {
  String? Id;
  String? name;
  int? levels;
  String? period;

  DepartmentModel({this.Id, this.name, this.levels, this.period});

  DepartmentModel.fromJson(Map<String, dynamic> json) {
    Id = json['Id'];
    name = json['Name'];
    levels = json['Levels'];
    period = json['period'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.Id;
    data['Name'] = this.name;
    data['Levels'] = this.levels;
    data['period'] = this.period;
    return data;
  }
}
