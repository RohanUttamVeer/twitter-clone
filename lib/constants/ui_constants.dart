import 'package:flutter/material.dart';
import 'package:socially/constants/constants.dart';
import 'package:socially/features/explore/view/explore_view.dart';
import 'package:socially/features/notifications/views/notification_view.dart';
import 'package:socially/features/post/widgets/post_list.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: Image.asset(
        AssetsConstants.sociallyLogo,
        // color: Pallete.blueColor,
        height: 30,
      ),
      centerTitle: true,
    );
  }

  static const List<Widget> bottomTabBarPages = [
    PostList(),
    ExploreView(),
    NotificationView(),
  ];
}
