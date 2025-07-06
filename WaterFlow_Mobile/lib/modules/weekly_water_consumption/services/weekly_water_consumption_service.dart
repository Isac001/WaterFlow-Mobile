import 'package:dio/dio.dart';
import 'package:waterflow_mobile/modules/weekly_water_consumption/models/days_on_week_model.dart';
import 'package:waterflow_mobile/modules/weekly_water_consumption/models/weekly_water_consumption_model.dart';
import 'package:waterflow_mobile/project_configs/dio_config.dart';

// This service class handles all API requests related to weekly water consumption.
class WeeklyWaterConsumptionServices {
  // The base URL for the API, loaded from environment variables for configuration.
  final String baseUrl = const String.fromEnvironment('BASEURL');

  // The specific endpoint for weekly water consumption resources.
  final String endPoint = 'weekly_water_consumption/';

  // Fetches a paginated list of weekly water consumption records.
  Future<Map<String, dynamic>> listWeeklyWaterConsumption(int pageKey,
      {showLoading = false}) async {
    try {
      // Makes the GET request to the paginated endpoint.
      final response = await DioConfig(showLoading: showLoading)
          .dio
          .get('$baseUrl$endPoint?page=$pageKey');

      // Check for a successful response status code.
      if (response.statusCode == 200) {
        // Extract the list of results from the response data.
        final List<dynamic> results = response.data['results'] ?? [];

        // Map the raw JSON items to a list of WeeklyWaterConsumptionModel objects.
        final List<WeeklyWaterConsumptionModel> weeklyConsumptionList =
            results.map((item) {
          return WeeklyWaterConsumptionModel.fromJson(item);
        }).toList();

        // Determine if this is the last page by checking if the 'next' URL is null.
        final bool isLastPage = response.data['next'] == null;

        // Return a map containing the processed list and pagination flag.
        return {'isLastPage': isLastPage, 'data': weeklyConsumptionList};
      } else {
        // If the request was not successful, return the server's error response.
        return Future.error(response.data);
      }
    } on DioException catch (error) {
      // Catches Dio-specific errors, like network issues or non-2xx responses.
      if (error.response != null) {
        // If the error has a response body from the server, return it.
        return Future.error(error.response!.data);
      } else {
        // Otherwise, return the generic Dio error.
        return Future.error(error);
      }
    }
  }

  // Fetches the daily consumption details for a specific week by its ID.
  Future<List<DaysOnWeekModel>> detailDaysOnWeekConsumption(String id) async {
    try {
      // API call to the detail endpoint (e.g., /weekly_water_consumption/some-id/).
      final response =
          await DioConfig(showLoading: false).dio.get('$baseUrl$endPoint$id/');

      // Check for a successful response.
      if (response.statusCode == 200) {
        // Extract the list of daily data from the response.
        final List<dynamic> daysOnWeekResults = response.data ?? [];
        // Map the raw JSON items to a list of DaysOnWeekModel objects.
        final List<DaysOnWeekModel> dailyDetails =
            daysOnWeekResults.map((item) {
          return DaysOnWeekModel.fromJson(item);
        }).toList();
        return dailyDetails;
      } else {
        // If the response code is not 200, return an error.
        return Future.error(response.data);
      }
    } on DioException catch (error) {
      // For Dio-specific errors, throw a formatted exception with status code.
      throw Exception(
          'Falha ao carregar detalhes: Status ${error.response!.statusCode}');
    } catch (e) {
      // For other errors (like parsing), throw a generic exception.
      throw Exception('Erro ao processar dados: ${e.toString()}');
    }
  }
}
