class CategoryType {
  final String categoryTypeId;
  final String categoryTypeName;

  CategoryType(this.categoryTypeId, this.categoryTypeName);

  factory CategoryType.fromJson(String categoryTypeId, Map<String, dynamic> json){
    return CategoryType(categoryTypeId, json['name']);
  }

}