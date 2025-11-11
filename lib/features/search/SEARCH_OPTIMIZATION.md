# Search Feature - Debouncer & Request ID Implementation

## 📚 Overview

تم تحسين الـ Search Feature بإضافة:
1. **Debouncer** - لتقليل عدد الـ API calls
2. **Request ID Tracking** - لضمان عرض أحدث النتائج فقط
3. **Request Cancellation** - لإلغاء الطلبات القديمة

## 🎯 المشاكل التي تم حلها

### المشكلة 1: Too Many API Calls
**قبل:** كل حرف تكتبه → API call جديد
**بعد:** الانتظار 500ms بعد آخر كتابة قبل إرسال الـ request

### المشكلة 2: Race Condition
**قبل:** لو كتبت "test" بسرعة، ممكن response "te" يرجع بعد "test" ويعرض نتائج خاطئة
**بعد:** كل request له ID، ولو response قديم رجع يتم تجاهله

### المشكلة 3: Wasted Resources
**قبل:** الـ requests القديمة تفضل شغالة حتى لو مش محتاجينها
**بعد:** إلغاء فوري للـ requests القديمة باستخدام CancelToken

## 🏗️ Architecture

### 1. Debouncer Class (`lib/core/utils/debouncer.dart`)
```dart
Debouncer(delay: Duration(milliseconds: 500))
  └── run(action) → ينفذ بعد التأخير
  └── cancel() → يلغي أي عملية معلقة
  └── dispose() → ينظف الموارد
```

**الفكرة:**
- لما تكتب حرف، يبدأ timer لمدة 500ms
- لو كتبت حرف تاني قبل ما الـ 500ms يخلصوا، يلغي الـ timer القديم ويبدأ واحد جديد
- بس لما تبطل كتابة لمدة 500ms، ساعتها بس يبعت الـ request

### 2. Request ID System
```dart
int _requestId = 0;  // Counter for requests

// عند كل search جديد:
final currentRequestId = ++_requestId;  // 1, 2, 3, 4...

// قبل عرض النتائج:
if (currentRequestId != _requestId) {
  // النتيجة دي قديمة، نتجاهلها
  return;
}
```

### 3. Request Cancellation (CancelToken)
```dart
CancelToken? _cancelToken;

// عند search جديد:
_cancelToken?.cancel('New search request');  // إلغاء القديم
_cancelToken = CancelToken();  // إنشاء جديد

// في الـ API call:
dio.get(url, cancelToken: _cancelToken);
```

## 📝 Implementation Details

### Modified Files:

#### 1. `lib/core/utils/debouncer.dart` (NEW)
- Utility class للـ debouncing
- يستخدم `Timer` من dart:async
- Auto-cancellation للـ timers القديمة

#### 2. `lib/features/search/manager/search_articles_cubit/search_articles_cubit.dart`
**الإضافات:**
```dart
// Debouncer instance
final Debouncer _debouncer = Debouncer(delay: Duration(milliseconds: 500));

// Request ID tracking
int _requestId = 0;

// Cancel token for Dio
CancelToken? _cancelToken;

// Enhanced search method
Future<void> searchArticlesByQuery(String query, String language) async {
  // 1. Increment request ID
  final currentRequestId = ++_requestId;
  
  // 2. Cancel previous request
  _cancelToken?.cancel('New search request');
  _cancelToken = CancelToken();
  
  // 3. Debounce the search
  _debouncer.run(() async {
    // 4. Check if still latest request
    if (currentRequestId != _requestId) return;
    
    // 5. Make API call
    final result = await _searchArticlesRepo.searchArticles(
      query: query,
      language: language,
      cancelToken: _cancelToken,
    );
    
    // 6. Double-check before emitting
    if (currentRequestId != _requestId) return;
    
    // 7. Emit result
    emit(...);
  });
}

// New: Reset search method
void resetSearch() {
  _cancelToken?.cancel('Search reset');
  _debouncer.cancel();
  _requestId = 0;
  emit(SearchArticlesInitial());
}

@override
Future<void> close() {
  _debouncer.dispose();
  _cancelToken?.cancel('Cubit closed');
  return super.close();
}
```

#### 3. `lib/features/search/data/repo/search_articles_repo.dart`
**الإضافات:**
```dart
Future<Either<String, List<ArticleModel>>> searchArticles({
  required String query,
  required String language,
  CancelToken? cancelToken,  // ← جديد
}) async {
  try {
    final response = await _dioHelper.getData(
      url: ApiEndpoints.posts.path,
      query: {...},
      cancelToken: cancelToken,  // ← تمريره للـ Dio
    );
    // ...
  } on DioException catch (e) {
    // معالجة حالة الإلغاء
    if (e.type == DioExceptionType.cancel) {
      return Left("search_cancelled".tr());
    }
    // ...
  }
}
```

#### 4. `lib/core/helper_network/dio_helper.dart`
**الإضافة:**
```dart
Future<Response> getData({
  required String url,
  Map<String, dynamic>? query,
  Map<String, dynamic>? headers,
  CancelToken? cancelToken,  // ← جديد
}) async {
  final response = await _dio.get(
    url,
    queryParameters: query,
    options: headers != null ? Options(headers: headers) : null,
    cancelToken: cancelToken,  // ← تمريره للـ Dio
  );
  return response;
}
```

#### 5. `lib/features/search/ui/search_view.dart`
**التحديث:**
```dart
void _onSearchChanged(String query) {
  if (query.trim().isEmpty) {
    setState(() => _isSearching = false);
    context.read<SearchArticlesCubit>().resetSearch();  // ← جديد
  } else {
    setState(() => _isSearching = true);
    // الـ debouncing بيحصل جوا الـ cubit
    context.read<SearchArticlesCubit>().searchArticlesByQuery(query, language);
  }
}
```

## 🔍 Logging & Debugging

الكود بيطبع logs مفصلة:
```
🔍 Search initiated - Query: "test", Request ID: 1
✅ Search success for request ID 1: 10 articles found

🔍 Search initiated - Query: "testing", Request ID: 2
⏭️ Skipping outdated request ID: 1 (current: 2)
✅ Search success for request ID 2: 5 articles found
```

## 🎨 User Experience Improvements

### قبل التحسينات:
- ⚠️ كل حرف → API call جديد (10 حروف = 10 requests!)
- ⚠️ Results بتظهر بترتيب عشوائي (race conditions)
- ⚠️ هدر في الـ bandwidth والـ server resources

### بعد التحسينات:
- ✅ Request واحد بس كل 500ms
- ✅ دايماً تعرض أحدث نتيجة فقط
- ✅ إلغاء تلقائي للـ requests القديمة
- ✅ تجربة مستخدم أسرع وأسلس

## 📊 Performance Metrics

**مثال: كتابة "Flutter Development"**

### قبل:
- عدد الـ Requests: 20 request (حرف × حرف)
- الوقت: ~2000ms
- الـ bandwidth: عالي جداً

### بعد:
- عدد الـ Requests: 1 request (بعد انتهاء الكتابة)
- الوقت: ~500ms + API response time
- الـ bandwidth: 95% أقل

## 🧪 Testing Scenarios

### Scenario 1: Fast Typing
```
User types: "F" → "Fl" → "Flu" → "Flut" → "Flutt" → "Flutte" → "Flutter"
Expected: فقط request واحد بعد 500ms من آخر حرف: "Flutter"
```

### Scenario 2: Slow Typing with Pauses
```
User types: "Test" [pause 600ms] " App" [pause 600ms] "lication"
Expected: 3 requests
  1. "Test" (بعد 500ms)
  2. "Test App" (بعد 500ms)
  3. "Test Application" (بعد 500ms)
```

### Scenario 3: Clear Search
```
User types: "Hello" → clears text field
Expected: 
  1. Cancel any pending debounced action
  2. Cancel any ongoing API request
  3. Reset to initial state (show categories grid)
```

### Scenario 4: Race Condition Prevention
```
Network slow, user types:
  1. "A" → request sent (takes 2000ms)
  2. "AB" → request sent (takes 500ms)
  
Without Request ID: Shows results for "A" (wrong!)
With Request ID: Ignores "A" response, shows "AB" results ✅
```

## 🚀 Benefits Summary

| Feature | Benefit |
|---------|---------|
| **Debouncer** | 📉 95% reduction in API calls |
| **Request ID** | 🎯 Always show correct results |
| **CancelToken** | ⚡ Save bandwidth & server resources |
| **Combined** | 🚀 Faster, smoother, better UX |

## 🔧 Configuration

### Adjust Debounce Delay
في `search_articles_cubit.dart`:
```dart
final Debouncer _debouncer = Debouncer(
  delay: const Duration(milliseconds: 300),  // أقصر = أسرع، لكن requests أكتر
);
```

**Recommendations:**
- 300ms: للـ applications السريعة جداً
- 500ms: **الافتراضي** - توازن ممتاز ✅
- 800ms: للـ slow networks أو expensive API calls

## 🐛 Error Handling

### Cancelled Requests
```dart
if (e.type == DioExceptionType.cancel) {
  return Left("search_cancelled".tr());
}
```
الـ UI **لا يعرض** error للـ cancelled requests لأنها مقصودة.

### Network Errors
تُعرض للمستخدم عبر `SearchArticlesErrorState`.

## 📱 Translation Keys Added

**English:**
```json
"search_cancelled": "Search cancelled"
```

**Arabic:**
```json
"search_cancelled": "تم إلغاء البحث"
```

## 🎓 Learning Resources

### What is Debouncing?
Debouncing is a programming practice used to ensure that time-consuming tasks do not fire so often, making them more efficient.

### What is a Race Condition?
A race condition occurs when the outcome depends on the sequence or timing of uncontrollable events.

### CancelToken in Dio
Dio's CancelToken allows you to cancel HTTP requests that are no longer needed, freeing up network resources.

---

**Created by:** Development Team  
**Date:** November 11, 2025  
**Feature:** Search Optimization with Debouncer & Request ID
