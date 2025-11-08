import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/text_field_model/text_field_model.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/utils/show_top_toast.dart';
import 'package:sahifa/core/validation/validatoin.dart';
import 'package:sahifa/core/widgets/custom_button.dart';
import 'package:sahifa/core/widgets/custom_text_form_field.dart';
import 'package:sahifa/features/auth/manager/auth_cubit/auth_cubit.dart';
import 'package:sahifa/features/auth/manager/auth_cubit/auth_state.dart';

class EditInfoView extends StatefulWidget {
  const EditInfoView({super.key});

  @override
  State<EditInfoView> createState() => _EditInfoViewState();
}

class _EditInfoViewState extends State<EditInfoView> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _loadUserData();
  }

  void _loadUserData() {
    final authCubit = context.read<AuthCubit>();
    final user = authCubit.currentUser;

    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthCubit>().updateProfile(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          showSuccessToast(
            context,
            'success'.tr(),
            'profile_updated_successfully'.tr(),
          );
          Navigator.pop(context);
        } else if (state is AuthError) {
          showErrorToast(context, 'error'.tr(), state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        
        return Scaffold(
          appBar: AppBar(title: Text('edit_information'.tr())),
          body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                SizedBox(height: 16),
                Text(
                  '${'name'.tr()}:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                CustomTextFormField(
                  textFieldModel: TextFieldModel(
                    controller: _nameController,
                    hintText: 'enter_your_name'.tr(),
                    keyboardType: TextInputType.name,
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return 'name_cannot_be_empty'.tr();
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '${'email'.tr()}:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                CustomTextFormField(
                  textFieldModel: TextFieldModel(
                    controller: _emailController,
                    hintText: 'enter_your_email'.tr(),
                    readOnly: true,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => Validation.emailValidation(value),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '${'phone'.tr()}:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                CustomTextFormField(
                  textFieldModel: TextFieldModel(
                    controller: _phoneController,
                    hintText: 'enter_your_phone'.tr(),
                    keyboardType: TextInputType.phone,
                    validator: (p0) => null,
                  ),
                ),
                SizedBox(height: 32),
                CustomButton(
                  text: 'save'.tr(),
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _handleSave,
                ),
              ],
            ),
          ),
        ),
      ),
        );
      },
    );
  }
}
