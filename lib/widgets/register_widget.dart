
import 'package:bitky/globals/globals.dart';
import 'package:bitky/screens/home_screen.dart';
import 'package:bitky/widgets/custom_textfield.dart';
import 'package:bitky/widgets/primary_button_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../locator.dart';
import '../view_models/planet_view_model.dart';
import 'custom_error_dialog.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({Key? key}) : super(key: key);

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> formValidation() async{
    if(passwordController.text == confirmPasswordController.text){
      if(passwordController.text.length <5 && confirmPasswordController.text.length <5){
        showDialog(context: context,
            builder: (c){
              return CustomErrorDialog(message: 'Password must be longer than 6 characters',);
            });
      }else{
        if(confirmPasswordController.text.isNotEmpty && emailController.text.isNotEmpty &&
            nameController.text.isNotEmpty){
          showDialog(context: context, builder:(c){
            return const CupertinoActivityIndicator();
          });
          authSellerAndSignUp();
        }else{
          showDialog(context: context,
              builder: (c){
                return CustomErrorDialog(message: 'Please fill all fields.',);
              });
        }
      }
    } else{
      showDialog(context: context,
          builder: (c){
            return CustomErrorDialog(message: 'Password and confirm password does not match',);
          });
    }

  }

  void authSellerAndSignUp() async{
    User? currentUser;
    await authUser.createUserWithEmailAndPassword(email: emailController.text.trim(),
        password: passwordController.text.trim()).then((auth) => {
      currentUser= auth.user,
      saveDataToFirestore(currentUser!),
    }).catchError((error){
      Navigator.pop(context);
      showDialog(context: context, builder: (c){
        return CustomErrorDialog(message: error.toString(),);
      });
    });
    if(currentUser != null){
      saveDataToFirestore(currentUser!).then((value) => {
        Navigator.pop(context),
        Navigator.of(context).pushReplacement(_createRoute())
      });
    }
  }


  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return ChangeNotifierProvider<BitkyViewModel>(
            create: (context)=>locator<BitkyViewModel>(),
            child:const HomeScreen());
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


  Future saveDataToFirestore(User currentUser) async{
    FirebaseFirestore.instance.collection("users").doc(currentUser.uid).
    set({
      "userUid": currentUser.uid,
      "userName": nameController.text.trim(),
      "userEmail": emailController.text.toString(),
      "createDate": DateTime.now()
    });}

  clearMenusUploadForm(){
    setState((){
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();

    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
       const Text("Register with email & password",
         textAlign: TextAlign.center,
         style: TextStyle(
           color: kPrymaryColor,
          fontWeight: FontWeight.w500,
          fontSize: 16
        ),),
       const SizedBox(height: 10,),
        Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [

                  Card(
                    child: CustomTextField(
                      iconData: Icons.person,
                      controller: nameController,
                      hintText: 'Name & surname',
                      isObscreen: false,
                      height: 25,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Card(
                    child: CustomTextField(
                      iconData: Icons.email,
                      controller: emailController,
                      hintText: 'e-mail',
                      height: 25,
                      isObscreen: false,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Card(
                    child: CustomTextField(
                      iconData: Icons.key,
                      controller: passwordController,
                      height: 30,
                      hintText: 'Password',
                      isObscreen: true,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Card(
                    child: CustomTextField(
                      height: 25,
                      controller: confirmPasswordController,
                      iconData: Icons.key,
                      hintText: 'Confirm password',
                      isObscreen: true,
                    ),
                  ),

                ],
              ),
            )),
        const SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomPrimaryButton(
                  text: "Register",
                  radius: 3.0,
                  function: formValidation,
                ),
              ),
              const SizedBox(width: 15,),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xfffD7816A),Color(0xfffBD4F6C)]),
                      borderRadius:BorderRadius.circular(3.0)
                  ),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)
                          )
                      ),
                      onPressed:(){
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancel", style: TextStyle(color: Colors.white),
                      )),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
