import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/features/audio/ui/widgets/audio_magazine_body_view.dart';

class AudioMagazineView extends StatelessWidget {
  const AudioMagazineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("audio_magazine".tr())),
      body: const AudioMagazineBodyView(),
    );
  }
}
