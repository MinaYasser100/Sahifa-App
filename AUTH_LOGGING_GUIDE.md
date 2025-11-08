# Auth Logging Guide

## نظرة عامة
تم إضافة Logging شامل لجميع عمليات الـ Authentication لتسهيل تتبع المشاكل.

## كيفية رؤية الـ Logs

### في Android Studio / VS Code:
1. افتح تبويب **Debug Console** أو **Logcat**
2. ابحث عن الاسم: **AuthCubit** أو **AuthInterceptor** أو **AuthService**
3. الـ Logs مرتبة بالـ Emojis للتمييز السريع

### أنواع الـ Logs:

| Emoji | المعنى | مثال |
|-------|--------|------|
| 🔐 | Auth operation | `🔐 Starting login process...` |
| 📝 | Registration | `📝 Starting registration process...` |
| 🔍 | Checking/Searching | `🔍 Checking authentication status...` |
| 📡 | API Call | `📡 Sending registration request to API...` |
| ✅ | Success | `✅ Registration completed successfully` |
| ❌ | Error | `❌ Registration API returned error` |
| 🔴 | Critical Error | `🔴 Emitting error state` |
| 💾 | Saving Data | `💾 Saving user session...` |
| 🎫 | Token Operation | `🎫 Access Token: xyz...` |
| 👤 | User Info | `👤 User ID: 123` |
| 🔄 | Refresh Token | `🔄 Starting token refresh...` |
| 🚪 | Logout | `🚪 Starting logout process...` |
| 🧹 | Cleanup | `🧹 Clearing local session...` |
| ⚠️ | Warning | `⚠️ No access token available` |
| 📤 | HTTP Request | `📤 HTTP Request: POST /auth/register` |
| 📊 | Status/Data | `📊 Login status: true` |

## مثال على Logs للـ Registration الناجح:

```
📝 Starting registration process...
📋 Registration data - Name: Ahmed Ali, Email: ahmed@example.com
🔑 Auth Attempt: Registration for email: ah***@example.com
📡 Sending registration request to API...
🔑 Password length: 12
🔑 Password confirmation match: true
📤 HTTP Request: POST /api/auth/register
✅ HTTP Response: 201 /api/auth/register
📊 Response data type: _JsonMap
✅ Registration successful for user: ahmed@example.com
💾 Saving user session...
👤 User: Ahmed Ali (ahmed@example.com)
🔑 User ID: 123
💾 Saving user session...
✅ Tokens saved
✅ User info saved
✅ Session saved successfully
👤 User ID: 123
✅ Auth Success: Registration for email: ah***@example.com
```

## مثال على Logs للـ Registration الفاشل:

```
📝 Starting registration process...
📋 Registration data - Name: Test User, Email: test@test.com
🔑 Auth Attempt: Registration for email: te***@test.com
📡 Sending registration request to API...
🔑 Password length: 8
🔑 Password confirmation match: true
📤 HTTP Request: POST /api/auth/register
❌ HTTP Error: 422 Unprocessable Entity
🔍 Error Response: {message: The email has already been taken}
❌ Registration API returned error: The email has already been taken
❌ Auth Failure: Registration for email: te***@test.com - Error: The email has already been taken
🔍 Parsing error message: The email has already been taken
🔴 Emitting error state: هذا البريد الإلكتروني مسجل بالفعل. يرجى تسجيل الدخول أو استخدام بريد إلكتروني آخر
```

## تشخيص المشاكل الشائعة:

### 1. المشكلة: "Registration failed" بدون سبب واضح
**ابحث عن:**
```
❌ Registration API returned error: [ERROR MESSAGE]
```
**الحل:** شوف الـ error message واعرف المشكلة من الـ backend

### 2. المشكلة: Token expired
**ابحث عن:**
```
🔒 401 Unauthorized - Token expired
🔄 Attempting to refresh token...
```
**الحل:** تأكد إن الـ refresh token شغال

### 3. المشكلة: No internet connection
**ابحث عن:**
```
❌ HTTP Error: SocketException
❌ Network error: No internet connection
```
**الحل:** تأكد من الاتصال بالإنترنت

### 4. المشكلة: Password validation failed
**ابحث عن:**
```
🔑 Password length: 6
```
**الحل:** Password لازم يكون 8 أحرف على الأقل

### 5. المشكلة: Session not saved
**ابحث عن:**
```
💾 Saving user session...
❌ [Error during save]
```
**الحل:** تأكد من permissions الـ secure storage

## الملفات اللي فيها Logging:

1. **auth_cubit.dart** - كل Auth operations
2. **auth_interceptor.dart** - HTTP requests/responses
3. **auth_service.dart** - Session management
4. **auth_error_handler.dart** - Error parsing

## نصائح للـ Debugging:

### ✅ استخدم Filter في Logcat:
```
AuthCubit|AuthInterceptor|AuthService
```

### ✅ ابحث عن الـ Error Icon:
```
❌
```

### ✅ تتبع الـ Flow:
```
📝 Starting → 📡 API Call → ✅ Success/❌ Error
```

### ✅ راجع الـ Token Status:
```
🎫 Access token retrieved: Yes/No
```

## معلومات الخصوصية:

⚠️ **البريد الإلكتروني مخفي في الـ Logs:**
- `john.doe@example.com` → `jo***@example.com`
- `user@test.com` → `us***@test.com`

⚠️ **Password ما يظهرش في الـ Logs:**
- بس الـ length بيظهر: `🔑 Password length: 12`

⚠️ **Token مخفي جزئياً:**
- بس أول 20 حرف: `🎫 Access Token: eyJhbGciOiJIUzI1NiI...`

## أمثلة استخدام:

### عند ظهور خطأ في Register:
1. افتح Debug Console
2. ابحث عن `📝 Starting registration`
3. اتبع الـ logs لحد ما توصل للـ `❌`
4. شوف الـ error message
5. استخدم `_parseErrorMessage` output

### عند مشكلة في Token:
1. ابحث عن `🔄 Starting token refresh`
2. شوف لو فيه `✅ Token refreshed` أو `❌ Token refresh failed`
3. تأكد من الـ refresh token موجود

### عند Logout بيفشل:
1. ابحث عن `🚪 Starting logout`
2. شوف الـ steps لحد `🧹 Clearing local session`
3. حتى لو الـ API فشل، الـ local session بيتمسح

## الخلاصة:

الـ Logging دلوقتي **شامل جداً** وهيساعدك تعرف:
- ✅ كل خطوة في الـ Auth process
- ✅ المشكلة فين بالضبط
- ✅ الـ data اللي راحت للـ backend
- ✅ الـ response اللي جاي من الـ backend
- ✅ Token status وقت أي عملية
- ✅ رسائل واضحة للـ user بالعربي

**الـ Backend شغال؟ الـ Logs هتقولك المشكلة فين!** 🎯
