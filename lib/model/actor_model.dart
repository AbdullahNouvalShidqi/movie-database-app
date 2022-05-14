import 'package:mini_project/model/item_model.dart';

class ActorModel {
    ActorModel({
        required this.id,
        required this.name,
        required this.role,
        required this.image,
        required this.summary,
        required this.birthDate,
        required this.deathDate,
        required this.awards,
        required this.height,
        required this.knownFor,
        required this.castMovies,
        required this.errorMessage,
    });

    String id;
    String name;
    String role;
    String image;
    String summary;
    DateTime? birthDate;
    dynamic deathDate;
    String awards;
    String height;
    List<Item> knownFor;
    List<Item> castMovies;
    String errorMessage;

    factory ActorModel.fromJson(Map<String, dynamic> json) => ActorModel(
        id: json["id"],
        name: json["name"],
        role: json["role"].toString(),
        image: json["image"],
        summary: json["summary"],
        birthDate: json['birthDate'] == null ? null : DateTime.parse(json["birthDate"]),
        deathDate: json["deathDate"],
        awards: json["awards"],
        height: json["height"],
        knownFor: List<Item>.from(json["knownFor"].map((x) => Item.fromJson(x))),
        castMovies: List<Item>.from(json["castMovies"].map((x) => Item.fromJson(x))),
        errorMessage: json["errorMessage"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "role": role,
        "image": image,
        "summary": summary,
        "birthDate": "${birthDate!.year.toString().padLeft(4, '0')}-${birthDate!.month.toString().padLeft(2, '0')}-${birthDate!.day.toString().padLeft(2, '0')}",
        "deathDate": deathDate,
        "awards": awards,
        "height": height,
        "knownFor": List<dynamic>.from(knownFor.map((x) => x.toJson())),
        "castMovies": List<dynamic>.from(castMovies.map((x) => x.toJson())),
        "errorMessage": errorMessage,
    };
}

// class CastMovie {
//     CastMovie({
//         required this.id,
//         required this.role,
//         required this.title,
//         required this.year,
//         required this.description,
//     });

//     String id;
//     String role;
//     String title;
//     String year;
//     String description;

//     factory CastMovie.fromJson(Map<String, dynamic> json) => CastMovie(
//         id: json["id"],
//         role: json["role"].toString(),
//         title: json["title"],
//         year: json["year"],
//         description: json["description"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "role": role,
//         "title": title,
//         "year": year,
//         "description": description,
//     };
// }

// class KnownFor {
//     KnownFor({
//         required this.id,
//         required this.title,
//         required this.fullTitle,
//         required this.year,
//         required this.role,
//         required this.image,
//     });

//     String id;
//     String title;
//     String fullTitle;
//     String year;
//     String role;
//     String image;

//     factory KnownFor.fromJson(Map<String, dynamic> json) => KnownFor(
//         id: json["id"],
//         title: json["title"],
//         fullTitle: json["fullTitle"],
//         year: json["year"],
//         role: json["role"],
//         image: json["image"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "title": title,
//         "fullTitle": fullTitle,
//         "year": year,
//         "role": role,
//         "image": image,
//     };
// }
