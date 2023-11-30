// ignore_for_file: constant_identifier_names, non_constant_identifier_names

var this_year = DateTime.now().year.toString();

class AppConfig {
  // static String copyright_text =
  //     "@ KhadBazar " + this_year; //this shows in the splash screen
  // static String app_name = "KhadBazar"; //this shows in the splash screen
  // static String bioactive_code =
  //     "1be68618-7648-4df2-81e6-211294500355"; //enter your purchase code for the app from codecanyon
  // //static String bioactive_code = ""; //enter your purchase code for the app from codecanyon

  //Default language config
  // static String default_language = "en";
  // static String mobile_app_code = "en";
  // static bool app_language_rtl = false;

  //configure this
  // static const bool HTTPS = false;
  static const bool HTTPS = true;

  static const DOMAIN_PATH = ""; //localhost

  //do not configure these below
  static const String API_ENDPATH = "wp-json";
  static const String PROTOCOL = HTTPS ? "https://" : "http://";
  static const String RAW_BASE_URL = "$PROTOCOL$DOMAIN_PATH";
  static const String BASE_URL = "$RAW_BASE_URL/$API_ENDPATH";
  static const String Consumer_Secret =
      '';
  static const String Consumer_Key =
      '';

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}
