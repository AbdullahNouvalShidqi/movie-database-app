import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project/model/data_detail_model.dart';
import 'package:mini_project/model/item_model.dart';
import 'package:mini_project/model/youtube_trailer_model.dart';
import 'package:mini_project/screen/account/account_view_model.dart';
import 'package:mini_project/screen/add_to_list/add_to_list_screen.dart';
import 'package:mini_project/screen/detail/detail_view_model.dart';
import 'package:mini_project/screen/detail/person_detail_screen.dart';
import 'package:mini_project/screen/sign_up_sign_in/sign_in_screen.dart';
import 'package:mini_project/screen/sign_up_sign_in/sign_up_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailScreen extends StatefulWidget {
  static String routeName = '/detail';
  const DetailScreen({ Key? key }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  DataDetail? dataDetail;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      final item = ModalRoute.of(context)!.settings.arguments as Item;
      dataDetail = await Provider.of<DetailViewModel>(context, listen: false).getDataDetail(item.id);
    });
  }
  @override
  Widget build(BuildContext context) {
    final detailViewModel = Provider.of<DetailViewModel>(context);
    final accountViewModel = Provider.of<AccountViewModel>(context);

    final thisItem = ModalRoute.of(context)!.settings.arguments as Item;
    final detail = dataDetail;
    final item = detailViewModel.checkItem(thisItem: thisItem, inMyListItems: accountViewModel.all);

    return WillPopScope(
      onWillPop: () async {
        if(detailViewModel.state == DetailViewState.error){
          detailViewModel.changeState(DetailViewState.none);
          return true;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Details'),
        ),
        body: body(item: item, detail: detail, detailViewModel: detailViewModel)
      ),
    );
  }

  Widget body({required Item item, required DataDetail? detail, required DetailViewModel detailViewModel}){
    final isLoading = detailViewModel.state == DetailViewState.laoding;
    final isError = detailViewModel.state == DetailViewState.error;

    if(isLoading){
      return const Center(child: CircularProgressIndicator(),);
    }

    if(isError){
      return Center(child: Text('Error cannot get data, check your internet connection and comeback later', textAlign: TextAlign.center, style: GoogleFonts.signikaNegative(),),);
    }

    if(detail == null){
      return Center(child: Text('Error cannot get data, the data is not available at the moment', textAlign: TextAlign.center, style: GoogleFonts.signikaNegative(),),);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imageView(detail: detail),
                mainDetail(item: item,detail: detail, viewModel: detailViewModel, context: context),
              ],
            ),
            genreListView(detail: detail),
            plot(detail: detail),
            actorsListView(detail: detail),
            similarListView(detail: detail),
          ],
        ),
      ),
    );
  }

  Widget imageView({required DataDetail detail}){
    return SizedBox(
      width: 175,
      height: 250,
      child: CachedNetworkImage(
        imageUrl: detail.image,
        placeholder: (context, url) => const Center(child: CircularProgressIndicator(),),
        errorWidget: (context, url, error) => Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.deepPurple
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              const Icon(Icons.error, size: 40,color: Colors.white,),
              const SizedBox(height: 5,),
              Text('Cannot get image', style: GoogleFonts.oleoScriptSwashCaps(color: Colors.white),)
            ],
          )
        ),
        fit: BoxFit.cover,
        imageBuilder: (context, imageProvider){
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover)
            ),
          );
        },
      ),
    );
  }

  Widget mainDetail({required Item item, required DataDetail detail, required DetailViewModel viewModel, required BuildContext context}){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(detail.title, style: GoogleFonts.signikaNegative(fontSize: 20),maxLines: 3,),
            const SizedBox(height: 10,),
            detail.releaseDate == null ? const Text('Released : Coming Soon') : Text('Released : ${DateFormat('dd-MM-yyyy').format(detail.releaseDate!)}'),
            const SizedBox(height: 5,),
            detail.runtimeStr == null ? Text('Runtime : -', style: GoogleFonts.signikaNegative()) : Text('Runtime : ${detail.runtimeStr}', style: GoogleFonts.signikaNegative()),
            const SizedBox(height: 5,),
            detail.imDbRating == null ? Text('Imdb Rating : -', style: GoogleFonts.signikaNegative()) : Text('Imdb Rating : ${detail.imDbRating}', style: GoogleFonts.signikaNegative()),
            const SizedBox(height: 5,),
            item.myRating != null ? Text('My Rating : ${item.myRating}') : const SizedBox(),
            const SizedBox(height: 10,),
            ElevatedButton(
              onPressed: (){
                showDialog(
                  context: context, builder: (context){
                    return trailer(viewModel: viewModel, id: detail.id);
                  }
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.play_arrow_outlined),
                  const SizedBox(width: 3,),
                  Text('Play the trailer', style: GoogleFonts.signikaNegative())
                ],
              )
            ),
            addToListButton(item: item, detail: detail)
          ],
        ),
      ),
    );
  }

  Widget genreListView({required DataDetail detail}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child:  Text('Genres :', style: GoogleFonts.signikaNegative()),
          ),
          Expanded(
            child: SizedBox(
              height: 30,
              child: ListView.builder(
                itemCount: detail.genreList.length,
                itemBuilder: (context, i){
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      alignment: Alignment.center,
                      width: 90,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.deepPurple,
                        border: Border.all(style: BorderStyle.none)
                      ),
                      child: Text(detail.genreList[i].value, style: GoogleFonts.signikaNegative(color: Colors.white)),
                    ),
                  );
                },
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget plot({required DataDetail detail}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Plot', style: GoogleFonts.signikaNegative(fontSize: 20),),
        Text(detail.plot, textAlign: TextAlign.justify, style: GoogleFonts.signikaNegative()),
        const SizedBox(height: 10,),
      ],
    );
  }

  Widget actorsListView({required DataDetail detail}) {
    return SizedBox(
      height: 310,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child:  Text('Actors', style: GoogleFonts.signikaNegative(fontSize: 20)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: detail.actorList.length,
              itemBuilder: (context, i){
                return GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, PersonDetailScreen.routeName, arguments: detail.actorList[i].id);
                  },
                  child: actorsCardView(detail: detail, i: i)
                );
              },
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }

  Widget actorsCardView({required DataDetail detail, required int i}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: 145,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedNetworkImage(
              imageUrl: detail.actorList[i].image,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator(),),
              errorWidget: (context, url, error) => Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.deepPurple
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    const Icon(Icons.error, size: 40,color: Colors.white,),
                    const SizedBox(height: 5,),
                    Text('Cannot get image', style: GoogleFonts.oleoScriptSwashCaps(color: Colors.white),)
                  ],
                )
              ),
              height: 200,
              width: 130,
              fit: BoxFit.cover,
              imageBuilder: (context, imageProvider){
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(image: imageProvider, fit: BoxFit.cover)
                  ),
                );
              },
            ),
            const SizedBox(height: 5,),
            Text(detail.actorList[i].name, textAlign: TextAlign.center, maxLines: 1,style: GoogleFonts.signikaNegative()),
            Text('(${detail.actorList[i].asCharacter})', maxLines: 2,textAlign: TextAlign.center, style: GoogleFonts.signikaNegative())
          ],
        ),
      )
    );
  }

  Widget similarListView({required DataDetail detail}){
    return detail.similars.isEmpty ? const SizedBox() : 
    SizedBox(
      height: 290,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child:  Text('Simillars ${detail.type}', style: GoogleFonts.signikaNegative(fontSize: 20),),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: detail.similars.length,
              itemBuilder: (context, i){
                return similarCardView(detail: detail, i: i);
              },
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }

  Widget similarCardView({required DataDetail detail, required int i}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: (){
          Navigator.pushNamed(context, DetailScreen.routeName, arguments: detail.similars[i]);
        },
        child: SizedBox(
          width: 145,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: detail.similars[i].image,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator(),),
                    errorWidget: (context, url, error) => Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.deepPurple
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          const Icon(Icons.error, size: 40,color: Colors.white,),
                          const SizedBox(height: 5,),
                          Text('Cannot get image', style: GoogleFonts.oleoScriptSwashCaps(color: Colors.white),)
                        ],
                      )
                    ),
                    height: 200,
                    width: 130,
                    fit: BoxFit.cover,
                    imageBuilder: (context, imageProvider){
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(image: imageProvider, fit: BoxFit.cover)
                        ),
                      );
                    },
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.yellow, size: 13,),
                          const SizedBox(width: 5,),
                          Text(detail.similars[i].imDbRating, style: GoogleFonts.signikaNegative(color: Colors.white),)
                        ],
                      ),
                    ),
                  )
                ]
                
              ),
              const SizedBox(height: 5,),
              Text(detail.similars[i].title, textAlign: TextAlign.center, maxLines: 2, style: GoogleFonts.signikaNegative()),
            ],
          ),
        ),
      )
    );
  }
  
  Widget trailer({required DetailViewModel viewModel, required String id}){
    return FutureBuilder<YoutubeTrailerModel>(
      future: viewModel.getYoutubeId(id),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator(),);
        }
        else if(snapshot.hasData){
          final youtube = snapshot.requireData;
          if(youtube.errorMessage.isNotEmpty){
            return const Center(child: Text('Error : No trailer has not found'),);
          }
          else{
            final _controller = YoutubePlayerController(
              initialVideoId: youtube.videoId,
              flags: const YoutubePlayerFlags(
                autoPlay: true,
                mute: false,
              )
            );
            return YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.deepPurple,
                progressColors: const ProgressBarColors(
                  playedColor: Colors.deepPurple,
                  handleColor: Colors.purple
                ),
              ),
              builder: (context, youtube){
                return AlertDialog(
                  insetPadding: EdgeInsets.zero,
                  contentPadding: EdgeInsets.zero,
                  content: youtube
                );
              },
            );
          }
        }else{
          return const Center(child: Text('Error cannot get data'),);
        }
      },
    );
  }

  Widget addToListButton({required Item item, required DataDetail detail}){
    item.year == null ? item.year = DateFormat('y').format(detail.releaseDate!) : item.year = item.year;
    item.image = detail.image;
    item.imDbRating = detail.imDbRating;
    return ElevatedButton(
      onPressed: (){
        final accountViewModel = Provider.of<AccountViewModel>(context, listen: false);
        final isSignIn = accountViewModel.isSignIn;
        if(isSignIn){
          showModalBottomSheet(
            context: context,
            builder: (context){
              return AddToListScreen(item: item,);
            }
          );
        }else{
          showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                title: const Text("You're not signed in yet"),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pushReplacementNamed(context, SignInScreen.routeName);
                      },
                      child: const Text('Sign in')
                    ),
                    const SizedBox(width: 10,),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pushReplacementNamed(context, SignUpScreen.routeName);
                      },
                      child: const Text('Sign up')
                    ),
                  ],
                ),
              );
            }
          );
        }
        
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: iconTextStatus(status: item.status)
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 5)),
        maximumSize: MaterialStateProperty.all(const Size(150, 50)),
        backgroundColor: MaterialStateProperty.all(buttonColor(status: item.status))
      ),
    );
  }

  Color? buttonColor({String? status}){
    if(status == 'Plan to watch' || status == 'Watching' || status == 'Finished'){
      return Colors.green[700];
    }
    else if(status == 'Dropped'){
      return Colors.red[700];
    }
    else{
      return null;
    }
  }

  List<Widget> iconTextStatus({String? status}){
    if(status == 'Plan to watch' || status == 'Watching' || status == 'Finished'){
      return [
        const Icon(Icons.bookmark_added),
        Text(status!)
      ];
    }
    else if(status == 'Dropped'){
      return [
        const Icon(Icons.warning_rounded),
        Text(status!)
      ];
    }
    else{
      return const [
        Icon(Icons.bookmark_add),
        Text('Add to List'),
      ];
    }
  }
  
}