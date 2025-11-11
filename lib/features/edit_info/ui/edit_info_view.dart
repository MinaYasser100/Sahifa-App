import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/services/auth_service.dart';
import 'package:sahifa/core/utils/show_top_toast.dart';
import 'package:sahifa/core/widgets/custom_button.dart';
import 'package:sahifa/features/edit_info/data/model/user_update_model.dart';
import 'package:sahifa/features/edit_info/data/repo/edit_user_info_repo.dart';
import 'package:sahifa/features/edit_info/manager/cubit/edit_user_info_cubit.dart';
import 'package:sahifa/features/edit_info/ui/widgets/profile_image_picker.dart';
import 'package:sahifa/features/edit_info/ui/widgets/social_accounts_section.dart';
import 'package:sahifa/features/edit_info/ui/widgets/user_info_section.dart';
import 'package:sahifa/features/profile/data/repo/profile_user_repo.dart';
import 'package:sahifa/features/profile/manager/profile_user_cubit/profile_user_cubit.dart';

class EditInfoView extends StatelessWidget {
  const EditInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EditUserInfoCubit(EditUserInfoRepoImpl()),
        ),
        BlocProvider(
          create: (context) {
            final cubit = ProfileUserCubit(getIt<ProfileUserRepoImpl>());
            // Fetch profile immediately
            _loadUserProfile(cubit);
            return cubit;
          },
        ),
      ],
      child: const _EditInfoBody(),
    );
  }

  Future<void> _loadUserProfile(ProfileUserCubit cubit) async {
    final authService = AuthService();
    final userInfo = await authService.getUserInfo();
    final userName = userInfo['name'];

    if (userName != null && userName.isNotEmpty) {
      cubit.fetchUserProfile(userName);
    }
  }
}

class _EditInfoBody extends StatefulWidget {
  const _EditInfoBody();

  @override
  State<_EditInfoBody> createState() => _EditInfoBodyState();
}

class _EditInfoBodyState extends State<_EditInfoBody> {
  late TextEditingController _userNameController;
  late TextEditingController _aboutMeController;
  late TextEditingController _facebookController;
  late TextEditingController _twitterController;
  late TextEditingController _instagramController;
  late TextEditingController _linkedInController;
  final _formKey = GlobalKey<FormState>();

  String? _userId;
  String? _currentAvatarUrl;
  File? _selectedImage;
  String? _imageFilePath;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _aboutMeController = TextEditingController();
    _facebookController = TextEditingController();
    _twitterController = TextEditingController();
    _instagramController = TextEditingController();
    _linkedInController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final authService = AuthService();
    final userInfo = await authService.getUserInfo();
    _userId = userInfo['userId'];
  }

  void _updateFieldsFromProfile(ProfileUserSuccess state) {
    final profile = state.profile;

    if (mounted) {
      setState(() {
        _userNameController.text = profile.userName;
        _aboutMeController.text = profile.aboutMe ?? '';
        _currentAvatarUrl = profile.profileImageUrl;

        // Load social accounts
        final socialAccounts = profile.socialAccounts.accounts;
        _facebookController.text = socialAccounts['facebook'] ?? '';
        _twitterController.text = socialAccounts['twitter'] ?? '';
        _instagramController.text = socialAccounts['instagram'] ?? '';
        _linkedInController.text = socialAccounts['linkedin'] ?? '';
      });
    }
  }

  void _onImageSelected(File imageFile, String filePath) {
    setState(() {
      _selectedImage = imageFile;
      _imageFilePath = filePath;
    });
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _aboutMeController.dispose();
    _facebookController.dispose();
    _twitterController.dispose();
    _instagramController.dispose();
    _linkedInController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    if (_userId == null) {
      showErrorToast(context, 'error'.tr(), 'user_id_not_found'.tr());
      return;
    }

    final userName = _userNameController.text.trim();
    final aboutMe = _aboutMeController.text.trim();

    // Build social accounts map
    final Map<String, String> socialAccounts = {};
    if (_facebookController.text.trim().isNotEmpty) {
      socialAccounts['facebook'] = _facebookController.text.trim();
    }
    if (_twitterController.text.trim().isNotEmpty) {
      socialAccounts['twitter'] = _twitterController.text.trim();
    }
    if (_instagramController.text.trim().isNotEmpty) {
      socialAccounts['instagram'] = _instagramController.text.trim();
    }
    if (_linkedInController.text.trim().isNotEmpty) {
      socialAccounts['linkedin'] = _linkedInController.text.trim();
    }

    final updateModel = UserUpdateModel(
      userId: _userId!, // Always send userId
      userName: userName,
      slug: userName.toLowerCase().replaceAll(' ', '_'),
      aboutMe: aboutMe.isNotEmpty ? aboutMe : null,
      avatarImage:
          _imageFilePath, // Send image path if selected, null otherwise
      socialAccounts: socialAccounts.isNotEmpty ? socialAccounts : null,
    );

    context.read<EditUserInfoCubit>().updateUserInfo(
      userId: _userId!,
      updateModel: updateModel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listen to ProfileUserCubit to load data when available
        BlocListener<ProfileUserCubit, ProfileUserState>(
          listener: (context, state) {
            if (state is ProfileUserSuccess) {
              _updateFieldsFromProfile(state);
            }
          },
        ),
        // Listen to EditUserInfoCubit for save operations
        BlocListener<EditUserInfoCubit, EditUserInfoState>(
          listener: (context, state) {
            if (state is EditUserInfoSuccess) {
              showSuccessToast(
                context,
                'success'.tr(),
                'profile_updated_successfully'.tr(),
              );

              // Pop and return true to indicate success
              // This will trigger a refresh in the ProfileView
              Navigator.pop(context, true);
            } else if (state is EditUserInfoError) {
              showErrorToast(context, 'error'.tr(), state.message);
            }
          },
        ),
      ],
      child: BlocBuilder<ProfileUserCubit, ProfileUserState>(
        builder: (context, profileState) {
          // Show loading indicator while profile data is being fetched
          if (profileState is ProfileUserLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              EasyLoading.show(status: 'loading'.tr());
            });
            return Scaffold(
              appBar: AppBar(title: Text('edit_information'.tr())),
              body: const SizedBox.shrink(),
            );
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              EasyLoading.dismiss();
            });
          }

          return BlocBuilder<EditUserInfoCubit, EditUserInfoState>(
            builder: (context, editState) {
              final isLoading = editState is EditUserInfoLoading;

              return Scaffold(
                appBar: AppBar(title: Text('edit_information'.tr())),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Image Picker
                        Center(
                          child: ProfileImagePicker(
                            selectedImage: _selectedImage,
                            currentAvatarUrl: _currentAvatarUrl,
                            onImageSelected: _onImageSelected,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // User Info Section
                        UserInfoSection(
                          userNameController: _userNameController,
                          aboutMeController: _aboutMeController,
                        ),
                        const SizedBox(height: 24),

                        // Social Accounts Section
                        SocialAccountsSection(
                          facebookController: _facebookController,
                          twitterController: _twitterController,
                          instagramController: _instagramController,
                          linkedInController: _linkedInController,
                        ),
                        const SizedBox(height: 32),

                        // Save Button
                        CustomButton(
                          text: 'save'.tr(),
                          isLoading: isLoading,
                          onPressed: isLoading ? null : _handleSave,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
