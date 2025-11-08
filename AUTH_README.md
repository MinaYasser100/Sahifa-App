# Authentication System Documentation

## Overview
This authentication system provides comprehensive logging and user-friendly error messages for Firebase Authentication.

## Features

### 1. Enhanced Password Validation
Strong password requirements:
- Minimum 8 characters
- At least one uppercase letter (A-Z)
- At least one lowercase letter (a-z)
- At least one number (0-9)
- At least one special character (!@#$%^&*)

### 2. Comprehensive Logging
All authentication operations are logged with:
- 🔐 Auth attempts (email masked for privacy)
- ✅ Successful operations
- ❌ Failed operations with error codes
- 📝 Step-by-step process logging

Example logs:
```
🔑 Auth Attempt: Registration for email: jo***@example.com
✅ Auth Success: Registration for email: jo***@example.com
❌ Auth Failure: Login for email: jo***@example.com - Error: wrong-password
```

### 3. User-Friendly Error Messages
Instead of showing technical Firebase errors, users see clear messages:

#### Before (Technical):
```
[firebase_auth/email-already-in-use] The email address is already in use by another account.
```

#### After (User-Friendly):
**Arabic:**
```
البريد الإلكتروني مستخدم بالفعل
هذا البريد الإلكتروني مسجل بالفعل. يرجى تسجيل الدخول أو استخدام بريد إلكتروني آخر
```

**English:**
```
Email already in use
This email is already registered. Please login or use a different email
```

## Supported Error Codes

| Error Code | Arabic Message | English Message |
|------------|---------------|-----------------|
| email-already-in-use | البريد الإلكتروني مستخدم بالفعل | Email already in use |
| invalid-email | البريد الإلكتروني غير صالح | Invalid email |
| weak-password | كلمة المرور ضعيفة جداً | Password is too weak |
| user-not-found | المستخدم غير موجود | User not found |
| wrong-password | كلمة المرور غير صحيحة | Wrong password |
| user-disabled | الحساب معطل | Account disabled |
| too-many-requests | عدد المحاولات كثير جداً | Too many requests |
| network-request-failed | خطأ في الاتصال بالإنترنت | Network error |
| invalid-credential | بيانات الاعتماد غير صحيحة | Invalid credentials |

## Usage

### 1. Using Password Validation

```dart
import 'package:sahifa/core/validation/validatoin.dart';

// In your form field
CustomTextFormField(
  textFieldModel: TextFieldModel(
    controller: passwordController,
    hintText: 'Password',
    validator: Validation.validatePassword,
    obscureText: true,
  ),
)
```

### 2. Using Auth Error Handler

```dart
import 'package:sahifa/core/utils/auth_error_handler.dart';

try {
  // Your Firebase Auth operation
  await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
} catch (e) {
  // Extract error code
  final errorCode = extractErrorCodeFromException(e);
  
  // Get user-friendly messages
  final errorTitle = AuthErrorHandler.getErrorTitle(errorCode);
  final errorMessage = AuthErrorHandler.getErrorMessage(errorCode);
  
  // Show to user
  showErrorDialog(title: errorTitle, message: errorMessage);
}
```

### 3. Using Auth Cubit (Template)

```dart
import 'package:sahifa/core/manager/auth/auth_cubit.dart';

// In your widget
BlocProvider(
  create: (context) => AuthCubit(),
  child: YourAuthScreen(),
)

// Register user
context.read<AuthCubit>().register(
  email: emailController.text,
  password: passwordController.text,
  fullName: fullNameController.text,
);

// Login user
context.read<AuthCubit>().login(
  email: emailController.text,
  password: passwordController.text,
);

// Listen to states
BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state is AuthSuccess) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
      // Navigate to home
    } else if (state is AuthError) {
      // Show error dialog with title and message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(state.title),
          content: Text(state.message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  },
  child: YourAuthForm(),
)
```

## Logging Examples

### Registration Flow
```
📝 Starting registration process...
🔑 Auth Attempt: Registration for email: us***@example.com
✅ Auth Success: Registration for email: us***@example.com
✅ Registration completed successfully
```

### Login Flow with Error
```
🔐 Starting login process...
🔑 Auth Attempt: Login for email: us***@example.com
❌ Login error: [firebase_auth/wrong-password] The password is invalid
🔐 Auth Error Code: wrong-password
❌ Auth Failure: Login for email: us***@example.com - Error: wrong-password
🔴 Emitting error state: كلمة المرور غير صحيحة - كلمة المرور التي أدخلتها غير صحيحة
```

### Password Reset Flow
```
🔄 Starting password reset process...
🔑 Auth Attempt: Password Reset for email: us***@example.com
✅ Auth Success: Password Reset for email: us***@example.com
✅ Password reset email sent successfully
```

## Security Features

### Email Masking in Logs
User emails are automatically masked in logs for privacy:
- `john.doe@example.com` → `jo***@example.com`
- `a@test.com` → `a***@test.com`
- Short usernames are fully masked for extra security

### Password Strength Requirements
All passwords must meet minimum security standards before being sent to Firebase.

## Localization

All error messages support both Arabic and English through Easy Localization:
- Error messages automatically switch based on app language
- Validation messages are also localized
- Consistent terminology across the app

## Files Structure

```
lib/
├── core/
│   ├── validation/
│   │   └── validatoin.dart          # Enhanced password validation
│   ├── utils/
│   │   └── auth_error_handler.dart  # Error message conversion & logging
│   └── manager/
│       └── auth/
│           ├── auth_cubit.dart      # Auth business logic (template)
│           └── auth_state.dart      # Auth states
assets/
└── localization/
    ├── ar.json                      # Arabic translations
    └── en.json                      # English translations
```

## Future Enhancements

- [ ] Add Firebase Authentication package
- [ ] Implement actual auth methods in AuthCubit
- [ ] Add biometric authentication
- [ ] Add social login (Google, Facebook, Apple)
- [ ] Add email verification flow
- [ ] Add phone number authentication
- [ ] Add user profile management

## Notes

- The `auth_cubit.dart` is a **template** ready for Firebase implementation
- All TODO comments indicate where to add Firebase Auth code
- Error handling is production-ready
- Logging is comprehensive but privacy-conscious
