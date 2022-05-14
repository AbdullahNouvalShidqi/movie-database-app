import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_project/main.dart';


class CostumBindings extends AutomatedTestWidgetsFlutterBinding{
  @override
  bool get overrideHttpClient => false;

  
}

void main(){
  CostumBindings();
  group('UI/Widget test', () {
    
    testWidgets('Testing SplashScreen', (WidgetTester tester) async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      await tester.pumpWidget(const MyApp());
      expect(find.byType(Image), findsOneWidget);
    });
  });
}
