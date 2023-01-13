import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bitky/globals/globals.dart';
import 'package:bitky/l10n/app_localizations.dart';
import 'package:bitky/screens/open_blog_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class FlowItem extends StatefulWidget {
  const FlowItem({Key? key}) : super(key: key);

  @override
  State<FlowItem> createState() => _FlowItemState();
}

class _FlowItemState extends State<FlowItem> {
  bool isLoading = false;
  Future<QuerySnapshot>? blogs;
  String title="";




  initSearching(String text) async{
   blogs= FirebaseFirestore.instance.collection('blog').
    where('title', isGreaterThanOrEqualTo: text).get();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/banner.png'),alignment: Alignment.topCenter),
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
                      AppLocalizations.of(context)!.flowtitle,
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                        onPressed: (){
                      showSearch(context: context,
                          delegate: SearchDelegatee());
                    },
                        icon: const Icon(Icons.search_sharp))
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
                          .collection('blog')
                          .orderBy("createdAt", descending: true)
                          .snapshots(),
                      builder: (ctx, recentSnapshot) {
                        if(recentSnapshot.connectionState == ConnectionState.waiting){
                          return const CupertinoActivityIndicator(color: Colors.transparent,);
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
                                                          height: 80,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(15)
                                                            ),
                                                          padding: const EdgeInsets.only(left: 5),
                                                          width: 80,
                                                          child: Card(
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(15)
                                                            ),
                                                            elevation: 3,
                                                            child:Card(
                                                              margin: const EdgeInsets.all(0),
                                                              elevation: 5,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(15)
                                                              ),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(15),
                                                                child: CachedNetworkImage(
                                                                  height: 80,
                                                                  width: 80,
                                                                  fit: BoxFit.cover,
                                                                  imageUrl: images[0],
                                                                  placeholder: (context, url) =>
                                                                  const CupertinoActivityIndicator(),
                                                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                  fadeOutDuration: const Duration(seconds: 1),
                                                                  fadeInDuration: const Duration(seconds: 2),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
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
        ),
      ),
    );
  }
}


class SearchDelegatee extends SearchDelegate{
  @override
  List<Widget>? buildActions(BuildContext context) {
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: ()=>close(context, null),
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
  IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: (){
    if(query.isEmpty){
      close(context, null);
    }else{
      query = '';
    }
    },
  );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
   var blogs = FirebaseFirestore.instance.collection('blog').
    where('title', isGreaterThanOrEqualTo: query).get();

    return FutureBuilder(
      future: blogs,
        builder: (context, snapshots){
         var recentDocs = snapshots.data!.docs;
         if(snapshots.connectionState == ConnectionState.waiting){
           return const Center(child: CupertinoActivityIndicator(color: Colors.transparent,));
         }
          return ListView.builder(
            itemCount: recentDocs.length,
              itemBuilder: (context, index){
              return ListTile(
                title: Text(recentDocs[index]["title"]),
                onTap: (){
                  query = recentDocs[index]["title"];
                  var date = DateTime.now().day - DateTime.parse(recentDocs[index]["createdAt"].toDate().toString()).day;
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: OpenBlogItemDetailScreen(images: recentDocs[index]["images"],title:recentDocs[index]["title"],
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
              );
              });
        });
  }

}

