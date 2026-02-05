import 'package:flutter/material.dart';
import 'load_more_indicator.dart';

class PaginatedListView<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final Future<void> Function()? onLoadMore;
  final bool isLoadingMore;
  final bool hasMoreItems;
  final EdgeInsetsGeometry? padding;
  final Widget? emptyWidget;
  final ScrollController? controller;
  final double loadMoreThreshold;

  const PaginatedListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.onLoadMore,
    this.isLoadingMore = false,
    this.hasMoreItems = true,
    this.padding,
    this.emptyWidget,
    this.controller,
    this.loadMoreThreshold = 200.0,
  });

  @override
  State<PaginatedListView<T>> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  late ScrollController _scrollController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (_isLoading || !widget.hasMoreItems || widget.onLoadMore == null) {
      return;
    }

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = widget.loadMoreThreshold;

    if (maxScroll - currentScroll <= threshold) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      await widget.onLoadMore?.call();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty && widget.emptyWidget != null) {
      return widget.emptyWidget!;
    }

    return ListView.builder(
      controller: _scrollController,
      padding: widget.padding,
      itemCount: widget.items.length + 1,
      itemBuilder: (context, index) {
        if (index == widget.items.length) {
          return LoadMoreIndicator(
            isLoadingMore: widget.isLoadingMore || _isLoading,
            hasMoreItems: widget.hasMoreItems,
          );
        }

        return widget.itemBuilder(context, widget.items[index], index);
      },
    );
  }
}
