import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginController extends GetxController {
  var _googleSignin = GoogleSignIn();
  var googleAccount = Rx<GoogleSignInAccount?>(null);
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  login() async {
    try {
      final googleUser = await _googleSignin.signIn();
      if (googleUser == null) {
        return; // The user canceled the sign-in
      }
      googleAccount.value = googleUser;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // Check if user exists in Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          // Save new user info to Firestore
          await _firestore.collection('users').doc(user.uid).set({
            'uid': userCredential.user!.uid,
            'displayName': user.displayName,
            'email': user.email,
            'photoURL': user.photoURL,
            'steps': 0, // Initialize steps only for new users
            'timestamp':
                FieldValue.serverTimestamp(), // Set the initial timestamp
          });
        }
      }
    } catch (e) {
      print('Login error: $e');
    }
  }

  logout() async {
    await _googleSignin.signOut();
    googleAccount.value = null;
    Get.offAllNamed('/user_info');
  }
}
