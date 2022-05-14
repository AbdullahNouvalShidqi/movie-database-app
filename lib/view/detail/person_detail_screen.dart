import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project/model/actor_model.dart';
import 'package:mini_project/view/detail/detail_screen.dart';
import 'package:mini_project/view/detail/detail_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PersonDetailScreen extends StatelessWidget {
  static String routeName = '/personDetail';
  const PersonDetailScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final detailViewModel = Provider.of<DetailViewModel>(context);
    final data = ModalRoute.of(context)!.settings.arguments as String;
    final String id = data;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Actor Details'),
      ),
      body: FutureBuilder<ActorModel>(
        future: detailViewModel.getActorData(id),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          else if(snapshot.hasData){
            final detail = snapshot.requireData;
            if(detail.errorMessage.isNotEmpty){
              return Center(child: Text(detail.errorMessage),);
            }else{
              return body(detail: detail, viewModel: detailViewModel, context: context);
            }
          }else{
            return Center(child: Text(snapshot.error.toString(),textAlign: TextAlign.justify,));
          }
        },
      ),
    );
  }

  Widget body({required ActorModel detail, required DetailViewModel viewModel, required BuildContext context}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: imageView(detail: detail),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: mainDetail(detail: detail, viewModel: viewModel, context: context)
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: castedMoviesListView(detail: detail),
            ),
            const Text('Summary', style: TextStyle(fontSize: 18),),
            Text(detail.summary, textAlign: TextAlign.justify),
            const SizedBox(height: 10,),
            detail.castMovies.isEmpty ? const Center() : knownForListView(detail: detail),
          ],
        ),
      ),
    );
  }

  Widget imageView({required ActorModel detail}){
    return CachedNetworkImage(
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
            const Icon(Icons.error, size: 40,),
            const SizedBox(height: 5,),
            Text('Cannot get image', style: GoogleFonts.oleoScriptSwashCaps(),)
          ],
        )
      ),
      height: 300,
      width: 150,
      fit: BoxFit.cover,
      imageBuilder: (context, imageProvider){
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover)
          ),
        );
      },
    );
  }

  Widget mainDetail({required ActorModel detail, required DetailViewModel viewModel, required BuildContext context}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(detail.name, maxLines: 3, style: GoogleFonts.signikaNegative(fontSize: 20)),
        const SizedBox(height: 10,),
        detail.birthDate == null ? Text('Birth Date : -', style: GoogleFonts.signikaNegative()) : Text('Birth Date : ${DateFormat('dd-MM-yyyy').format(detail.birthDate!)}', style: GoogleFonts.signikaNegative()),
        const SizedBox(height: 5,),
        Text('Played Roles : ${detail.role}', style: GoogleFonts.signikaNegative()),
        const SizedBox(height: 5,),
        Text('Awards : ${detail.awards}',style: GoogleFonts.signikaNegative(),),
        const SizedBox(height: 5,),
        detail.deathDate == null ? const SizedBox() : Text('Death Date : ${detail.deathDate}', style: GoogleFonts.signikaNegative()),
        const SizedBox(height: 15,),
      ],
    );
  }

  Widget castedMoviesListView({required ActorModel detail}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text('Casted Movies : ', style: GoogleFonts.signikaNegative()),
          ),
          Expanded(
            child: SizedBox(
              height: 30,
              child: ListView.builder(
                itemCount: detail.castMovies.length,
                itemBuilder: (context, i){
                  return GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, DetailScreen.routeName, arguments: detail.castMovies[i]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.deepPurple,
                          border: Border.all(style: BorderStyle.none)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 2),
                          child: Text(detail.castMovies[i].title, style: GoogleFonts.signikaNegative(color: Colors.white),),
                        ),
                      ),
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

  Widget knownForListView({required ActorModel detail}){
    return SizedBox(
      height: 290,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child:  Text('Known For', style: GoogleFonts.signikaNegative(fontSize: 20)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: detail.knownFor.length,
              itemBuilder: (context, i){
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, DetailScreen.routeName, arguments: detail.knownFor[i]);
                  },
                  child: cardView(detail: detail, i: i)
                );
              },
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }

  Widget cardView({required ActorModel detail, required int i}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: 145,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedNetworkImage(
              imageUrl: detail.knownFor[i].image,
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
                    const Icon(Icons.error, size: 40,),
                    const SizedBox(height: 5,),
                    Text('Cannot get image', style: GoogleFonts.oleoScriptSwashCaps(),)
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
            Text(detail.knownFor[i].title,textAlign: TextAlign.center,maxLines: 2, style: GoogleFonts.signikaNegative()),
          ],
        ),
      )
    );
  }

}