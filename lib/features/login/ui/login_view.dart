import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/manager/autovalidate_mode/autovalidate_mode_cubit.dart';
import 'package:sahifa/core/utils/responsive_helper.dart';
import 'package:sahifa/features/login/ui/widgets/login_body_view.dart';
import 'package:sahifa/features/login/ui/widgets/tablet_login_body.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  late GlobalKey<FormState> formKey;
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    formKey = GlobalKey<FormState>();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);

    return BlocProvider(
      create: (context) => AutovalidateModeCubit(),
      child: Scaffold(
        appBar: AppBar(title: Text('login'.tr())),
        body: SafeArea(
          child: isTablet
              ? TabletLoginBody(
                  formKey: formKey,
                  emailController: emailController,
                  emailFocusNode: emailFocusNode,
                  passwordController: passwordController,
                  passwordFocusNode: passwordFocusNode,
                )
              : LoginBodyView(
                  formKey: formKey,
                  emailController: emailController,
                  emailFocusNode: emailFocusNode,
                  passwordController: passwordController,
                  passwordFocusNode: passwordFocusNode,
                ),
        ),
      ),
    );
  }
}
