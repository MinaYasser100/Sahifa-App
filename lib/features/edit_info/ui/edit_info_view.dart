import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/text_field_model/text_field_model.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/validation/validatoin.dart';
import 'package:sahifa/core/widgets/custom_button.dart';
import 'package:sahifa/core/widgets/custom_text_form_field.dart';

class EditInfoView extends StatefulWidget {
  const EditInfoView({super.key});

  @override
  State<EditInfoView> createState() => _EditInfoViewState();
}

class _EditInfoViewState extends State<EditInfoView> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    _nameController = TextEditingController(text: '');
    _emailController = TextEditingController(text: '');
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: Text('edit_information'.tr())),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              SizedBox(height: 32),
              CustomButton(text: 'save'.tr(), onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
