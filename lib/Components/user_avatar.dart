import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:house_rental_app/core/colors/color.dart';
import 'package:house_rental_app/core/utils/theme_extensions.dart';

class UserAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double radius;

  UserAvatar({super.key, required this.name, this.imageUrl, this.radius = 40});

  String getInitials() {
    if (name.trim().isEmpty) return "";

    final parts = name
        .trim()
        .split(' ')
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return "";

    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }

    return "${parts[0][0]}${parts.last[0]}".toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final hasValidImageUrl = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return SizedBox(
      height: radius * 2,
      width: radius * 2,
      child: ClipOval(
        child: hasValidImageUrl
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                height: radius * 2,
                width: radius * 2,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Container(
                      color: context.currentCardColor,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: downloadProgress.progress,
                          color: primaryBlue,
                        ),
                      ),
                    ),
                memCacheHeight: (radius * 4).toInt(),
                maxWidthDiskCache: (radius * 4).toInt(),
                errorWidget: (_, __, ___) => buildInitialsAvatar(context),
              )
            : buildInitialsAvatar(context),
      ),
    );
  }

  Widget buildInitialsAvatar(BuildContext context) {
    final initials = getInitials();

    return Container(
      height: radius * 2,
      width: radius * 2,
      decoration: BoxDecoration(
        color: context.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: context.primary,
            fontSize: radius.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
