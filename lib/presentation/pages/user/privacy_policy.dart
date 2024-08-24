import 'dart:math';

import 'package:flutter/material.dart';
import 'package:masjid_noor_customer/presentation/pages/all_export.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    _controller.loadFlutterAsset('assets/privacy_policy.html');
    _controller.setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (url) {
          Future.delayed(const Duration(seconds: 1)).then((value) {
            setState(() {
              _isLoading = false;
            });
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Privacy Policy'),
        ),
        body: _isLoading
            ? shimmerPage()
            : WebViewWidget(controller: _controller));
  }

  Widget shimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        //random
        width: MediaQuery.of(context).size.width * 0.8 +
            Random().nextInt(100).toDouble(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        height: 20 + Random().nextInt(10).toDouble(),
      ),
    );
  }

  Widget shimmerPage() {
    return SizedBox(
      height: double.infinity,
      child: SpacedColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          verticalSpace: 10.h,
          children: List.generate(15, (index) => shimmer())),
    );
  }
}
