import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/text_field_model/text_field_model.dart';
import 'package:sahifa/core/widgets/custom_text_form_field.dart';
import 'package:sahifa/features/altharwa_archive/data/repo/magazines_repo.dart';
import 'package:sahifa/features/altharwa_archive/manager/magazines_cubit/magazines_cubit.dart';
import 'package:sahifa/features/altharwa_archive/ui/widgets/magazines_empty_widget.dart';
import 'package:sahifa/features/altharwa_archive/ui/widgets/magazines_error_widget.dart';
import 'package:sahifa/features/altharwa_archive/ui/widgets/magazines_grid_view.dart';
import 'package:sahifa/features/altharwa_archive/ui/widgets/magazines_loading_more_indicator.dart';
import 'package:sahifa/features/altharwa_archive/ui/widgets/magazines_loading_widget.dart';
import 'package:get_it/get_it.dart';
import 'widgets/date_range_filter_sheet.dart';

class AltharwaArchiveView extends StatefulWidget {
  const AltharwaArchiveView({super.key});

  @override
  State<AltharwaArchiveView> createState() => _AltharwaArchiveViewState();
}

class _AltharwaArchiveViewState extends State<AltharwaArchiveView> {
  late TextEditingController controller;
  late ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    controller = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Check if we've scrolled to 60% of the content
    if (_scrollController.hasClients && !_isLoadingMore) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      final threshold = maxScroll * 0.6; // 60% threshold

      if (currentScroll >= threshold) {
        // Trigger load more
        final cubit = context.read<MagazinesCubit>();
        final state = cubit.state;

        if (state is MagazinesLoaded && state.hasMore) {
          _isLoadingMore = true;
          cubit.loadMoreMagazines().then((_) {
            if (mounted) {
              setState(() {
                _isLoadingMore = false;
              });
            }
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MagazinesCubit(GetIt.instance<MagazinesRepoImpl>())..fetchMagazines(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('altharwa_archive'.tr()),
          elevation: 10,
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return const DateRangeFilterSheet();
                  },
                );
              },
              icon: const Icon(Icons.tune_rounded),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                left: 16.0,
                right: 16.0,
              ),
              child: CustomTextFormField(
                textFieldModel: TextFieldModel(
                  controller: controller,
                  hintText: 'search_placeholder'.tr(),
                  icon: Icons.search,
                  keyboardType: TextInputType.text,
                  validator: (p0) {
                    return null;
                  },
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<MagazinesCubit, MagazinesState>(
                builder: (context, state) {
                  if (state is MagazinesLoading) {
                    return const MagazinesLoadingWidget();
                  }

                  if (state is MagazinesError) {
                    return MagazinesErrorWidget(message: state.message);
                  }

                  if (state is MagazinesLoaded ||
                      state is MagazinesLoadingMore) {
                    final magazines = state is MagazinesLoaded
                        ? state.magazines
                        : (state as MagazinesLoadingMore).magazines;

                    if (magazines.isEmpty) {
                      return const MagazinesEmptyWidget();
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: MagazinesGridView(
                            magazines: magazines,
                            scrollController: _scrollController,
                          ),
                        ),
                        // Loading more indicator
                        if (state is MagazinesLoadingMore)
                          const MagazinesLoadingMoreIndicator(),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
