import 'package:flutter/material.dart';
import 'package:mini_project/view/account/account_screen.dart';
import 'package:mini_project/view/home/home_screen.dart';
import 'package:mini_project/view/search/search_screen.dart';

class HomePage extends StatefulWidget {
  static String routeName = '/homePage';
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedPage = 0;
  final List<Widget> _pageOption = [
    const HomeScreen(),
    const AccountScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(_selectedPage != 0){
          setState(() {
            _selectedPage = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: IndexedStack(index: _selectedPage, children: _pageOption),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
          ],
          elevation: 5,
          currentIndex: _selectedPage == 1 ? 2 : _selectedPage,
          onTap: (index){
            setState(() {
              if(index == 2){
                _selectedPage = 1;
              }

              if(index == 0){
                _selectedPage = 0;
              }
              
              if(index == 1){
                Navigator.pushNamed(context, SearchScreen.routeName);
              }
            });
          },
        ),
      ),
    );
  }
}