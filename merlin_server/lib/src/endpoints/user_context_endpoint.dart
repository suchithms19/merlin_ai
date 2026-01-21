import 'package:serverpod/serverpod.dart';

import '../generated/user_context/user_context.dart';
import '../services/user_profile_service.dart';

class UserContextEndpoint extends Endpoint {
  /// Get all user contexts for the current user
  Future<List<UserContext>> getUserContexts(Session session) async {
    final userProfileId = await _requireUserProfileId(session);
    return UserContext.db.find(
      session,
      where: (t) => t.userProfileId.equals(userProfileId),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Add a new user context
  Future<UserContext> addUserContext(
    Session session,
    String title,
    String content,
  ) async {
    final userProfileId = await _requireUserProfileId(session);

    final userContext = UserContext(
      userProfileId: userProfileId,
      title: title,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return await UserContext.db.insertRow(session, userContext);
  }

  /// Update an existing user context
  Future<UserContext> updateUserContext(
    Session session,
    int contextId,
    String title,
    String content,
  ) async {
    final userProfileId = await _requireUserProfileId(session);

    final existing = await UserContext.db.findById(session, contextId);
    if (existing == null) {
      throw Exception('User context not found');
    }
    if (existing.userProfileId != userProfileId) {
      throw Exception('Not authorized to update this context');
    }

    final updated = existing.copyWith(
      title: title,
      content: content,
      updatedAt: DateTime.now(),
    );

    return await UserContext.db.updateRow(session, updated);
  }

  /// Delete a user context
  Future<bool> deleteUserContext(Session session, int contextId) async {
    final userProfileId = await _requireUserProfileId(session);

    final existing = await UserContext.db.findById(session, contextId);
    if (existing == null) {
      throw Exception('User context not found');
    }
    if (existing.userProfileId != userProfileId) {
      throw Exception('Not authorized to delete this context');
    }

    await UserContext.db.deleteRow(session, existing);
    return true;
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
