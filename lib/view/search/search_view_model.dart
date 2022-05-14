import 'package:flutter/cupertino.dart';
import 'package:mini_project/model/item_model.dart';

class SearchViewModel with ChangeNotifier{
  final List<Item> _searchResult = [];
  List<Item> get searchResult => _searchResult;

  String? _sort;
  String? get sort => _sort;

  void onChangedSort(String? newValue){
    _sort = newValue;
    notifyListeners();
  }

  void searchOperation(String searchText, List<Item> items){
    _searchResult.clear();
    notifyListeners();
    for(var i in items){
      String title = i.title;
      String year = i.year;
      if(title.toLowerCase().contains(searchText.toLowerCase()) || year.toLowerCase().contains(searchText.toLowerCase())){
        _searchResult.add(Item(id: i.id, rank: i.rank, title: title, fullTitle: i.fullTitle, year: i.year, image: i.image, crew: i.crew, imDbRating: i.imDbRating, imDbRatingCount: i.imDbRatingCount, myRating: i.myRating, myReview: i.myReview, status: i.status));
      }
    }
  }

  void clearSearchList(){
    _searchResult.clear();
    notifyListeners();
  }
}