import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FeedbackDialog {
  static Future<void> mostrarFeedbackDialog(BuildContext context) async {
    int rating = 0;
    String comentario = "";
    final localizations = AppLocalizations.of(context)!;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16.0,
                  20.0,
                  16.0,
                  16.0,
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.32,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            localizations.feedbackTitle,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Divider(
                          color: Colors.red,
                          thickness: 2,
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: Icon(
                                  index < rating ? Icons.star : Icons.star_border,
                                  color: Colors.black,
                                  size: 55,
                                ),
                                onPressed: () {
                                  setState(() {
                                    rating = index + 1;
                                  });
                                },
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          onChanged: (value) {
                            comentario = value;
                          },
                          decoration: InputDecoration(
                            hintText: localizations.feedbackCommentHint,
                            contentPadding: const EdgeInsets.all(12),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.red, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.red, width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              await _guardarFeedback(rating, comentario);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(localizations.feedbackThankYou(rating.toString())),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(98, 41),
                            ),
                            child: Text(
                              localizations.submitButton,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 0),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  static Future<void> _guardarFeedback(int rating, String comentario) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('feedback').add({
        'userId': user.uid,
        'rating': rating,
        'comentario': comentario,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }
}