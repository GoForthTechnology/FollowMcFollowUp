/// A Configuration Class that holds the `Google reCAPTCHA v3` API Confidential Information.
class Config {

  /// Prevents from object instantiation.
  Config._();

  /// Holds the 'Site Key' for the `Google reCAPTCHA v3` API .
  static const String siteKey = String.fromEnvironment('RECAPTCHA_SITE_KEY', defaultValue: "");

  /// Holds the 'Secret Key' for the `Google reCAPTCHA v3` API .
  static const String secretKey = String.fromEnvironment('RECAPTCHA_SECRET_KEY', defaultValue: "");

  /// Holds the 'Verfication URL' for the `Google reCAPTCHA v3` API .
  static final verificationURL =
  Uri.parse('https://www.google.com/recaptcha/api/siteverify');
}