import 'package:flutter/material.dart';
import 'package:merlin_client/merlin_client.dart';
import 'chat_message_widget.dart';

class ChatHistoryWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (messages.isEmpty && !isLoading) {
      return _buildEmptyState(context);
    }

    return ListView(
      key: PageStorageKey('chat_messages_${messages.length}'),
      controller: scrollController,
      padding: const EdgeInsets.only(top: 16, bottom: 100),
      children: [
        ...messages.asMap().entries.map((entry) {
          final index = entry.key;
          final message = entry.value;
          return ChatMessageWidget(
            key: ValueKey(
              'msg_${message.timestamp?.millisecondsSinceEpoch}_$index',
            ),
            content: message.content,
            role: message.role == 'user'
                ? MessageRole.user
                : MessageRole.assistant,
            timestamp: message.timestamp,
            functionsExecuted: message.functionsExecuted,
            isError: message.isError,
          );
        }),
        if (isLoading) _buildLoadingIndicator(context),
      ],
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
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 40,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Hello! I'm Merlin",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your AI personal assistant',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 40),

            _buildFeatureItem(
              context,
              Icons.calendar_today_rounded,
              'Manage your calendar',
            ),
            const SizedBox(height: 12),
            _buildFeatureItem(
              context,
              Icons.email_rounded,
              'Read and send emails',
            ),
            const SizedBox(height: 12),
            _buildFeatureItem(
              context,
              Icons.schedule_rounded,
              'Schedule meetings',
            ),
            const SizedBox(height: 12),
            _buildFeatureItem(
              context,
              Icons.summarize_rounded,
              'Summarize your day',
            ),

            const SizedBox(height: 40),

            Text(
              'Try asking:',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 16),
            _buildSuggestionChip(context, '"What\'s on my schedule today?"'),
            const SizedBox(height: 8),
            _buildSuggestionChip(context, '"Summarize my unread emails"'),
            const SizedBox(height: 8),
            _buildSuggestionChip(context, '"Schedule a meeting tomorrow"'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(BuildContext context, String text) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
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
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 18,
              color: theme.colorScheme.onTertiaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(context, 0),
                const SizedBox(width: 4),
                _buildTypingDot(context, 1),
                const SizedBox(width: 4),
                _buildTypingDot(context, 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(BuildContext context, int index) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + (index * 200)),
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(
              0.3 + (0.4 * (1 - (value - value.floor()))),
            ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

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
