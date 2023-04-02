import 'package:flutter/material.dart';
import 'package:socially/constants/constants.dart';
import 'package:socially/core/enums/notification_type_enum.dart';
import 'package:socially/models/notification_model.dart' as model;
import 'package:socially/theme/pallete.dart';

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
              : notification.notificationType == NotificationType.repost
                  ? Image.asset(
                      AssetsConstants.repostIcon,
                      color: Pallete.lightPurpleColor,
                      height: 20,
                    )
                  : null,
      title: Text(notification.text),
    );
  }
}
