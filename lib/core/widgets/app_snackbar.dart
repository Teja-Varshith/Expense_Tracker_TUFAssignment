import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class AppSnackbar {
  AppSnackbar._();

  static void success(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    _show(
      context,
      title: title,
      message: message,
      type: ContentType.success,
    );
  }

  static void failure(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    _show(
      context,
      title: title,
      message: message,
      type: ContentType.failure,
    );
  }

  static void warning(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    _show(
      context,
      title: title,
      message: message,
      type: ContentType.warning,
    );
  }

  static void _show(
    BuildContext context, {
    required String title,
    required String message,
    required ContentType type,
  }) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: type,
      ),
    );

    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
