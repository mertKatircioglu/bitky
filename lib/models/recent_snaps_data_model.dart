class RecentSnapsDataModel{
  List<String>? problemNames;
  Map<String, dynamic>? images;
  DateTime? createdAt;
  bool? isHealthy;

  RecentSnapsDataModel(
      {this.problemNames, this.images, this.createdAt, this.isHealthy});


}