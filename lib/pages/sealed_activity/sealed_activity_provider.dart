import 'package:notifier_provider/models/activity.dart';
import 'package:notifier_provider/pages/sealed_activity/sealed_activity_state.dart';
import 'package:notifier_provider/providers/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sealed_activity_provider.g.dart';

@riverpod
class SealedActivity extends _$SealedActivity {
  int _errorCounter = 0;

  @override
  SealedActivityState build() {
    ref.onDispose(() {
      print('[sealedActivity provider] disposed');
    });
    print('hashCode: $hashCode');
    return const SealedActivityInitial();
  }

  Future<void> fetchActivity(String activityType) async {
    print('hashCode in fetchActivity function: $hashCode');

    state = const SealedActivityLoading();

    try {
      print('_errorCounter: $_errorCounter');

      if (_errorCounter++ % 2 != 1) {
        await Future.delayed(const Duration(microseconds: 500));
        throw 'Fail to fetch activity';
      }

      final response = await ref.read(dioProvider).get('?type=$activityType');

      final activity = Activity.fromJson(response.data);

      state = SealedActivitySuccess(activity: activity);
    } catch (e) {
      state = SealedActivityFailure(error: e.toString());
    }
  }
}
