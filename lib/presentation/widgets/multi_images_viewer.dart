import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class MultiImagesViewer extends StatefulWidget {
  final List<String> imageUrls;
  final double? height;
  final double? width;

  const MultiImagesViewer({
    super.key,
    required this.imageUrls,
    this.height,
    this.width,
  });

  @override
  MultiImagesViewerState createState() => MultiImagesViewerState();
}

class MultiImagesViewerState extends State<MultiImagesViewer> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _nextPage() {
    if (_currentPage < widget.imageUrls.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = widget.width ?? 340.w;
    double h = widget.height ?? 250.h;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: w,
            height: h,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.imageUrls.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final imageUrl = widget.imageUrls[index];
                return imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: w,
                              height: h,
                              decoration: BoxDecoration(color: Colors.grey[200]),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/no_image.png',
                            fit: BoxFit.cover,
                          );
                        },
                        fit: BoxFit.fitHeight,
                      )
                    : Image.asset(
                        'assets/no_image.png',
                        fit: BoxFit.cover,
                      );
                },
              ),
            ),
          ),
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: 10.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.imageUrls.length,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0.w),
                    width: 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          if (widget.imageUrls.length > 1)
            Positioned(
              left: 2.w,
              child: IconButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(Colors.black.withOpacity(0.2)),
                  fixedSize: WidgetStateProperty.all(const Size(20, 20)),
                ),
                icon:
                    const Icon(Icons.chevron_left_rounded, color: Colors.white),
                onPressed: _previousPage,
              ),
            ),
          if (widget.imageUrls.length > 1)
            Positioned(
              right: 2.w,
              child: IconButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(Colors.black.withOpacity(0.2)),
                ),
                icon: const Icon(Icons.chevron_right_rounded,
                    color: Colors.white),
                onPressed: _nextPage,
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
