# دليل نظام الـ Theme في تطبيق Sahifa

## 📋 نظرة عامة

تم تطبيق نظام متكامل للـ Dark/Light Theme في التطبيق باستخدام **BLoC Pattern** (Cubit).

---

## 🗂️ الملفات المتضمنة

### 1️⃣ **ThemeCubit** (`lib/core/theme/cubit/theme_cubit.dart`)
- **المسؤولية**: إدارة حالة الـ theme والتبديل بينهم
- **الوظائف الرئيسية**:
  - `toggleTheme()` - تبديل بين Light و Dark
  - `setLightTheme()` - تعيين Light Theme
  - `setDarkTheme()` - تعيين Dark Theme
  - `isDarkMode` - للتحقق من الوضع الحالي

### 2️⃣ **ThemeState** (`lib/core/theme/cubit/theme_state.dart`)
- **الحالات**:
  - `ThemeInitial` - الحالة الأولية
  - `ThemeLight` - وضع الإضاءة
  - `ThemeDark` - الوضع الداكن

### 3️⃣ **Theme Functions** (`lib/core/utils/theme_data_func.dart`)
- `themeDataFunc()` - Light Theme
- `darkThemeDataFunc()` - Dark Theme

### 4️⃣ **ProfileView** (`lib/features/profile/ui/profile_view.dart`)
- يحتوي على **Switch** للتبديل بين الـ themes

---

## 🎨 الألوان المستخدمة

### Light Theme:
- خلفية: `White`
- Primary: `#052659` (Deep Blue)
- Secondary: `#7DA0CA` (Light Blue)

### Dark Theme:
- خلفية: `#021024` (Darkest Blue)
- Primary: `#021024` (Dark Navy)
- Cards: `#052659` (Deep Blue)
- Text: `White/White70`

---

## 🔧 كيفية الاستخدام

### 1. الوصول للـ ThemeCubit في أي Widget:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/theme/cubit/theme_cubit.dart';

// للقراءة فقط
final themeCubit = context.read<ThemeCubit>();

// للاستماع للتغييرات
BlocBuilder<ThemeCubit, ThemeState>(
  builder: (context, state) {
    final isDark = state is ThemeDark;
    return Text(isDark ? 'Dark' : 'Light');
  },
)
```

### 2. تبديل الـ Theme:

```dart
context.read<ThemeCubit>().toggleTheme();
```

### 3. تعيين theme محدد:

```dart
// Light
context.read<ThemeCubit>().setLightTheme();

// Dark
context.read<ThemeCubit>().setDarkTheme();
```

### 4. التحقق من الوضع الحالي:

```dart
final isDark = context.read<ThemeCubit>().isDarkMode;
```

---

## 💾 التخزين التلقائي

- يتم حفظ اختيار المستخدم تلقائياً في **SharedPreferences**
- عند إعادة فتح التطبيق، يتم استرجاع الـ theme المحفوظ

---

## 🚀 التطبيق في main.dart

```dart
BlocProvider(
  create: (context) => ThemeCubit(),
  child: BlocBuilder<ThemeCubit, ThemeState>(
    builder: (context, themeState) {
      return MaterialApp.router(
        theme: themeDataFunc(),
        darkTheme: darkThemeDataFunc(),
        themeMode: themeState is ThemeDark 
          ? ThemeMode.dark 
          : ThemeMode.light,
        // ... rest of config
      );
    },
  ),
)
```

---

## ✅ المميزات

1. ✨ **سهولة التبديل** - بزر واحد في Profile
2. 💾 **حفظ تلقائي** - للاختيار عبر SharedPreferences
3. 🎨 **ألوان متناسقة** - مع هوية التطبيق
4. 🔄 **استجابة فورية** - تغيير Theme في كل الشاشات
5. 📱 **Material 3** - يستخدم أحدث معايير التصميم

---

## 🔮 تطويرات مستقبلية

- [ ] إضافة System Theme (يتبع نظام الجهاز)
- [ ] ألوان مخصصة للمستخدم
- [ ] Themes إضافية (Blue, Green, etc.)
- [ ] Animation عند التبديل

---

## 📝 ملاحظات

- الـ ThemeCubit متاح عالمياً في كل التطبيق
- يمكن استخدامه في أي Widget بدون إعادة إنشاء
- التغييرات تظهر فوراً في كل الشاشات المفتوحة

---

**تم بنجاح! 🎉**
