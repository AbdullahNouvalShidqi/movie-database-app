import 'package:flutter_test/flutter_test.dart';
import 'package:mini_project/model/api/firebase_api.dart';
import 'package:mini_project/model/item_model.dart';
import 'package:mini_project/model/user_data_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'firebase_api.mocks.dart';

@GenerateMocks([FirebaseAPI])
void main(){
  group('Firebase API test', (){
    FirebaseAPI firebaseAPI = MockFirebaseAPI();

    test('Getting all data of movies and else that exist in firebase api', () async {
      when(firebaseAPI.getApiData(jsonName: 'jsonName')).thenAnswer(
        (realInvocation) async => <Item> [
          Item(id: 'id', rank: 'rank', title: 'title', fullTitle: 'fullTitle', year: 'year', image: 'image', crew: 'crew', 
          imDbRating: 'imDbRating', imDbRatingCount: 'imDbRatingCount')
        ]
      );
      var items = await firebaseAPI.getApiData(jsonName: 'jsonName');
      expect(items.isNotEmpty, true);
    });

    test('Getting user data to the application', () async {
      when(firebaseAPI.getUserData(uid: 'uid')).thenAnswer(
        (realInvocation) async => UserData(userName: 'userName', email: 'email', myListItem: [])
      );
      var userData = await firebaseAPI.getUserData(uid: 'uid');
      expect(userData.email.isNotEmpty, true);
      expect(userData.userName.isNotEmpty, true);
      expect(userData.myListItem.isEmpty, true);
    });

    test('Getting all user data to verified username and email of new account', () async {
      when(firebaseAPI.getAllUsersData()).thenAnswer(
        (realInvocation) async => <UserData>[UserData(userName: 'userName', email: 'email', myListItem: [])]
      );
      var allUser = await firebaseAPI.getAllUsersData();
      expect(allUser.first.email.isNotEmpty, true);
      expect(allUser.first.userName.isNotEmpty, true);
      expect(allUser.first.myListItem.isEmpty, true);
    });

  });
}