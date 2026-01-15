import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AIInputField extends StatefulWidget {
  final Function(String) onSend;
  final bool isLoading;
  final String? hintText;
  final VoidCallback? onFocus;

  const AIInputField({
    super.key,
    required this.onSend,
    this.isLoading = false,
    this.hintText,
    this.onFocus,
  });

  @override
  State<AIInputField> createState() => _AIInputFieldState();
}

class _AIInputFieldState extends State<AIInputField>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;
  bool _isFocused = false;
  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _onFocusChanged() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    if (_isFocused && widget.onFocus != null) {
      widget.onFocus!();
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && !widget.isLoading) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + bottomPadding,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _gradientController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: _isFocused || _hasText
                  ? SweepGradient(
                      center: Alignment.center,
                      startAngle: 0,
                      endAngle: 6.28,
                      colors: [
                        ...AppTheme.rainbowGradient,
                        AppTheme.rainbowGradient.first,
                      ],
                      transform: GradientRotation(
                        _gradientController.value * 6.28,
                      ),
                    )
                  : LinearGradient(
                      colors: [
                        theme.colorScheme.surfaceContainerHigh,
                        theme.colorScheme.surfaceContainerHigh,
                      ],
                    ),
            ),
            padding: const EdgeInsets.all(1.5),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(26.5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Text Input
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 120,
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        enabled: !widget.isLoading,
                        style: theme.textTheme.bodyLarge,
                        decoration: InputDecoration(
                          hintText: widget.hintText ?? 'Ask Merlin',
                          hintStyle: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          filled: false,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),

                  // Send Button
                  Padding(
                    padding: const EdgeInsets.only(right: 6, bottom: 6),
                    child: _buildSendButton(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSendButton(BuildContext context) {
    final theme = Theme.of(context);
    final canSend = _hasText && !widget.isLoading;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: canSend
            ? theme.colorScheme.surfaceContainerHighest
            : theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canSend ? _sendMessage : null,
          borderRadius: BorderRadius.circular(22),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  )
                : Icon(
                    Icons.send_rounded,
                    size: 20,
                    color: canSend
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
          ),
        ),
      ),
    );
  }
}
