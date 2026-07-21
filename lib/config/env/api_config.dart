import 'package:resturent_billinng_app/config/env/environment.dart';

class AppUrl {
  static String baseUrl = EnvironmentConfig.baseUrl;

  static String addManager = "${baseUrl}add-manager";
  static String getManager = "${baseUrl}get-manager";
  static String addSite = "${baseUrl}add-site";
  static String getSites = "${baseUrl}get-sites";
  static String addStaff = "${baseUrl}add-staff";
  static String getStaff = "${baseUrl}get-staff";
  static String updateStaff = "${baseUrl}update-staff";
  static String addAttendance = "${baseUrl}add-attendance";
  static String getAttendance = "${baseUrl}get-attendance";
  static String addAttendanceBulk = "${baseUrl}add-attendance/bulk";
  static String getAttendanceBulk = "${baseUrl}get-attendance/bulk";
  static String addAmount = "${baseUrl}add-amount";
  static String getAmount = "${baseUrl}get-amount";
  static String updateAmount = "${baseUrl}update-amount";
  static String deleteAmount = "${baseUrl}delete-amount";
}
