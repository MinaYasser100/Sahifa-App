# Flutter EasyLoading Integration

## 📦 Package
- **flutter_easyloading**: ^3.0.5

## 🎯 Setup

### 1. Added to pubspec.yaml
```yaml
dependencies:
  flutter_easyloading: ^3.0.5
```

### 2. Configured in main.dart
```dart
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  // ...
  _configureEasyLoading();
  runApp(...);
}

// Configuration
void _configureEasyLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = const Color(0xFF2196F3)
    ..backgroundColor = Colors.white
    ..indicatorColor = const Color(0xFF2196F3)
    ..textColor = const Color(0xFF2196F3)
    ..maskColor = Colors.black.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}

// In MaterialApp
MaterialApp.router(
  // ...
  builder: EasyLoading.init(),
)
```

## 🛠️ LoadingHelper Class

Created a helper class at `lib/core/utils/loading_helper.dart` for easy usage throughout the app.

### Methods

#### 1. Show Loading
```dart
LoadingHelper.show(); // Default message: "Loading..."
LoadingHelper.showWithMessage('Please wait...');
```

#### 2. Show Progress (0.0 to 1.0)
```dart
LoadingHelper.showProgress(0.5, message: 'Downloading...');
```

#### 3. Show Success
```dart
LoadingHelper.showSuccess('Done successfully!');
```

#### 4. Show Error
```dart
LoadingHelper.showError('Something went wrong!');
```

#### 5. Show Info
```dart
LoadingHelper.showInfo('Please note that...');
```

#### 6. Show Toast
```dart
LoadingHelper.showToast('Item added to cart');
```

#### 7. Dismiss Loading
```dart
LoadingHelper.dismiss();
```

#### 8. Check if Loading is Showing
```dart
if (LoadingHelper.isShowing) {
  // Do something
}
```

## 📝 Usage Examples

### Example 1: Simple Loading
```dart
// Show loading
LoadingHelper.show();

// Do some work
await Future.delayed(Duration(seconds: 2));

// Dismiss
LoadingHelper.dismiss();
```

### Example 2: API Call with Loading
```dart
Future<void> fetchData() async {
  LoadingHelper.showWithMessage('Fetching data...');
  
  try {
    final response = await apiService.getData();
    LoadingHelper.dismiss();
    LoadingHelper.showSuccess('Data loaded!');
  } catch (e) {
    LoadingHelper.dismiss();
    LoadingHelper.showError('Failed to load data');
  }
}
```

### Example 3: Progress Upload
```dart
Future<void> uploadFile(File file) async {
  for (double progress = 0.0; progress <= 1.0; progress += 0.1) {
    LoadingHelper.showProgress(
      progress,
      message: 'Uploading ${(progress * 100).toInt()}%',
    );
    await Future.delayed(Duration(milliseconds: 500));
  }
  LoadingHelper.dismiss();
  LoadingHelper.showSuccess('Upload complete!');
}
```

### Example 4: In Comments Feature
```dart
// In AddCommentField widget
Future<void> _addComment() async {
  if (_commentController.text.trim().isEmpty) return;

  LoadingHelper.showWithMessage('Adding comment...');
  
  await context.read<ReelCommentsCubit>().addComment(
    widget.reelId,
    _commentController.text,
  );
  
  _commentController.clear();
  LoadingHelper.dismiss();
  LoadingHelper.showSuccess('Comment added!');
}
```

### Example 5: In StatefulWidget Loading State
```dart
class CommentsLoadingState extends StatefulWidget {
  @override
  State<CommentsLoadingState> createState() => _CommentsLoadingStateState();
}

class _CommentsLoadingStateState extends State<CommentsLoadingState> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoadingHelper.showWithMessage('Loading comments...');
    });
  }

  @override
  void dispose() {
    LoadingHelper.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
```

## 🎨 Customization

You can customize EasyLoading in `main.dart`:

```dart
void _configureEasyLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)  // Auto dismiss duration
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle // Indicator style
    ..loadingStyle = EasyLoadingStyle.custom                // Custom style
    ..indicatorSize = 45.0                                  // Size
    ..radius = 10.0                                         // Border radius
    ..progressColor = Colors.blue                           // Progress color
    ..backgroundColor = Colors.white                        // Background
    ..indicatorColor = Colors.blue                          // Indicator color
    ..textColor = Colors.blue                               // Text color
    ..maskColor = Colors.black.withOpacity(0.5)            // Mask overlay
    ..userInteractions = false                              // Block interactions
    ..dismissOnTap = false;                                 // Don't dismiss on tap
}
```

### Available Indicator Types
- `EasyLoadingIndicatorType.circle`
- `EasyLoadingIndicatorType.fadingCircle`
- `EasyLoadingIndicatorType.chasingDots`
- `EasyLoadingIndicatorType.cubeGrid`
- `EasyLoadingIndicatorType.dualRing`
- `EasyLoadingIndicatorType.fadingCube`
- `EasyLoadingIndicatorType.fadingFour`
- `EasyLoadingIndicatorType.fadingGrid`
- `EasyLoadingIndicatorType.foldingCube`
- `EasyLoadingIndicatorType.hourGlass`
- `EasyLoadingIndicatorType.pulse`
- `EasyLoadingIndicatorType.ring`
- `EasyLoadingIndicatorType.ripple`
- `EasyLoadingIndicatorType.rotatingCircle`
- `EasyLoadingIndicatorType.rotatingPlain`
- `EasyLoadingIndicatorType.threeBounce`
- `EasyLoadingIndicatorType.wave`
- `EasyLoadingIndicatorType.wanderingCubes`

### Loading Styles
- `EasyLoadingStyle.light` - Light theme
- `EasyLoadingStyle.dark` - Dark theme
- `EasyLoadingStyle.custom` - Custom colors

### Mask Types
- `EasyLoadingMaskType.none` - No mask
- `EasyLoadingMaskType.clear` - Clear mask (allows interaction)
- `EasyLoadingMaskType.black` - Black overlay
- `EasyLoadingMaskType.custom` - Custom color

## 🌍 Best Practices

1. **Always dismiss loading** when done:
   ```dart
   try {
     LoadingHelper.show();
     await doSomething();
     LoadingHelper.dismiss();
   } catch (e) {
     LoadingHelper.dismiss(); // Don't forget in catch block!
   }
   ```

2. **Use meaningful messages**:
   ```dart
   LoadingHelper.showWithMessage('Saving changes...'); // Good
   LoadingHelper.show(); // Less informative
   ```

3. **Don't show multiple loaders** at once:
   ```dart
   if (!LoadingHelper.isShowing) {
     LoadingHelper.show();
   }
   ```

4. **Use appropriate methods** for feedback:
   - `show()` - For loading states
   - `showSuccess()` - For successful operations
   - `showError()` - For errors
   - `showToast()` - For quick notifications

## 📱 Where It's Used

Currently implemented in:
- ✅ Reel Comments Loading State
- ✅ Add Comment Action

### Future Usage
Can be used throughout the app for:
- [ ] API calls
- [ ] File uploads/downloads
- [ ] Form submissions
- [ ] Data synchronization
- [ ] Image loading
- [ ] Video processing
- [ ] Login/Register
- [ ] Any async operations

## 🔧 Troubleshooting

### Loading doesn't show
Make sure you added `builder: EasyLoading.init()` in MaterialApp

### Loading doesn't dismiss
Always call `LoadingHelper.dismiss()` in finally block or after operations

### Multiple loaders
Check if loading is already showing: `LoadingHelper.isShowing`

## 📚 Resources

- [EasyLoading Package](https://pub.dev/packages/flutter_easyloading)
- [GitHub Repository](https://github.com/nslog11/flutter_easyloading)
