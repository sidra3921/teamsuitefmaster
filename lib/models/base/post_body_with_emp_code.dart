/// A request body that includes an employee code
class PostBodyWithEmpCode {
  final String spName;
  final Map<String, dynamic> parameters;

  PostBodyWithEmpCode({
    required this.spName,
    required String empCode,
    Map<String, dynamic>? additionalParams,
  }) : parameters = {
         'empCode': empCode,
         if (additionalParams != null) ...additionalParams,
       };

  Map<String, dynamic> toJson() {
    return {'spName': spName, 'parameters': parameters};
  }
}
