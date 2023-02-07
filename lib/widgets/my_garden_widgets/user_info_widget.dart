import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../globals/globals.dart';

class UserInfoWidget extends StatelessWidget {
  int? day;
   UserInfoWidget({Key? key, this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(1.0),
            decoration: BoxDecoration(
                color: kPrymaryColor,
                borderRadius: BorderRadius.circular(30)
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                imageUrl: authUser.currentUser!.photoURL.toString(),
                placeholder: (context, url) =>
                const CupertinoActivityIndicator(),
                errorWidget: (context, url, error) =>
                const Icon(Icons.error),
                fadeOutDuration: const Duration(seconds: 1),
                fadeInDuration: const Duration(seconds: 1),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
              authUser.currentUser!.displayName.toString(),
              style: GoogleFonts.sourceSansPro(
                  color: day == 0
                      ? Colors.white
                      : Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),

        ],
      ),
    );
  }
}
