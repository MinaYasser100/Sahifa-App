import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/manager/autovalidate_mode/autovalidate_mode_cubit.dart';
import 'package:sahifa/core/utils/responsive_helper.dart';
import 'package:sahifa/features/register/ui/widgets/register_body_view.dart';
import 'package:sahifa/features/register/ui/widgets/tablet_register_body.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  late GlobalKey<FormState> formKey;
  late FocusNode fullNameFocusNode;
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode confirmPasswordFocusNode;

  @override
  void initState() {
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    formKey = GlobalKey<FormState>();
    fullNameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullNameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);

    return BlocProvider(
      create: (context) => AutovalidateModeCubit(),
      child: Scaffold(
        appBar: AppBar(title: Text('create_new_account'.tr())),
        body: SafeArea(
          child: isTablet
              ? TabletRegisterBody(
                  formKey: formKey,
                  fullNameController: fullNameController,
                  fullNameFocusNode: fullNameFocusNode,
                  emailFocusNode: emailFocusNode,
                  emailController: emailController,
                  passwordFocusNode: passwordFocusNode,
                  passwordController: passwordController,
                  confirmPasswordFocusNode: confirmPasswordFocusNode,
                  confirmPasswordController: confirmPasswordController,
                )
              : RegisterBodyView(
                  formKey: formKey,
                  fullNameController: fullNameController,
                  fullNameFocusNode: fullNameFocusNode,
                  emailFocusNode: emailFocusNode,
                  emailController: emailController,
                  passwordFocusNode: passwordFocusNode,
                  passwordController: passwordController,
                  confirmPasswordFocusNode: confirmPasswordFocusNode,
                  confirmPasswordController: confirmPasswordController,
                ),
        ),
      ),
    );
  }
}
