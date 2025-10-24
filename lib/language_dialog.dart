import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'main.dart';

Future<void> showLanguageDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) {
      final localizations = AppLocalizations.of(context)!;
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              localizations.languageDialogTitle,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(
              color: Colors.red,
              thickness: 2,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                localizations.languageOptionSpanish,
                style: const TextStyle(color: Colors.black),
              ),
              onTap: () async {
                Navigator.pop(context);
                BuildContext? spinnerContext;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext ctx) {
                    spinnerContext = ctx;
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    );
                  },
                );
                await Future.delayed(const Duration(milliseconds: 100));
                MyApp.of(context)?.setLocale(const Locale('es', 'ES'));
                Timer(const Duration(seconds: 5), () {
                  if (spinnerContext != null) {
                    Navigator.pop(spinnerContext!);
                  }
                });
              },
            ),
            ListTile(
              title: Text(
                localizations.languageOptionEnglish,
                style: const TextStyle(color: Colors.black),
              ),
              onTap: () async {
                Navigator.pop(context);
                BuildContext? spinnerContext;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext ctx) {
                    spinnerContext = ctx;
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    );
                  },
                );
                await Future.delayed(const Duration(milliseconds: 100));
                MyApp.of(context)?.setLocale(const Locale('en', 'US'));
                Timer(const Duration(seconds: 5), () {
                  if (spinnerContext != null) {
                    Navigator.pop(spinnerContext!);
                  }
                });
              },
            ),
          ],
        ),
      );
    },
  );
}