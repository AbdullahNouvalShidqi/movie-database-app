import 'package:flutter/cupertino.dart';
import 'package:mini_project/model/api/firebase_api.dart';
import 'package:mini_project/model/item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum HomeViewState{
  none,
  loading,
  error,
}

class HomeViewModel with ChangeNotifier{

  HomeViewState _state = HomeViewState.none;
  HomeViewState get state => _state;

  List<Item> _popularMovies = [];
  List<Item> get popularMovies => _popularMovies;

  List<Item> _popularSeries = [];
  List<Item> get popularSeries => _popularSeries;

  List<Item> _topMovies = [];
  List<Item> get topMovies => _topMovies;

  List<Item> _topSeries = [];
  List<Item> get topSeries => _topSeries;

  List<Item> _popularAnimes = [];
  List<Item> get popularAnimes => _popularAnimes;

  List<Item> _topAnimes = [];
  List<Item> get topAnimes => _topAnimes;

  List<Item> _allItem = [];
  List<Item> get allItem => _allItem;


  late SharedPreferences _sharedPreferences;

  bool _darkMode = true;
  bool get darkMode => _darkMode;

  void changeDarkMode(){
    _darkMode = !_darkMode;
    notifyListeners();
    _sharedPreferences.setBool('darkMode', _darkMode);
  }

  void changeState(HomeViewState s) {
    _state = s;
    notifyListeners();
  }

  Future<void> getPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    if(_sharedPreferences.getBool('darkMode') != null){
      _darkMode = _sharedPreferences.getBool('darkMode')!;
      notifyListeners();
    }
  }

  Future<void> getAllData() async {
    changeState(HomeViewState.loading);

    try{
      _popularMovies =  await FirebaseAPI().getApiData(jsonName: 'popularMovies');
      _popularSeries = await FirebaseAPI().getApiData(jsonName: 'popularSeries');
      _topMovies = await FirebaseAPI().getApiData(jsonName: 'topMovies');
      _topSeries = await FirebaseAPI().getApiData(jsonName: 'topSeries');
      _popularAnimes = await FirebaseAPI().getApiData(jsonName: 'popularAnimes');
      _topAnimes = await FirebaseAPI().getApiData(jsonName: 'topAnimes');

      _topAnimes.sort((a, b) => b.imDbRating.toString().compareTo(a.imDbRating),);

      _allItem = _popularMovies + _popularSeries + _topMovies + _topSeries + _popularAnimes + _topAnimes;
      notifyListeners();

      changeState(HomeViewState.none);
    } catch (e){
      changeState(HomeViewState.error);
    }
  }
  
  List<Item> checkItems({required List<Item> thisItems, required List<Item> inMyListItems}){
    if(inMyListItems.isEmpty){
      for(var i = 0; i < thisItems.length; i++){
        if(thisItems[i].status != null || thisItems[i].myRating != null || thisItems[i].myReview != null){
          thisItems[i].status = null;
          thisItems[i].myRating = null;
          thisItems[i].myReview = null;
        }
      }
    }
    else{
      for(var i = 0; i < inMyListItems.length; i++){
        for(var j = 0; j < thisItems.length; j++){
          if(inMyListItems[i].id == thisItems[j].id){
            thisItems[j].status = inMyListItems[i].status;
            thisItems[j].myRating = inMyListItems[i].myRating;
            thisItems[j].myReview = inMyListItems[i].myReview;
          }
        }
      }
    }
    return thisItems;
  }

  Item checkItem({required Item thisItem, required List<Item> inMyListItems}){
    if(inMyListItems.isEmpty){
      thisItem.status = null;
      thisItem.myRating = null;
      thisItem.myReview = null;
    }
    else{
      for(var i in inMyListItems){
        if(i.id == thisItem.id){
          thisItem.status = i.status;
          thisItem.myReview= i.myReview;
          thisItem.myRating= i.myRating;
        }
      }
    }
    return thisItem;
  }

}