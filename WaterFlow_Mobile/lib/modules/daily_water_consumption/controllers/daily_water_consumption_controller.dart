import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:waterflow_mobile/modules/daily_water_consumption/models/daily_water_consumption_models.dart';
import 'package:waterflow_mobile/modules/daily_water_consumption/services/daily_water_consumption_services.dart';

// Controller class to de manage the daily water consumption
class DailyWaterConsumptionController extends GetxController {
  // Paging controller to list the water consumption
  final PagingController<int, DailyWaterConsumptionModel> pagingController =
      PagingController<int, DailyWaterConsumptionModel>(firstPageKey: 1);

  // Method to initialize the controller
  @override
  void onInit() {
    // The listener to the paging controller
    pagingController.addPageRequestListener((pageKey) {
      lazyLoad(pageKey);
    });
    super.onInit();
  }

  // Lazy load method
  Future<void> lazyLoad(int pageKey) async {
    try {
      // 1: First the call to the list endpoint in API
      final response = await DailyWaterConsumptionServices()
          .listDailyWaterConsumption(pageKey, showLoading: false);

      // 2: Get the data from the response
      final List<DailyWaterConsumptionModel> newItems = response['data'] ?? [];

      // 3: Check if is the last page
      final bool isLastPage = response['isLastPage'] ?? true;

      // 4: If is the last page, add the data to the pagging controller
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        // 5: If is not the last page, add the data to the pagging controller
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  // Refresh Method
  Future<void> refreshList() async {
    // Refresh the list
    return Future.sync(() => pagingController.refresh());
  }

  // Close the controller
  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }
}
