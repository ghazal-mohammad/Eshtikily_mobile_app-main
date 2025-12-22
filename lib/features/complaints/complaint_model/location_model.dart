class LocationModel {
  final int id;
  final String name;

  LocationModel({required this.id, required this.name});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
class DepartmentsModel {
  final int id;
  final String name;

  DepartmentsModel({required this.id, required this.name});

  factory DepartmentsModel.fromJson(Map<String, dynamic> json) {
    return DepartmentsModel(
      id: json['id'],
      name: json['name'],
    );
  }
}class TypesModel {
  final int id;
  final String name;

  TypesModel({required this.id, required this.name});

  factory TypesModel.fromJson(Map<String, dynamic> json) {
    return TypesModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
