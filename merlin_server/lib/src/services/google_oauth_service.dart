import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../generated/google_oauth/google_oauth_token.dart';
import '../util/token_encryption.dart';
import 'user_profile_service.dart';

class GoogleOAuthService {
  final Session session;

  GoogleOAuthService(this.session);

  Map<String, dynamic> _getOAuthConfig() {
    try {
      // Access config from passwords.yaml or environment
      // For now, we'll read from environment variables
      // In production, these should be set as environment variables
      return {
        'clientId': session.passwords['googleOAuthClientId'] ?? '',
        'clientSecret': session.passwords['googleOAuthClientSecret'] ?? '',
        'redirectUri': 'http://localhost:8082/auth/google/callback',
        'scopes': [
          'https://www.googleapis.com/auth/calendar',
          'https://www.googleapis.com/auth/gmail.readonly',
          'https://www.googleapis.com/auth/gmail.send',
          'https://www.googleapis.com/auth/gmail.modify',
        ],
      };
    } catch (e) {
      session.log('Error reading OAuth config: $e', level: LogLevel.error);
      return {};
    }
  }

  Future<String> getAuthorizationUrl() async {
    final config = _getOAuthConfig();
    final clientId = config['clientId'] as String? ?? '';
    final redirectUri = config['redirectUri'] as String? ?? '';
    final scopes = (config['scopes'] as List<dynamic>?)?.cast<String>() ?? [];

    if (clientId.isEmpty) {
      throw Exception('Google OAuth client ID not configured');
    }

    // Get or create user profile to include in state
    final profileService = UserProfileService(session);
    final userProfile = await profileService.getOrCreateUserProfile();
    if (userProfile == null || userProfile.id == null) {
      throw Exception('User not authenticated');
    }

    // Create state parameter with user profile ID (encrypted for security)
    final stateData = '${userProfile.id}';
    final state = TokenEncryption.encrypt(stateData, session);

    final params = {
      'client_id': clientId,
      'redirect_uri': redirectUri,
      'response_type': 'code',
      'scope': scopes.join(' '),
      'access_type': 'offline',
      'prompt': 'consent',
      'state': state,
    };

    final queryString = params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');

    return 'https://accounts.google.com/o/oauth2/v2/auth?$queryString';
  }

  Future<GoogleOAuthToken> exchangeCodeForTokens(String code) async {
    final config = _getOAuthConfig();
    final clientId = config['clientId'] as String? ?? '';
    final clientSecret = config['clientSecret'] as String? ?? '';
    final redirectUri = config['redirectUri'] as String? ?? '';

    if (clientId.isEmpty || clientSecret.isEmpty) {
      throw Exception('Google OAuth credentials not configured');
    }

    try {
      final response = await http.post(
        Uri.parse('https://oauth2.googleapis.com/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'code': code,
          'client_id': clientId,
          'client_secret': clientSecret,
          'redirect_uri': redirectUri,
          'grant_type': 'authorization_code',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to exchange code: ${response.body}');
      }

      final tokenData = json.decode(response.body) as Map<String, dynamic>;
      final accessToken = tokenData['access_token'] as String;
      final refreshToken = tokenData['refresh_token'] as String? ?? '';
      final expiresIn = tokenData['expires_in'] as int? ?? 3600;
      final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));

      final encryptedAccessToken = TokenEncryption.encrypt(
        accessToken,
        session,
      );
      final encryptedRefreshToken = refreshToken.isNotEmpty
          ? TokenEncryption.encrypt(refreshToken, session)
          : '';

      // Get or create user profile
      final profileService = UserProfileService(session);
      final userProfile = await profileService.getOrCreateUserProfile();
      if (userProfile == null || userProfile.id == null) {
        throw Exception('User not authenticated');
      }

      final userProfileId = userProfile.id!;

      final existingToken = await GoogleOAuthToken.db.findFirstRow(
        session,
        where: (t) => t.userProfileId.equals(userProfileId),
      );

      final now = DateTime.now();

      if (existingToken != null) {
        existingToken.accessToken = encryptedAccessToken;
        existingToken.refreshToken = encryptedRefreshToken;
        existingToken.expiresAt = expiresAt;
        existingToken.updatedAt = now;
        await GoogleOAuthToken.db.updateRow(session, existingToken);
        return existingToken;
      } else {
        final token = GoogleOAuthToken(
          userProfileId: userProfileId,
          accessToken: encryptedAccessToken,
          refreshToken: encryptedRefreshToken,
          expiresAt: expiresAt,
          createdAt: now,
          updatedAt: now,
        );
        await GoogleOAuthToken.db.insertRow(session, token);
        return token;
      }
    } catch (e) {
      session.log(
        'Error exchanging code for tokens: $e',
        level: LogLevel.error,
      );
      rethrow;
    }
  }

  /// Exchange code for tokens using state parameter (for callback route)
  /// This method decrypts the state to get the user profile ID
  Future<GoogleOAuthToken> exchangeCodeForTokensWithState(
    String code,
    String state,
  ) async {
    final config = _getOAuthConfig();
    final clientId = config['clientId'] as String? ?? '';
    final clientSecret = config['clientSecret'] as String? ?? '';
    final redirectUri = config['redirectUri'] as String? ?? '';

    if (clientId.isEmpty || clientSecret.isEmpty) {
      throw Exception('Google OAuth credentials not configured');
    }

    // Decrypt state to get user profile ID
    final stateData = TokenEncryption.decrypt(state, session);
    final userProfileId = int.tryParse(stateData);
    if (userProfileId == null) {
      throw Exception('Invalid state parameter');
    }

    try {
      final response = await http.post(
        Uri.parse('https://oauth2.googleapis.com/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'code': code,
          'client_id': clientId,
          'client_secret': clientSecret,
          'redirect_uri': redirectUri,
          'grant_type': 'authorization_code',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to exchange code: ${response.body}');
      }

      final tokenData = json.decode(response.body) as Map<String, dynamic>;
      final accessToken = tokenData['access_token'] as String;
      final refreshToken = tokenData['refresh_token'] as String? ?? '';
      final expiresIn = tokenData['expires_in'] as int? ?? 3600;
      final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));

      final encryptedAccessToken = TokenEncryption.encrypt(
        accessToken,
        session,
      );
      final encryptedRefreshToken = refreshToken.isNotEmpty
          ? TokenEncryption.encrypt(refreshToken, session)
          : '';

      final existingToken = await GoogleOAuthToken.db.findFirstRow(
        session,
        where: (t) => t.userProfileId.equals(userProfileId),
      );

      final now = DateTime.now();

      if (existingToken != null) {
        existingToken.accessToken = encryptedAccessToken;
        existingToken.refreshToken = encryptedRefreshToken;
        existingToken.expiresAt = expiresAt;
        existingToken.updatedAt = now;
        await GoogleOAuthToken.db.updateRow(session, existingToken);
        return existingToken;
      } else {
        final token = GoogleOAuthToken(
          userProfileId: userProfileId,
          accessToken: encryptedAccessToken,
          refreshToken: encryptedRefreshToken,
          expiresAt: expiresAt,
          createdAt: now,
          updatedAt: now,
        );
        await GoogleOAuthToken.db.insertRow(session, token);
        return token;
      }
    } catch (e) {
      session.log(
        'Error exchanging code for tokens with state: $e',
        level: LogLevel.error,
      );
      rethrow;
    }
  }

  Future<GoogleOAuthToken> refreshTokens(int userProfileId) async {
    final config = _getOAuthConfig();
    final clientId = config['clientId'] as String? ?? '';
    final clientSecret = config['clientSecret'] as String? ?? '';

    if (clientId.isEmpty || clientSecret.isEmpty) {
      throw Exception('Google OAuth credentials not configured');
    }

    final existingToken = await GoogleOAuthToken.db.findFirstRow(
      session,
      where: (t) => t.userProfileId.equals(userProfileId),
    );

    if (existingToken == null) {
      throw Exception('No OAuth token found for user');
    }

    if (existingToken.refreshToken.isEmpty) {
      throw Exception('No refresh token available');
    }

    try {
      final refreshToken = TokenEncryption.decrypt(
        existingToken.refreshToken,
        session,
      );

      final response = await http.post(
        Uri.parse('https://oauth2.googleapis.com/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'refresh_token': refreshToken,
          'client_id': clientId,
          'client_secret': clientSecret,
          'grant_type': 'refresh_token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to refresh token: ${response.body}');
      }

      final tokenData = json.decode(response.body) as Map<String, dynamic>;
      final newAccessToken = tokenData['access_token'] as String;
      final newRefreshToken =
          tokenData['refresh_token'] as String? ?? refreshToken;
      final expiresIn = tokenData['expires_in'] as int? ?? 3600;
      final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));

      final encryptedAccessToken = TokenEncryption.encrypt(
        newAccessToken,
        session,
      );
      final encryptedRefreshToken = TokenEncryption.encrypt(
        newRefreshToken,
        session,
      );

      existingToken.accessToken = encryptedAccessToken;
      existingToken.refreshToken = encryptedRefreshToken;
      existingToken.expiresAt = expiresAt;
      existingToken.updatedAt = DateTime.now();
      await GoogleOAuthToken.db.updateRow(session, existingToken);

      return existingToken;
    } catch (e) {
      session.log('Error refreshing tokens: $e', level: LogLevel.error);
      rethrow;
    }
  }

  Future<String> getValidAccessToken(int userProfileId) async {
    final token = await GoogleOAuthToken.db.findFirstRow(
      session,
      where: (t) => t.userProfileId.equals(userProfileId),
    );

    if (token == null) {
      throw Exception('No OAuth token found for user');
    }

    final now = DateTime.now();
    final expiresAt = token.expiresAt;
    if (expiresAt.isBefore(now.add(const Duration(minutes: 5)))) {
      final refreshedToken = await refreshTokens(userProfileId);
      return TokenEncryption.decrypt(refreshedToken.accessToken, session);
    }

    return TokenEncryption.decrypt(token.accessToken, session);
  }

  Future<bool> isConnected(int userProfileId) async {
    try {
      final token = await GoogleOAuthToken.db.findFirstRow(
        session,
        where: (t) => t.userProfileId.equals(userProfileId),
      );

      if (token == null) return false;

      await getValidAccessToken(userProfileId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> disconnect(int userProfileId) async {
    final token = await GoogleOAuthToken.db.findFirstRow(
      session,
      where: (t) => t.userProfileId.equals(userProfileId),
    );

    if (token != null) {
      try {
        final accessToken = TokenEncryption.decrypt(token.accessToken, session);

        final revokeResponse = await http.post(
          Uri.parse('https://oauth2.googleapis.com/revoke'),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {'token': accessToken},
        );

        if (revokeResponse.statusCode != 200) {
          session.log(
            'Failed to revoke Google OAuth token: ${revokeResponse.body}',
            level: LogLevel.warning,
          );
        }
      } catch (e) {
        session.log(
          'Error revoking Google OAuth token: $e',
          level: LogLevel.warning,
        );
      }
    }

    await GoogleOAuthToken.db.deleteWhere(
      session,
      where: (t) => t.userProfileId.equals(userProfileId),
    );
  }
}
