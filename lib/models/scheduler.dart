class Scheduler {
  late String id;
  late String day;
  late bool isMorningAvailable = false,
      isAfterNoonAvailable = false,
      isEveningAvailable = false;
  late bool isAvailableToday = false;
  late bool isWholeDayAvailable = false;

  Scheduler(
      {required this.id,
      required this.day,
      required this.isAfterNoonAvailable,
      required this.isMorningAvailable,
      required this.isEveningAvailable}) {
    setOtherValue();
  }

  setOtherValue() {
    if (isAfterNoonAvailable || isEveningAvailable || isMorningAvailable) {
      isAvailableToday = true;
    }
    if (isMorningAvailable && isEveningAvailable && isAfterNoonAvailable) {
      isWholeDayAvailable = true;
    }
  }

  setWholeDayAvailable() {
    isAfterNoonAvailable = true;
    isEveningAvailable = true;
    isMorningAvailable = true;
    isWholeDayAvailable = true;
    isAvailableToday = true;
  }

  setNotAvailableToday(){
    isAfterNoonAvailable = false;
    isEveningAvailable = false;
    isMorningAvailable = false;
    isWholeDayAvailable = false;
    isAvailableToday = false;
  }

  factory Scheduler.fromJson(Map<String, dynamic> json) {
    return Scheduler(
        id: json['id'],
        day: json['day'],
        isAfterNoonAvailable: json['isAfterNoonAvailable'],
        isMorningAvailable: json['isMorningAvailable'],
        isEveningAvailable: json['isEveningAvailable']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "day": day,
      "isAfterNoonAvailable": isAfterNoonAvailable,
      "isMorningAvailable": isMorningAvailable,
      "isEveningAvailable": isEveningAvailable
    };
  }
}
