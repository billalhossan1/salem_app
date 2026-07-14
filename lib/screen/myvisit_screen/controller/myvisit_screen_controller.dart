import 'dart:async';
import 'package:core_kit/core_kit.dart';
import 'package:core_kit/network/request_input.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:zena_app/screen/myvisit_screen/model/tiar_model.dart';
import 'package:zena_app/screen/myvisit_screen/model/user_rewards_model.dart';
import 'package:zena_app/screen/myvisit_screen/model/visit_history_model.dart';
import 'package:zena_app/screen/profile_screen/controller/profile_screen_controller.dart';
import 'package:zena_app/screen/rewards_screen/controller/rewards_screen_controller.dart';

import '../../../core/api_endpoints/api_endpoints.dart';
import '../model/active_rewards_model.dart';

class VisitModel {
  final String salonName;
  final String date;
  final String service;
  final String status;
  final String points;

  VisitModel({
    required this.salonName,
    required this.date,
    required this.service,
    required this.status,
    required this.points,
  });
}

class MyvisitScreenController extends GetxController {
  var searchText = ''.obs;
  var isDateAscending = false.obs;

  RxList<TiarModel> tiarList = <TiarModel>[].obs;
  final RxList<Purchases> activeRewards = <Purchases>[].obs;
  final RxList<UserRewardsModel> userRewardsList = <UserRewardsModel>[].obs;
  RxBool isTiarLoading = false.obs;
  RxBool isCurrentRewardsLoading = false.obs;
  RxBool isCurrentRewardsLoadDone = false.obs;
  RxBool isUserRewardsLoading = false.obs;
  RxBool isUserRewardsLoadDone = false.obs;
  RxList<RewardHistoryModel> rewardHistoryList = <RewardHistoryModel>[].obs;
  // ── Visit filter state ─────────────────────────────────────────────
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final RxString selectedStatus = ''.obs;

  static const int _limit = 10;
  int get limit => _limit;

  @override
  void onInit() {
    getAllTiar();
    getAllCurrentRewards(1);
    getUserRewards(1);

    super.onInit();
  }

  Future<void> getAllCurrentRewards(int page) async {
    if (isCurrentRewardsLoading.value || isCurrentRewardsLoadDone.value) return;
    isCurrentRewardsLoading.value = true;

    final response = await DioService.instance.request(
      input: RequestInput(
        endpoint: ApiEndpoints.getActiveRewards,
        method: .GET,
        queryParams: {'page': page, 'limit': _limit},
      ),
      responseBuilder: (data) {
        final list = (data['purchases'] as List<dynamic>)
            .map((e) => Purchases.fromJson(e))
            .toList();
        if (page == 1) {
          activeRewards.assignAll(list);
        } else {
          activeRewards.addAll(list);
        }
        if (list.length < _limit) isCurrentRewardsLoadDone.value = true;
      },
    );

    isCurrentRewardsLoading.value = false;
    if (!response.isSuccess) {
      showSnackBar(response.message ?? '', type: SnackBarType.error);
    }
  }

  Future<void> getAllVisit(int page) async {
    isUserRewardsLoading.value = true;
    await DioService.instance.request(
      input: RequestInput(
        endpoint: '/visit',
        method: .GET,
        queryParams: {'page': page},
        // queryParams: {"userId": userId},
      ),
      responseBuilder: (data) {
        final list = (data['data'] as List<dynamic>)
            .map((e) => RewardHistoryModel.fromJson(e))
            .toList();
        if (page == 1) {
          rewardHistoryList.assignAll(list);
        } else {
          rewardHistoryList.addAll(list);
        }
      },
    );
    isUserRewardsLoading.value = false;
  }

  Future<void> getUserRewards(int page) async {
    getAllVisit(page);

    if (isUserRewardsLoading.value || isUserRewardsLoadDone.value) return;
    isUserRewardsLoading.value = true;

    final Map<String, dynamic> params = {'page': page, 'limit': _limit};
    if (selectedDate.value != null) {
      final d = selectedDate.value!;
      params['date'] =
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    }
    if (selectedStatus.value.isNotEmpty) {
      params['status'] = selectedStatus.value;
    }
    if (searchText.value.isNotEmpty) {
      params['searchTerm'] = searchText.value;
    }

    final response = await DioService.instance.request(
      input: RequestInput(
        endpoint: ApiEndpoints.getUserRewardHistory,
        method: .GET,
        queryParams: params,
      ),
      responseBuilder: (data) {
        final list = (data['Reward'] as List<dynamic>)
            .map((e) => UserRewardsModel.fromJson(e))
            .toList();
        if (page == 1) {
          userRewardsList.assignAll(list);
        } else {
          userRewardsList.addAll(list);
        }
        if (list.length < _limit) isUserRewardsLoadDone.value = true;
      },
    );

    isUserRewardsLoading.value = false;
    if (!response.isSuccess) {
      showSnackBar(response.message ?? '', type: SnackBarType.error);
    }
  }

  void clearVisitFilters() {
    selectedDate.value = null;
    selectedStatus.value = '';
    searchText.value = '';
    onUserRewardsRefresh();
  }

  void onUserRewardsRefresh() {
    isUserRewardsLoadDone.value = false;
    userRewardsList.clear();
    rewardHistoryList.clear();
    getAllVisit(1);
    getUserRewards(1);
  }

  void onUserRewardsLoadMore(int page) {
    getUserRewards(page);
    getAllVisit(page);
  }

  void onCurrentRewardRefresh() {
    isCurrentRewardsLoadDone.value = false;
    activeRewards.clear();
    getAllCurrentRewards(1);
    getAllVisit(1);
  }

  void onCurrentRewardLoadMore(int page) => getAllCurrentRewards(page);

  Timer? _searchDebounce;

  void updateSearchText(String value) {
    searchText.value = value;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 600), () {
      onUserRewardsRefresh();
    });
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    super.onClose();
  }

  void toggleDateSort() {
    isDateAscending.value = !isDateAscending.value;
  }

  List<TiarModel> get sortedTiers =>
      [...tiarList]..sort((a, b) => a.tireCoins.compareTo(b.tireCoins));

  int getTargetCoins(int coins) {
    final tiers = sortedTiers;
    if (tiers.isEmpty) return 400;
    for (final t in tiers) {
      if (coins < t.tireCoins) return t.tireCoins;
    }
    return tiers.last.tireCoins;
  }

  double calculateTierProgress(int coins) {
    final tiers = sortedTiers;
    if (tiers.isEmpty) return (coins / 400).clamp(0.0, 1.0);

    TiarModel? cur;
    for (final t in tiers) {
      if (coins >= t.tireCoins) cur = t;
    }

    TiarModel? next;
    for (final t in tiers) {
      if (coins < t.tireCoins) {
        next = t;
        break;
      }
    }

    if (next == null) return 1.0;
    final base = cur?.tireCoins ?? 0;
    final range = next.tireCoins - base;
    if (range <= 0) return 1.0;
    return ((coins - base) / range).clamp(0.0, 1.0);
  }

  Future<void> getAllTiar() async {
    isTiarLoading.value = true;
    await DioService.instance.request(
      input: RequestInput(endpoint: ApiEndpoints.getAllTiar, method: .GET),
      responseBuilder: (data) {
        final list = (data as List<dynamic>)
            .map((item) => TiarModel.fromJson(item))
            .toList();
        tiarList.assignAll(list);
       print("first tiar name ${ tiarList[0].tireName}");
      },
    );
    isTiarLoading.value = false;
  }

  /// The tier whose tireCoins the user has already reached.
  TiarModel? get currentTier {
    final coins = rewardsController?.userCoin.value ?? 0;
    TiarModel? matched;
    for (final t in tiarList) {
      if (coins >= t.tireCoins) matched = t;
    }
    return matched;
  }

  /// The next tier above the current one, if any.
  TiarModel? get nextTier {
    final coins = rewardsController?.userCoin.value ?? 0;
    for (final t in tiarList) {
      if (coins < t.tireCoins) return t;
    }
    return null;
  }

  /// Progress fraction (0.0 – 1.0) toward the next tier.
  double get tierProgress {
    final coins = rewardsController?.userCoin.value ?? 0;
    final next = nextTier;
    final cur = currentTier;
    if (next == null) return 1.0; // max tier reached
    final base = cur?.tireCoins ?? 0;
    final range = next.tireCoins - base;
    if (range <= 0) return 1.0;
    return ((coins - base) / range).clamp(0.0, 1.0);
  }

  RewardsScreenController? get rewardsController {
    try {
      return Get.find<RewardsScreenController>();
    } catch (_) {
      return null;
    }
  }

  DateTime _parseDate(String dateStr) {
    // Format: "Jan 12, 2025"
    try {
      final parts = dateStr.split(' ');
      if (parts.length != 3) return DateTime.now();

      final monthStr = parts[0];
      final day = int.tryParse(parts[1].replaceAll(',', '')) ?? 1;
      final year = int.tryParse(parts[2]) ?? 2025;

      int month = 1;
      const months = {
        'Jan': 1,
        'Feb': 2,
        'Mar': 3,
        'Apr': 4,
        'May': 5,
        'Jun': 6,
        'Jul': 7,
        'Aug': 8,
        'Sep': 9,
        'Oct': 10,
        'Nov': 11,
        'Dec': 12,
      };

      month = months[monthStr] ?? 1;

      return DateTime(year, month, day);
    } catch (e) {
      return DateTime.now();
    }
  }
}
