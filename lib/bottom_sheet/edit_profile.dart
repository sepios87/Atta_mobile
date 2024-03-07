import 'dart:io';

import 'package:atta/entities/user.dart';
import 'package:atta/entities/wrapped.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/main.dart';
import 'package:atta/pages/profile/profile_page.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:image_picker/image_picker.dart';

Future<void> showEditProfileBottomSheet(BuildContext context, AttaUser user) {
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
  final _formKey = GlobalKey<FormState>();

  String _firstName = '';
  String _lastName = '';
  String _phone = '';
  File? _image;

  bool _deleteImage = false;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.paddingOf(context).bottom + AttaSpacing.s,
        left: AttaSpacing.m,
        right: AttaSpacing.m,
      ),
      child: IgnorePointer(
        ignoring: _isLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AttaSpacing.xxs),
            Center(
              child: Container(
                height: 3,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(AttaRadius.small),
                ),
              ),
            ),
            const SizedBox(height: AttaSpacing.m),
            GestureDetector(
              onTap: () async {
                final picker = ImagePicker();
                final image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    _deleteImage = false;
                    _image = File(image.path);
                  });
                }
              },
              child: Center(
                child: Badge(
                  label: Icon(Icons.edit_outlined, size: 20, color: Colors.grey.shade800),
                  largeSize: 20,
                  offset: const Offset(8, 0),
                  backgroundColor: Colors.transparent,
                  child: _deleteImage
                      ? UserAvatar(
                          user: widget.user,
                          radius: 48,
                          withoutImage: true,
                        )
                      : _image == null
                          ? UserAvatar(user: widget.user, radius: 48)
                          : CircleAvatar(
                              radius: 48,
                              backgroundColor: Colors.transparent,
                              foregroundImage: FileImage(_image!),
                            ),
                ),
              ),
            ),
            if (!_deleteImage && (widget.user.imageUrl != null || _image != null)) ...[
              const SizedBox(height: AttaSpacing.xxs),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _deleteImage = true;
                    _image = null;
                  });
                },
                icon: const Icon(Icons.delete_outline_rounded),
                label: Text(translate('edit_profile_bottom_sheet.delete_image')),
              ),
            ],
            const SizedBox(height: AttaSpacing.m),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: widget.user.lastName,
                    onSaved: (value) => _lastName = value ?? '',
                    decoration: InputDecoration(
                      labelText: translate('edit_profile_bottom_sheet.last_name'),
                    ),
                  ),
                  const SizedBox(height: AttaSpacing.m),
                  TextFormField(
                    initialValue: widget.user.firstName,
                    onSaved: (value) => _firstName = value ?? '',
                    decoration: InputDecoration(
                      labelText: translate('edit_profile_bottom_sheet.first_name'),
                    ),
                  ),
                  const SizedBox(height: AttaSpacing.m),
                  TextFormField(
                    initialValue: widget.user.phone,
                    onSaved: (value) => _phone = value ?? '',
                    decoration: InputDecoration(
                      labelText: translate('edit_profile_bottom_sheet.phone'),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: AttaSpacing.m),
                  TextFormField(
                    initialValue: widget.user.email,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: translate('edit_profile_bottom_sheet.email'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AttaSpacing.xl),
            ElevatedButton(
              onPressed: () async {
                final formState = _formKey.currentState;

                if (formState == null) return;

                formState.save();
                if (formState.validate()) {
                  setState(() => _isLoading = true);

                  String? imageUrl;

                  if (_image != null && !_deleteImage) {
                    imageUrl = await userService.uploadAvatarImage(_image!);
                  }

                  await userService.updateProfile(
                    firstName: _firstName.isEmpty ? const Wrapped.value(null) : Wrapped.value(_firstName),
                    lastName: _lastName.isEmpty ? const Wrapped.value(null) : Wrapped.value(_lastName),
                    phone: _phone.isEmpty ? const Wrapped.value(null) : Wrapped.value(_phone),
                    imageUrl: _deleteImage
                        ? const Wrapped.value(null)
                        : imageUrl == null
                            ? null
                            : Wrapped.value(imageUrl),
                  );

                  // ignore: use_build_context_synchronously
                  context.adaptativePopNamed(ProfilePage.routeName);
                }
              },
              child: _isLoading
                  ? const SizedBox.square(
                      dimension: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(translate('edit_profile_bottom_sheet.save_button')),
            ),
          ],
        ),
      ),
    );
  }
}
