import 'package:flutter/cupertino.dart';
import 'package:mini_project/model/actor_model.dart';
import 'package:mini_project/model/api/imdb_api.dart';
import 'package:mini_project/model/data_detail_model.dart';
import 'package:mini_project/model/item_model.dart';
import 'package:mini_project/model/youtube_trailer_model.dart';

enum DetailViewState{
  none,
  laoding,
  error
}

class DetailViewModel with ChangeNotifier {

  DetailViewState _state = DetailViewState.laoding;
  DetailViewState get state => _state;

  DataDetail? _detail;
  DataDetail? get detail => _detail;

  void changeState(DetailViewState s){
    _state = s;
    notifyListeners();
  }

  Future<DataDetail?> getDataDetail(String id) async {
    changeState(DetailViewState.laoding);
    
    try{
      final d = await ImdbAPI().getDataDetail(id: id);
      changeState(DetailViewState.none);
      return d;
    }catch(e){
      changeState(DetailViewState.error);
      return null;
    }
  }

  Future<ActorModel> getActorData(String id) async {
    final _actorData = await ImdbAPI().getActorDetail(id: id);

    return _actorData;
  }

  Future<YoutubeTrailerModel> getYoutubeId(String id) async {
    final _youtube = await ImdbAPI().getYoutubeId(id: id);

    return _youtube;
  }

  Item checkItem({required Item thisItem, required List<Item> inMyListItems}){
    for(var i in inMyListItems){
      if(i.id == thisItem.id){
        thisItem = i;
      }
    }
    return thisItem;
  }
}