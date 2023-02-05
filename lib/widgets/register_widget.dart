
import 'dart:io';

import 'package:bitky/globals/globals.dart';
import 'package:bitky/screens/home_screen.dart';
import 'package:bitky/screens/splash_screen.dart';
import 'package:bitky/widgets/custom_textfield.dart';
import 'package:bitky/widgets/primary_button_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../locator.dart';
import '../view_models/planet_view_model.dart';
import 'custom_error_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;


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
  String userImageUrl ="";
  XFile? imageXfile;
  final ImagePicker _picker = ImagePicker();


  Future<void> formValidation() async{
    if(imageXfile == null){
      showDialog(context: context,
          builder: (c){
            return CustomErrorDialog(message: AppLocalizations.of(context)!.plsselectaphoto,);
          });
    }else {
      if (passwordController.text == confirmPasswordController.text) {
        if (passwordController.text.length < 5 &&
            confirmPasswordController.text.length < 5) {
          showDialog(context: context,
              builder: (c) {
                return CustomErrorDialog(
                  message: AppLocalizations.of(context)!.passwordwarningone,);
              });
        } else {
          if (confirmPasswordController.text.isNotEmpty &&
              emailController.text.isNotEmpty &&
              nameController.text.isNotEmpty) {
            showDialog(context: context, builder: (c) {
              return const CupertinoActivityIndicator();
            });

            String fileName= DateTime.now().millisecondsSinceEpoch.toString();
            fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child("users").
            child(fileName);
            fStorage.UploadTask uploadTask = reference.putFile(File(imageXfile!.path));
            fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
            await taskSnapshot.ref.getDownloadURL().then((url) => {
              userImageUrl = url,
            authSellerAndSignUp()
            });
          } else {
            showDialog(context: context,
                builder: (c) {
                  return CustomErrorDialog(
                    message: AppLocalizations.of(context)!.fillallfields,);
                });
          }
        }
      } else {
        showDialog(context: context,
            builder: (c) {
              return CustomErrorDialog(
                message: AppLocalizations.of(context)!.passwordwarningtwo,);
            });
      }
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


  Future saveDataToFirestore(User currentUser) async{
    currentUser.updateDisplayName(nameController.text.trim());
    currentUser.updatePhotoURL(userImageUrl);
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
      userImageUrl ="";
    });
  }
  Future<void> _getImage() async{
    imageXfile = await _picker.pickImage(source: ImageSource.gallery);
    setState((){
      imageXfile;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: (){
              _getImage();
            },
            child: DottedBorder(
              borderType: BorderType.Circle,
              padding: const EdgeInsets.all(1),
              color: kPrymaryColor,
              strokeCap: StrokeCap.butt,
              child: CircleAvatar(
                radius:40,
                backgroundColor: Colors.white,
                backgroundImage: imageXfile == null ? null : FileImage(File(imageXfile!.path)),
                child: imageXfile == null ? const Icon(Icons.add_a_photo_outlined,
                  size:20,
                  color: kPrymaryColor,
                ) : null,
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Text(AppLocalizations.of(context)!.registertitle,
           textAlign: TextAlign.center,
           style: const TextStyle(
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
                        hintText: AppLocalizations.of(context)!.namesurname,
                        isObscreen: false,
                        height: 25,
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Card(
                      child: CustomTextField(
                        iconData: Icons.email,
                        controller: emailController,
                        hintText: AppLocalizations.of(context)!.email,
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
                        hintText: AppLocalizations.of(context)!.password,
                        isObscreen: true,
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Card(
                      child: CustomTextField(
                        height: 25,
                        controller: confirmPasswordController,
                        iconData: Icons.key,
                        hintText: AppLocalizations.of(context)!.confirmpassword,
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
                    text: AppLocalizations.of(context)!.registerbutton,
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
                        child: Text(
                          AppLocalizations.of(context)!.cancelbutton, style: const TextStyle(color: Colors.white),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
