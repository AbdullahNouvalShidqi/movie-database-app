import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project/model/item_model.dart';
import 'package:mini_project/screen/account/account_view_model.dart';
import 'package:mini_project/screen/add_to_list/add_to_list_screen.dart';
import 'package:mini_project/screen/detail/detail_screen.dart';
import 'package:mini_project/screen/home/home_view_model.dart';
import 'package:mini_project/screen/all_list/all_list_screen.dart';
import 'package:mini_project/screen/sign_up_sign_in/sign_in_screen.dart';
import 'package:mini_project/screen/sign_up_sign_in/sign_up_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home';
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    final accountViewModel = Provider.of<AccountViewModel>(context);
    
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          bottom: const TabBar(
            tabs: [
              Tab(child: Text('Movies'),),
              Tab(child: Text('Series'),),
              Tab(child: Text('Animes'),)
            ]
          ),
          actions: [
            IconButton(
              onPressed: (){
                homeViewModel.changeDarkMode();
              },
              icon: homeViewModel.darkMode ? const Icon(Icons.dark_mode) : const Icon(Icons.light_mode)
            ),
          ],
        ),
        body: TabBarView(
          children: [
            RefreshIndicator(
              onRefresh: homeViewModel.getMoviesData,
              child: moviesBody(homeViewModel: homeViewModel, accountViewModel: accountViewModel)
            ),
            RefreshIndicator(
              onRefresh: homeViewModel.getSeriesData,
              child: seriesBody(homeViewModel: homeViewModel, accountViewModel: accountViewModel)
            ),
            RefreshIndicator(
              onRefresh: homeViewModel.getAnimesData,
              child: animesBody(homeViewModel: homeViewModel, accountViewModel: accountViewModel)
            )
          ]
        )
        
      ),
    );
  }

  Widget moviesBody({required HomeViewModel homeViewModel, required AccountViewModel accountViewModel}) {
    final isLoading = homeViewModel.state == HomeViewState.loading;
    final isError = homeViewModel.state == HomeViewState.error;

    if(isLoading){
      return const Center(child: CircularProgressIndicator(),);
    }
    else if(isError){
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: const Center(child: Text('Cannot get data, check your internet connection'),)
        )
      );
    }else{
      return SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              carouselView(thisItems: homeViewModel.popularMovies, homeViewModel: homeViewModel, accountViewModel: accountViewModel),
              const Divider(height: 0,),
              itemsView(thisItems: homeViewModel.popularMovies, title: 'Popular Movies', homeViewModel: homeViewModel, accountViewModel: accountViewModel),
              itemsView(thisItems: homeViewModel.topMovies, title: 'Top Movies', homeViewModel: homeViewModel, accountViewModel: accountViewModel),
            ],
          ),
        )
      );
    }
  }

  Widget seriesBody({required HomeViewModel homeViewModel, required AccountViewModel accountViewModel}) {
    final isLoading = homeViewModel.state == HomeViewState.loading;
    final isError = homeViewModel.state == HomeViewState.error;

    if(isLoading){
      return const Center(child: CircularProgressIndicator(),);
    }
    else if(isError){
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: const Center(child: Text('Cannot get data, check your internet connection'),)
        )
      );
    }else{
      return SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              carouselView(thisItems: homeViewModel.popularSeries,homeViewModel: homeViewModel, accountViewModel: accountViewModel),
              const Divider(height: 0,),
              itemsView(thisItems: homeViewModel.popularSeries, title: 'Popular Series', homeViewModel: homeViewModel, accountViewModel: accountViewModel),
              itemsView(thisItems: homeViewModel.topSeries, title: 'Top Series', homeViewModel: homeViewModel, accountViewModel: accountViewModel),
            ],
          ),
        )
      );
    }
  }
  
  Widget animesBody({required HomeViewModel homeViewModel, required AccountViewModel accountViewModel}) {
    final isLoading = homeViewModel.state == HomeViewState.loading;
    final isError = homeViewModel.state == HomeViewState.error;

    if(isLoading){
      return const Center(child: CircularProgressIndicator(),);
    }
    else if(isError){
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: const Center(child: Text('Cannot get data, check your internet connection'),)
        )
      );
    }else{
      return SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              carouselView(thisItems: homeViewModel.popularAnimes, homeViewModel: homeViewModel, accountViewModel: accountViewModel),
              const Divider(height: 0,),
              itemsView(thisItems: homeViewModel.popularAnimes, title: 'Popular Animes', homeViewModel: homeViewModel, accountViewModel: accountViewModel),
              itemsView(thisItems: homeViewModel.topAnimes, title: 'Top Animes', homeViewModel: homeViewModel, accountViewModel: accountViewModel),
            ],
          ),
        )
      );
    }
  }

  Widget carouselView({required List<Item> thisItems, required HomeViewModel homeViewModel, required AccountViewModel accountViewModel}){
    final items = homeViewModel.checkItems(thisItems: thisItems, inMyListItems: accountViewModel.all);
    final random = Random();
    return CarouselSlider.builder(
      itemCount: items.length,
      itemBuilder: (context, itemI, pageViewI){
        return InkWell(
          onTap: itemOnTap(item: items[itemI]),
          child: Stack(
            children: [
              carouselImage(item: items[itemI]),
              addToListButton(item: items[itemI]),
              rating(item: items[itemI])
            ],
          ),
        );
      },
      options: CarouselOptions(
        initialPage: random.nextInt(items.length),
        autoPlayInterval: const Duration(seconds: 6),
        autoPlay: true,
        height: 450,
        enlargeCenterPage: true,  
      )
    );
  }

  Widget carouselImage({required Item item}){
    return SizedBox(
      width: 300,
      child: CachedNetworkImage(  
        imageUrl: item.image,
        placeholder: (context, url) => Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.deepPurple
          ),
          child: const SpinKitSpinningLines(color: Colors.white)
        ),
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
        fit: BoxFit.contain,
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

  Widget itemsView({required List<Item> thisItems, required String title, required HomeViewModel homeViewModel, required AccountViewModel accountViewModel}){
    final items = homeViewModel.checkItems(thisItems: thisItems, inMyListItems: accountViewModel.all);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: GoogleFonts.signikaNegative(fontSize: 20)),
              IconButton(
                onPressed: (){
                  Navigator.pushNamed(context, AllListScreen.routeName, arguments: {
                    'items' : items,
                    'title' : title
                  });
                }, 
                icon: const Icon(Icons.arrow_forward)
              )
            ],
          ),
        ),
        SizedBox(
          height: 320,
          child: ListView.builder(
            itemCount: 8,
            itemBuilder: (context, i){
              return cardView(items: items, i: i);
            },
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );
  }

  Widget cardView({required List<Item> items, required int i}){
    return Container(
      padding: const EdgeInsets.all(8),
      height: 200,
      width: 185,
      child: InkWell(
        onTap: itemOnTap(item: items[i]),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                cardImage(item: items[i]),
                addToListButton(item: items[i]),
                rating(item: items[i]),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Center(child: Text(items[i].title,style: GoogleFonts.signikaNegative(fontSize: 18) ,maxLines: 2, overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,)),
            )
          ],
        ),
      ),
    );
  }

  Widget cardImage({required Item item}){
    return CachedNetworkImage(
      imageUrl: item.image,
      placeholder: (context, url) => Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.deepPurple
          ),
          child: const SpinKitSpinningLines(color: Colors.white)
        ),
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
      height: 250,
      width: 180,
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

  Widget rating({required Item item}){
    return Positioned(
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
            item.imDbRating.toString().isNotEmpty ? Text(item.imDbRating, style: GoogleFonts.signikaNegative(color: Colors.white),):
            Text('-.-', style: GoogleFonts.signikaNegative(color: Colors.white))
          ],
        ),
      ),
    );
  }

  Widget addToListButton({required Item item}){
    return Positioned(
      left: 0,
      top: 0,
      width: 40,
      height: 40,
      child: InkWell(
        onTap: (){
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
        child: iconTextStatus(status: item.status)
      )
    );
  }
  
  Widget iconTextStatus({String? status}){
    if(status == 'Plan to watch' || status == 'Watching' || status == 'Finished'){
      return const Opacity(opacity: 0.85, child: Icon(Icons.bookmark_added, size: 45,color: Colors.green,));
    }
    else if(status == 'Dropped'){
      return const Opacity(opacity: 0.85, child: Icon(Icons.warning_rounded, size: 45,color: Colors.red,));
    }
    else{
      return const Opacity(opacity: 0.85, child: Icon(Icons.bookmark_add, size: 45,color: Colors.deepPurple,));
    }
  }

  void Function() itemOnTap({required Item item}){
    return () {
      Navigator.pushNamed(context, DetailScreen.routeName, arguments: item);
    };
  }
}