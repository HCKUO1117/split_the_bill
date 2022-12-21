// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Members`
  String get members {
    return Intl.message(
      'Members',
      name: 'members',
      desc: '',
      args: [],
    );
  }

  /// `Groups`
  String get groups {
    return Intl.message(
      'Groups',
      name: 'groups',
      desc: '',
      args: [],
    );
  }

  /// `Add new member`
  String get addMember {
    return Intl.message(
      'Add new member',
      name: 'addMember',
      desc: '',
      args: [],
    );
  }

  /// `Add Group`
  String get addGroup {
    return Intl.message(
      'Add Group',
      name: 'addGroup',
      desc: '',
      args: [],
    );
  }

  /// `Add Event`
  String get addEvent {
    return Intl.message(
      'Add Event',
      name: 'addEvent',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get more {
    return Intl.message(
      'More',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `login`
  String get login {
    return Intl.message(
      'login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `mailbox`
  String get email {
    return Intl.message(
      'mailbox',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `password`
  String get password {
    return Intl.message(
      'password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Guest Login`
  String get guestLogin {
    return Intl.message(
      'Guest Login',
      name: 'guestLogin',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `No account`
  String get noAccount {
    return Intl.message(
      'No account',
      name: 'noAccount',
      desc: '',
      args: [],
    );
  }

  /// `Please click here`
  String get clickHere {
    return Intl.message(
      'Please click here',
      name: 'clickHere',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get or {
    return Intl.message(
      'or',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password`
  String get forgetPassword {
    return Intl.message(
      'Forgot password',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `We will send a password reset email to your email address, please reset your password and then login again.`
  String get sendResetEmailInfo {
    return Intl.message(
      'We will send a password reset email to your email address, please reset your password and then login again.',
      name: 'sendResetEmailInfo',
      desc: '',
      args: [],
    );
  }

  /// `Didn't receive the Email? Please check your spam folder first, if you still haven't received the Email, please click Resend.`
  String get notGetMailInfo {
    return Intl.message(
      'Didn\'t receive the Email? Please check your spam folder first, if you still haven\'t received the Email, please click Resend.',
      name: 'notGetMailInfo',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get resend {
    return Intl.message(
      'Resend',
      name: 'resend',
      desc: '',
      args: [],
    );
  }

  /// `User does not exist`
  String get userNotFound {
    return Intl.message(
      'User does not exist',
      name: 'userNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Email format error`
  String get invalidEmail {
    return Intl.message(
      'Email format error',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Unknown Error`
  String get unknownError {
    return Intl.message(
      'Unknown Error',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `Sent successfully!`
  String get sendSuccess {
    return Intl.message(
      'Sent successfully!',
      name: 'sendSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Use your mailbox to register without any verification. Please make sure you enter the correct mailbox, which will be used to receive invitations and retrieve passwords.`
  String get signUpInfo {
    return Intl.message(
      'Use your mailbox to register without any verification. Please make sure you enter the correct mailbox, which will be used to receive invitations and retrieve passwords.',
      name: 'signUpInfo',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
