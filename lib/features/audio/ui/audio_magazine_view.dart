import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/features/audio/data/repo/audio_categories_repo.dart';
import 'package:sahifa/features/audio/manager/audio_categories_cubit/audio_categories_cubit.dart';
import 'package:sahifa/features/audio/ui/widgets/audio_magazine_body_view.dart';

class AudioMagazineView extends StatelessWidget {
  const AudioMagazineView({super.key});

  @override
  Widget build(BuildContext context) {
    final language = context.locale.languageCode;
    
    return Scaffold(
      appBar: AppBar(title: Text("audio_magazine".tr())),
      body: BlocProvider(
        create: (context) =>
            AudioCategoriesCubit(AudioCategoriesRepoImpl(DioHelper()))
              ..fetchAudioCategories(language: language),
        child: const AudioMagazineBodyView(),
      ),
    );
  }
}
