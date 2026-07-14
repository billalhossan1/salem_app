String _domain = "https://api.zenaapp.net";
// String _domain = "http://10.10.26.208:4000";
final String _baseUrl = "$_domain/api/v1";

class ApiEndpoints {
  ApiEndpoints._();
  static String get baseUrl => _baseUrl;
  static String get domain => _domain;
  static const String refreshToken = "";

  static final String sendOtp = "/user/send-otp";
  static final String login = "/user";
  static final String getRewards = "/salon-reward";
  static final String socketUrl = "/salon-reward";
  static final String getUserCoin = "/user/coins";
  static final String globalReward = "/salon-reward/global-reward";
  static final String getAllTiar = "/rule/tire";
  static final String getUsedReward = "/reward/used";
  static final String getActiveRewards = "/reward/active";
  static final String getRewardHistory = "/salon-reward/purchase-view-history";
  static final String getUserRewardHistory =
      "/salon-reward/purchase-reward-history";
  static final String visitSalon = "/salon/visit-confirm";
  static final String redeemNow = "/salon-reward/claim";
  static final String salonList = "/salon";
  static final String getProfile = "/user/details";
  static final String updateProfile = "/user";
  static final String getAllNotification = "/notification";
  static final String notificationCount = "/notification/count";
  static final String updateNotification = "/user";
  static final String rating = "/salon/rating";
}
