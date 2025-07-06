class WeeksOnTheMonthModel {
  DateTime? startDate;
  DateTime? endDate;
  double? consumption;

  WeeksOnTheMonthModel({this.startDate, this.endDate, this.consumption});

  factory WeeksOnTheMonthModel.fromJson(Map<String, dynamic> json) {
    return WeeksOnTheMonthModel(
      consumption: double.tryParse(json['consumption']?.toString() ?? '0.0'),
      startDate: json['start_date'] == null ? null : DateTime.parse(json['start_date']),
      endDate: json['end_date'] == null ? null : DateTime.parse(json['end_date']),  
    );
  }
}
