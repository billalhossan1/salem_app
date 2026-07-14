class RewardHistoryModel {
  final String user;
  final String userId;
  final String rewardId;
  final String lastView;
  final String salonName;
  final String serviceName;
  final String location;
  final int totalPoint;
  final String status;
  final int everyVisitCoins;
  final List<String> services;

  const RewardHistoryModel({
    this.user = '',
    this.userId = '',
    this.rewardId = '',
    this.lastView = '',
    this.salonName = '',
    this.location = '',
    this.totalPoint = 0,
    this.status = '',
    this.serviceName = '',
    this.everyVisitCoins = 0,
    this.services = const [],
  });

  factory RewardHistoryModel.fromJson(Map<String, dynamic> json) {
    return RewardHistoryModel(
      user: json['user'] ?? '',
      userId: json['userId'] ?? '',
      rewardId: json['rewardId'] ?? '',
      lastView: json['lastView'] ?? '',
      salonName: json['salonName'] ?? '',
      location: json['location'] ?? '',
      totalPoint: json['totalPoint'] ?? 0,
      status: json['status'] ?? '',
      serviceName: json['serviceName'] ?? '',
      everyVisitCoins: json['everyVisitCoins'] ?? 0,
      services: json['services'] == null
          ? []
          : List<String>.from(json['services']!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'userId': userId,
      'rewardId': rewardId,
      'lastView': lastView,
      'salonName': salonName,
      'location': location,
      'totalPoint': totalPoint,
      'status': status,
      'everyVisitCoins': everyVisitCoins,
      'services': List<dynamic>.from(services.map((x) => x)),
    };
  }

  RewardHistoryModel copyWith({
    String? user,
    String? userId,
    String? rewardId,
    String? lastView,
    String? salonName,
    String? location,
    int? totalPoint,
    String? status,
    int? everyVisitCoins,
    List<String>? services,
  }) {
    return RewardHistoryModel(
      user: user ?? this.user,
      userId: userId ?? this.userId,
      rewardId: rewardId ?? this.rewardId,
      lastView: lastView ?? this.lastView,
      salonName: salonName ?? this.salonName,
      location: location ?? this.location,
      totalPoint: totalPoint ?? this.totalPoint,
      status: status ?? this.status,
      everyVisitCoins: everyVisitCoins ?? this.everyVisitCoins,
      services: services?? this.services
    );
  }
}
