import 'package:dio/dio.dart';
import 'package:mini_project/model/actor_model.dart';
import 'package:mini_project/model/data_detail_model.dart';
import 'package:mini_project/model/youtube_trailer_model.dart';

class ImdbAPI{
  

  Future<DataDetail> getDataDetail({required String id}) async {

    final response = await Dio().get('https://imdb-api.com/en/API/Title/k_p032tzmb/$id');

    DataDetail data = DataDetail.fromJson(response.data);

    return data;
  }

  Future<ActorModel> getActorDetail({required String id}) async {
    
    final response = await Dio().get('https://imdb-api.com/en/API/Name/k_p032tzmb/$id');

    ActorModel data = ActorModel.fromJson(response.data);

    return data;
  }

  Future<YoutubeTrailerModel> getYoutubeId({required String id}) async {

    final response = await Dio().get('https://imdb-api.com/en/API/YouTubeTrailer/k_p032tzmb/$id');

    YoutubeTrailerModel data = YoutubeTrailerModel.fromJson(response.data);

    return data;
  }
  
}