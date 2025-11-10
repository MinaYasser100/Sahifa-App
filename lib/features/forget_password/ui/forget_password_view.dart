import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/manager/autovalidate_mode/autovalidate_mode_cubit.dart';
import 'package:sahifa/core/utils/responsive_helper.dart';
import 'package:sahifa/features/forget_password/ui/widgets/forget_password_body_view.dart';
import 'package:sahifa/features/forget_password/ui/widgets/tablet_forget_password_body.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  late TextEditingController emailController;
  late GlobalKey<FormState> formKey;
  late FocusNode emailFocusNode;

  @override
  void initState() {
    emailController = TextEditingController();
    formKey = GlobalKey<FormState>();
    emailFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);

    return BlocProvider(
      create: (context) => AutovalidateModeCubit(),
      child: Scaffold(
        appBar: AppBar(title: Text('forget_password'.tr())),
        body: SafeArea(
          child: isTablet
              ? TabletForgetPasswordBody(
                  formKey: formKey,
                  emailController: emailController,
                  emailFocusNode: emailFocusNode,
                )
              : ForgetPasswordBodyView(
                  formKey: formKey,
                  emailController: emailController,
                  emailFocusNode: emailFocusNode,
                ),
        ),
      ),
    );
  }
}
