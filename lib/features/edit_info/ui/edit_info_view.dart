import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/model/text_field_model/text_field_model.dart';
import 'package:sahifa/core/services/auth_service.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/utils/show_top_toast.dart';
import 'package:sahifa/core/widgets/custom_button.dart';
import 'package:sahifa/core/widgets/custom_text_form_field.dart';
import 'package:sahifa/features/edit_info/data/model/user_update_model.dart';
import 'package:sahifa/features/edit_info/data/repo/edit_user_info_repo.dart';
import 'package:sahifa/features/edit_info/manager/cubit/edit_user_info_cubit.dart';
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
  String? _currentUserName;

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
    _currentUserName = userInfo['name'];

    // Get profile data from ProfileUserCubit if available
    final profileState = context.read<ProfileUserCubit>().state;
    if (profileState is ProfileUserSuccess) {
      final profile = profileState.profile;
      _userNameController.text = profile.userName;
      _aboutMeController.text = profile.aboutMe ?? '';

      // Load social accounts
      final socialAccounts = profile.socialAccounts.accounts;
      _facebookController.text = socialAccounts['facebook'] ?? '';
      _twitterController.text = socialAccounts['twitter'] ?? '';
      _instagramController.text = socialAccounts['instagram'] ?? '';
      _linkedInController.text = socialAccounts['linkedin'] ?? '';
    } else if (_currentUserName != null) {
      _userNameController.text = _currentUserName!;
    }
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
      userName: userName,
      slug: userName.toLowerCase().replaceAll(' ', '_'),
      aboutMe: aboutMe.isNotEmpty ? aboutMe : null,
      socialAccounts: socialAccounts.isNotEmpty ? socialAccounts : null,
    );

    context.read<EditUserInfoCubit>().updateUserInfo(
      userId: _userId!,
      updateModel: updateModel,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<EditUserInfoCubit, EditUserInfoState>(
      listener: (context, state) {
        if (state is EditUserInfoSuccess) {
          showSuccessToast(
            context,
            'success'.tr(),
            'profile_updated_successfully'.tr(),
          );

          // Refresh profile data
          context.read<ProfileUserCubit>().fetchUserProfile(
            state.profile.userName,
          );

          Navigator.pop(context);
        } else if (state is EditUserInfoError) {
          showErrorToast(context, 'error'.tr(), state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is EditUserInfoLoading;

        return Scaffold(
          appBar: AppBar(title: Text('edit_information'.tr())),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image
                  Center(
                    child: CircleAvatar(
                      backgroundColor: isDark
                          ? ColorsTheme().primaryLight
                          : ColorsTheme().primaryColor,
                      radius: 50,
                      child: Icon(
                        Icons.person,
                        color: ColorsTheme().whiteColor,
                        size: 50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // User Name
                  Text(
                    '${'username'.tr()}:',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    textFieldModel: TextFieldModel(
                      controller: _userNameController,
                      hintText: 'enter_username'.tr(),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'username_cannot_be_empty'.tr();
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // About Me
                  Text(
                    '${'about_me'.tr()}:',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    textFieldModel: TextFieldModel(
                      controller: _aboutMeController,
                      hintText: 'enter_about_me'.tr(),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      validator: (value) => null,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Social Accounts Section
                  Text(
                    'social_accounts'.tr(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Facebook
                  _buildSocialField(
                    label: 'Facebook',
                    controller: _facebookController,
                    icon: Icons.facebook,
                  ),
                  const SizedBox(height: 12),

                  // Twitter
                  _buildSocialField(
                    label: 'Twitter',
                    controller: _twitterController,
                    icon: Icons.sports_basketball, // Twitter icon alternative
                  ),
                  const SizedBox(height: 12),

                  // Instagram
                  _buildSocialField(
                    label: 'Instagram',
                    controller: _instagramController,
                    icon: Icons.camera_alt,
                  ),
                  const SizedBox(height: 12),

                  // LinkedIn
                  _buildSocialField(
                    label: 'LinkedIn',
                    controller: _linkedInController,
                    icon: Icons.work,
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
  }

  Widget _buildSocialField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              '$label:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 8),
        CustomTextFormField(
          textFieldModel: TextFieldModel(
            controller: controller,
            hintText: '$label URL',
            keyboardType: TextInputType.url,
            validator: (value) => null, // Optional field
          ),
        ),
      ],
    );
  }
}
