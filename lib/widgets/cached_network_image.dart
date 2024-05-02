import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomImageHandler {
  final String imageUrl;
  // bool isLoading = false;  
  String? errorMessage;

  CustomImageHandler(this.imageUrl);

  Widget displayImage({BoxFit fit = BoxFit.cover}) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      placeholder: (context, url) {
        // isLoading = true;
        return Center(child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator()));
      },
      errorWidget: (context, url, error) {
        // isLoading = false;
        errorMessage = error.toString();
        return Center(child: Icon(Icons.error));
      },
      imageBuilder: (context, imageProvider) {
        // isLoading = false;
        return Image(image: imageProvider, fit: fit);
      },
    );
  }
}