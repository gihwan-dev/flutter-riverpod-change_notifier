import 'package:notifier_provider/models/activity.dart';
import 'package:notifier_provider/pages/enum_activity/enum_activity_state.dart';
import 'package:notifier_provider/providers/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'enum_activity_provider.g.dart';

@riverpod
class EnumActivity extends _$EnumActivity {
  int _errorCounter = 0;

  @override
  EnumActivityState build() {
    ref.onDispose(() {
      print('[enumActivity provider] disposed');
    });
    print('hashCode: $hashCode');
    return EnumActivityState.initial();
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
