import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FinvuDateUtils {
  static String format(DateTime dateTime) {
    return DateFormat('dd MMM yyyy hh:mm a').format(dateTime.toLocal());
  }

  static String formatToDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy hh:mm a').format(dateTime.toLocal());
  }

  static String formatToDateFromString(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat('dd MMM yyyy hh:mm a').format(dateTime.toLocal());
  }

  static DateTime getDateFromTimestamp(String timestamp) {
    return DateTime.parse(timestamp);
  }

  static String formatToDateFromStringZ(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(dateTime.toUtc());
  }

  static String formatToRelativeTime(BuildContext context, String timestamp) {
    debugPrint("Timestamp for notification is: $timestamp");
    DateTime dateTime = DateTime.parse(timestamp).toLocal();
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return AppLocalizations.of(context)!.timeAgo(
        difference.inSeconds,
        difference.inSeconds == 1
            ? AppLocalizations.of(context)!.sec
            : AppLocalizations.of(context)!.secs,
      );
    } else if (difference.inMinutes < 60) {
      return AppLocalizations.of(context)!.timeAgo(
        difference.inMinutes,
        difference.inMinutes == 1
            ? AppLocalizations.of(context)!.min
            : AppLocalizations.of(context)!.mins,
      );
    } else if (difference.inHours < 24) {
      return AppLocalizations.of(context)!.timeAgo(
        difference.inHours,
        difference.inHours == 1
            ? AppLocalizations.of(context)!.hr
            : AppLocalizations.of(context)!.hrs,
      );
    } else if (difference.inDays < 7) {
      return AppLocalizations.of(context)!.timeAgo(
        difference.inDays,
        difference.inDays == 1
            ? AppLocalizations.of(context)!.day
            : AppLocalizations.of(context)!.days,
      );
    } else if (difference.inDays < 30) {
      int weeks = (difference.inDays / 7).floor();
      return AppLocalizations.of(context)!.timeAgo(
        weeks,
        weeks == 1
            ? AppLocalizations.of(context)!.week
            : AppLocalizations.of(context)!.weeks,
      );
    } else if (difference.inDays < 365) {
      int months = (difference.inDays / 30).floor();
      return AppLocalizations.of(context)!.timeAgo(
        months,
        months == 1
            ? AppLocalizations.of(context)!.month
            : AppLocalizations.of(context)!.months,
      );
    } else {
      int years = (difference.inDays / 365).floor();
      return AppLocalizations.of(context)!.timeAgo(
        years,
        years == 1
            ? AppLocalizations.of(context)!.year
            : AppLocalizations.of(context)!.years,
      );
    }
  }
}
