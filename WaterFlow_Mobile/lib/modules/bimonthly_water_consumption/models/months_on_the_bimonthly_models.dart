/// Represents the data model for a single month's consumption within a bimonthly period.
class MonthsOnTheBimonthlyModel {
  
  // Fields
  DateTime? startDate;
  DateTime? endDate;
  double? consumption;

  /// Default constructor to create an instance of the model.
  MonthsOnTheBimonthlyModel({this.startDate, this.endDate, this.consumption});

  /// Factory constructor to create a [MonthsOnTheBimonthlyModel] instance from a JSON map.
  /// This is used to deserialize data received from an API.
  factory MonthsOnTheBimonthlyModel.fromJson(Map<String, dynamic> json) {
    return MonthsOnTheBimonthlyModel(
      // Safely parses the 'consumption' value into a double.
      // It handles nulls and conversion errors by defaulting to '0.0'.
      consumption: double.tryParse(json['consumption']?.toString() ?? '0.0'),
      
      // Safely parses the 'start_date' string into a DateTime object, remaining null if the source is null.
      startDate: json['start_date'] == null ? null : DateTime.parse(json['start_date']),

      // Safely parses the 'end_date' string into a DateTime object, remaining null if the source is null.
      endDate: json['end_date'] == null ? null : DateTime.parse(json['end_date']),  
    );
  }
}