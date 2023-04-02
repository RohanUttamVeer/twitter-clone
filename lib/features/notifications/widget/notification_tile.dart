import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/enums/notification_type_enum.dart';
import 'package:twitter_clone/models/notification_model.dart' as model;
import 'package:twitter_clone/theme/pallete.dart';

class NotificationTile extends StatelessWidget {
  final model.Notification notification;
  const NotificationTile({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: notification.notificationType == NotificationType.follow
          ? const Icon(
              Icons.person,
              color: Pallete.lightPurpleColor,
            )
          : notification.notificationType == NotificationType.like
              ? Image.asset(
                  AssetsConstants.likeFilledIcon,
                  color: Pallete.lightPurpleColor,
                  height: 20,
                )
              : notification.notificationType == NotificationType.retweet
                  ? Image.asset(
                      AssetsConstants.retweetIcon,
                      color: Pallete.lightPurpleColor,
                      height: 20,
                    )
                  : null,
      title: Text(notification.text),
    );
  }
}
