import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mini_project/screen/account/account_view_model.dart';
import 'package:mini_project/screen/detail/detail_screen.dart';
import 'package:mini_project/screen/detail/detail_view_model.dart';
import 'package:mini_project/screen/detail/person_detail_screen.dart';
import 'package:mini_project/screen/home/home_page_screen.dart';
import 'package:mini_project/screen/home/home_screen.dart';
import 'package:mini_project/screen/home/home_view_model.dart';
import 'package:mini_project/screen/all_list/all_list_screen.dart';
import 'package:mini_project/screen/search/search_screen.dart';
import 'package:mini_project/screen/search/search_view_model.dart';
import 'package:mini_project/screen/sign_up_sign_in/sign_in_screen.dart';
import 'package:mini_project/screen/sign_up_sign_in/sign_up_screen.dart';
import 'package:mini_project/screen/sign_up_sign_in/sign_up_sign_in_view_model.dart';
import 'package:mini_project/screen/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => DetailViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AccountViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SignUpSignInViewModel(),
        ),
      ],
      builder: (context, widget){
        final viewModel = Provider.of<HomeViewModel>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: SplashScreen.routeName,
          onGenerateRoute: (settings){
            if(settings.name == SplashScreen.routeName){
              return PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const SplashScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child){
                  final tween = Tween(begin: 0.0, end: 1.0);
                  return ScaleTransition(
                    scale: animation.drive(tween),
                    child: child,
                  );
                }
              );
            }
            if(settings.name == HomePage.routeName){
              return PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child){
                  final tween = Tween(begin: 0.0, end: 1.0);
                  return ScaleTransition(
                    scale: animation.drive(tween),
                    child: child,
                  );
                }
              );
            }
            if(settings.name == HomeScreen.routeName){
              return PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child){
                  final tween = Tween(begin: 0.0, end: 1.0);
                  return ScaleTransition(
                    scale: animation.drive(tween),
                    child: child,
                  );
                }
              );
            }
            if(settings.name == AllListScreen.routeName){
              return PageRouteBuilder(
                settings: settings,
                pageBuilder: (context, animation, secondaryAnimation) => const AllListScreen(),
                transitionDuration: const Duration(milliseconds: 300),
                transitionsBuilder: (context, animation, secondaryAnimation, child){
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  final tween = Tween(begin: begin, end: end);
                  final offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                }
              );
            }
            if(settings.name == DetailScreen.routeName){
              return PageRouteBuilder(
                settings: settings,
                pageBuilder: (context, animation, secondaryAnimation) => const DetailScreen(),
                transitionDuration: const Duration(milliseconds: 300),
                transitionsBuilder: (context, animation, secondaryAnimation, child){
                  final tween = Tween(begin: 0.0, end: 1.0);

                  return ScaleTransition(
                    scale: animation.drive(tween),
                    child: child,
                  );
                }
              );
            }
            if(settings.name == PersonDetailScreen.routeName){
              return PageRouteBuilder(
                settings: settings,
                pageBuilder: (context, animation, secondaryAnimation) => const PersonDetailScreen(),
                transitionDuration: const Duration(milliseconds: 300),
                transitionsBuilder: (context, animation, secondaryAnimation, child){
                  final tween = Tween(begin: 0.0, end: 1.0);

                  return ScaleTransition(
                    scale: animation.drive(tween),
                    child: child,
                  );
                }
              );
            }
            if(settings.name == SearchScreen.routeName){
              return PageRouteBuilder(
                settings: settings,
                pageBuilder: (context, animation, secondaryAnimation) => const SearchScreen(),
                transitionDuration: const Duration(milliseconds: 300),
                transitionsBuilder: (context, animation, secondaryAnimation, child){
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  final tween = Tween(begin: begin, end: end);
                  final offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                }
              );
            }
            if(settings.name == SignInScreen.routeName){
              return PageRouteBuilder(
                settings: settings,
                pageBuilder: (context, animation, secondaryAnimation) => const SignInScreen(),
                transitionDuration: const Duration(milliseconds: 300),
                transitionsBuilder: (context, animation, secondaryAnimation, child){
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  final tween = Tween(begin: begin, end: end);
                  final offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                }
              );
            }
             if(settings.name == SignUpScreen.routeName){
              return PageRouteBuilder(
                settings: settings,
                pageBuilder: (context, animation, secondaryAnimation) => const SignUpScreen(),
                transitionDuration: const Duration(milliseconds: 300),
                transitionsBuilder: (context, animation, secondaryAnimation, child){
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  final tween = Tween(begin: begin, end: end);
                  final offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                }
              );
            }
            return null;
          },
          title: 'Flutter Demo',
          theme: ThemeData(
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: viewModel.darkMode ?  Colors.white : null,
            ),
            toggleableActiveColor: Colors.deepPurple,
            primarySwatch: Colors.deepPurple,
            primaryColor: Colors.deepPurple,
            brightness: viewModel.darkMode ?  Brightness.dark : Brightness.light,
          )
        );
      }
    );
  }
}