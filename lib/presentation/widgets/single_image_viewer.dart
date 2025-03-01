import 'package:flutter/material.dart';
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
          child: Image.network(
            imageUrl,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: width ?? 100.w,
                  height: height ?? 100.h,
                  decoration: BoxDecoration(color: Colors.grey[200]),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: width ?? 100.w,
                height: height ?? 100.h,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  image: const DecorationImage(
                    image: AssetImage('assets/no_image.png') as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            fit: BoxFit.fitHeight,
          )),
    );
  }
}
