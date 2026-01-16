import 'package:flutter/material.dart';
import 'package:merlin_client/merlin_client.dart';

import '../widgets/ai_input_field.dart';
import '../widgets/chat_history_widget.dart';

class ChatScreen extends StatefulWidget {
  final Client client;

  const ChatScreen({
    super.key,
    required this.client,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessageData> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadChatHistory() async {
    try {
      final history = await widget.client.aiChat.getChatHistory(limit: 50);
      setState(() {
        _messages.clear();
        _messages.addAll(history.map((msg) => ChatMessageData(
          content: msg.content,
          role: msg.role,
          timestamp: msg.createdAt,
        )));
      });
      _scrollToBottom();
    } catch (e) {
      // Chat history not available yet, that's fine
    }
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    if (!mounted) return;
    
    setState(() {
      _messages.add(ChatMessageData(
        content: message,
        role: 'user',
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
      _errorMessage = null;
    });
    
    _scrollToBottom();

    try {
      final response = await widget.client.aiChat.chat(
        message,
        includeCalendarContext: true,
        includeEmailContext: true,
      );
      
      if (!mounted) return;
      
      setState(() {
        _messages.add(ChatMessageData(
          content: response.message,
          role: 'model',
          timestamp: DateTime.now(),
          functionsExecuted: response.functionsCalled,
          isError: response.error != null,
        ));
        _isLoading = false;
      });
      
      // Force a frame to be scheduled
      WidgetsBinding.instance.scheduleFrame();
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _messages.add(ChatMessageData(
          content: 'Sorry, I encountered an error: $e',
          role: 'model',
          timestamp: DateTime.now(),
          isError: true,
        ));
        _isLoading = false;
        _errorMessage = e.toString();
      });
      
      WidgetsBinding.instance.scheduleFrame();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _clearChat() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text('Are you sure you want to clear all chat history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await widget.client.aiChat.clearChatHistory();
        setState(() {
          _messages.clear();
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to clear chat: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, size: 24),
            SizedBox(width: 8),
            Text('Merlin'),
          ],
        ),
        actions: [
          if (_messages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _clearChat,
              tooltip: 'Clear chat',
            ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleQuickAction(value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'briefing',
                child: ListTile(
                  leading: Icon(Icons.wb_sunny),
                  title: Text('Daily Briefing'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'schedule',
                child: ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text('Today\'s Schedule'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'emails',
                child: ListTile(
                  leading: Icon(Icons.email),
                  title: Text('Email Summary'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatHistoryWidget(
              client: widget.client,
              messages: _messages,
              scrollController: _scrollController,
              isLoading: _isLoading,
            ),
          ),
          AIInputField(
            onSend: _sendMessage,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }

  Future<void> _handleQuickAction(String action) async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      ChatResponse response;
      String userMessage;
      
      switch (action) {
        case 'briefing':
          userMessage = 'Give me my daily briefing';
          response = await widget.client.aiChat.getDailyBriefing();
          break;
        case 'schedule':
          userMessage = 'What\'s on my schedule today?';
          response = await widget.client.aiChat.summarizeSchedule();
          break;
        case 'emails':
          userMessage = 'Summarize my unread emails';
          response = await widget.client.aiChat.summarizeEmails();
          break;
        default:
          return;
      }

      if (!mounted) return;
      
      setState(() {
        _messages.add(ChatMessageData(
          content: userMessage,
          role: 'user',
          timestamp: DateTime.now(),
        ));
        _messages.add(ChatMessageData(
          content: response.message,
          role: 'model',
          timestamp: DateTime.now(),
          functionsExecuted: response.functionsCalled,
        ));
        _isLoading = false;
      });
      
      WidgetsBinding.instance.scheduleFrame();
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
