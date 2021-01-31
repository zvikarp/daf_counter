import 'package:daf_plus_plus/enums/AccountProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _firebaseUser;

  Future<void> _signinWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final credential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode);
    return credential;
  }

  Future<GoogleAuthCredential> _signinWithGoogle() async {
    GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return credential;
  }

  Future<dynamic> _getCredential(AccountProvider provider) async {
    if (provider == AccountProvider.GOOGLE) {
      return await _signinWithGoogle();
    } else if (provider == AccountProvider.APPLE) {
      return await _signinWithApple();
    }
  }

  Future<String> signin(AccountProvider provider) async {
    try {
      dynamic credential = await _getCredential(provider);
      try {
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        User user = userCredential.user;
        if (user != null) {
          _firebaseUser = user;
          return user.uid;
        }
      } catch (e) {
        try {
          _auth.signOut();
        } catch (e) {}
      }
    } catch (e) {}
    return null;
  }

  Future<String> getUserId() async {
    if (_firebaseUser != null)
      return _firebaseUser.uid;
    else {
      refreshUser();
      return _firebaseUser?.uid;
    }
  }

  Future<bool> isAuthed() async {
    String userId = await getUserId();
    return userId != null;
  }

  Future<bool> signOut() async {
    await FirebaseAuth.instance.signOut();
    await _auth.signOut();
    _firebaseUser = null;
    return true;
  }

  User refreshUser() {
    User user = _auth.currentUser;
    _firebaseUser = user;
    return user;
  }
}

final AuthService authService = AuthService();
