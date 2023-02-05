import 'package:bitky/l10n/app_localizations.dart';
import 'package:bitky/screens/splash_screen.dart';
import 'package:bitky/widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../globals/globals.dart';
import '../locator.dart';
import '../view_models/planet_view_model.dart';
import '../widgets/custom_error_dialog.dart';
import '../widgets/register_widget.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Color okeyColor = Colors.grey;
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();


  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return ChangeNotifierProvider<BitkyViewModel>(
            create: (context)=>locator<BitkyViewModel>(),
            child: const SplashScreen());
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }


  Future loginUser() async {
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
      showDialog(context: context, builder: (c){
        return const CupertinoActivityIndicator();
      });
      await authUser.signInWithEmailAndPassword(email: emailController.text.trim(),
          password: passwordController.text.trim()).then((auth){
        User? currentUser;
        currentUser = auth.user!;
        if(currentUser != null){
          Navigator.of(context).push(_createRoute());
        } else{
          showDialog(context: context, builder: (c){
            return CustomErrorDialog(message:AppLocalizations.of(context)!.usernotfound);
          });
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=>const AuthScreen()));

        }
      }).catchError((err){
        Navigator.pop(context);
        showDialog(context: context, builder: (c){
          return CustomErrorDialog(message: err.toString(),);
        });
      });
    }else{
      showDialog(context: context, builder: (c){
        return CustomErrorDialog(message: AppLocalizations.of(context)!.fillallfields,);
      });
    }
  }
  Widget _dialog(BuildContext context){
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)),
    elevation: 0,
      content: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                    Radius.circular(15))),
            child: const RegisterWidget(),
          ),
        ),

    );
  }

  void _scaleDialog(Widget dialog) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "go",
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child:dialog,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Future<void> signupWithGoogle(BuildContext context) async {
    showDialog(context: context, builder: (c){
      return const CupertinoActivityIndicator();
    });
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      // Getting users credential
      UserCredential result = await authUser.signInWithCredential(authCredential);
      User? user = result.user;
      if (result != null) {
        FirebaseFirestore.instance.collection("users").doc(user!.uid).
        set({
          "userUid": user.uid,
          "userName": user.displayName,
          "userEmail": user.email,
          "createDate": DateTime.now()
        });

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c){
          return ChangeNotifierProvider<BitkyViewModel>(
              create: (context)=>locator<BitkyViewModel>(),
              child:const SplashScreen());
        })).whenComplete(() => Navigator.pop(context));

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFA5EFB0),
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(3.0, 2.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.signin, style:GoogleFonts.sourceSansPro(color:Colors.black45,fontSize: 28, fontWeight: FontWeight.w600, shadows: [
              const Shadow(
                offset: Offset(0.0, 0.0),
                blurRadius: 2.0,
                color: Color.fromARGB(255, 140, 211, 140),
              ),
            ]),),
            const SizedBox(height: 20,),
            CustomTextField(
              iconData: Icons.person,
              controller: emailController,
              hintText: AppLocalizations.of(context)!.email,
              isObscreen: false,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.2,
              height: 45,
              decoration:const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(6)
                  )
              ),
              margin:const EdgeInsets.all(10),
              child: TextFormField(
                controller: passwordController,
                onChanged: (currentValue){
                  if(passwordController.text.length == 6){
                    setState((){
                      okeyColor = Colors.green;
                    });
                  }
                },
                obscureText: true,
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                    suffixIcon: Card(
                      elevation: 0,
                      child: IconButton(
                        onPressed: (){
                          loginUser();

                        },
                        icon:const Icon(Icons.login),
                        color: okeyColor,
                      ),
                    ),
                    border: InputBorder.none,
                    prefixIcon:const Icon(Icons.lock, color: Colors.black45,),
                    focusColor: Theme.of(context).primaryColor,
                    hintText: AppLocalizations.of(context)!.password
                ),
              ),
            ),
            const SizedBox(height: 10,),
            SignInButton(
              Buttons.Google,
              onPressed: () {
                signupWithGoogle(context);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                SignInButton(
                  Buttons.Facebook,
                  mini: true,
                  onPressed: () {},
                ),


                SignInButton(
                  Buttons.AppleDark,
                  mini: true,
                  onPressed: () {
                  },
                ),

                SignInButton(
                  Buttons.Email,
                  mini: true,
                  onPressed: () {
                    _scaleDialog(_dialog(context));
                  },
                ),
              ],
            ),
            const SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                Text(AppLocalizations.of(context)!.forgotpass, style:const TextStyle(color: Colors.black45)),
                Text(AppLocalizations.of(context)!.clickhere, style:const TextStyle(color: Colors.blueAccent),)
              ],
            )
          ],
        ),
      ),
    );
  }
}
