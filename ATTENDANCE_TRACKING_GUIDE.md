# Attendance Tracking in TeamSuite

## Overview

The attendance tracking system in TeamSuite allows employees to:
1. Mark attendance (check-in and check-out)
2. View today's attendance status
3. View attendance history

This guide explains how attendance data is stored and synchronized between different views.

## Attendance Marking Process

When a user marks attendance, the following happens:

1. **Check-in**:
   - The check-in time is recorded
   - Today's attendance record is updated
   - The attendance history is updated

2. **Check-out**:
   - The check-out time is recorded
   - Hours worked are calculated
   - Both today's attendance and history are updated

## Implementation Details

### 1. Marking Attendance

```dart
final result = await AttendanceService.markAttendance('check_in', DateTime.now());
```

This saves the attendance record and ensures that:
- The time is correctly formatted
- The status is updated to "Present"
- The record appears in both today's view and history

### 2. Viewing Today's Attendance

```dart
final todayRecord = await AttendanceService.getTodayAttendance();
```

This returns the current day's attendance with:
- Check-in time (if marked)
- Check-out time (if marked)
- Hours worked (calculated if both check-in and check-out are available)
- Attendance status

### 3. Viewing Attendance History

```dart
final history = await AttendanceService.getAttendanceHistory();
```

Returns a list of attendance records including:
- Past attendance dates
- Check-in and check-out times
- Hours worked
- Attendance status

## Data Persistence

In mock mode, attendance data is stored in memory:
- `_todayAttendance`: Stores current day's attendance record
- `_attendanceHistory`: Stores the attendance history list

In production mode, data is fetched from and saved to the backend API via stored procedures:
- `POST_MARK_ATTENDANCE`: Saves attendance records
- `GET_TODAYS_ATTENDANCE`: Retrieves today's attendance
- `GET_EMP_ATTENDANCE`: Retrieves attendance history

## Key Features

1. **Real-time Updates**: When attendance is marked, all views are automatically updated
2. **Synchronized Views**: Today's attendance appears in both today's view and history
3. **Time Tracking**: Both check-in and check-out times are tracked and hours calculated
4. **Status Management**: Attendance status is automatically set based on check-in/check-out

## Testing

Run the attendance tests with:

```bash
flutter test test/api_test.dart
```

The tests verify that:
1. Marking attendance works correctly
2. Today's attendance is updated after marking
3. Check-in and check-out times are recorded
4. Data is persisted between API calls

## Common Issues

If attendance is not appearing in the overview:
1. Ensure `AppConfig.useMockMode` is set correctly
2. Check that attendance is being marked with the correct type ('check_in' or 'check_out')
3. Verify that the date formatting matches between marking and viewing
