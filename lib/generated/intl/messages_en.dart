// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addEvent": MessageLookupByLibrary.simpleMessage("Add Event"),
        "addGroup": MessageLookupByLibrary.simpleMessage("Add Group"),
        "addMember": MessageLookupByLibrary.simpleMessage("Add new member"),
        "clickHere": MessageLookupByLibrary.simpleMessage("Please click here"),
        "email": MessageLookupByLibrary.simpleMessage("mailbox"),
        "forgetPassword":
            MessageLookupByLibrary.simpleMessage("Forgot password"),
        "groups": MessageLookupByLibrary.simpleMessage("Groups"),
        "guestLogin": MessageLookupByLibrary.simpleMessage("Guest Login"),
        "invalidEmail":
            MessageLookupByLibrary.simpleMessage("Email format error"),
        "login": MessageLookupByLibrary.simpleMessage("login"),
        "members": MessageLookupByLibrary.simpleMessage("Members"),
        "more": MessageLookupByLibrary.simpleMessage("More"),
        "noAccount": MessageLookupByLibrary.simpleMessage("No account"),
        "notGetMailInfo": MessageLookupByLibrary.simpleMessage(
            "Didn\'t receive the Email? Please check your spam folder first, if you still haven\'t received the Email, please click Resend."),
        "or": MessageLookupByLibrary.simpleMessage("or"),
        "password": MessageLookupByLibrary.simpleMessage("password"),
        "resend": MessageLookupByLibrary.simpleMessage("Resend"),
        "send": MessageLookupByLibrary.simpleMessage("Send"),
        "sendResetEmailInfo": MessageLookupByLibrary.simpleMessage(
            "We will send a password reset email to your email address, please reset your password and then login again."),
        "sendSuccess":
            MessageLookupByLibrary.simpleMessage("Sent successfully!"),
        "signUp": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "signUpInfo": MessageLookupByLibrary.simpleMessage(
            "Use your mailbox to register without any verification. Please make sure you enter the correct mailbox, which will be used to receive invitations and retrieve passwords."),
        "unknownError": MessageLookupByLibrary.simpleMessage("Unknown Error"),
        "userNotFound":
            MessageLookupByLibrary.simpleMessage("User does not exist")
      };
}
