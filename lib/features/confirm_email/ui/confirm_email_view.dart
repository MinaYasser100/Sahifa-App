import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/text_field_model/text_field_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/show_top_toast.dart';
import 'package:sahifa/core/widgets/custom_button.dart';
import 'package:sahifa/core/widgets/custom_text_form_field.dart';
import 'package:sahifa/features/auth/manager/auth_cubit/auth_cubit.dart';
import 'package:sahifa/features/auth/manager/auth_cubit/auth_state.dart';

class ConfirmEmailView extends StatefulWidget {
  final String email;

  const ConfirmEmailView({super.key, required this.email});

  @override
  State<ConfirmEmailView> createState() => _ConfirmEmailViewState();
}

class _ConfirmEmailViewState extends State<ConfirmEmailView> {
  late TextEditingController _codeController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthCubit>().confirmEmail(
          token: _codeController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          showSuccessToast(context, 'success'.tr(), 'email_confirmed'.tr());
          context.go(Routes.loginView);
        } else if (state is AuthError) {
          showErrorToast(context, 'error'.tr(), state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          appBar: AppBar(title: Text('confirm_email'.tr())),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Icon
                    Icon(
                      Icons.email_outlined,
                      size: 100,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 32),

                    // Title
                    Text(
                      'confirm_email'.tr(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Text(
                      'code_sent_to_email'.tr(),
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Email
                    Text(
                      widget.email,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Code Input
                    CustomTextFormField(
                      textFieldModel: TextFieldModel(
                        controller: _codeController,
                        hintText: 'enter_confirmation_code'.tr(),
                        labelText: 'confirmation_code'.tr(),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'enter_confirmation_code'.tr();
                          }
                          if (value.length < 4) {
                            return 'Code must be at least 4 digits';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Confirm Button
                    CustomButton(
                      text: 'confirm_email'.tr(),
                      isLoading: isLoading,
                      onPressed: isLoading ? null : _handleConfirm,
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
