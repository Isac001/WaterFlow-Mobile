/// Represents the data model for a single week's (or sub-period's) consumption within a month.
class WeeksOnTheMonthModel {

  // Fields
  DateTime? startDate;
  DateTime? endDate;
  double? consumption;

  /// Default constructor to create an instance of the model.
  WeeksOnTheMonthModel({this.startDate, this.endDate, this.consumption});

  /// Factory constructor to create a [WeeksOnTheMonthModel] instance from a JSON map.
  /// This is used to deserialize data received from an API.
  factory WeeksOnTheMonthModel.fromJson(Map<String, dynamic> json) {
    return WeeksOnTheMonthModel(
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