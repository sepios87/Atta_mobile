import 'dart:io';

import 'package:atta/entities/user.dart';
import 'package:atta/main.dart';
import 'package:atta/services/database/db_service.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<void> showEditProfile(BuildContext context, AttaUser user) {
  return showModalBottomSheet(
    context: context,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * 0.8,
    ),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return _EditProfileContent(user: user);
    },
  );
}

class _EditProfileContent extends StatefulWidget {
  const _EditProfileContent({
    required this.user,
  });

  final AttaUser user;

  @override
  State<_EditProfileContent> createState() => _EditProfileContentState();
}

class _EditProfileContentState extends State<_EditProfileContent> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + AttaSpacing.m,
        top: AttaSpacing.m,
        left: AttaSpacing.m,
        right: AttaSpacing.m,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () async {
              final picker = ImagePicker();
              final image = await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                print(image.path);
                await databaseService.uploadUserAvatar(
                  '${widget.user.id}/${DateTime.now().millisecondsSinceEpoch}',
                  File(image.path),
                );
              }
            },
            child: Center(
              child: Badge(
                label: Icon(Icons.edit_outlined, size: 20, color: Colors.grey.shade800),
                largeSize: 20,
                offset: const Offset(8, 0),
                backgroundColor: Colors.transparent,
                child: UserAvatar(user: widget.user, radius: 48),
              ),
            ),
          ),
          const SizedBox(height: AttaSpacing.m),
          Form(
            child: Column(
              children: [
                TextFormField(
                  initialValue: widget.user.lastName,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    hintText: 'Entrez votre nom',
                  ),
                ),
                const SizedBox(height: AttaSpacing.m),
                TextFormField(
                  initialValue: widget.user.firstName,
                  decoration: const InputDecoration(
                    labelText: 'Prénom',
                    hintText: 'Entrez votre prénom',
                  ),
                ),
                const SizedBox(height: AttaSpacing.m),
                TextFormField(
                  initialValue: widget.user.phone,
                  decoration: const InputDecoration(
                    labelText: 'Numéro de téléphone',
                    hintText: 'Entrez votre numéro de téléphone',
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: AttaSpacing.m),
                TextFormField(
                  initialValue: widget.user.email,
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Entrez votre email',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AttaSpacing.xl),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}
