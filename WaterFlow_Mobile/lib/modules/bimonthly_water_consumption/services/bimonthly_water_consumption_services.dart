import 'package:dio/dio.dart';
import 'package:waterflow_mobile/modules/bimonthly_water_consumption/models/bimonthly_water_consumption_models.dart';
import 'package:waterflow_mobile/modules/bimonthly_water_consumption/models/months_on_the_bimonthly_models.dart';
import 'package:waterflow_mobile/project_configs/dio_config.dart';

/// This service class handles all API requests related to bimonthly water consumption.
class BimonthlyWaterConsumptionServices {
  // The base URL for the API, loaded from environment variables for configuration flexibility.
  final String baseUrl = const String.fromEnvironment('BASEURL');

  // The specific API endpoint for bimonthly water consumption resources.
  final String endPoint = 'bimonthly_water_consumption/';

  /// Fetches a paginated list of bimonthly consumption records.
  ///
  /// [pageKey] is the page number to fetch.
  /// [showLoading] determines if a global loading indicator should be shown.
  /// Returns a Map containing the list of data and a boolean indicating if it's the last page.
  Future<Map<String, dynamic>> listBimonthlyWaterConsumption(int pageKey,
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

        // Map the raw JSON list to a list of BimonthlyWaterConsumptionModel objects.
        final List<BimonthlyWaterConsumptionModel> bimonthlyConsumptionList =
            results.map((item) {
          return BimonthlyWaterConsumptionModel.fromJson(item);
        }).toList();

        // Determine if this is the last page by checking if the 'next' URL is null.
        final bool isLastPage = response.data['next'] == null;

        // Return the processed data and pagination info.
        return {'isLastPage': isLastPage, 'data': bimonthlyConsumptionList};
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

  /// Fetches the detailed monthly consumption breakdown for a specific bimonthly period.
  ///
  /// [id] is the unique identifier of the bimonthly period to fetch details for.
  /// Returns a list of [MonthsOnTheBimonthlyModel].
  Future<List<MonthsOnTheBimonthlyModel>> detailMonthsOnBimonthlyConsumption(
      String id) async {
    try {
      // Performs a GET request to the detail endpoint (e.g., /bimonthly_water_consumption/123/).
      final response =
          await DioConfig(showLoading: false).dio.get('$baseUrl$endPoint$id/');

      // Check for a successful response.
      if (response.statusCode == 200) {
        // The response data is expected to be a list of monthly details.
        final List<dynamic> monthsOnBimonthlyResults = response.data ?? [];

        // Map the raw JSON list to a list of MonthsOnTheBimonthlyModel objects.
        final List<MonthsOnTheBimonthlyModel> monthlyDetails =
            monthsOnBimonthlyResults.map((item) {
          return MonthsOnTheBimonthlyModel.fromJson(item);
        }).toList();

        return monthlyDetails;
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