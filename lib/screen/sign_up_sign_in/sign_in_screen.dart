import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project/screen/account/account_view_model.dart';
import 'package:mini_project/screen/sign_up_sign_in/sign_up_screen.dart';
import 'package:mini_project/screen/sign_up_sign_in/sign_up_sign_in_view_model.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  static String routeName = '/signIn';
  const SignInScreen({ Key? key }) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool hidePassword = true;

  @override
  void dispose() {
    super.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<SignUpSignInViewModel>(context, listen: false).getAllUserData();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final signInViewModel = Provider.of<SignUpSignInViewModel>(context);
    final accountViewModel = Provider.of<AccountViewModel>(context);
    return WillPopScope(
      onWillPop: ()async{
        if(signInViewModel.state == SignUpSignInState.error){
          signInViewModel.changeState(SignUpSignInState.none);
          if(accountViewModel.state == AccountViewState.error){
            accountViewModel.changeState(AccountViewState.none);
          }
          return true;
        }
        return true;
      },
      child: Scaffold(
        body: body(signInViewModel: signInViewModel, accountViewModel: accountViewModel)
      ),
    );
  }

  Widget body({required SignUpSignInViewModel signInViewModel, required AccountViewModel accountViewModel}){
    // final isLoading = signInViewModel.state == SignUpSignInState.loading || accountViewModel.state == AccountViewState.laoding;
    final isError = accountViewModel.state == AccountViewState.error;

    // if(isLoading){
    //   return const Center(child: CircularProgressIndicator(),);
    // }
    if(isError){
      return const Center(child: Text('Error : Check your internet connection'),);
    }

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(36),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                main(),
                const SizedBox(height: 45,),
                emailFormField(),
                const SizedBox(height: 25,),
                passwordFormField(),
                const SizedBox(height: 35,),
                signInButton(signInViewModel: signInViewModel, accountViewModel: accountViewModel),
                const SizedBox(height: 15,),
                signUp()
              ],
            ),
          ),
        )
      ),
    );
  }

  Widget main(){
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Column(
        children: [
          Image.asset(
            'assets/mainIcon.png',
            width: 300,
          ),
          Text('The Movie Database', style: GoogleFonts.oleoScriptSwashCaps(fontSize: 25, fontWeight: FontWeight.w700))
        ],
      ),
    );
  }

  Widget emailFormField(){
    return TextFormField(
      controller: _emailCtrl,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        label: const Text('Email/Username'),
        prefixIcon: const Icon(Icons.email),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))
      ),
      validator: (String? newValue){
        if(newValue == null || newValue.isEmpty || newValue == ' '){
          return 'Please input your email/username';
        }
        else if(newValue.contains(' ') || newValue.contains('  ') || RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(newValue)){
          return 'Please input your email/username correctly';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
    );
  }

  Widget passwordFormField(){
    return TextFormField(
      controller: _passwordCtrl,
      keyboardType: TextInputType.visiblePassword,
      obscureText: hidePassword,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        label: const Text('Password'),
        prefixIcon: const Icon(Icons.password),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: IconButton(
          onPressed: (){
            setState(() {
              hidePassword = !hidePassword;
            });
          },
          icon: const Icon(Icons.remove_red_eye),
        )
      ),
      validator: (String? newValue){
        if(newValue == null || newValue.isEmpty || newValue == ' '){
          return 'Please input your password';
        }
        else if(newValue.contains('  ') || newValue.length < 6){
          return 'Please input your password correctly';
        }
        return null;
      },
      textInputAction: TextInputAction.done,
    );
  }

  Widget signInButton({required SignUpSignInViewModel signInViewModel, required AccountViewModel accountViewModel}){
    final isLoading = signInViewModel.state == SignUpSignInState.loading || accountViewModel.state == AccountViewState.laoding;
    return ElevatedButton(
      onPressed: isLoading ? null : () async {
        if(!_formKey.currentState!.validate())return;
        final allUserData = signInViewModel.allUserData;
        
        if(allUserData.isNotEmpty){
          for(var i in allUserData){
            if(i.userName == _emailCtrl.text){
              _emailCtrl.text = i.email;
            }
          }
        }

        await signInViewModel.signIn(email: _emailCtrl.text, password: _passwordCtrl.text);
        final user = FirebaseAuth.instance.currentUser;
        
        if(user != null){
          await accountViewModel.setUserData(uid: user.uid);
          accountViewModel.setSignIn();
          final snackBar = SnackBar(content: Text('Sign in Succes', style: GoogleFonts.signikaNegative(),));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pop(context);
        }
        else{
          final snackBar = SnackBar(content: Text('Sign in Failed, check your username or password', style: GoogleFonts.signikaNegative()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        
      },
      child: isLoading ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2,) : Text('Sign in', style: GoogleFonts.signikaNegative(fontSize: 18, fontWeight: FontWeight.bold),),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        fixedSize: MaterialStateProperty.all(const Size(100, 45))
      ),
    );
  }

  Widget signUp(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account ?", style: GoogleFonts.signikaNegative(),),
        TextButton(
          onPressed: (){
            Navigator.pushReplacementNamed(context, SignUpScreen.routeName);
          },
          child: Text('Sign up', style: GoogleFonts.signikaNegative(fontWeight: FontWeight.bold))
        )
      ],
    );
  }
}