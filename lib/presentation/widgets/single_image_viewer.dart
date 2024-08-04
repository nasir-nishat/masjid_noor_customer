import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class SingleImagesViewer extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;

  const SingleImagesViewer({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 100.w,
      height: height ?? 100.h,
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            errorWidget: (context, url, error) {
              return Container(
                width: width ?? 100.w,
                height: height ?? 100.h,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: const Center(
                  child: Text('No Image'),
                ),
              );
            },
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: width ?? 100.w,
                height: height ?? 100.h,
                decoration: BoxDecoration(color: Colors.grey[200]),
              ),
            ),
            fit: BoxFit.cover,
          )),
    );
  }
}
