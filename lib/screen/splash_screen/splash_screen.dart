import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project/screen/account/account_view_model.dart';
import 'package:mini_project/screen/home/home_page_screen.dart';
import 'package:mini_project/screen/home/home_view_model.dart';
import 'package:mini_project/screen/sign_up_sign_in/sign_up_sign_in_view_model.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = '/';
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void getData() async {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      final viewModel = Provider.of<HomeViewModel>(context, listen: false);
      final accountViewModel = Provider.of<AccountViewModel>(context, listen: false);
      final signUpSignInViewModel = Provider.of<SignUpSignInViewModel>(context, listen: false);
      final user = FirebaseAuth.instance.currentUser;
      if(user != null){
        accountViewModel.setUserData(uid: user.uid);
        accountViewModel.setSignIn();
      }
      await signUpSignInViewModel.getAllUserData();
      await viewModel.getAllData();
      await viewModel.getPreferences();
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    });
  }
  
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/mainIcon.png',
                  width: 300,
                ),
                Text('The Movie Database', style: GoogleFonts.oleoScriptSwashCaps(fontSize: 25, fontWeight: FontWeight.w700, color: Colors.white))
              ],
            )
          ],
        )
      ),
    );
  }
}