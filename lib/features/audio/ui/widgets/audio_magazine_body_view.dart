import 'package:flutter/material.dart';
import 'package:sahifa/core/model/audios_model/audio_item_model.dart';
import 'package:sahifa/features/audio/ui/widgets/audio_category_section.dart';

class AudioMagazineBodyView extends StatelessWidget {
  const AudioMagazineBodyView({super.key});

  Map<String, List<AudioItemModel>> _getDummyAudioCategories() {
    return {
      'تاريخ': [
        AudioItemModel(
          id: '1',
          title: 'كتاب صوتي عن التاريخ الإسلامي',
          thumbnailUrl: 'https://via.placeholder.com/160x220',
          duration: '45:30',
          authorName: 'محمد أحمد',
          summary:
              'كتاب صوتي رائع يتحدث عن التاريخ الإسلامي وأهم الأحداث التي شكلت العالم الإسلامي',
          categoryName: 'تاريخ',
        ),
        AudioItemModel(
          id: '2',
          title: 'الحضارة العربية القديمة',
          thumbnailUrl: 'https://via.placeholder.com/160x220',
          duration: '38:20',
          authorName: 'سامي حسن',
          summary: 'استكشاف للحضارة العربية وإنجازاتها عبر التاريخ',
          categoryName: 'تاريخ',
        ),
        AudioItemModel(
          id: '2',
          title: 'الحضارة العربية القديمة',
          thumbnailUrl: 'https://via.placeholder.com/160x220',
          duration: '38:20',
          authorName: 'سامي حسن',
          summary: 'استكشاف للحضارة العربية وإنجازاتها عبر التاريخ',
          categoryName: 'تاريخ',
        ),
      ],
      'أدب': [
        AudioItemModel(
          id: '3',
          title: 'رحلة في عالم الأدب العربي',
          thumbnailUrl: 'https://via.placeholder.com/160x220',
          duration: '52:15',
          authorName: 'أحمد محمود',
          summary:
              'استكشاف شيق لأهم الأعمال الأدبية العربية عبر العصور المختلفة',
          categoryName: 'أدب',
        ),
        AudioItemModel(
          id: '4',
          title: 'الشعر العربي الحديث',
          thumbnailUrl: 'https://via.placeholder.com/160x220',
          duration: '41:30',
          authorName: 'نادية كمال',
          summary: 'جولة في عالم الشعر العربي الحديث وأبرز شعرائه',
          categoryName: 'أدب',
        ),
      ],
      'ثقافة': [
        AudioItemModel(
          id: '5',
          title: 'فن الطبخ العربي',
          thumbnailUrl: 'https://via.placeholder.com/160x220',
          duration: '38:45',
          authorName: 'فاطمة حسن',
          summary:
              'دليل صوتي شامل لأشهر الأطباق العربية وكيفية تحضيرها بطريقة احترافية',
          categoryName: 'ثقافة',
        ),
        AudioItemModel(
          id: '6',
          title: 'العادات والتقاليد العربية',
          thumbnailUrl: 'https://via.placeholder.com/160x220',
          duration: '44:10',
          authorName: 'ياسر محمد',
          summary: 'تعرف على العادات والتقاليد العربية الأصيلة',
          categoryName: 'ثقافة',
        ),
        AudioItemModel(
          id: '5',
          title: 'فن الطبخ العربي',
          thumbnailUrl: 'https://via.placeholder.com/160x220',
          duration: '38:45',
          authorName: 'فاطمة حسن',
          summary:
              'دليل صوتي شامل لأشهر الأطباق العربية وكيفية تحضيرها بطريقة احترافية',
          categoryName: 'ثقافة',
        ),
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final audioCategories = _getDummyAudioCategories();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          ...audioCategories.entries.map((entry) {
            return AudioCategorySection(
              categoryName: entry.key,
              audioItems: entry.value,
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
