import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project/model/item_model.dart';
import 'package:mini_project/screen/account/account_view_model.dart';
import 'package:mini_project/screen/add_to_list/add_to_list_screen.dart';
import 'package:mini_project/screen/detail/detail_screen.dart';
import 'package:mini_project/screen/sign_up_sign_in/sign_in_screen.dart';
import 'package:mini_project/screen/sign_up_sign_in/sign_up_screen.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  static String routeName = '/account';
  const AccountScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accountViewModel = Provider.of<AccountViewModel>(context);
    return SafeArea(
      child: DefaultTabController(
        length: 5,
        initialIndex: 0,
        child: accountViewModel.isSignIn ? body(context: context, accountViewModel: accountViewModel) : notSignedInbody(context: context, thisViewModel: accountViewModel)
      ),
    );
  }

  Widget notSignedInbody({required BuildContext context, required AccountViewModel thisViewModel}){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('You are not signed, sign in or sign up to get your account',textAlign: TextAlign.center, style: GoogleFonts.signikaNegative(fontSize: 18),)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, SignInScreen.routeName);
                },
                child: const Text('Sign in')
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('Or', style: GoogleFonts.signikaNegative(fontSize: 18),),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, SignUpScreen.routeName);
                },
                child: const Text('Sign up')
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget body({required BuildContext context, required AccountViewModel accountViewModel}){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        containerView(context: context, accountViewModel: accountViewModel),
        Expanded(
          child: TabBarView(
            children:  tabBarViews(accountViewModel: accountViewModel)
          ),
        )
      ],
    );
  }

  Widget containerView({required BuildContext context, required AccountViewModel accountViewModel}){
    return Card(
      margin: const EdgeInsetsDirectional.all(0),
      elevation: 5,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.deepPurple, Colors.black])
        ),
        child: Column(
          children: [
            accountView(context: context, accountViewModel: accountViewModel),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text('Your List', style: GoogleFonts.signikaNegative(fontSize: 20, color: Colors.white),),
            ),
            tabBar()
          ],
        ),
      ),
    );
  }

  Widget accountView({required BuildContext context, required AccountViewModel accountViewModel}){
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 25,
            child: Icon(Icons.person, size: 30,),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize : MainAxisSize.min,
                children: [
                  Text(accountViewModel.username, style: GoogleFonts.signikaNegative(color: Colors.white,fontSize: 18),),        
                  Text('Your List count : ${accountViewModel.all.length}', style: GoogleFonts.signikaNegative(color: Colors.white,fontSize: 18),)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: signOutButton(context: context, accountViewModel: accountViewModel),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget signOutButton({required BuildContext context, required AccountViewModel accountViewModel}){
    return ElevatedButton(
      onPressed: ()async{
        final isError = accountViewModel.state == AccountViewState.error;
        accountViewModel.signOut();
        await showDialog(
          context: context,
          builder: (context){
            final thisState = Provider.of<AccountViewModel>(context).state;
            final isError = thisState == AccountViewState.error;
            final isDone = thisState == AccountViewState.done;
            if(isDone || isError){
              Navigator.pop(context);
            }
            return const Center(child: CircularProgressIndicator(),);
          }
        );
        if(isError){
          final snackBar = SnackBar(content: Text('Sign Out failed, check your internet connection', style: GoogleFonts.signikaNegative()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        else{
          final snackBar = SnackBar(content: Text('Succesfuly Signed out', style: GoogleFonts.signikaNegative()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: const Text('Sign Out')
    );
  }

  Widget tabBar(){
    return TabBar(
      indicatorSize: TabBarIndicatorSize.label,
      isScrollable: true,
      labelPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      indicatorWeight: 2,
      indicatorColor: Colors.white,
      labelStyle: GoogleFonts.signikaNegative(fontSize: 16),
      tabs: const [
        Text('All',textAlign: TextAlign.center),
        Text('Plan to Watch',textAlign: TextAlign.center),
        Text('Watching',textAlign: TextAlign.center),
        Text('Finished',textAlign: TextAlign.center),
        Text('Dropped',textAlign: TextAlign.center),
      ]
    );
  }

  List<Widget> tabBarViews({required AccountViewModel accountViewModel}){
    return [
      costumListItem(allItems: accountViewModel.all, status: 'All'),
      costumListItem(allItems: accountViewModel.all, status: 'Plan to watch'),
      costumListItem(allItems: accountViewModel.all, status: 'Watching'),
      costumListItem(allItems: accountViewModel.all, status: 'Finished'),
      costumListItem(allItems: accountViewModel.all, status: 'Dropped'),
    ];
  }

  Widget costumListItem({required List<Item> allItems, required String status}){
    List<Item> items;
    status == 'All' ?  items = allItems : items = allItems.where((element) => element.status == status).toList();
    if (items.isEmpty) {
      return Center(child: Text('Your $status list is empty', style: GoogleFonts.signikaNegative(fontSize: 20) ,),);
    } else {
      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context,i){
          return InkWell(
            onTap: listItemOnTap(context: context, item: items[i]),
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
                    mainDetail(item: items[i], context: context),
                    mainRating(item: items[i])
                  ],
                ),
              ),
            ),
          );
        },     
      );
    }
  }

  void Function() listItemOnTap({required BuildContext context, required Item item}){
    return () {
      Navigator.pushNamed(context, DetailScreen.routeName, arguments: item);
    };
  }

  Widget mainImage({required Item item}){
    return SizedBox(
      width: 150,
      child: CachedNetworkImage(
        memCacheHeight: 800,
        memCacheWidth: 600,
        imageUrl: item.image,
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
              image: DecorationImage(
                image: imageProvider, fit: BoxFit.cover
              )
            ),
          );
        },
      ),
    );
  }

  Widget mainDetail({required Item item, required BuildContext context}){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal : 8.0),
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
                  addToListButton(item: item, context: context)
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget addToListButton({required Item item, required BuildContext context}){
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
                        Navigator.pushNamed(context, SignInScreen.routeName);
                      },
                      child: const Text('Sign in')
                    ),
                    const SizedBox(width: 10,),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pushNamed(context, SignUpScreen.routeName);
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

  Widget mainRating({required Item item}){
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.yellow,),
        Text(item.imDbRating ?? '--')
      ],
    );
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

}