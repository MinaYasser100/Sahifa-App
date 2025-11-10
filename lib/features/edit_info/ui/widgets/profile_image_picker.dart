import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/utils/show_top_toast.dart';

class ProfileImagePicker extends StatelessWidget {
  final File? selectedImage;
  final String? currentAvatarUrl;
  final Function(File imageFile, String filePath) onImageSelected;

  const ProfileImagePicker({
    super.key,
    required this.selectedImage,
    required this.currentAvatarUrl,
    required this.onImageSelected,
  });

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      log('📸 Starting image picker for source: $source');

      final imagePicker = ImagePicker();
      final XFile? pickedFile = await imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      log('📸 Picked file: ${pickedFile?.path}');

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        log('✅ Image file selected: ${imageFile.path}');

        onImageSelected(imageFile, imageFile.path);

        if (context.mounted) {
          showSuccessToast(context, 'success'.tr(), 'image_selected'.tr());
        }
      } else {
        log('⚠️ No image selected');
      }
    } catch (e, stackTrace) {
      log('❌ Error picking image: $e');
      log('📍 Stack trace: $stackTrace');

      if (context.mounted) {
        showErrorToast(context, 'error'.tr(), 'failed_to_pick_image'.tr());
      }
    }
  }

  void _showImageSourceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text('camera'.tr()),
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text('gallery'.tr()),
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              backgroundColor: isDark
                  ? ColorsTheme().primaryLight
                  : ColorsTheme().primaryColor,
              radius: 60,
              backgroundImage: selectedImage != null
                  ? FileImage(selectedImage!)
                  : (currentAvatarUrl != null && currentAvatarUrl!.isNotEmpty
                            ? NetworkImage(currentAvatarUrl!)
                            : null)
                        as ImageProvider?,
              child:
                  (selectedImage == null &&
                      (currentAvatarUrl == null || currentAvatarUrl!.isEmpty))
                  ? Icon(
                      Icons.person,
                      color: ColorsTheme().whiteColor,
                      size: 60,
                    )
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _showImageSourceBottomSheet(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ColorsTheme().primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorsTheme().whiteColor,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: ColorsTheme().whiteColor,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'change_picture'.tr(),
          style: TextStyle(color: ColorsTheme().primaryColor, fontSize: 14),
        ),
      ],
    );
  }
}
