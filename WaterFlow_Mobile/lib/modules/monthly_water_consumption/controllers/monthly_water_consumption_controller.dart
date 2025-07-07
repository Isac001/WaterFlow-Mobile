import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:waterflow_mobile/modules/monthly_water_consumption/models/monthly_water_consumption_model.dart';
import 'package:waterflow_mobile/modules/monthly_water_consumption/models/weeks_on_the_month_model.dart';
import 'package:waterflow_mobile/modules/monthly_water_consumption/services/monthly_water_consumption_services.dart';
import 'package:waterflow_mobile/widgets/lines_graph_widget.dart';

// Manages the state and business logic for the monthly water consumption screen.
class MonthlyWaterConsumptionController extends GetxController {
  // Controller to manage the state of the paginated list of months.
  final PagingController<int, MonthlyWaterConsumptionModel> pagingController =
      PagingController<int, MonthlyWaterConsumptionModel>(firstPageKey: 1);

  // Instance of the service class to handle API requests.
  final _serivce = MonthlyWaterConsumptionServices();

  // Called when the controller is initialized.
  @override
  void onInit() {
    // Adds a listener that calls lazyLoad whenever a new page is requested.
    pagingController.addPageRequestListener((pageKey) {
      lazyLoad(pageKey);
    });
    super.onInit();
  }

  /// Fetches detailed weekly data for a given month ID and processes it into a list of [ChartPoint] for graphing.
  Future<List<ChartPoint>> fetchAndProcessGraphData(String id) async {
    // 1. Fetch the raw data from the API.
    final List<WeeksOnTheMonthModel> weeklyDetails =
        await _serivce.detailWeeksOnMonthConsumption(id);

    // 2. Map each weekly detail record directly to a ChartPoint.
    final List<ChartPoint> chartPoints = weeklyDetails
        .map((detail) {
          // Ensure that the data is not null before processing.
          if (detail.startDate == null ||
              detail.endDate == null ||
              detail.consumption == null) {
            return null; // Return null to be filtered out later.
          }

          // Format the dates for the X-axis label.
          final String startDateFormatted =
              DateFormat('dd/MM').format(detail.startDate!);
          final String endDateFormatted =
              DateFormat('dd/MM').format(detail.endDate!);

          String labelX;

          // Create a clear label: "dd/MM" if it's a single day, or "dd/MM - dd/MM" for a range.
          if (startDateFormatted == endDateFormatted) {
            labelX = startDateFormatted;
          } else {
            labelX = '$startDateFormatted - $endDateFormatted';
          }

          // Create the chart point.
          return ChartPoint(x: labelX, y: detail.consumption!);
        })
        .where((point) => point != null)
        .cast<ChartPoint>()
        .toList(); // Filter out any resulting null values.

    // Since the API already returns the data sorted by date, no additional sorting is necessary.
    return chartPoints;
  }

  /// Fetches a page of data for the infinite scroll list.
  Future<void> lazyLoad(int pageKey) async {
    try {
      // Make the API call to get the list of monthly consumptions for the given page.
      final response = await _serivce.listMonthlyWaterConsumption(pageKey,
          showLoading: false);

      // Extract the list of new items and whether this is the last page from the response.
      final List<MonthlyWaterConsumptionModel> newItems =
          response['data'] ?? [];
      final bool isLastPage = response['isLastPage'] ?? true;

      // If it's the last page, append the items and stop listening for new pages.
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        // Otherwise, append the new items and set the key for the next page.
        pagingController.appendPage(newItems, pageKey + 1);
      }
    } catch (error) {
      // If an error occurs, update the controller with the error information.
      pagingController.error = error;
    }
  }

  // Called when the controller is removed from memory.
  @override
  void onClose() {
    // Dispose of the paging controller to free up resources.
    pagingController.dispose();
    super.onClose();
  }
}
