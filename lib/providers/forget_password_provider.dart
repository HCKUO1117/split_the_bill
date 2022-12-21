import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/utils/show_snack.dart';

enum ForgetPasswordStatus {
  unSend,
  sending,
  isSend,
}

class ForgetPasswordProvider extends ChangeNotifier {
  ForgetPasswordStatus status = ForgetPasswordStatus.unSend;
  String? errorText;

  Future<void> resetPassword(BuildContext context, {required String email}) async {
    if(email.isEmpty){
      errorText = S.of(context).invalidEmail;
      notifyListeners();
      return;
    }
    status = ForgetPasswordStatus.sending;
    notifyListeners();

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      status = ForgetPasswordStatus.isSend;
      ShowSnack.show(context, content: S.of(context).sendSuccess);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          errorText = S.of(context).userNotFound;
          break;
        case 'invalid-email':
          errorText = S.of(context).invalidEmail;
          break;
        case 'missing-email':
          errorText = 'missing-email';
          break;
        default:
          errorText = e.code;
      }

      status = ForgetPasswordStatus.unSend;
      notifyListeners();
    }
  }
}
