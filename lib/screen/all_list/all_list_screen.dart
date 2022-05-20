import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project/model/item_model.dart';
import 'package:mini_project/screen/account/account_view_model.dart';
import 'package:mini_project/screen/add_to_list/add_to_list_screen.dart';
import 'package:mini_project/screen/detail/detail_screen.dart';
import 'package:mini_project/screen/home/home_view_model.dart';
import 'package:mini_project/screen/sign_up_sign_in/sign_in_screen.dart';
import 'package:mini_project/screen/sign_up_sign_in/sign_up_screen.dart';
import 'package:provider/provider.dart';

class AllListScreen extends StatefulWidget {
  static String routeName = '/allList';
  const AllListScreen({ Key? key}) : super(key: key);

  @override
  State<AllListScreen> createState() => _AllListScreenState();
}

class _AllListScreenState extends State<AllListScreen> {
  @override
  Widget build(BuildContext context) {

    final homeViewModel = Provider.of<HomeViewModel>(context);
    final accountViewModel = Provider.of<AccountViewModel>(context);
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    final title = data['title'];
    final items = data['items'];

    return Scaffold(
      appBar: AppBar(
        title: Text(title,),
      ),
      body: costumListItem(thisItem: items, homeViewModel: homeViewModel, accountViewModel: accountViewModel)
    );
  }

  Widget costumListItem({required List<Item> thisItem, required HomeViewModel homeViewModel, required AccountViewModel accountViewModel}){
    final items = homeViewModel.checkItems(thisItems: thisItem, inMyListItems: accountViewModel.all);
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context,i){
        return InkWell(
          onTap: listItemOnTap(item: items[i]),
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
                  rating(item: items[i]),
                ],
              ),
            ),
          ),
        );
      },     
    );
  }

  void Function() listItemOnTap({required Item item}){
    return () {
      Navigator.pushNamed(context, DetailScreen.routeName, arguments: item);
    };
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
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title, style: GoogleFonts.signikaNegative(fontSize: 18),maxLines: 3, overflow: TextOverflow.ellipsis,),
            const SizedBox(height: 5,),
            item.year != null ? Text(item.year, style: GoogleFonts.signikaNegative()) : const SizedBox(),
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
        backgroundColor: MaterialStateProperty.all(buttonColor(status: item.status)),
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
        Text(status!, style: GoogleFonts.signikaNegative())
      ];
    }
    else if(status == 'Dropped'){
      return [
        const Icon(Icons.warning_rounded),
        Text(status!, style: GoogleFonts.signikaNegative())
      ];
    }
    else{
      return [
        const Icon(Icons.bookmark_add),
        Text('Add to List', style: GoogleFonts.signikaNegative(),),
      ];
    }
  }

  Widget rating({required Item item}){
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.yellow,),
          Text(item.imDbRating.isNotEmpty? item.imDbRating : '--')
        ],
      ),
    );
  }

}