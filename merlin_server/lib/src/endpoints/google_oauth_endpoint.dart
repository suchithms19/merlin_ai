import 'package:serverpod/serverpod.dart';
import '../generated/google_oauth/google_oauth_token.dart';
import '../services/google_oauth_service.dart';
import '../services/user_profile_service.dart';

class GoogleOAuthEndpoint extends Endpoint {
  Future<String> initiateGoogleOAuth(Session session) async {
    final service = GoogleOAuthService(session);
    return await service.getAuthorizationUrl();
  }
  
  Future<GoogleOAuthToken> handleGoogleOAuthCallback(
    Session session,
    String code,
  ) async {
    final service = GoogleOAuthService(session);
    return await service.exchangeCodeForTokens(code);
  }
  
  Future<GoogleOAuthToken> refreshGoogleTokens(Session session) async {
    final profileService = UserProfileService(session);
    final userProfileId = await profileService.getCurrentUserProfileId();
    if (userProfileId == null) {
      throw Exception('User not authenticated');
    }
    
    final service = GoogleOAuthService(session);
    return await service.refreshTokens(userProfileId);
  }
  
  Future<bool> getGoogleConnectionStatus(Session session) async {
    final profileService = UserProfileService(session);
    final userProfileId = await profileService.getCurrentUserProfileId();
    if (userProfileId == null) {
      return false;
    }
    
    final service = GoogleOAuthService(session);
    return await service.isConnected(userProfileId);
  }
  
  Future<void> disconnectGoogle(Session session) async {
    final profileService = UserProfileService(session);
    final userProfileId = await profileService.getCurrentUserProfileId();
    if (userProfileId == null) {
      throw Exception('User not authenticated');
    }
    
    final service = GoogleOAuthService(session);
    await service.disconnect(userProfileId);
  }
}
