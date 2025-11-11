import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/core/widgets/custom_article_item/custom_article_item_card.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/core/widgets/vertical_articles_loading_skeleton.dart';
import 'package:sahifa/features/home/manger/galeries_posts_cubit/galeries_posts_cubit.dart';
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/empty_articles_view.dart';

class GalleriesListView extends StatelessWidget {
  const GalleriesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GaleriesPostsCubit(getIt()),
      child: const GalleriesListViewChild(),
    );
  }
}

class GalleriesListViewChild extends StatefulWidget {
  const GalleriesListViewChild({super.key});

  @override
  State<GalleriesListViewChild> createState() => _GalleriesListViewChildState();
}

class _GalleriesListViewChildState extends State<GalleriesListViewChild> {
  late ScrollController _scrollController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      EasyLoading.show(status: 'loading'.tr());
      final cubit = context.read<GaleriesPostsCubit>();
      final lang = LanguageHelper.getCurrentLanguageCode(context);
      cubit.fetchGaleriesPosts(lang).then((_) {
        EasyLoading.dismiss();
      });
      _isInitialized = true;
    }
  }

  void _onScroll() {
    final cubit = context.read<GaleriesPostsCubit>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      cubit.loadMore();
    }
  }

  Future<void> _onRefresh() async {
    EasyLoading.show(status: 'loading'.tr());
    final cubit = context.read<GaleriesPostsCubit>();
    await cubit.refresh();
    EasyLoading.dismiss();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('galleries'.tr())),
      body: BlocBuilder<GaleriesPostsCubit, GaleriesPostsState>(
        builder: (context, state) {
          if (state is GaleriesPostsLoading) {
            return const VerticalArticlesLoadingSkeleton();
          } else if (state is GaleriesPostsError) {
            return CustomErrorLoadingWidget(
              message: state.message,
              onPressed: () {
                context.read<GaleriesPostsCubit>().refresh();
              },
            );
          } else if (state is GaleriesPostsEmpty) {
            return const EmptyArticlesView();
          } else if (state is GaleriesPostsLoaded ||
              state is GaleriesPostsLoadingMore) {
            final articles = state is GaleriesPostsLoaded
                ? state.articles
                : (state as GaleriesPostsLoadingMore).currentArticles;

            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: GestureDetector(
                            onTap: () {
                              context.push(
                                Routes.detailsGalleryView,
                                extra: articles[index],
                              );
                            },
                            child: CustomArticleItemCard(
                              articleItem: articles[index],
                              cardWidth: double.infinity,
                              isItemList: true,
                            ),
                          ),
                        );
                      }, childCount: articles.length),
                    ),
                  ),
                  if (state is GaleriesPostsLoadingMore)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            'loading_more'.tr(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }

          return const EmptyArticlesView();
        },
      ),
    );
  }
}
