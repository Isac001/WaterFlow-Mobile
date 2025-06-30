// DailyWaterConsumptionModel class
class DailyWaterConsumptionModel {

  // Fields
  String? id;
  String? dateLabel;
  DateTime? dateOfRegister;
  double? totalConsumption;

  DailyWaterConsumptionModel({
    this.id,
    this.dateLabel,
    this.dateOfRegister,
    this.totalConsumption,
  });

  // Factory method to create a DailyWaterConsumptionModel object
  factory DailyWaterConsumptionModel.fromJson(Map<String, dynamic> json) {
    return DailyWaterConsumptionModel(
      id: json['id']?.toString(),
      dateLabel: json['date_label'],
      dateOfRegister: json['date_of_register'] == null
          ? null
          : DateTime.tryParse(json['date_of_register']),
      totalConsumption:
          double.tryParse(json['total_consumption']?.toString() ?? '0.0'),
    );
  }

  // Method to convert a DailyWaterConsumptionModel object to a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date_label': dateLabel,
      'date_of_register': dateOfRegister?.toIso8601String(),
      'total_consumption': totalConsumption,
    };
  }
}
