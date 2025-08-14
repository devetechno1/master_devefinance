// lib/common/widgets/paged_view.dart
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

typedef PageFetcher<T> = Future<PageResult<T>> Function(int page);
typedef ItemBuilder<T> = Widget Function(
    BuildContext context, T item, int index);
typedef LoadingItemBuilder = Widget Function(BuildContext context, int index);
typedef EmptyBuilder = Widget Function(BuildContext context);

class PageResult<T> {
  final List<T> data;
  final bool hasMore;
  const PageResult({required this.data, required this.hasMore});
}

enum PagedLayout { list, grid, masonry }

class PagedView<T> extends StatefulWidget {
  const PagedView({
    super.key,
    required this.fetchPage,
    required this.itemBuilder,
    this.layout = PagedLayout.list,
    this.gridCrossAxisCount = 2,
    this.mainAxisSpacing = 8,
    this.crossAxisSpacing = 8,
    this.gridAspectRatio = 1,
    this.gridMainAxisExtent,
    this.padding = const EdgeInsets.all(16),
    this.preloadTriggerFraction = 0.8,
    this.initialPage = 1,
    this.enableRefresh = true,
    this.loadingItemBuilder,
    this.loadingPlaceholdersCount = 6,
    this.loadingMoreBuilder,
    this.emptyBuilder,
    this.physics,
  });

  final PageFetcher<T> fetchPage;
  final ItemBuilder<T> itemBuilder;

  final PagedLayout layout;

  // Grid settings
  final int gridCrossAxisCount;
  final double gridAspectRatio;
  final double? gridMainAxisExtent;

  // Shared spacing
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  final EdgeInsetsGeometry padding;
  final double preloadTriggerFraction;
  final int initialPage;
  final bool enableRefresh;

  final LoadingItemBuilder? loadingItemBuilder;
  final int loadingPlaceholdersCount;

  final Widget? loadingMoreBuilder;
  final EmptyBuilder? emptyBuilder;

  final ScrollPhysics? physics;

  @override
  State<PagedView<T>> createState() => _PagedViewState<T>();
}

class _PagedViewState<T> extends State<PagedView<T>> {
  final ScrollController _scrollController = ScrollController();

  int _page = 1;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  final List<T> _items = [];

  @override
  void initState() {
    super.initState();
    _page = widget.initialPage;
    _loadFirstPage();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isLoadingMore || !_hasMore) return;
    final position = _scrollController.position;
    final triggerPx = position.maxScrollExtent * widget.preloadTriggerFraction;
    if (position.pixels >= triggerPx) {
      _loadMore();
    }
  }

  Future<void> _loadFirstPage() async {
    _page = widget.initialPage;
    _items.clear();
    _hasMore = true;
    _isLoadingMore = false;
    setState(() => _isLoading = true);

    final PageResult<T> res = await widget.fetchPage(_page);
    if (!mounted) return;
    _items.addAll(res.data);
    _hasMore = res.hasMore;
    _isLoading = false;
    setState(() {});
  }

  Future<void> _loadMore() async {
    if (_isLoading || _isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    setState(() {});
    final res = await widget.fetchPage(++_page);
    if (!mounted) return;
    _items.addAll(res.data);
    _hasMore = res.hasMore;
    _isLoadingMore = false;
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildLoadingSliver() {
    if (widget.loadingItemBuilder != null) {
      switch (widget.layout) {
        case PagedLayout.list:
          return SliverList.builder(
            itemCount: widget.loadingPlaceholdersCount,
            itemBuilder: (c, i) => widget.loadingItemBuilder!(c, i),
          );
        case PagedLayout.grid:
          return SliverPadding(
            padding: widget.padding,
            sliver: SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.gridCrossAxisCount,
                mainAxisSpacing: widget.mainAxisSpacing,
                crossAxisSpacing: widget.crossAxisSpacing,
                childAspectRatio: widget.gridAspectRatio,
                mainAxisExtent: widget.gridMainAxisExtent,
              ),
              itemCount: widget.loadingPlaceholdersCount,
              itemBuilder: (c, i) => widget.loadingItemBuilder!(c, i),
            ),
          );
        case PagedLayout.masonry:
          return SliverPadding(
            padding: widget.padding,
            sliver: SliverMasonryGrid.count(
              crossAxisCount: widget.gridCrossAxisCount,
              mainAxisSpacing: widget.mainAxisSpacing,
              crossAxisSpacing: widget.crossAxisSpacing,
              childCount: widget.loadingPlaceholdersCount,
              itemBuilder: (c, i) => widget.loadingItemBuilder!(c, i),
            ),
          );
      }
    }
    // Default minimal loader
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CupertinoActivityIndicator()),
      ),
    );
  }

  Widget _buildItemsSliver() {
    switch (widget.layout) {
      case PagedLayout.list:
        return SliverList.builder(
          itemCount: _items.length,
          itemBuilder: (c, i) => widget.itemBuilder(c, _items[i], i),
        );

      case PagedLayout.grid:
        return SliverPadding(
          padding: widget.padding,
          sliver: SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.gridCrossAxisCount,
              mainAxisSpacing: widget.mainAxisSpacing,
              crossAxisSpacing: widget.crossAxisSpacing,
              childAspectRatio: widget.gridAspectRatio,
              mainAxisExtent: widget.gridMainAxisExtent,
            ),
            itemCount: _items.length,
            itemBuilder: (c, i) => widget.itemBuilder(c, _items[i], i),
          ),
        );

      case PagedLayout.masonry:
        return SliverPadding(
          padding: widget.padding,
          sliver: SliverMasonryGrid.count(
            crossAxisCount: widget.gridCrossAxisCount,
            mainAxisSpacing: widget.mainAxisSpacing,
            crossAxisSpacing: widget.crossAxisSpacing,
            childCount: _items.length,
            itemBuilder: (c, i) => widget.itemBuilder(c, _items[i], i),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = CustomScrollView(
      controller: _scrollController,
      physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
      slivers: [
        if (_isLoading)
          _buildLoadingSliver()
        else if (_items.isEmpty)
          SliverToBoxAdapter(
            child: (widget.emptyBuilder != null)
                ? widget.emptyBuilder!(context)
                : SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.6,
                    child: Center(
                      child: Text('no_data_is_available'.tr(context: context)),
                    ),
                  ),
          )
        else
          _buildItemsSliver(),
        if (_isLoadingMore)
          SliverToBoxAdapter(
            child: widget.loadingMoreBuilder ??
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CupertinoActivityIndicator()),
                ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
      ],
    );

    if (!widget.enableRefresh) return body;

    return RefreshIndicator(
      onRefresh: _loadFirstPage,
      child: body,
    );
  }
}
