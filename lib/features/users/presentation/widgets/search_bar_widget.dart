import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/debouncer.dart';
import '../controllers/search_query_notifier.dart';

class SearchBarWidget extends ConsumerStatefulWidget {
  final String hintText;
  final Function(String) onChanged;
  final int debounceDuration;

  const SearchBarWidget({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.debounceDuration = 500,
  });

  @override
  ConsumerState<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends ConsumerState<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  late final Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(milliseconds: widget.debounceDuration);
  }

  @override
  void dispose() {
    _controller.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String>(searchQueryProvider, (previous, next) {
      if (next.isEmpty && _controller.text.isNotEmpty) {
        _controller.clear();
        setState(() {});
      }
    });

    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _debouncer.cancel();
                  _controller.clear();
                  widget.onChanged('');
                  setState(() {});
                },
              )
            : null,
      ),
      onChanged: (value) {
        setState(() {});
        if (value.isEmpty) {
          _debouncer.cancel();
          widget.onChanged('');
        } else {
          _debouncer.run(() => widget.onChanged(value));
        }
      },
    );
  }
}
