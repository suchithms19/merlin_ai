import 'package:serverpod/serverpod.dart';

import '../generated/chat/chat_message.dart';
import '../generated/chat/chat_response.dart';
import '../services/gemini_ai_service.dart';
import '../services/user_profile_service.dart';

class AiChatEndpoint extends Endpoint {
  /// Main chat endpoint - send message to AI and get response
  /// Handles function calling for calendar and email operations
  Future<ChatResponse> chat(
    Session session,
    String message, {
    bool includeCalendarContext = true,
    bool includeEmailContext = true,
  }) async {
    final userProfileId = await _requireUserProfileId(session);
    final aiService = GeminiAIService(session);

    // Get conversation history
    final history = await aiService.getConversationHistory(
      userProfileId,
      limit: 10,
    );

    return aiService.chat(
      userProfileId: userProfileId,
      message: message,
      conversationHistory: history,
      includeCalendarContext: includeCalendarContext,
      includeEmailContext: includeEmailContext,
    );
  }

  /// Get chat history for the current user
  Future<List<ChatMessage>> getChatHistory(
    Session session, {
    int limit = 50,
  }) async {
    final userProfileId = await _requireUserProfileId(session);
    final aiService = GeminiAIService(session);
    return aiService.getConversationHistory(userProfileId, limit: limit);
  }

  /// Clear chat history for the current user
  Future<void> clearChatHistory(Session session) async {
    final userProfileId = await _requireUserProfileId(session);
    final aiService = GeminiAIService(session);
    await aiService.clearConversationHistory(userProfileId);
  }

  /// Quick action: Summarize today's schedule
  Future<ChatResponse> summarizeSchedule(Session session) async {
    return chat(
      session,
      'Please summarize my schedule for today. What meetings do I have and what should I prepare for?',
      includeCalendarContext: true,
      includeEmailContext: false,
    );
  }

  /// Quick action: Summarize unread emails
  Future<ChatResponse> summarizeEmails(Session session) async {
    return chat(
      session,
      'Please summarize my unread emails. Are there any urgent messages I should respond to?',
      includeCalendarContext: false,
      includeEmailContext: true,
    );
  }

  /// Quick action: Daily briefing (calendar + emails)
  Future<ChatResponse> getDailyBriefing(Session session) async {
    return chat(
      session,
      'Good morning! Please give me a daily briefing. Summarize my schedule for today and highlight any important unread emails.',
      includeCalendarContext: true,
      includeEmailContext: true,
    );
  }

  Future<int> _requireUserProfileId(Session session) async {
    final profileService = UserProfileService(session);
    final userProfileId = await profileService.getCurrentUserProfileId();
    if (userProfileId == null) {
      throw Exception('User not authenticated');
    }
    return userProfileId;
  }
}
