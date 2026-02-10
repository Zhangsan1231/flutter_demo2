class MyGoalClass {
  int step;
  List<int> bloodPressure;
  BloodGlucoseSub bloodGlucose;
  List<int> reminders;

  MyGoalClass({
    this.step = 0,
    List<int>? bloodPressure,
    BloodGlucoseSub? bloodGlucose,
    List<int>? reminders,
  })  : bloodPressure = bloodPressure ?? [],
        reminders = reminders ?? [],
        bloodGlucose = bloodGlucose ?? BloodGlucoseSub();

  // 添加序列化方法
  Map<String, dynamic> toJson() => {
        'step': step,
        'blood_pressure': bloodPressure,
        'blood_glucose': bloodGlucose.toJson(),
        'reminder': reminders,
      };

  // 添加反序列化工厂方法
  factory MyGoalClass.fromJson(Map<String, dynamic> json) {
    return MyGoalClass(
      step: _safeGetInt(json['step']) ?? 0,
      bloodPressure: _parseIntList(json['blood_pressure']),
      bloodGlucose: BloodGlucoseSub.fromJson(json['blood_glucose'] ?? null), // 空对象保护
      reminders: _parseIntList(json['reminder']),
    );
  }

  static int? _safeGetInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    return null;
  }

  static List<int> _parseIntList(dynamic data) {
    if (data is List)
      return data.whereType<num>().map((e) => e.toInt()).toList();
    return [];
  }

  String toString() {
    return "step: $step, bloodPressure: $bloodPressure, bloodGlucose: $bloodGlucose, reminders: $reminders";
  }
}

class BloodGlucoseSub {
  GlucoseSub wakeUp;
  GlucoseSub breakfast;
  GlucoseSub lunch;
  GlucoseSub dinner;
  GlucoseSub bedtime;
  GlucoseSub midnight;

  BloodGlucoseSub({
    GlucoseSub? wakeUp,
    GlucoseSub? breakfast,
    GlucoseSub? lunch,
    GlucoseSub? dinner,
    GlucoseSub? bedtime,
    GlucoseSub? midnight,
  })  : wakeUp = wakeUp ?? GlucoseSub(),
        breakfast = breakfast ?? GlucoseSub(),
        lunch = lunch ?? GlucoseSub(),
        dinner = dinner ?? GlucoseSub(),
        bedtime = bedtime ?? GlucoseSub(),
        midnight = midnight ?? GlucoseSub();

  Map<String, dynamic> toJson() => {
        'wakeUp': wakeUp.toJson(),
        'breakfast': breakfast.toJson(),
        'lunch': lunch.toJson(),
        'dinner': dinner.toJson(),
        'bedtime': bedtime.toJson(),
        'midnight': midnight.toJson(),
      };

  factory BloodGlucoseSub.fromJson(Map<String, dynamic> json) {
    return BloodGlucoseSub(
      wakeUp: _parseSub(json['wakeUp']),
      breakfast: _parseSub(json['breakfast']),
      lunch: _parseSub(json['lunch']),
      dinner: _parseSub(json['dinner']),
      bedtime: _parseSub(json['bedtime']),
      midnight: _parseSub(json['midnight']),
    );
  }
  static GlucoseSub _parseSub(dynamic data) {
    if (data is Map<String, dynamic>) {
      return GlucoseSub.fromJson(data);
    }
    return GlucoseSub(); // 返回空对象
  }
}

class GlucoseSub {
  List<String> timeRange;
  List<int> values;

  GlucoseSub({
    List<String>? timeRange,
    List<int>? values,
  })  : timeRange = timeRange ?? [],
        values = values ?? [];

  Map<String, dynamic> toJson() => {
        'time_range': timeRange,
        'values': values,
      };

  factory GlucoseSub.fromJson(Map<String, dynamic> json) {
    return GlucoseSub(
      timeRange: _parseTimeRange(json['time_range']),
      values: _parseValues(json['values']),
    );
  }
  static List<String> _parseTimeRange(dynamic data) {
    if (data is List) return data.whereType<String>().toList();
    return [];
  }

  static List<int> _parseValues(dynamic data) {
    if (data is List)
      return data.whereType<num>().map((e) => e.toInt()).toList();
    return [];
  }
}