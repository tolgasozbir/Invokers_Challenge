import 'dart:developer';

import 'package:dota2_invoker_game/constants/app_strings.dart';

import 'IFirebaseAuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/app_snackbar.dart';

class FirebaseAuthService implements IFirebaseAuthService {
  FirebaseAuthService._();

  static FirebaseAuthService? _instance;
  static FirebaseAuthService get instance => _instance ??= FirebaseAuthService._();

  final _firebaseAuth = FirebaseAuth.instance;

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  void _errorSnackbar(String error) => AppSnackBar.showSnackBarMessage(
    text: error,
    snackBartype: SnackBarType.error,
  );

  //TODO: ERROR CODES LANG
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return AppStrings.AuthInvalidMail;
      case 'user-not-found':
        return AppStrings.AuthUserNotFound;
      case 'wrong-password':
        return AppStrings.AuthWrongPassword;
      case 'weak-password':
        return AppStrings.AuthWeakPassword;
      case 'email-already-in-use':
        return AppStrings.AuthEmailAlreadyInUse;
      case 'unknown':
        return AppStrings.AuthUnknown;
      case 'too-many-requests':
        return AppStrings.AuthToManyRequests;
      default:
        return AppStrings.AuthDefaultError;
    }
  }

  Future<bool> _handleAsyncAuthOperation(Future<void> Function() operation) async {
    try {
      await operation();
      return true;
    } on FirebaseAuthException catch (error) {
      log(error.code);
      log(_getErrorMessage(error.code));
      _errorSnackbar(_getErrorMessage(error.code));
      return false;
    } catch (error) {
      log(error.toString());
      log(_getErrorMessage(error.toString()));
      _errorSnackbar(_getErrorMessage(error.toString()));
      return false;
    }
  }

  @override
  Future<bool> signIn({required String email, required String password}) async {
    final bool isSuccess = await _handleAsyncAuthOperation(() async {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user == null) throw Exception('Something went wrong, try again!');
    });
    return isSuccess;
  }

  @override
  Future<bool> signUp({required String email, required String password, required String username}) async {
    final bool isSuccess = await _handleAsyncAuthOperation(() async {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user == null) throw Exception('Something went wrong, try again!');
    });
    return isSuccess;
  }

  @override
  Future<bool> resetPassword({required String email}) async {
    return _handleAsyncAuthOperation(() async => _firebaseAuth.sendPasswordResetEmail(email: email));
  }

  @override
  Future<void> signOut() async {
    await _handleAsyncAuthOperation(() async => _firebaseAuth.signOut());
  }

}
