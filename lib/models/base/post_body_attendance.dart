/// A request body that is used for attendance marking
class PostBodyAttendance {
  final String spName;
  final Map<String, dynamic> parameters;

  PostBodyAttendance({
    required this.spName,
    required String empCode,
    required String type,
    required double latitude,
    required double longitude,
    String? locationName,
    Map<String, dynamic>? additionalParams,
  }) : parameters = {
         'empCode': empCode,
         'type': type,
         'latitude': latitude,
         'longitude': longitude,
         'locationName': locationName ?? 'Unknown',
         if (additionalParams != null) ...additionalParams,
       };

  Map<String, dynamic> toJson() {
    return {'spName': spName, 'parameters': parameters};
  }
}
