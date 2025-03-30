// import 'package:resume_builder_app/core/network/api_client.dart';
// import 'package:resume_builder_app/core/utils/constants.dart';
import 'package:resume_builder_app/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSource()
      : _firebaseAuth = FirebaseAuth.instance,
        _firestore = FirebaseFirestore.instance,
        _googleSignIn = GoogleSignIn();

  Future<UserModel> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Login failed');
      }

      // Update last login timestamp
      await _updateLastLogin(userCredential.user!.uid);

      // Get full user profile
      return await getUserProfile(userCredential.user!.uid);
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<UserModel> signup(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Signup failed');
      }

      // Create user document in Firestore with additional fields
      await _createUserDocument(
        uid: userCredential.user!.uid,
        email: email,
        displayName: null,
        photoURL: null,
        provider: 'email',
      );

      // Get full user profile
      return await getUserProfile(userCredential.user!.uid);
    } catch (e) {
      throw Exception('Signup failed: ${e.toString()}');
    }
  }

  Future<UserModel> signInWithGoogle() async {
    try {
      // Trigger the Google Sign In process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google Sign In was cancelled');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw Exception('Google Sign In failed');
      }

      // Check if this is the first time the user is signing in
      final userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();

      if (!userDoc.exists) {
        // If first time, create the user document
        await _createUserDocument(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email!,
          displayName: userCredential.user!.displayName,
          photoURL: userCredential.user!.photoURL,
          provider: 'google',
        );
      } else {
        // Update last login timestamp
        await _updateLastLogin(userCredential.user!.uid);
      }

      // Get full user profile
      return await getUserProfile(userCredential.user!.uid);
    } catch (e) {
      throw Exception('Google Sign In failed: ${e.toString()}');
    }
  }

  Future<void> _createUserDocument({
    required String uid,
    required String email,
    required String provider,
    String? displayName,
    String? photoURL,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': FieldValue.serverTimestamp(),
      'lastLoginAt': FieldValue.serverTimestamp(),
      'provider': provider,
      'isEmailVerified': _firebaseAuth.currentUser?.emailVerified ?? false,
    });
  }

  Future<void> _updateLastLogin(String uid) async {
    await _firestore.collection('users').doc(uid).update({
      'lastLoginAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  // New methods for user profile management
  Future<UserModel> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) {
        throw Exception('User profile not found');
      }

      final data = doc.data()!;
      return UserModel.fromJson({
        'id': doc.id,
        ...data,
      });
    } catch (e) {
      throw Exception('Failed to get user profile: ${e.toString()}');
    }
  }

  Future<UserModel> updateUserProfile({
    required String displayName,
    String? photoURL,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      // Update Firebase Auth profile
      await user.updateDisplayName(displayName);
      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }

      // Update Firestore document
      await _firestore.collection('users').doc(user.uid).update({
        'displayName': displayName,
        if (photoURL != null) 'photoURL': photoURL,
      });

      // Get updated profile
      return await getUserProfile(user.uid);
    } catch (e) {
      throw Exception('Failed to update user profile: ${e.toString()}');
    }
  }

  Future<UserModel> updateEmail(String newEmail) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      // Update Firebase Auth email
      await user.verifyBeforeUpdateEmail(newEmail);

      // Update Firestore document
      await _firestore.collection('users').doc(user.uid).update({
        'email': newEmail,
      });

      // Get updated profile
      return await getUserProfile(user.uid);
    } catch (e) {
      throw Exception('Failed to update email: ${e.toString()}');
    }
  }

  Future<UserModel> updatePassword(String newPassword) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      // Update Firebase Auth password
      await user.updatePassword(newPassword);

      // Get current profile
      return await getUserProfile(user.uid);
    } catch (e) {
      throw Exception('Failed to update password: ${e.toString()}');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send password reset email: ${e.toString()}');
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }
      await user.sendEmailVerification();
    } catch (e) {
      throw Exception('Failed to send email verification: ${e.toString()}');
    }
  }
}
