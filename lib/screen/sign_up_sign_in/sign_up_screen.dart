import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project/screen/account/account_view_model.dart';
import 'package:mini_project/screen/sign_up_sign_in/sign_up_sign_in_view_model.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  static String routeName = '/signUp';
  const SignUpScreen({ Key? key }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final _formKey = GlobalKey<FormState>();
  final _userNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  bool _hidePassword = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    super.dispose();
    _userNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPassCtrl.dispose();
    _otpCtrl.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await Provider.of<SignUpSignInViewModel>(context, listen: false).getAllUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final signUpViewModel = Provider.of<SignUpSignInViewModel>(context);
    final accountViewModel = Provider.of<AccountViewModel>(context);
    return Scaffold(
      body: body(signUpViewModel: signUpViewModel, accountViewModel: accountViewModel)
    );
  }
  
  Widget body({required SignUpSignInViewModel signUpViewModel, required AccountViewModel accountViewModel}){
    final isLoading = signUpViewModel.state == SignUpSignInState.loading || accountViewModel.state == AccountViewState.laoding;

    if(isLoading){
      return const Center(child: CircularProgressIndicator(),);
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
                userNameField(signInViewModel: signUpViewModel),
                const SizedBox(height: 25,),
                emailFormField(signInViewModel: signUpViewModel),
                const SizedBox(height: 25,),
                passwordFormField(),
                const SizedBox(height: 25,),
                confirmPasswordField(),
                const SizedBox(height: 15,),
                signUp(signUpViewModel: signUpViewModel, accountViewModel: accountViewModel)
              ],
            ),
          ),
        )
      ),
    );
  }

  Widget main(){
    return const Padding(
      padding:  EdgeInsets.only(top: 100),
      child:  CircleAvatar(
        backgroundColor: Colors.deepPurple,
        radius: 50,
        child: Icon(Icons.person, size: 55,),
      ),
    );
  }

  Widget userNameField({required SignUpSignInViewModel signInViewModel}){
    return TextFormField(
      controller: _userNameCtrl,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        label: const Text('UserName'),
        hintText: 'name_lastName',
        prefixIcon: const Icon(Icons.email),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))
      ),
      validator: (String? newValue){
        if(newValue == null || newValue.isEmpty || newValue == ' '){
          return 'Please input your username';
        }
        if(newValue.contains(' ') || newValue.contains('  ') || RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(newValue)){
          return 'Please input your username with no spaces';
        }
        if(signInViewModel.allUserData.any((e) => e.userName.toLowerCase() == newValue.toLowerCase())){
          return 'Username is already used';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
    );
  }

  Widget emailFormField({required SignUpSignInViewModel signInViewModel}){
    return TextFormField(
      controller: _emailCtrl,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        label: const Text('Email'),
        hintText: 'expample@email.com',
        prefixIcon: const Icon(Icons.email),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))
      ),
      validator: (String? newValue){
        if(newValue == null || newValue.isEmpty || newValue == ' '){
          return 'Please input your email';
        }
        if(newValue.contains(' ') || newValue.contains('  ') || !newValue.contains('@') || !newValue.contains('.')){
          return 'Please input your email correctly';
        }
        if(signInViewModel.allUserData.any((e) => e.email == newValue)){
          return 'Email is alredy used';
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
      obscureText: _hidePassword,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        label: const Text('Password'),
        prefixIcon: const Icon(Icons.password),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: IconButton(
          onPressed: (){
            setState(() {
              _hidePassword = !_hidePassword;
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
      textInputAction: TextInputAction.next,
    );
  }

  Widget confirmPasswordField(){
    return TextFormField(
      controller: _confirmPassCtrl,
      keyboardType: TextInputType.visiblePassword,
      obscureText: _hideConfirm,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        label: const Text('Confirm Password'),
        prefixIcon: const Icon(Icons.password),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: IconButton(
          onPressed: (){
            setState(() {
              _hideConfirm = !_hideConfirm;
            });
          },
          icon: const Icon(Icons.remove_red_eye),
        )
      ),
      validator: (String? newValue){
        if(newValue == null || newValue != _passwordCtrl.text){
          return 'Confirm password is different with the password';
        }
        return null;
      },
      textInputAction: TextInputAction.done,
    );
  }

  Widget signUp({required SignUpSignInViewModel signUpViewModel, required AccountViewModel accountViewModel}){
    return ElevatedButton(
      onPressed: () async {
        if(!_formKey.currentState!.validate())return;

        await signUpViewModel.signUp(email: _emailCtrl.text, password: _passwordCtrl.text, username: _userNameCtrl.text);
        final user = FirebaseAuth.instance.currentUser;
        if(user != null){
          await accountViewModel.setUserData(uid: user.uid);
          accountViewModel.setSignIn();
          final snackBar = SnackBar(content: Text('Sign up Succes', style: GoogleFonts.signikaNegative()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pop(context);
        }
        else{
          final snackBar = SnackBar(content: Text('Sign up Failed, check your username or password', style: GoogleFonts.signikaNegative()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } 
        
      },
      child: Text('Sign up', style: GoogleFonts.signikaNegative(fontSize: 18, fontWeight: FontWeight.bold),),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      ),
    ); 
  }
}