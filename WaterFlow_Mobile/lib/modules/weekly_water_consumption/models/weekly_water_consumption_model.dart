// Represents the data model for a single weekly water consumption record.
class WeeklyWaterConsumptionModel {
  // Fields
  String? id;
  String? dateLabel;
  DateTime? startDate;
  DateTime? endDate;
  double? totalConsumption;

  // Standard constructor to create an instance of the model.
  WeeklyWaterConsumptionModel({
    this.id,
    this.dateLabel,
    this.startDate,
    this.endDate,
    this.totalConsumption,
  });

  // Factory constructor for creating a model instance from a map (e.g., a JSON object).
  factory WeeklyWaterConsumptionModel.fromJson(Map<String, dynamic> json) {
    return WeeklyWaterConsumptionModel(
      id: json['id']?.toString(),
      dateLabel: json['date_label'],
      // Safely parse date strings into DateTime objects, allowing for nulls.
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(
              json['start_date'],
            ),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(
              json['end_date'],
            ),
      // Use tryParse to safely convert the consumption value to a double.
      totalConsumption:
          double.tryParse(json['total_consumption']?.toString() ?? '0.0'),
    );
  }

  // Converts the model instance into a map, suitable for JSON encoding.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date_label': dateLabel,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'total_consumption': totalConsumption,
    };
  }
}