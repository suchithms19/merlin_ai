import 'package:serverpod/serverpod.dart';
import '../generated/user_profile/user_profile.dart';

class UserProfileService {
  final Session session;

  UserProfileService(this.session);

  Future<UserProfile?> getOrCreateUserProfile() async {
    final authUserId = session.authenticated?.userIdentifier;
    if (authUserId == null) {
      return null;
    }

    final authUserIdString = authUserId.toString();

    var profile = await UserProfile.db.findFirstRow(
      session,
      where: (p) => p.authUserId.equals(authUserIdString),
    );

    if (profile != null) {
      return profile;
    }

    final now = DateTime.now();
    profile = UserProfile(
      authUserId: authUserIdString,
      email: null,
      fullName: null,
      createdAt: now,
      updatedAt: now,
    );

    await UserProfile.db.insertRow(session, profile);
    return profile;
  }

  Future<int?> getCurrentUserProfileId() async {
    final profile = await getOrCreateUserProfile();
    return profile?.id;
  }

  Future<UserProfile?> getUserProfileByAuthId(String authUserId) async {
    return await UserProfile.db.findFirstRow(
      session,
      where: (p) => p.authUserId.equals(authUserId),
    );
  }
}
