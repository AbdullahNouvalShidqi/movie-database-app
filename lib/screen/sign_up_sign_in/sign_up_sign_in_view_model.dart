import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mini_project/model/api/firebase_api.dart';
import 'package:mini_project/model/user_data_model.dart';

enum SignUpSignInState{
  done,
  loading,
  error,
  none
}

class SignUpSignInViewModel with ChangeNotifier{

  SignUpSignInState _state = SignUpSignInState.none;
  SignUpSignInState get state => _state;

  List<UserData> _allUserData = [];
  List<UserData> get allUserData => _allUserData;

  void changeState(SignUpSignInState s){
    _state = s;
    notifyListeners();
  }

  Future<void> signIn({required String email, required String password}) async {
    changeState(SignUpSignInState.loading);
    final _auth = FirebaseAuth.instance;
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      changeState(SignUpSignInState.done);
    }catch(e){
      changeState(SignUpSignInState.error);
    }
  }

  Future<void> signUp({required String email, required String password, required String username}) async {
    changeState(SignUpSignInState.loading);
    final _auth = FirebaseAuth.instance;
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final _user = _auth.currentUser;
      await FirebaseAPI().putUserData(uid: _user!.uid, userData: UserData(userName: username, email: email, myListItem: []));
      changeState(SignUpSignInState.done);
    }catch(e){
      changeState(SignUpSignInState.error);
    }  
  }

  Future<void> getAllUserData() async {
    changeState(SignUpSignInState.loading);

    try{
      _allUserData = await FirebaseAPI().getAllUsersData();
      changeState(SignUpSignInState.done);
    }catch(e){
      changeState(SignUpSignInState.error);
    }
  }

  // Future<bool?> sendOtp({required String email}) async {
  //   changeState(SignUpSignInState.loading);
  //   try{
  //     bool result = await _emailAuth.sendOtp(recipientMail: email, otpLength: 6);
  //     notifyListeners();
  //     changeState(SignUpSignInState.done);
  //     return result;
  //   }catch(e){
  //     changeState(SignUpSignInState.error);
  //     return null;
  //   }
    
  // }

  // bool verify({required String email, required String otp}){
  //   final result = _emailAuth.validateOtp(recipientMail: email, userOtp: otp);
  //   notifyListeners();
  //   return result;
  // }

}