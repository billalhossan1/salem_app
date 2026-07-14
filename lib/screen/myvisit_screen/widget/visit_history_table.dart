import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zena_app/screen/myvisit_screen/controller/myvisit_screen_controller.dart';
import 'package:zena_app/screen/myvisit_screen/model/user_rewards_model.dart';
import 'package:zena_app/screen/myvisit_screen/model/visit_history_model.dart';
import 'package:zena_app/utils/app_colors/app_colors.dart';

/// Reusable paginated visit-history table.
/// Uses [SmartListLoader] to handle loading, empty-state, and infinite-scroll.
class VisitHistoryTable extends StatelessWidget {
  const VisitHistoryTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyvisitScreenController>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        shadows: const [
          BoxShadow(
            color: Color(0x113A3A3A),
            blurRadius: 16,
            offset: Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Table header ────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE7FEF0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _THead(text: "Salon Name".tr, align: TextAlign.start),
                _THead(text: "Date".tr, align: TextAlign.center),
                _THead(text: "Service".tr, align: TextAlign.center),
                _THead(text: "Status".tr, align: TextAlign.center),
                _THead(text: "Points".tr, align: TextAlign.end),
              ],
            ),
          ),
          12.height,

          // ── Paginated rows ───────────────────────────────────────
          Obx(
            () => SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: SmartListLoader(
                isLoading: controller.isUserRewardsLoading.value,
                // isLoadDone: controller.isUserRewardsLoadDone.value,
                itemCount: controller.rewardHistoryList.length,
                onRefresh: controller.onUserRewardsRefresh,
                onLoadMore: controller.onUserRewardsLoadMore,
                itemBuilder: (context, index) {
                  final item = controller.rewardHistoryList[index];
                  return _VisitRow(item: item);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Table header cell ────────────────────────────────────────────────────────
class _THead extends StatelessWidget {
  final String text;
  final TextAlign align;
  const _THead({required this.text, required this.align});

  @override
  Widget build(BuildContext context) => Expanded(
    flex: 2,
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: Color(0xFF333333),
      ),
      textAlign: align,
    ),
  );
}

// ─── Single data row ──────────────────────────────────────────────────────────
class _VisitRow extends StatelessWidget {
  final RewardHistoryModel item;
  const _VisitRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            children: [
              // Salon Name
              Expanded(
                flex: 2,
                child: Text(
                  item.salonName.isNotEmpty ? item.salonName : '—',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Date
              Expanded(
                flex: 2,
                child: Text(
                  formatDate(item.lastView),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6E6E6E),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Service
              Expanded(
                flex: 2,
                child: Text(
                  item.services.isNotEmpty
                      ? "${item.services.first} ${item.services.length > 1 ? "+${item.services.length - 1}" : ""}"
                      : '—',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6E6E6E),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Status
              Expanded(
                flex: 2,
                child: Text(
                  item.status.isNotEmpty ? item.status.tr : '—',
                  style: TextStyle(
                    fontSize: 11,
                    color: item.status.toLowerCase() == 'pending'
                        ? Colors.orange
                        : const Color(0xFF6E6E6E),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Points
              Expanded(
                flex: 2,
                child: Text(
                  '${item.everyVisitCoins} PTS'.tr,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColor.successColor,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
        const Divider(color: Color(0xFFEEEEEE), height: 1),
      ],
    );
  }
}

// ── Date formatter ────────────────────────────────────────────────────────────
String formatDate(String raw) {
  if (raw.isEmpty) return '—';
  try {
    final dt = DateTime.parse(raw);
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  } catch (_) {
    return raw;
  }
}
