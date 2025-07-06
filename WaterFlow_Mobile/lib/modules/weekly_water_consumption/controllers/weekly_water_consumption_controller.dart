import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:waterflow_mobile/modules/weekly_water_consumption/models/weekly_water_consumption_model.dart';
import 'package:waterflow_mobile/modules/weekly_water_consumption/services/weekly_water_consumption_service.dart';
import 'package:waterflow_mobile/widgets/lines_graph_widget.dart';

// Manages the business logic and state for the weekly water consumption feature.
class WeeklyWaterConsumptionController extends GetxController {
  // Controller for handling pagination and infinite scrolling of the weekly list.
  final PagingController<int, WeeklyWaterConsumptionModel> pagingController =
      PagingController<int, WeeklyWaterConsumptionModel>(firstPageKey: 1);

  // An instance of the service to fetch data from the API.
  final _service = WeeklyWaterConsumptionServices();

  @override
  void onInit() {
    // In the GetX initialization lifecycle, set up the page request listener.
    // This listener triggers the lazyLoad method whenever a new page is needed.
    pagingController.addPageRequestListener((pageKey) {
      lazyLoad(pageKey);
    });
    super.onInit();
  }

  // Fetches daily consumption data for a specific week, processes it, and prepares it for a chart.
  Future<List<ChartPoint>> fetchAndProcessGraphData(String id) async {
    // Call the service to get the raw daily details for the given week ID.
    final details = await _service.detailDaysOnWeekConsumption(id);

    // Use a map to aggregate consumptions by date (e.g., '23/07').
    final Map<String, double> agregatedData = {};

    // Loop through the raw data to populate the aggregation map.
    for (var detail in details) {
      if (detail.date != null && detail.consumption != null) {
        // Format the date to a 'dd/MM' string to use as a key.
        final String formattedDate = DateFormat('dd/MM').format(detail.date!);

        // Add the consumption to the existing value for that day, or initialize it.
        agregatedData[formattedDate] =
            (agregatedData[formattedDate] ?? 0) + detail.consumption!;
      }
    }

    // Convert the aggregated map data into a list of ChartPoint objects.
    final List<ChartPoint> chartPoints = agregatedData.entries.map((entry) {
      return ChartPoint(x: entry.key, y: entry.value);
    }).toList();

    // Sort the points chronologically to ensure the graph is drawn correctly.
    chartPoints.sort((a, b) {
      try {
        // Parse the 'dd/MM' string back to a date for accurate comparison.
        final dateA = DateFormat('dd/MM').parse(a.x);
        final dateB = DateFormat('dd/MM').parse(b.x);
        return dateA.compareTo(dateB);
      } catch (error) {
        // In case of a parsing error, consider them equal.
        return 0;
      }
    });

    return chartPoints;
  }

  // Method responsible for fetching a single page of data for the infinite scroll list.
  Future<void> lazyLoad(int pageKey) async {
    try {
      // Fetches a page of data from the service.
      final response = await _service.listWeeklyWaterConsumption(pageKey,
          showLoading: false);
      // Extracts the list of items and the 'isLastPage' flag from the response.
      final List<WeeklyWaterConsumptionModel> newItems = response['data'] ?? [];
      final bool isLastPage = response['isLastPage'] ?? true;

      if (isLastPage) {
        // If it's the last page, append the items and stop listening for more pages.
        pagingController.appendLastPage(newItems);
      } else {
        // Otherwise, append the new items and set the key for the next page.
        pagingController.appendPage(newItems, pageKey + 1);
      }
    } catch (error) {
      // If an error occurs, update the paging controller with the error information.
      pagingController.error = error;
    }
  }

  @override
  void onClose() {
    // Dispose the PagingController when the GetxController is closed to prevent memory leaks.
    pagingController.dispose();
    super.onClose();
  }
}
