import 'package:mini_project/model/item_model.dart';

class UserData{
  String userName;
  String email;
  List<Item> myListItem;

  UserData({required this.userName, required this.email, required this.myListItem});

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    userName: json['userName'],
    email: json['email'],
    myListItem: json['items'] == null ? [] : List<Item>.from((json['items'] as List).map((e) => Item.fromJson(e))).toList()
  );

  toJson() => {
    'userName' : userName,
    'email' : email,
    'items' :  List<dynamic>.from(myListItem.map((e) => e.toJson()))
  };
}