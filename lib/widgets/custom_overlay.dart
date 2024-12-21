import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomOverlay {
  static final List<OverlayEntry> _overlayEntries = [];

  static void showOverlay(String textName, BuildContext context) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Padding(
        padding: EdgeInsets.only(top: 640.0.h),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding:
                  EdgeInsets.symmetric(vertical: 80.0.w, horizontal: 160.0.w),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                textName,
                style: TextStyle(
                  color: Colors.white70,
                  letterSpacing: 2,
                  fontFamily: 'NANUM',
                  fontWeight: FontWeight.w900,
                  fontSize: 70.0.sp,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    _overlayEntries.add(overlayEntry);

    Future.delayed(const Duration(milliseconds: 700), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
        _overlayEntries.remove(overlayEntry);
      }
    });
  }
}
