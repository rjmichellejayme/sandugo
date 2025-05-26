import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandugo/hospital_data.dart';

class SaveHospitalButton extends StatefulWidget {
  final Hospital hospital;
  final VoidCallback? onShowSavedPlaces;

  const SaveHospitalButton({
    Key? key,
    required this.hospital,
    this.onShowSavedPlaces,
  }) : super(key: key);

  @override
  State<SaveHospitalButton> createState() => _SaveHospitalButtonState();
}

class _SaveHospitalButtonState extends State<SaveHospitalButton> {
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: isSaving
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red),
            )
          : const Icon(Icons.bookmark_border, color: Colors.red),
      onPressed: isSaving
          ? null
          : () async {
              String? userId = FirebaseAuth.instance.currentUser?.uid;
              if (userId != null) {
                setState(() => isSaving = true);
                try {
                  await saveHospitalToUserData(userId, widget.hospital);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${widget.hospital.name} Hospital Saved!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to save: $e')),
                  );
                } finally {
                  setState(() => isSaving = false);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User not logged in.')),
                );
              }
              Navigator.pop(context);
              if (widget.onShowSavedPlaces != null) {
                widget.onShowSavedPlaces!();
              }
            },
    );
  }
}