class Item {
  String id;
  dynamic rank;
  dynamic title;
  dynamic fullTitle;
  dynamic year;
  dynamic image;
  dynamic crew;
  dynamic imDbRating;
  dynamic imDbRatingCount;
  String? status;
  String? myRating;
  String? myReview;

  Item({
    required this.id, required this.rank, required this.title, 
    required this.fullTitle, required this.year, required this.image,
    required this.crew,required this.imDbRating, required this.imDbRatingCount, this.status, this.myRating, this.myReview
  });

  Item.fromJson(Map<String, dynamic> json):
    id = json["id"],
    rank = json["rank"],
    title = json["title"],
    fullTitle = json["fullTitle"],
    year = json["year"],
    image = json["image"],
    crew = json["crew"],
    imDbRating = json["imDbRating"],
    imDbRatingCount = json["imDbRatingCount"],
    status = json["status"],
    myRating = json["myRating"],
    myReview = json["myReview"]
  ;

  Map<String, dynamic> toJson() =>{
    "id": id,
    "rank": rank,
    "title": title,
    "fullTitle": fullTitle,
    "year": year,
    "image": image,
    "crew": crew,
    "imDbRating": imDbRating,
    "imDbRatingCount": imDbRatingCount,
    "status" : status,
    "myRating" : myRating,
    "myReview" : myReview
  };
}