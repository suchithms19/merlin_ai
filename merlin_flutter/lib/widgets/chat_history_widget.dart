import 'package:flutter/material.dart';
import 'package:merlin_client/merlin_client.dart';
import 'chat_message_widget.dart';

class ChatHistoryWidget extends StatefulWidget {
  final Client client;
  final ScrollController? scrollController;
  final List<ChatMessageData> messages;
  final bool isLoading;

  const ChatHistoryWidget({
    super.key,
    required this.client,
    required this.messages,
    this.scrollController,
    this.isLoading = false,
  });

  @override
  State<ChatHistoryWidget> createState() => _ChatHistoryWidgetState();
}

class _ChatHistoryWidgetState extends State<ChatHistoryWidget> {
  @override
  Widget build(BuildContext context) {
    
    if (widget.messages.isEmpty && !widget.isLoading) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      controller: widget.scrollController,
      padding: const EdgeInsets.only(top: 16, bottom: 100),
      itemCount: widget.messages.length + (widget.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == widget.messages.length && widget.isLoading) {
          return _buildLoadingIndicator(context);
        }
        
        final message = widget.messages[index];
        return ChatMessageWidget(
          content: message.content,
          role: message.role == 'user' ? MessageRole.user : MessageRole.assistant,
          timestamp: message.timestamp,
          functionsExecuted: message.functionsExecuted,
          isError: message.isError,
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome,
                size: 40,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Hello! I\'m Merlin',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your AI personal assistant',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'I can help you with:',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildFeatureChip(context, Icons.calendar_today, 'Manage your calendar'),
            const SizedBox(height: 8),
            _buildFeatureChip(context, Icons.email, 'Read and send emails'),
            const SizedBox(height: 8),
            _buildFeatureChip(context, Icons.schedule, 'Schedule meetings'),
            const SizedBox(height: 8),
            _buildFeatureChip(context, Icons.summarize, 'Summarize your day'),
            const SizedBox(height: 32),
            Text(
              'Try asking:',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 12),
            _buildSuggestionChip(context, '"What\'s on my schedule today?"'),
            const SizedBox(height: 8),
            _buildSuggestionChip(context, '"Summarize my unread emails"'),
            const SizedBox(height: 8),
            _buildSuggestionChip(context, '"Schedule a meeting tomorrow at 2pm"'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Text(text, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(BuildContext context, String text) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.7),
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_awesome,
              size: 20,
              color: theme.colorScheme.onTertiaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + (index * 200)),
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withOpacity(0.3 + (0.3 * (1 - (value - value.floor())))),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

/// Data class for chat messages
class ChatMessageData {
  final String content;
  final String role;
  final DateTime? timestamp;
  final List<String>? functionsExecuted;
  final bool isError;

  ChatMessageData({
    required this.content,
    required this.role,
    this.timestamp,
    this.functionsExecuted,
    this.isError = false,
  });
}
