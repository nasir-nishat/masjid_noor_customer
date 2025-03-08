
import 'package:flutter/material.dart';
import 'package:masjid_noor_customer/presentation/pages/all_export.dart';

class ProductImageGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const ProductImageGallery({
    Key? key,
    required this.images,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextImage() {
    if (_currentIndex < widget.images.length - 1) {
      setState(() {
        _currentIndex++;
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void _previousImage() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(16.r),
      backgroundColor: Colors.white,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
          maxWidth: MediaQuery.of(context).size.width * 0.4,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Main image slider
            PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  minScale: 0.6,
                  maxScale: 5.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Image.network(
                      widget.images[index],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Image.asset(
                            'assets/no_image.png',
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),

            // Close button
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // Navigation arrows (only show if multiple images)
            if (widget.images.length > 1) ...[
              // Left arrow
              Positioned(
                left: 10,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: _currentIndex > 0 ? Colors.black : Colors.black.withOpacity(0.2),
                      size: 36,
                    ),
                    onPressed: _currentIndex > 0 ? _previousImage : null,
                  ),
                ),
              ),

              // Right arrow
              Positioned(
                right: 10,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: _currentIndex < widget.images.length - 1
                          ? Colors.black
                          : Colors.black.withOpacity(0.2),
                      size: 36,
                    ),
                    onPressed: _currentIndex < widget.images.length - 1 ? _nextImage : null,
                  ),
                ),
              ),
            ],

            // Image counter indicator
            if (widget.images.length > 1)
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '${_currentIndex + 1}/${widget.images.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}