import 'package:flutter_test/flutter_test.dart';
import 'package:teamsuitefmaster/services/api_constants.dart';

void main() {
  test('URL Construction Test', () {
    const baseUrl = "http://api.faastdemo.com";
    const endpoint = "Api/Common/ExecSp";

    // Correct way to build URL (with slash)
    final correctUrl = Uri.parse("$baseUrl/$endpoint");
    expect(
      correctUrl.toString(),
      equals("http://api.faastdemo.com/Api/Common/ExecSp"),
    );

    // Wrong way (without slash)
    final wrongUrl = Uri.parse("$baseUrl$endpoint");
    expect(
      wrongUrl.toString(),
      equals("http://api.faastdemo.comapi/Common/ExecSp"),
      reason: "The string matches with case-insensitivity",
    );

    // Verify our constants
    expect(ApiConstants.baseUrl, equals("http://api.faastdemo.com"));
    expect(ApiConstants.commonExecSp, equals("Api/Common/ExecSp"));

    // Test buildUrl method
    expect(
      ApiConstants.buildUrl(baseUrl, endpoint),
      equals("http://api.faastdemo.com/Api/Common/ExecSp"),
    );

    // Test buildUrl with extra slashes
    expect(
      ApiConstants.buildUrl("http://api.faastdemo.com/", "/Api/Common/ExecSp"),
      equals("http://api.faastdemo.com/Api/Common/ExecSp"),
    );

    // Test buildUrl with double slashes
    expect(
      ApiConstants.buildUrl("http://api.faastdemo.com/", "//Api/Common/ExecSp"),
      equals("http://api.faastdemo.com/Api/Common/ExecSp"),
    );
  });
}
