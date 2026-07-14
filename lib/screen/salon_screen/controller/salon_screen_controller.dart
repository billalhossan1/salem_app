import 'package:core_kit/core_kit.dart';
import 'package:core_kit/network/request_input.dart';
import 'package:get/get.dart';
import '../../../core/api_endpoints/api_endpoints.dart';
import '../../../core/models/lat_long.dart';
import '../../../core/services/location_controller.dart';
import '../model/salon_item_model.dart';

class SalonScreenController extends GetxController {
  var selectedTab = "Nearest".obs;
  RxBool isLoading = false.obs;
  Debouncer debouncer = Debouncer(milliseconds: 300);
  String search = '';
  RxList<SalonItemModel> allSalonList = <SalonItemModel>[].obs;
  Rx<LatLong> currentLocation = LatLong(lat: 0, long: 0).obs;

  bool _isFetching = false;

  void onSearch(String value) {
    debouncer.run(() {
      allSalonList.clear();
      allSalonList.refresh();
      search = value;
      getSalonList();
    });
  }

  void selectTab(String tab) {
    selectedTab.value = tab;
  }

  @override
  void onInit() {
    super.onInit();
    _initial();
  }

  Future<void> _initial() async {
    // Wait for location before any API call
    await LocationController.instance.ready;
    currentLocation.value = LocationController.instance.currentLocation.value;
    getSalonList();
  }

  Future<void> getSalonList({int page = 1}) async {
    // Prevent duplicate concurrent calls (e.g. SmartListLoader + _initial both firing)
    if (_isFetching && page == 1) return;
    _isFetching = true;

    currentLocation.value = LocationController.instance.currentLocation.value;
    page == 1 ? allSalonList.clear() : null;
    page == 1 ? isLoading.value = true : null;
    final response = await DioService.instance.request(
      input: RequestInput(
        endpoint: ApiEndpoints.salonList,
        method: .GET,
        queryParams: {
          'lat1': currentLocation.value.lat,
          'lon1': currentLocation.value.long,
          if (search.isNotEmpty) 'searchTerm': search,
          'page': page,
          'limit': 10,
        },
      ),
      responseBuilder: (data) {
        final list = (data as List<dynamic>)
            .map((e) => SalonItemModel.fromJson(e))
            .toList();
        allSalonList.addAll(list);
      },
    );
    isLoading.value = false;
    _isFetching = false;

    if (response.isSuccess) {
    } else {
      showSnackBar(response.message ?? '', type: SnackBarType.error);
    }
  }
}
