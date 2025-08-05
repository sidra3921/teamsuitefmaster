import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/leave_service.dart';
import '../services/attendance_service.dart';

class ApiDemoScreen extends StatefulWidget {
  const ApiDemoScreen({super.key});

  @override
  State<ApiDemoScreen> createState() => _ApiDemoScreenState();
}

class _ApiDemoScreenState extends State<ApiDemoScreen> {
  final ScrollController _scrollController = ScrollController();
  List<String> _logs = [];
  bool _isLoading = false;

  void _addLog(String message) {
    setState(() {
      _logs.add('${DateTime.now().toString().substring(11, 19)}: $message');
    });
    // Auto scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _testGenericApi() async {
    setState(() => _isLoading = true);
    _addLog('Testing Generic API calls...');

    try {
      // Test GET request
      _addLog('GET Request to /posts/1');
      final getResult = await ApiService.get('/posts/1');
      _addLog('GET Result: ${getResult['success'] ? "SUCCESS" : "FAILED"}');
      if (getResult['success']) {
        _addLog('Data: ${getResult['data']['title']}');
      }

      // Test POST request
      _addLog('POST Request to /posts');
      final postResult = await ApiService.post('/posts', {
        'title': 'Test Post from Flutter',
        'body': 'This is a test post',
        'userId': 1,
      });
      _addLog('POST Result: ${postResult['success'] ? "SUCCESS" : "FAILED"}');
      if (postResult['success']) {
        _addLog('Created post ID: ${postResult['data']['id']}');
      }
    } catch (e) {
      _addLog('Error: $e');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _testAuthService() async {
    setState(() => _isLoading = true);
    _addLog('Testing Authentication Service...');

    try {
      _addLog('Attempting login with test@example.com');
      final result = await AuthService.login('test@example.com', 'password123');
      _addLog('Login Result: ${result['success'] ? "SUCCESS" : "FAILED"}');

      if (result['success']) {
        _addLog('User: ${result['data']['user']['name']}');
        _addLog('Email: ${result['data']['user']['email']}');
      } else {
        _addLog('Error: ${result['message']}');
      }

      // Test empty credentials
      _addLog('Testing empty credentials...');
      final emptyResult = await AuthService.login('', '');
      _addLog(
        'Empty Login Result: ${emptyResult['success'] ? "SUCCESS" : "FAILED"}',
      );
      _addLog('Message: ${emptyResult['message']}');
    } catch (e) {
      _addLog('Error: $e');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _testLeaveService() async {
    setState(() => _isLoading = true);
    _addLog('Testing Leave Service...');

    try {
      // Test leave balance
      _addLog('Fetching leave balance...');
      final balanceResult = await LeaveService.getLeaveBalance();
      _addLog(
        'Balance Result: ${balanceResult['success'] ? "SUCCESS" : "FAILED"}',
      );

      if (balanceResult['success']) {
        final data = balanceResult['data'];
        _addLog('Annual Leave: ${data['annual_leave']['remaining']} remaining');
        _addLog('Sick Leave: ${data['sick_leave']['remaining']} remaining');
      }

      // Test leave history
      _addLog('Fetching leave history...');
      final historyResult = await LeaveService.getLeaveHistory();
      _addLog(
        'History Result: ${historyResult['success'] ? "SUCCESS" : "FAILED"}',
      );

      if (historyResult['success']) {
        final leaves = historyResult['data'] as List;
        _addLog('Found ${leaves.length} leave records');
        if (leaves.isNotEmpty) {
          _addLog(
            'Latest: ${leaves.first['type']} - ${leaves.first['status']}',
          );
        }
      }

      // Test leave request submission
      _addLog('Submitting test leave request...');
      final requestResult = await LeaveService.submitLeaveRequest({
        'leave_type': 'Annual Leave',
        'from_date': '2024-02-01',
        'to_date': '2024-02-03',
        'days': 3,
        'reason': 'API Test Leave Request',
      });
      _addLog(
        'Request Result: ${requestResult['success'] ? "SUCCESS" : "FAILED"}',
      );
    } catch (e) {
      _addLog('Error: $e');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _testAttendanceService() async {
    setState(() => _isLoading = true);
    _addLog('Testing Attendance Service...');

    try {
      // Test today's attendance
      _addLog('Fetching today\'s attendance...');
      final todayResult = await AttendanceService.getTodayAttendance();
      _addLog('Today Result: ${todayResult['success'] ? "SUCCESS" : "FAILED"}');

      if (todayResult['success']) {
        final data = todayResult['data'];
        _addLog('Status: ${data['status']}');
        _addLog('Total Hours: ${data['total_hours']}');
      }

      // Test check-in
      _addLog('Testing check-in...');
      final checkInResult = await AttendanceService.markAttendance(
        'check_in',
        DateTime.now(),
      );
      _addLog(
        'Check-in Result: ${checkInResult['success'] ? "SUCCESS" : "FAILED"}',
      );

      // Test attendance history
      _addLog('Fetching attendance history...');
      final historyResult = await AttendanceService.getAttendanceHistory();
      _addLog(
        'History Result: ${historyResult['success'] ? "SUCCESS" : "FAILED"}',
      );

      if (historyResult['success']) {
        final records = historyResult['data'] as List;
        _addLog('Found ${records.length} attendance records');
      }
    } catch (e) {
      _addLog('Error: $e');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _runAllTests() async {
    _logs.clear();
    _addLog('🚀 Starting Complete API Test Suite...');

    await _testGenericApi();
    await Future.delayed(const Duration(seconds: 1));

    await _testAuthService();
    await Future.delayed(const Duration(seconds: 1));

    await _testLeaveService();
    await Future.delayed(const Duration(seconds: 1));

    await _testAttendanceService();

    _addLog('✅ All API tests completed!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Demo & Testing'),
        backgroundColor: const Color.fromARGB(255, 12, 12, 120),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => setState(() => _logs.clear()),
          ),
        ],
      ),
      body: Column(
        children: [
          // Test Buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _testGenericApi,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Generic API'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _testAuthService,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Auth API'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _testLeaveService,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Leave API'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _testAttendanceService,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Attendance API'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _runAllTests,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Icon(Icons.play_arrow),
                    label: Text(
                      _isLoading ? 'Running Tests...' : 'Run All Tests',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 12, 12, 120),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // API Response Logs
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'API Response Logs:',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _logs.isEmpty
                        ? const Center(
                            child: Text(
                              'No logs yet. Run a test to see API responses.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: _logs.length,
                            itemBuilder: (context, index) {
                              final log = _logs[index];
                              Color textColor = Colors.white;

                              if (log.contains('SUCCESS')) {
                                textColor = Colors.green;
                              } else if (log.contains('FAILED') ||
                                  log.contains('Error:')) {
                                textColor = Colors.red;
                              } else if (log.contains('Testing') ||
                                  log.contains('🚀') ||
                                  log.contains('✅')) {
                                textColor = Colors.yellow;
                              } else if (log.contains('Result:')) {
                                textColor = Colors.cyan;
                              }

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: Text(
                                  log,
                                  style: TextStyle(
                                    color: textColor,
                                    fontFamily: 'monospace',
                                    fontSize: 13,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
