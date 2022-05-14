import 'package:flutter_test/flutter_test.dart';
import 'package:mini_project/model/actor_model.dart';
import 'package:mini_project/model/api/imdb_api.dart';
import 'package:mini_project/model/data_detail_model.dart';
import 'package:mini_project/model/youtube_trailer_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'imdb_api.mocks.dart';

@GenerateMocks([ImdbAPI])
void main(){
  group('IMDB api test', (){
    ImdbAPI imdbAPI = MockImdbAPI();

    test('Getting detail of movie by id', () async { 
      when(imdbAPI.getDataDetail(id: 'test')).thenAnswer(
        (realInvocation) async => DataDetail(
          id: 'test', title: 'title', originalTitle: 'originalTitle', fullTitle: 'fullTitle', 
          type: 'type', year: 'year', image: 'image', releaseDate: DateTime.now(), 
          runtimeMins: 'runtimeMins', runtimeStr: 'runtimeStr', plot: 'plot', plotLocal: 'plotLocal', 
          plotLocalIsRtl: false, awards: 'awards', directors: 'directors', directorList: [], writers: 'writers', 
          writerList: [], stars: 'stars', starList: [], actorList: [], fullCast: 'fullCast', genres: 'genres', 
          genreList: [], companies: 'companies', companyList: [], countries: [], countryList: [], languages: [], 
          languageList: [], contentRating: 'contentRating', imDbRating: 'imDbRating', imDbRatingVotes: 'imDbRatingVotes',
          metacriticRating: 'metacriticRating', ratings: 'ratings', wikipedia: 'wikipedia', posters: 'posters', 
          images: [], trailer: 'trailer', boxOffice: BoxOffice(budget: '',cumulativeWorldwideGross: '', grossUsa: '', openingWeekendUsa: ''), 
          tagline: 'tagline', keywords: 'keywords', keywordList: [], similars: [], tvSeriesInfo: 'tvSeriesInfo', 
          tvEpisodeInfo: 'tvEpisodeInfo', errorMessage: 'errorMessage')
      );
      var detail = await imdbAPI.getDataDetail(id: 'test');
      expect(detail.toJson().isNotEmpty, true);
    });

    test('Getting actor detail', () async {
      when(imdbAPI.getActorDetail(id: 'id')).thenAnswer(
        (realInvocation) async=> ActorModel(id: 'id', name: 'name', role: 'role', image: 'image', summary: 'summary', 
        birthDate: DateTime.now(), deathDate: null, awards: 'awards', height: 'height', knownFor: [], castMovies: [], 
        errorMessage: 'errorMessage')
      );
      var actorDetail = await imdbAPI.getActorDetail(id: 'id');
      expect(actorDetail.toJson().isNotEmpty, true);
    });

    test('Getting youtube id by id', () async {
      when(imdbAPI.getYoutubeId(id: 'id')).thenAnswer(
        (realInvocation) async=> YoutubeTrailerModel(imDbId: 'imDbId', title: 'title', fullTitle: 'fullTitle', type: 'type', 
        year: 'year', videoId: 'videoId', videoUrl: 'videoUrl', errorMessage: 'errorMessage')
      );
      var youtubeTrailer = await imdbAPI.getYoutubeId(id: 'id');
      expect(youtubeTrailer.toJson().isNotEmpty, true);
    });
    
  });
}