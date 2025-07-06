/// Represents the data model for a monthly water consumption record.
class MonthlyWaterConsumptionModel {

  // Fields representing the properties of the model
  String? id;
  String? dateLabel;
  DateTime? startDate;
  DateTime? endDate;
  double? totalConsumption;

  // Default constructor for creating an instance of the model.
  MonthlyWaterConsumptionModel({
    this.id,
    this.dateLabel,
    this.startDate,
    this.endDate,
    this.totalConsumption,
  });

  /// Factory constructor to create a [MonthlyWaterConsumptionModel] instance from a JSON map.
  /// This is typically used when decoding data from an API response.
  factory MonthlyWaterConsumptionModel.fromJson(Map<String, dynamic> json) {
    return MonthlyWaterConsumptionModel(
        // Converts the 'id' from JSON to a string.
        id: json['id'].toString(),
        // Assigns the 'date_label' directly.
        dateLabel: json['date_label'],
        // Safely parses the 'start_date' string into a DateTime object. If null, remains null.
        startDate: json['start_date'] == null
            ? null
            : DateTime.parse(json['start_date']),
        // Safely parses the 'end_date' string into a DateTime object. If null, remains null.
        endDate:
            json['end_date'] == null ? null : DateTime.parse(json['end_date']),
        // Safely parses 'total_consumption' into a double.
        // It handles null values and conversion errors by defaulting to 0.0.
        totalConsumption:
            double.tryParse(json['total_consumption']?.toString() ?? '0.0'));
  }

  /// Converts the [MonthlyWaterConsumptionModel] instance into a JSON map.
  /// This is useful for encoding the data to be sent in an API request.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date_label': dateLabel,
      // Converts the DateTime object to an ISO 8601 string format, handling nulls.
      'start_date': startDate?.toIso8601String(),
      // Converts the DateTime object to an ISO 8601 string format, handling nulls.
      'end_date': endDate?.toIso8601String(),
      'total_consumption': totalConsumption
    };
  }
}