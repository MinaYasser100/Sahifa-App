import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/features/altharwa_archive/data/repo/magazines_repo.dart';
import 'package:sahifa/features/altharwa_archive/manager/date_filter_cubit/date_filter_cubit.dart';
import 'package:sahifa/features/altharwa_archive/manager/magazines_cubit/magazines_cubit.dart';
import 'package:get_it/get_it.dart';
import 'widgets/althawra_archive_body_view.dart';
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
        final dateFilterCubit = context.read<DateFilterCubit>();
        final state = cubit.state;

        if (state is MagazinesLoaded && state.hasMore) {
          _isLoadingMore = true;

          // Pass filter dates if available
          cubit
              .loadMoreMagazines(
                fromDate: dateFilterCubit.fromDate,
                toDate: dateFilterCubit.toDate,
              )
              .then((_) {
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              MagazinesCubit(GetIt.instance<MagazinesRepoImpl>())
                ..fetchMagazines(),
        ),
        BlocProvider(create: (context) => DateFilterCubit()),
      ],
      child: Builder(
        builder: (context) {
          final magazinesCubit = BlocProvider.of<MagazinesCubit>(context);
          final dateFilterCubit = BlocProvider.of<DateFilterCubit>(context);

          return Scaffold(
            appBar: AppBar(
              title: Text('altharwa_archive'.tr()),
              elevation: 10,
              actions: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: DateRangeFilterSheet(
                          magazinesCubit: magazinesCubit,
                          dateFilterCubit: dateFilterCubit,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.tune_rounded),
                ),
              ],
            ),
            body: AlthawraArchiveBodyView(
              controller: controller,
              scrollController: _scrollController,
            ),
          );
        },
      ),
    );
  }
}
