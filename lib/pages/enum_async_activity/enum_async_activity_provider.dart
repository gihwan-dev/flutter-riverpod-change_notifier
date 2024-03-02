import 'package:notifier_provider/models/activity.dart';
import 'package:notifier_provider/pages/enum_async_activity/enum_async_activity_state.dart';
import 'package:notifier_provider/providers/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'enum_async_activity_provider.g.dart';

@riverpod
class EnumAsyncActivity extends _$EnumAsyncActivity {
  int _errorCounter = 0;

  EnumAsyncActivity() {
    print('[EnumAsyncActivity] constructor called');
  }

  @override
  EnumAsyncActivityState build() {
    print('numAsyncActivity provider initialized');
    ref.onDispose(() {
      print('[enumAsyncActivity provider] disposed');
    });
    print('hashCode: $hashCode');
    state = EnumAsyncActivityState.initial();
    fetchActivity(activityTypes[0]);
    return EnumAsyncActivityState.initial();
  }

  Future<void> fetchActivity(String activityType) async {
    print('hashCode in fetchActivity function: $hashCode');

    state = state.copyWith(status: ActivityStatus.loading);

    try {
      print('_errorCounter: $_errorCounter');

      if (_errorCounter++ % 2 != 1) {
        await Future.delayed(const Duration(microseconds: 500));
        throw 'Fail to fetch activity';
      }

      final response = await ref.read(dioProvider).get('?type=$activityType');

      final activity = Activity.fromJson(response.data);

      state = state.copyWith(
        status: ActivityStatus.success,
        activity: activity,
      );
    } catch (e) {
      state =
          state.copyWith(status: ActivityStatus.failure, error: e.toString());
    }
  }
}
