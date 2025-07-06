import 'package:dio/dio.dart';
import 'package:waterflow_mobile/modules/monthly_water_consumption/models/monthly_water_consumption_model.dart';
import 'package:waterflow_mobile/modules/monthly_water_consumption/models/weeks_on_the_month_model.dart';
import 'package:waterflow_mobile/project_configs/dio_config.dart';

/// This service class handles all API requests related to monthly water consumption.
class MonthlyWaterConsumptionServices {
  // The base URL for the API, loaded from environment variables for configuration flexibility.
  final String baseUrl = const String.fromEnvironment('BASEURL');

  // The specific API endpoint for monthly water consumption resources.
  final String endPoint = 'monthly_water_consumption/';

  /// Fetches a paginated list of monthly consumption records.
  ///
  /// [pageKey] is the page number to fetch.
  /// [showLoading] determines if a global loading indicator should be shown.
  /// Returns a Map containing the list of data and a boolean indicating if it's the last page.
  Future<Map<String, dynamic>> listWeeklyWaterConsumption(int pageKey,
      {bool showLoading = false}) async {
    try {
      // Performs a GET request using the configured Dio instance.
      final response = await DioConfig(showLoading: showLoading)
          .dio
          .get('$baseUrl$endPoint?page=$pageKey');

      // Check if the request was successful.
      if (response.statusCode == 200) {
        // Safely extract the list of results from the response data.
        final List<dynamic> results = response.data['results'] ?? [];
        
        // Map the raw JSON list to a list of MonthlyWaterConsumptionModel objects.
        final List<MonthlyWaterConsumptionModel> monthlyConsumptionList =
            results.map((item) {
          return MonthlyWaterConsumptionModel.fromJson(item);
        }).toList();

        // Determine if this is the last page by checking if the 'next' URL is null.
        final bool isLastPage = response.data['next'] == null;

        // Return the processed data and pagination info.
        return {'isLastPage': isLastPage, 'data': monthlyConsumptionList};
      } else {
        // If the status code is not 200, throw an error with the response data.
        return Future.error(response.data);
      }
    } on DioException catch (error) {
      // Handle Dio-specific exceptions (e.g., network errors, timeouts).
      if (error.response != null) {
        // If the error includes a response from the server, return its data.
        return Future.error(error.response!.data);
      } else {
        // If there's no response (e.g., connection error), return the generic error.
        return Future.error(error);
      }
    }
  }

  /// Fetches the detailed weekly consumption breakdown for a specific month.
  ///
  /// [id] is the unique identifier of the month to fetch details for.
  /// Returns a list of [WeeksOnTheMonthModel].
  Future<List<WeeksOnTheMonthModel>> detailWeeksOnMonthConsumption(
      String id) async {
    try {
      // Performs a GET request to the detail endpoint (e.g., /monthly_water_consumption/123/).
      final response =
         await  DioConfig(showLoading: false).dio.get('$baseUrl$endPoint$id/');

      // Check for a successful response.
      if (response.statusCode == 200) {
        // The response data is expected to be a list of weekly details.
        final List<dynamic> weeksOnMonthResults = response.data ?? [];

        // Map the raw JSON list to a list of WeeksOnTheMonthModel objects.
        final List<WeeksOnTheMonthModel> weeklyDetais =
            weeksOnMonthResults.map((item) {
          return WeeksOnTheMonthModel.fromJson(item);
        }).toList();

        return weeklyDetais;
      } else {
        // If the status code is not 200, throw an error.
        return Future.error(response.data);
      }
    } on DioException catch (error) {
      // Handle Dio-specific exceptions consistently.
      if (error.response != null) {
        return Future.error(error.response!.data);
      } else {
        return Future.error(error);
      }
    }
  }
}