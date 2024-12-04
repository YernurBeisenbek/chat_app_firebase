import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid, // Firebase UID = document ID
          'displayName': user.displayName,
          'email': user.email,
          'photoURL': user.photoURL,
          'lastSignIn': DateTime.now(),
        });
      }

      return user;
    } catch (e) {
      print("Google Sign-In failed: $e");
      return null;
    }
  }

  // Sign out function
  Future<void> signOut() async {
    try {
      await _auth.signOut(); 
      await _googleSignIn.signOut(); 
    } catch (e) {
      print("Sign out failed: $e");
    }
  }
}
