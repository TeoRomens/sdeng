import 'package:flutter/material.dart';

/// Enum of different notification types.
enum NotificationType {
  medical,
  payment,
  board,

  /// Other notifications.
  other,
}

/// Extension method to convert String representation of
/// notification type to Enum.
extension NotificationTypeCreate on NotificationType {
  /// Extension method to convert String representation of
  /// notification type to Enum.
  static NotificationType fromString(String val) {
    switch (val) {
      case 'medical':
        return NotificationType.medical;
      case 'payment':
        return NotificationType.payment;
      case 'board':
        return NotificationType.board;
      default:
        return NotificationType.other;
    }
  }
}

/// Class representing in app notification.
class AppNotification {
  /// Class representing in app notification.
  AppNotification({
    required this.type,
    this.commentText,
    this.targetVideoId,
    this.targetVideoThumbnail,
    this.actionUid,
    this.actionUserName,
    this.actionUserImageUrl,
    required this.createdAt,
    required this.isNew,
  });

  /// Type of this notification.
  final NotificationType type;

  /// Text of the comment.
  ///
  /// Only present if the type if `comment` or `mention`.
  final String? commentText;

  /// ID of the video that the notification event happened.
  ///
  /// Only present for `like`, `comment` and `mention`.
  final String? targetVideoId;

  /// Thumbnail of the video that the notification event happened.
  ///
  /// Only present for `like`, `comment` and `mention`.
  final String? targetVideoThumbnail;

  /// User ID of the user who caused the notification.
  final String? actionUid;

  /// User name of the user who caused the notification.
  final String? actionUserName;

  /// Image URL of the user who caused the notification.
  final String? actionUserImageUrl;

  /// Timestamp when the notification happened.
  final DateTime createdAt;

  /// Whether the notification is unread or not.
  final bool isNew;

  /// Converts raw data loaded from Supabase `notifications` view
  /// into list of `AppNotification`
  static List<AppNotification> fromData(
      List<dynamic> data, {
        @required DateTime? createdAtOfLastSeenNotification,
      }) {
    return data.map<AppNotification>(
          (row) {
        final createdAt = DateTime.parse(row['created_at'] as String);
        var isNew = false;
        if (createdAtOfLastSeenNotification == null ||
            createdAt.isAfter(createdAtOfLastSeenNotification)) {
          isNew = true;
        }
        return AppNotification(
          type: NotificationTypeCreate.fromString(row['type'] as String),
          commentText: row['comment_text'] as String?,
          targetVideoId: row['video_id'] as String?,
          targetVideoThumbnail: row['video_thumbnail_url'] as String?,
          actionUid: row['action_user_id'] as String?,
          actionUserName: row['action_user_name'] as String?,
          actionUserImageUrl: row['action_user_image_url'] as String?,
          createdAt: createdAt,
          isNew: isNew,
        );
      },
    ).toList();
  }

  /// Creates a new instance of `AppNotification` while copyinng properties.
  AppNotification copyWith({
    NotificationType? type,
    String? commentText,
    String? targetVideoId,
    String? targetVideoThumbnail,
    String? actionUid,
    String? actionUserName,
    String? actionUserImageUrl,
    DateTime? createdAt,
    bool? isNew,
  }) {
    return AppNotification(
      type: type ?? this.type,
      commentText: commentText ?? this.commentText,
      targetVideoId: targetVideoId ?? this.targetVideoId,
      targetVideoThumbnail: targetVideoThumbnail ?? this.targetVideoThumbnail,
      actionUid: actionUid ?? this.actionUid,
      actionUserName: actionUserName ?? this.actionUserName,
      actionUserImageUrl: actionUserImageUrl ?? this.actionUserImageUrl,
      createdAt: createdAt ?? this.createdAt,
      isNew: isNew ?? this.isNew,
    );
  }
}