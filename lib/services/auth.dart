import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _firebaseUser;

  Future<String> loginWithGoogle() async {
    try {
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
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
    await _googleSignIn.signOut();
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
