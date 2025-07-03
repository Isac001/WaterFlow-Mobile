// Represents the data model for a single day's consumption within a week.
class DaysOnWeekModel {
  // The amount of water consumed on this day.
  double? consumption;
  // The specific date of the consumption record.
  DateTime? date;

  // Standard constructor to create an instance of the model.
  DaysOnWeekModel({this.consumption, this.date});

  // Factory constructor for creating a model instance from a map (e.g., a JSON object).
  factory DaysOnWeekModel.fromJson(Map<String, dynamic> json) {
    return DaysOnWeekModel(
    
      // Safely parse the consumption value to a double, defaulting to 0.0 if null or invalid.
      consumption: double.tryParse(json['consumption']?.toString() ?? '0.0') ?? 0.0,

      // Parse the date string into a DateTime object, allowing for nulls.
      date: json['date'] == null ? null : DateTime.parse(json['date']),
    );
  }
}