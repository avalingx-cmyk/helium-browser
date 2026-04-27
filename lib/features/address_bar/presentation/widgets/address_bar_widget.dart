import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/providers/address_bar_provider.dart';
import '../../../../core/utils/url_utils.dart';

// CONST AUDIT: ❌ Cannot be const - ConsumerStatefulWidget with dynamic callbacks.
// Uses Riverpod ref.watch and TextEditingController.
class AddressBarWidget extends ConsumerStatefulWidget {
  final String? initialUrl;
  final String? title;
  final Function(String url) onSubmit;
  final bool isSecure;

  const AddressBarWidget({
    super.key,
    this.initialUrl,
    this.title,
    required this.onSubmit,
    this.isSecure = true,
  });

  @override
  ConsumerState<AddressBarWidget> createState() => _AddressBarWidgetState();
}

class _AddressBarWidgetState extends ConsumerState<AddressBarWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialUrl ?? '');
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(AddressBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!ref.read(addressBarProvider).isEditing && widget.initialUrl != oldWidget.initialUrl) {
      _controller.text = widget.initialUrl ?? '';
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      ref.read(addressBarProvider.notifier).startEditing();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addressBarProvider);
    final notifier = ref.read(addressBarProvider.notifier);

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          // Security icon
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Icon(
              widget.isSecure ? Icons.lock : Icons.warning_amber,
              size: 18,
              color: widget.isSecure
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.error,
            ),
          ),
          
          // Text field
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: state.isEditing
                    ? 'Search or enter address'
                    : (widget.title ?? widget.initialUrl ?? 'Search'),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 14,
              ),
              textInputAction: TextInputAction.go,
              onChanged: notifier.updateText,
              onSubmitted: (value) {
                final url = notifier.submitUrl(value);
                if (url.isNotEmpty) {
                  widget.onSubmit(url);
                }
              },
            ),
          ),
          
          // Clear button (when editing)
          if (state.isEditing && _controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () {
                _controller.clear();
                notifier.clearInput();
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
            ),
          
          // Menu button (when not editing)
          if (!state.isEditing)
            IconButton(
              icon: const Icon(Icons.more_vert, size: 20),
              onPressed: () {
                // Show menu
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
            ),
        ],
      ),
    );
  }
}
