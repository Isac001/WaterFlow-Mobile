// import 'package:dio/dio.dart';
// import 'package:waterflow_mobile/modules/daily_water_consumption/models/daily_water_consumption_models.dart';
// import 'package:waterflow_mobile/project_configs/dio_config.dart';

// class DailyWaterConsumptionService {
//   // Base Url
//   final String baseUrl = const String.fromEnvironment('BASEURL');

//   // Endpoint
//   final String listEndpoint = 'daily_water_consumption/';

//   // List View
//   Future<Map<String, dynamic>> listDailyWaterConsumption(int pageKey,
//       {bool showLoading = false}) async {
//     try {
//       var response = await DioConfig(showLoading: showLoading)
//           .dio
//           .get('$baseUrl$listEndpoint?page=$pageKey');

//       if (response.statusCode == 200) {
//         final List<dynamic> results = response.data['results'] ?? [];

//         if (results.isEmpty) {}

//         final List<DailyWaterConsumptionModel> consumptionList =
//             results.map((item) {
//           return DailyWaterConsumptionModel.fromJson(item);
//         }).toList();

//         final bool isLastPage = response.data['next'] == null;

//         return {
//           'isLastPage': isLastPage,
//           'data': consumptionList,
//         };
//       } else {
//         return Future.error(response.data);
//       }
//     } on DioException catch (error) {
//       if (error.response != null) {
//         return Future.error(error.response!.data);
//       } else {
//         return Future.error(error);
//       }
//     }
//   }
// }

// Class to de manage the daily water consumption API requests
import 'package:dio/dio.dart';
import 'package:waterflow_mobile/modules/daily_water_consumption/models/daily_water_consumption_models.dart';
import 'package:waterflow_mobile/project_configs/dio_config.dart';

class DailyWaterConsumptionServices {
  // Base Url
  final String baseUrl = const String.fromEnvironment('BASEURL');

  // Endpoint
  final String listEndpoint = 'daily_water_consumption/';

  // Daily Water Consumption List Endpoint
  Future<Map<String, dynamic>> listDailyWaterConsumption(int pageKey,
      {bool showLoading = false}) async {
    try {
      // 1: Dio request
      final response = await DioConfig(showLoading: showLoading)
          .dio
          .get('$baseUrl$listEndpoint?page=$pageKey');

      // 2: Check if the request was successful
      if (response.statusCode == 200) {
        // 3: Catch the data from the response
        final List<dynamic> results = response.data['results'] ?? [];

        // 4: Transform the json data in a DailyWaterConsumptionModel object
        final List<DailyWaterConsumptionModel> comsumptionList =
            results.map((item) {
          return DailyWaterConsumptionModel.fromJson(item);
        }).toList();

        // 5: Check if the request is the last page
        final bool isLastPage = response.data['next'] == null;

        // 6: Return the data
        return {'isLastPage': isLastPage, 'data': comsumptionList};
      } else {
        return Future.error(response.data);
      }

      // 7: Dio-level exception capture
    } on DioException catch (error) {
      if (error.response != null) {
        return Future.error(error.response!.data);
      } else {
        return Future.error(error);
      }
    }
  }
}
