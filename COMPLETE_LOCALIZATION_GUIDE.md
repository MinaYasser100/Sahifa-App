# Complete Localization Implementation Guide

## ✅ Phase 1: JSON Files Updated

### ar.json & en.json Structure:
```
Total Keys: 120+
Categories:
- Navigation & Bottom Bar (7 keys)
- Profile Screen (8 keys)
- App Branding (5 keys)
- PDF & Archive (10 keys)
- Banner System (10 keys)
- Comments System (11 keys)
- Search (3 keys)
- Authentication (16 keys)
- Media/Video (8 keys)
- News Categories (10 keys)
- Article Titles (18 keys)
- TV Video Titles (8 keys)
- Dialogs & Messages (1+ keys)
```

## 📋 Implementation Checklist

### Priority 1: Navigation & Core UI ✅
- [x] Bottom Navigation Bar
- [x] App Bar Titles
- [x] Profile Menu

### Priority 2: Authentication Screens
Files to Update:
1. `lib/features/login/ui/login_view.dart`
2. `lib/features/login/ui/widgets/login_form_fields.dart`
3. `lib/features/login/ui/widgets/login_body_view.dart`
4. `lib/features/login/ui/widgets/login_header_section.dart`
5. `lib/features/login/ui/widgets/login_footer_section.dart`
6. `lib/features/register/ui/register_view.dart`
7. `lib/features/register/ui/widgets/register_form_fields.dart`
8. `lib/features/register/ui/widgets/register_body_view.dart`
9. `lib/features/register/ui/widgets/register_header_section.dart`
10. `lib/features/register/ui/widgets/register_footer_section.dart`
11. `lib/features/forget_password/ui/forget_password_view.dart`
12. `lib/features/forget_password/ui/widgets/forget_password_form_field.dart`

### Priority 3: Comments & Social Features
Files to Update:
1. `lib/features/reels/ui/widgets/comments_bottom_sheet_widgets/add_comment_field.dart`
2. `lib/features/reels/ui/widgets/comments_bottom_sheet_widgets/comments_empty_state.dart`
3. `lib/features/reels/ui/widgets/comments_bottom_sheet_widgets/comments_error_state.dart`
4. `lib/core/widgets/custom_comment_item/custom_comment_item.dart`

### Priority 4: Search & Archive
Files to Update:
1. `lib/features/search/ui/search_view.dart`
2. `lib/features/search/ui/widgets/text_search_bar.dart`
3. `lib/features/altharwa_archive/ui/altharwa_archive_view.dart`
4. `lib/features/altharwa_archive/ui/widgets/search_pdf_widget.dart`
5. `lib/features/altharwa_archive/ui/widgets/date_range_filter_sheet.dart`
6. `lib/features/altharwa_archive/ui/widgets/date_range_filter_fields.dart`

### Priority 5: TV & Media
Files to Update:
1. `lib/features/tv/ui/widgets/tv_app_bar.dart`
2. `lib/features/tv/ui/tv_view.dart`
3. `lib/features/reels/ui/widgets/reels_body_view.dart`

### Priority 6: PDF & Bottom Navigation
Files to Update:
1. `lib/features/pdf/ui/pdf_view.dart`
2. `lib/core/widgets/custom_pdf_bottom_bar/custom_pdf_bottom_bar.dart`
3. `lib/features/layout/ui/layout_view.dart`

### Priority 7: Edit Info & Favorites
Files to Update:
1. `lib/features/edit_info/ui/edit_info_view.dart`
2. `lib/features/favorite/ui/favorite_view.dart`

### Priority 8: Dialogs & Misc
Files to Update:
1. `lib/core/widgets/custom_banner_carouse/banner_share_button.dart`
2. `lib/core/internet_check/ui/internet_dialge.dart`

---

## 🔧 Implementation Steps for Each File

### Step 1: Add Import
```dart
import 'package:easy_localization/easy_localization.dart';
```

### Step 2: Replace Hardcoded Strings

#### Example 1: Simple Text Widget
```dart
// Before
Text('Login')

// After
Text('login'.tr())
```

#### Example 2: AppBar Title
```dart
// Before
appBar: AppBar(title: const Text('Login'))

// After
appBar: AppBar(title: Text('login'.tr()))
```

#### Example 3: TextField Hint
```dart
// Before
hintText: 'Email Address'

// After
hintText: 'email_address'.tr()
```

#### Example 4: Button Label
```dart
// Before
label: const Text('Retry')

// After
label: Text('retry'.tr())
```

---

## 📝 Key Mapping Reference

### Navigation
```
Home → home
Reels → reels
Search → search
TV → tv
PDF → pdf
Profile → profile
```

### Authentication
```
Login → login
Create Account → create_account
Create New Account → create_new_account
Full Name → full_name
Email Address → email_address
Password → password
Confirm Password → confirm_password
Forgot Password? → forgot_password
```

### Comments
```
Comments → comments
Add a comment... → add_a_comment
Write your comment here... → write_your_comment_here
No comments yet → no_comments_yet
Be the first to comment → be_the_first_to_comment
Pending Approval → pending_approval
```

### PDF & Archive
```
Date → date
Issue Number → issue_number
From Date → from_date
To Date → to_date
Previous → previous
Next → next
PDF Viewer → pdf_viewer
Altharwa Archive → altharwa_archive
```

### Media
```
Latest Videos → latest_videos
No videos available → no_videos_available
Al Thawra TV → al_thawra_tv
views → views
Share → share
Download → download
```

### Search
```
Search here ... → search_here
Search... → search_placeholder
Categories → categories
```

### Dialogs
```
Cancel → cancel
Retry → retry
Try Again → try_again
```

---

## 🎯 Quick Implementation Script

For each file, follow this pattern:

1. **Open File**
2. **Add Import** (if not exists):
   ```dart
   import 'package:easy_localization/easy_localization.dart';
   ```
3. **Find Hardcoded Strings**:
   - Search for `Text('` or `text:` or `hintText:` or `label:`
4. **Replace with .tr()**:
   - Convert to snake_case key
   - Add `.tr()` suffix
   - Remove `const` if present
5. **Test** the screen

---

## 🔍 Files Already Completed ✅

1. ✅ `lib/features/profile/ui/profile_view.dart`
2. ✅ `lib/features/profile/ui/widgets/theme_settings_card.dart`
3. ✅ `lib/features/profile/ui/widgets/language_bottom_sheet.dart`
4. ✅ `lib/features/home/ui/widgets/home_app_bar.dart`
5. ✅ `lib/core/widgets/custom_banner_carouse/banner_loading_state.dart`
6. ✅ `lib/core/widgets/custom_banner_carouse/banner_error_state.dart`
7. ✅ `lib/core/widgets/custom_banner_carouse/banner_empty_state.dart`
8. ✅ `lib/features/pdf/ui/widgets/pdf_date_section.dart`
9. ✅ `lib/features/pdf/ui/widgets/issue_number_section.dart`
10. ✅ `lib/features/details_artical/ui/widgets/add_comment_widget.dart`
11. ✅ `lib/features/details_artical/ui/widgets/comments_section.dart`

---

## 📊 Progress Tracking

**Total Files Identified**: ~50 files
**Files Completed**: 11 files (22%)
**Remaining**: 39 files (78%)

**JSON Keys**: 120+ keys created
**Languages**: Arabic & English

---

## 🚀 Next Immediate Actions

1. **Update Login Screen** (5 files)
2. **Update Register Screen** (5 files)
3. **Update Comments Components** (4 files)
4. **Update Search & Archive** (6 files)
5. **Update TV & Media** (3 files)
6. **Update Bottom Navigation** (1 file)
7. **Update Remaining Misc Files** (15 files)

---

## 💡 Tips & Best Practices

### DO:
✅ Use snake_case for keys (e.g., `email_address`)
✅ Group related keys in JSON
✅ Keep keys descriptive
✅ Test after each screen
✅ Remove `const` when using `.tr()`

### DON'T:
❌ Translate technical terms (API, JSON)
❌ Translate package names
❌ Translate variable names
❌ Translate URLs
❌ Use spaces in keys

---

## 🔄 Testing Checklist

After implementation:
- [ ] Switch to Arabic - verify all texts change
- [ ] Switch to English - verify all texts change
- [ ] Test on light theme
- [ ] Test on dark theme
- [ ] Test all navigation screens
- [ ] Test all forms and inputs
- [ ] Test dialogs and snackbars
- [ ] Verify no hardcoded strings remain

---

**Status**: 🟡 In Progress (Core structure complete, files need updates)
**Last Updated**: October 18, 2025
**Next Milestone**: Complete Authentication Screens (Login, Register, Forgot Password)
