import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zena_app/utils/app_images/app_images.dart';
import 'package:zena_app/widget/notificaiton_widget/notification_widget.dart';

import '../../core/app_route/app_route.dart';
import '../../utils/app_colors/app_colors.dart';
import '../../utils/app_icons/app_icons.dart';
import '../../widget/app_custom_appbar/app_custom_appbar.dart';
import '../../widget/loading_widget/loading_widget.dart';
import '../../widget/shimmer/app_shimmer.dart';
import 'controller/salon_details_controller.dart';

class SalonDetailsScreen extends StatelessWidget {
  const SalonDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SalonDetailsController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const DetailPageShimmer();
        }

        final salon = controller.salon.value;

        print('salon image==================/${salon.admin.image}');

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //! Header Image
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 300.h,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                          ),
                          child: CommonImage(
                            src: "/${salon.admin.image}",
                            fill: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 50.h,
                          left: 16.w,
                          right: 16.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => Get.back(),
                                child: Container(
                                  width: 40.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE7FEF0),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back_ios_new,
                                    size: 18.sp,
                                    color: AppColor.darkColor,
                                  ),
                                ),
                              ),
                              CommonText(
                                text: "Salon Details".tr,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                textColor: AppColor.darkColor,
                              ),
                              NotificationWidget(),
                            ],
                          ),
                        ),
                        // Rounded top corners for the content below
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 20.h,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //! Salon Name & Subtitle
                          CommonText(
                            text: salon.businessName,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                            textColor: AppColor.darkColor,
                          ),
                          8.height,
                          CommonText(
                            text: salon.businessType,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            textColor: const Color(0xFFE86DAC),
                          ),
                          16.height,
                          CommonText(
                            text: salon.description,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            textColor: AppColor.textColor,
                            maxLines: 4,
                          ),
                          24.height,

                          //! Services Section
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                AppIcons.myVisitIcons,
                                width: 24.w,
                                colorFilter: ColorFilter.mode(
                                  AppColor.textColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                              12.width,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      text: "Services".tr,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                      textColor: AppColor.darkColor,
                                    ),
                                    4.height,
                                    CommonText(
                                      text: salon.service.isNotEmpty
                                          ? salon.service
                                          : "N/A",
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      textColor: const Color(0xFFE86DAC),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 32.h,
                            color: AppColor.textColor.withValues(alpha: 0.2),
                          ),

                          //! Opening Hours Section
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.access_time_filled,
                                color: AppColor.textColor,
                                size: 24.sp,
                              ),
                              12.width,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      text: "Opening Hours".tr,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                      textColor: AppColor.darkColor,
                                    ),
                                    12.height,
                                    Container(
                                      padding: EdgeInsets.all(12.w),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFDE8F3),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: salon.openingTime.isEmpty
                                          ? Center(
                                              child: CommonText(
                                                text:
                                                    "No opening hours available"
                                                        .tr,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                textColor: AppColor.textColor,
                                              ),
                                            )
                                          : Column(
                                              children: salon.openingTime
                                                  .asMap()
                                                  .entries
                                                  .map((entry) {
                                                    final i = entry.key;
                                                    final ot = entry.value;
                                                    return Column(
                                                      children: [
                                                        if (i > 0) 8.height,
                                                        _buildTimeRow(
                                                          ot.day,
                                                          ot.isClosed
                                                              ? "Closed"
                                                              : "${ot.openingTime} - ${ot.closingTime}",
                                                          isClosed: ot.isClosed,
                                                        ),
                                                      ],
                                                    );
                                                  })
                                                  .toList(),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 32.h,
                            color: AppColor.textColor.withValues(alpha: 0.2),
                          ),

                          //! Location Section
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: AppColor.textColor,
                                size: 24.sp,
                              ),
                              12.width,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      text: "Location".tr,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                      textColor: AppColor.darkColor,
                                    ),
                                    4.height,
                                    CommonText(
                                      text: salon.location.isNotEmpty
                                          ? salon.location
                                          : salon.city,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      textColor: AppColor.textColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          12.height,
                          CommonButton(
                            onTap: () {
                              controller.openMap();
                            },
                            buttonWidth: double.infinity,
                            buttonRadius: 12,
                            titleText: "Get Direction".tr,
                            prefix: SvgPicture.asset(AppIcons.getDirection),
                            buttonColor: AppColor.screenBackgroundColor,
                            borderColor: AppColor.textColor,
                          ),
                          // 16.height,
                          // controller.isConfirmVisitLoading.value
                          //     ? LoadingWidget()
                          //     : CommonButton(
                          //         buttonColor: Colors.white,
                          //         borderColor: Colors.black,
                          //         buttonWidth: double.infinity,
                          //         buttonRadius: 12.w,
                          //         titleText: "Visit".tr,
                          //         onTap: () {
                          //           controller.confirmVisit();
                          //         },
                          //       ),
                          24.height,

                          //! Active Points Banner (only when rewards available)
                          if (salon.isRewardAvailable) ...[
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: 16.h,
                                horizontal: 16.w,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF9E6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(
                                    text: "🎁 Rewards Active".tr,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    textColor: AppColor.darkColor,
                                  ),
                                  8.height,
                                  CommonText(
                                    text: "Points & Offers Available".tr,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    textColor: AppColor.textColor,
                                  ),
                                ],
                              ),
                            ),

                            24.height,
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //! Bottom Bar (only when rewards available)
            if (salon.isRewardAvailable)
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText(
                                text: "YOUR POINTS BALANCE".tr,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                textColor: AppColor.textColor,
                              ),
                              4.height,
                              CommonText(
                                text: "${salon.visitor} Points".tr,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                textColor: AppColor.darkColor,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40.h,
                          color: AppColor.secondaryColor.withValues(alpha: 0.2),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CommonText(
                                text: "POINTS REQUIRED".tr,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                textColor: AppColor.textColor,
                              ),
                              4.height,
                              CommonText(
                                text: "${salon.visitor} Points".tr,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                textColor: AppColor.darkColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    16.height,
                    CommonButton(
                      buttonWidth: double.infinity,
                      buttonRadius: 12.w,
                      titleText: "Enjoy Your Reward".tr,
                      buttonColor: AppColor.primaryColor,
                      titleColor: AppColor.darkColor,
                      onTap: () {
                        Get.toNamed(AppRoute.redemNowScreen);
                      },
                    ),
                  ],
                ),
              ),
            16.height,
            controller.salon.value.isVisited
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CommonButton(
                      buttonColor: AppColor.primaryColor,
                      titleColor: AppColor.darkColor,
                      buttonWidth: double.infinity,
                      buttonRadius: 12.w,
                      titleText: "Rate This Salon".tr,
                      prefix: Icon(
                        Icons.star_rate_rounded,
                        color: AppColor.darkColor,
                        size: 20.sp,
                      ),
                      onTap: () {
                        Get.toNamed(
                          AppRoute.ratingScreen,
                          arguments: {
                            'name': salon.businessName,
                            'service': salon.service,
                            'salonId': salon.id,
                          },
                        );
                      },
                    ),
                  )
                : SizedBox(),
            30.height,
          ],
        );
      }),
    );
  }

  Widget _buildTimeRow(String day, String time, {bool isClosed = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          text: day,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          textColor: AppColor.textColor,
        ),
        CommonText(
          text: time,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          textColor: isClosed ? Color(0xFFE86DAC) : AppColor.darkColor,
        ),
      ],
    );
  }
}
