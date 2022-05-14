import 'package:dio/dio.dart';
import 'package:mini_project/model/item_model.dart';
import 'package:mini_project/model/user_data_model.dart';

class FirebaseAPI{
  Future<List<Item>> getApiData({required String jsonName}) async {

    final response = await Dio()
      .get('https://miniproject-49708-default-rtdb.firebaseio.com/$jsonName.json');

    List<Item> data = (response.data['items'] as List).map((e) => Item.fromJson(e)).toList();

    return data;
  }

  Future<void> putUserData({required String uid, required UserData userData}) async {
    await Dio()
      .put(
        'https://miniproject-49708-default-rtdb.firebaseio.com/usersData/$uid.json',
        data: userData.toJson()
      );
  }

  Future<UserData> getUserData({required uid}) async {

    final response = await Dio().get('https://miniproject-49708-default-rtdb.firebaseio.com/usersData/$uid.json');
    UserData data = UserData.fromJson(response.data);

    return data;
  }

  Future<List<UserData>> getAllUsersData() async {
    List<UserData> data = [];
    final response = await Dio().get('https://miniproject-49708-default-rtdb.firebaseio.com/usersData.json');
    if(response.data != null){
      final responseData = (response.data as Map<String, dynamic>).map((key, value) => MapEntry(key, UserData.fromJson(value)));
      
      for(var i in responseData.keys){
        data.add(responseData[i]!);
      }
    }
    return data;
  }

  Future<void> addItem({required List<Item> items, required String uid}) async {
    final data = {
      'items' : List<dynamic>.from(items.map((e) => e.toJson())),
    };
    await Dio()
    .patch(
      'https://miniproject-49708-default-rtdb.firebaseio.com/usersData/$uid.json',
      data: data
    );
  }
}