import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:waterflow_mobile/modules/bimonthly_water_consumption/models/bimonthly_water_consumption_models.dart';
import 'package:waterflow_mobile/modules/bimonthly_water_consumption/models/months_on_the_bimonthly_models.dart';
import 'package:waterflow_mobile/modules/bimonthly_water_consumption/services/bimonthly_water_consumption_services.dart';
import 'package:waterflow_mobile/widgets/lines_graph_widget.dart';

/// Manages the state and business logic for the bimonthly water consumption screen.
class BimonthlyWaterConsumptionController extends GetxController {
  /// Controller to manage the state of the paginated list of bimonthly periods.
  final PagingController<int, BimonthlyWaterConsumptionModel> pagingController =
      PagingController<int, BimonthlyWaterConsumptionModel>(firstPageKey: 1);

  /// Instance of the service class to handle API requests.
  final _serivce = BimonthlyWaterConsumptionServices();

  /// Called when the controller is initialized.
  @override
  void onInit() {
    // Adds a listener that calls lazyLoad whenever a new page is requested.
    pagingController.addPageRequestListener((pageKey) {
      lazyLoad(pageKey);
    });
    super.onInit();
  }

  /// Fetches detailed monthly data for a given bimonthly period ID and processes it into a list of [ChartPoint] for graphing.
  Future<List<ChartPoint>> fetchAndProcessGraphData(String id) async {
    // 1. Fetch the raw data from the API.
    final List<MonthsOnTheBimonthlyModel> monthlyDetails =
        await _serivce.detailMonthsOnBimonthlyConsumption(id);

    // 2. Map each monthly detail record directly to a ChartPoint.
    final List<ChartPoint> chartPoints = monthlyDetails
        .map((detail) {
          // Ensure that the data is not null before processing.
          if (detail.startDate == null ||
              detail.endDate == null ||
              detail.consumption == null) {
            return null; // Return null to be filtered out later.
          }

          // Format the dates for the X-axis label. In this case, we can use the month name.
          final String labelX = DateFormat('MM/yyyy', 'pt_BR').format(detail.startDate!);

          // Create the chart point.
          return ChartPoint(x: labelX, y: detail.consumption!);
        })
        .where((point) => point != null)
        .cast<ChartPoint>()
        .toList(); // Filter out any resulting null values.

    // The data is assumed to be sorted by the API.
    return chartPoints;
  }

  /// Fetches a page of data for the infinite scroll list.
  Future<void> lazyLoad(int pageKey) async {
    try {
      // Make the API call to get the list of bimonthly consumptions for the given page.
      final response = await _serivce.listBimonthlyWaterConsumption(pageKey,
          showLoading: false);

      // Extract the list of new items and whether this is the last page from the response.
      final List<BimonthlyWaterConsumptionModel> newItems =
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

  /// Called when the controller is removed from memory.
  @override
  void onClose() {
    // Dispose of the paging controller to free up resources.
    pagingController.dispose();
    super.onClose();
  }
}