class BlogModel{
  String? title;
  String? subTitle;
  String? description;
  String? createdAt;
  String? author;
  String? category;
  List<String> images= [];
  int? blogId;

  BlogModel(this.title, this.subTitle, this.description, this.createdAt,
      this.author, this.category, this.images, this.blogId);


}