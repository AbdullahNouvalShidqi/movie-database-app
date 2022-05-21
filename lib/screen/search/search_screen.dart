import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project/model/item_model.dart';
import 'package:mini_project/screen/account/account_view_model.dart';
import 'package:mini_project/screen/add_to_list/add_to_list_screen.dart';
import 'package:mini_project/screen/detail/detail_screen.dart';
import 'package:mini_project/screen/home/home_view_model.dart';
import 'package:mini_project/screen/search/search_view_model.dart';
import 'package:mini_project/screen/sign_up_sign_in/sign_in_screen.dart';
import 'package:mini_project/screen/sign_up_sign_in/sign_up_screen.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static String routeName = '/searchScreen';
  const SearchScreen({ Key? key }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchCtrl = TextEditingController();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    final accountViewModel = Provider.of<AccountViewModel>(context);
    final searchViewModel = Provider.of<SearchViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchCtrl,
          style: GoogleFonts.signikaNegative(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintStyle: GoogleFonts.signikaNegative(color: Colors.white, fontWeight: FontWeight.w100),
            icon: const Icon(Icons.search, color: Colors.white,),
            hintText: 'Search...'
          ),
          onChanged: (search){
            searchViewModel.searchOperation(search, homeViewModel.allItem);
          },
        ),
        actions: [
          _searchCtrl.text.isEmpty ? const Center() :
          IconButton(
            onPressed: (){
              _searchCtrl.text = '';
              searchViewModel.clearSearchList();
            },
            icon: const Icon(Icons.highlight_remove)
          )
        ],
      ),
      body: _searchCtrl.text.isNotEmpty  ?
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Search Results', style: GoogleFonts.signikaNegative(fontSize: 20),),
                sortDropDownButton(searchViewModel: searchViewModel)
              ],
            ),
          ),
          Expanded(child: body(items: searchViewModel.searchResult,homeViewModel: homeViewModel, inMyListItems: accountViewModel.all, searchViewModel: searchViewModel)),
        ],
      ) : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('All Movies/Series', style: GoogleFonts.signikaNegative(fontSize: 20),),
                sortDropDownButton(searchViewModel: searchViewModel)
              ],
            ),
          ),
          Expanded(child: body(items: homeViewModel.allItem,homeViewModel: homeViewModel, inMyListItems: accountViewModel.all, searchViewModel: searchViewModel)),
        ],
      )
    );
  }

  Widget body({required List<Item> items, required HomeViewModel homeViewModel, required List<Item> inMyListItems, required SearchViewModel searchViewModel}){
    return items.isEmpty ? Center(child: Text('No data found', style: GoogleFonts.signikaNegative(fontSize: 20),),) :
    costumListItem(thisItem: items,homeViewModel: homeViewModel, inMyListItems: inMyListItems, searchViewModel: searchViewModel);
  }

  Widget costumListItem({required List<Item> thisItem, required List<Item> inMyListItems, required HomeViewModel homeViewModel, required SearchViewModel searchViewModel}){
    final items = homeViewModel.checkItems(thisItems: thisItem, inMyListItems: inMyListItems);
    sorting(items: items, sort: searchViewModel.sort);
    
    return ListView.builder(
      controller: scrollController,
      itemCount: items.length,
      itemBuilder: (context,i){
        return InkWell(
          onTap: itemOnTap(item: items[i]),
          child: Container(
            height: 235,
            decoration: const BoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  mainImage(item: items[i]),
                  mainDetail(item: items[i]),
                  rating(item: items[i])
                ],
              ),
            ),
          ),
        );
      },     
    );
  }

  Widget mainImage({required Item item}){
    return SizedBox(
      width: 150,
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
        fit: BoxFit.cover,
        imageBuilder: (context, imageProvider){
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                image: imageProvider, fit: BoxFit.cover
              )
            ),
          );
        },
      ),
    );
  }

  Widget mainDetail({required Item item}){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal : 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title, style: GoogleFonts.signikaNegative(fontSize: 18),maxLines: 3, overflow: TextOverflow.ellipsis,),
            const SizedBox(height: 5,),
            Text(item.year, style: GoogleFonts.signikaNegative()),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  item.myRating != null ? Text('My Rating : ${item.myRating}', style: GoogleFonts.signikaNegative(),) : const SizedBox(),
                  addToListButton(item: item)
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget addToListButton({required Item item}){
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

  Widget rating({required Item item}){
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.yellow,),
          Text(item.imDbRating.isNotEmpty && item.imDbRating != null ? item.imDbRating : '--')
        ],
      ),
    );
  }

  Widget sortDropDownButton({required SearchViewModel searchViewModel}){
    return DropdownButton(
      value: searchViewModel.sort,
      hint: const Text('Sort By'),
      items: <String>['Name','Rating','Year']
      .map((value) => DropdownMenuItem<String>(child: Text(value,style: GoogleFonts.signikaNegative(),), value: value)).toList(),
      onChanged: searchViewModel.onChangedSort
    );
  }

  void sorting({required List<Item> items ,required String? sort}){
  if(sort == 'Name'){
    items.sort((a, b) => a.title.toString().compareTo(b.title));
  }
  if(sort == 'Rating'){
    items.sort((a, b) => b.imDbRating.toString().compareTo(a.imDbRating.toString()),);
  }
  if(sort == 'Year'){
    items.sort((a, b) => b.year.toString().compareTo(a.year.toString()),);
  }
 }

  void Function() itemOnTap({required Item item}){
    return () {
      Navigator.pushNamed(context, DetailScreen.routeName, arguments: item);
    };
  }
}