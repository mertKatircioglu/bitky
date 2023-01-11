import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bitky/widgets/add_room_widgets/add_room.dart';
import 'package:bitky/widgets/primary_button_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../globals/globals.dart';
import '../l10n/app_localizations.dart';
import '../screens/open_blog_item.dart';

class MyGarden extends StatefulWidget {
  const MyGarden({Key? key}) : super(key: key);

  @override
  State<MyGarden> createState() => _MyGardenState();
}

class _MyGardenState extends State<MyGarden> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration:  const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/plant1.png'),alignment: Alignment.bottomCenter),
          gradient: LinearGradient(
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFA5EFB0),
              ],
              begin: FractionalOffset(0.1, 1.0),
              end: FractionalOffset(0.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.mygardentitle,
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  /*  IconButton(
                        onPressed: (){
                          showSearch(context: context,
                              delegate: SearchDelegatee());
                        },
                        icon: const Icon(Icons.search_sharp))*/
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              isLoading == true
                  ? Center(
                  child: SizedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CupertinoActivityIndicator(
                          color: kPrymaryColor,
                        ),
                        WavyAnimatedTextKit(
                          textStyle: GoogleFonts.sourceSansPro(
                              fontSize: 18, color: kPrymaryColor),
                          text: [AppLocalizations.of(context)!.plswait],
                          isRepeatingAnimation: true,
                          speed: const Duration(milliseconds: 150),
                        ),
                      ],
                    ),
                  ))
                  : StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users/${authUser.currentUser!.uid}/gardens')
                      .orderBy("createdAt", descending: true)
                      .snapshots(),
                  builder: (ctx, recentSnapshot) {
                    if(recentSnapshot.connectionState == ConnectionState.waiting){
                      return const CupertinoActivityIndicator(color: Colors.transparent,);
                    }else if(recentSnapshot.data!.docs.isEmpty){
                      return Padding(
                        padding:  EdgeInsets.only(top:MediaQuery.of(context).size.height/3  ),
                        child: Center(
                          child: CustomPrimaryButton(
                            text: AppLocalizations.of(context)!.addyourfirstgardenbutton,
                            radius: 15,
                            function:()=>  PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: const AddRoomWidget(),
                              withNavBar: false,
                              pageTransitionAnimation:PageTransitionAnimation.cupertino,
                            ),
                          ),
                        ),
                      );
                    }
                    final recentDocs = recentSnapshot.data!.docs;
                    return Expanded(
                      child: FutureBuilder(
                        builder: (context, futureSnapshot) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: recentDocs.length,
                              itemBuilder: (context, index) {
                                // print(recentDocs[index]['uploadedImages'].toString());
                                var imagesJson =
                                (recentDocs[index]['images'] as List);
                                List<String> images = [];
                                imagesJson.forEach((element) {
                                  images.add(element);
                                });
                                var date = DateTime.now().day - DateTime.parse(recentDocs[index]["createdAt"].toDate().toString()).day;
                                return InkWell(
                                  onTap: (){
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: OpenBlogItemDetailScreen(images: images,title:recentDocs[index]["title"],
                                        subTitle: recentDocs[index]["subTitle"],
                                        description: recentDocs[index]["description"],
                                        category: recentDocs[index]["category"],
                                        author: recentDocs[index]["author"],
                                        date: date.toString(),
                                      ),
                                      withNavBar: false,
                                      pageTransitionAnimation:PageTransitionAnimation.cupertino,
                                    );

                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: SizedBox(
                                        height: 120,
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(15)),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                flex: 1,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      height: 90,
                                                      padding: const EdgeInsets.only(left: 5),
                                                      width: 90,
                                                      child: GridView.builder(
                                                          gridDelegate:const SliverGridDelegateWithMaxCrossAxisExtent(
                                                              maxCrossAxisExtent: 60,
                                                              childAspectRatio: 1,
                                                              crossAxisSpacing: 1,
                                                              mainAxisSpacing: 4
                                                          ),
                                                          itemCount: images.length,
                                                          itemBuilder: (_, index){
                                                            return Card(
                                                              elevation: 3,
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                        fit: BoxFit.cover,
                                                                        image: NetworkImage(images[index])
                                                                    ),
                                                                    borderRadius: BorderRadius.circular(5)
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 5,),
                                              Flexible(
                                                flex: 3,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(recentDocs[index]["title"],maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: GoogleFonts.sourceSansPro(
                                                          fontWeight: FontWeight.w600, fontSize: 16
                                                      ),),
                                                    const Padding(padding: EdgeInsets.symmetric(horizontal: 2),
                                                      child: Divider(height: 2, thickness: 0.4,),
                                                    ),
                                                    Text(recentDocs[index]["subTitle"]+"   >>>",
                                                      maxLines:2,
                                                      textAlign: TextAlign.justify,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: GoogleFonts.sourceSansPro(
                                                          fontSize: 14,
                                                          color: Colors.black54
                                                      ),),
                                                    const Padding(padding: EdgeInsets.symmetric(horizontal: 2),
                                                      child: Divider(height: 5, thickness: 0.4,),
                                                    ), Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(recentDocs[index]["author"],
                                                          style: GoogleFonts.sourceSansPro(
                                                              fontSize: 10,
                                                              fontStyle: FontStyle.italic,
                                                              color: Colors.black
                                                          ),),
                                                        Text("$date ${AppLocalizations.of(context)!.daysago}",
                                                          style: GoogleFonts.sourceSansPro(
                                                              fontSize: 10,
                                                              fontStyle: FontStyle.italic,
                                                              color: Colors.black
                                                          ),),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                );
                              });
                        },
                      ),
                    );
                  }),
            ],
          ),
        ) ,
      ),
    );

  }
}
