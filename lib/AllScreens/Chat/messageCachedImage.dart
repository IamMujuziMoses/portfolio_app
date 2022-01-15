import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class MessageCachedImage extends StatelessWidget {
  final String imageUrl;
  final bool isSender;
  final bool isRound;
  final double radius;
  final double height;
  final double width;
  final BoxFit fit;
  final String noImageAvailable =
      "https://firebasestorage.googleapis.com/v0/b/emalert-2788e.appspot.com/o/logo.png?alt=media&token=" +
      "f040ba3d-c7da-4e77-b8ef-4ad3746994c9";

  const MessageCachedImage({Key key,
    this.imageUrl,
    this.isSender,
    this.isRound = false,
    this.radius,
    this.height,
    this.width,
    this.fit = BoxFit.cover}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   try {
       return SizedBox(
         height: isRound ? radius : height,
         width: isRound ? radius : width,
         child: ClipRRect(
           borderRadius: isSender
               ?  BorderRadius.only(
             topLeft: Radius.circular(5),
             topRight: Radius.circular(5),
             bottomRight: Radius.circular(50),
             bottomLeft: Radius.circular(5),
           ) :  BorderRadius.only(
             topLeft: Radius.circular(5),
             topRight: Radius.circular(5),
             bottomRight: Radius.circular(5),
             bottomLeft: Radius.circular(50),
           ) ,
           child: CachedNetworkImage(
             imageUrl: imageUrl,
             fit: fit,
             placeholder: (context, url) =>
                 Center(
                   child: CircularProgressIndicator(valueColor: isSender
                       ? new AlwaysStoppedAnimation<Color>(Colors.black)
                       : new AlwaysStoppedAnimation<Color>(Color(0xFFa81845)),
                   ),
                 ),
             errorWidget: (context, url, error) =>
                 Image.network(noImageAvailable, fit: BoxFit.cover),
           ),
         ),
       );
   } catch (e) {
     print("CachedImage Error ::: " + e.toString());
     return Image.network(noImageAvailable, fit: BoxFit.cover);
   }
  }
}
