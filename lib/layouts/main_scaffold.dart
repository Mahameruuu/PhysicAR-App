import 'package:flutter/material.dart';
import 'package:physic_lab_app/widgets/custom_bottom_navbar.dart';
import 'package:physic_lab_app/widgets/custom_header.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    super.key,
    required this.currentIndex,
    required this.userName,
    required this.child,
    required this.onTapNav,
    this.padding = const EdgeInsets.fromLTRB(18, 14, 18, 12),
    this.scrollPhysics = const BouncingScrollPhysics(),
  });

  final int currentIndex;
  final String userName;
  final Widget child;
  final ValueChanged<int> onTapNav;
  final EdgeInsets padding;
  final ScrollPhysics scrollPhysics;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      body: SafeArea(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 18 * (1 - value)),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: scrollPhysics,
                        padding: padding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomHeader(userName: userName),
                            const SizedBox(height: 18),
                            child,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: currentIndex,
        onTap: onTapNav,
      ),
    );
  }
}
