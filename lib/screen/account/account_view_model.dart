import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mini_project/model/api/firebase_api.dart';
import 'package:mini_project/model/item_model.dart';

enum AccountViewState{
  done,
  laoding,
  error,
  none
}

class AccountViewModel with ChangeNotifier{
  
  bool _isSignIn = false;
  bool get isSignIn => _isSignIn;

  AccountViewState _state = AccountViewState.none;
  AccountViewState get state => _state;

  List<Item> _all = [];
  List<Item> get all => _all;

  String? _status;
  String? get status => _status;

  String _username = '';
  String get username => _username;

  String _email = '';
  String get email => _email;

  void changeState(AccountViewState s){
    _state = s;
    notifyListeners();
  }

  Future<void> setUserData({required String uid}) async {
    changeState(AccountViewState.laoding);
    try{
      final data = await FirebaseAPI().getUserData(uid: uid);
      _username = data.userName;
      _all = data.myListItem;
      _email = data.email;
      changeState(AccountViewState.done);
    }catch(e){
      changeState(AccountViewState.error);
    }
    
    
  }

  void setSignIn(){
    _isSignIn = !_isSignIn;
    notifyListeners();
  }

  Future<void> signOut() async {
    changeState(AccountViewState.laoding);
    try{
      await FirebaseAuth.instance.signOut().catchError((error){changeState(AccountViewState.error);});
      setSignIn();
      _all = [];
      changeState(AccountViewState.done);
    }catch(e){
      changeState(AccountViewState.error);
    }
    
  }

  void addToList(Item item)async{
    final User? user = FirebaseAuth.instance.currentUser;
    _all.insert(0,item);
    notifyListeners();
    await FirebaseAPI().addItem(items: _all, uid: user!.uid);
  }

  void updateList(Item item)async{
    final User? user = FirebaseAuth.instance.currentUser;
    int index = _all.indexWhere((element) => element.id == item.id);
    _all[index] = item;
    notifyListeners();
    await FirebaseAPI().addItem(items: _all, uid: user!.uid);
  }

  void deleteList(Item item){
    _all.removeWhere((element) => element.id == item.id);
    notifyListeners();
  }

  void changeStatus(String? newValue){
    _status = newValue;
    notifyListeners();
  }

  void initStatus(String? status){
    _status = status;
    notifyListeners();
  }

}