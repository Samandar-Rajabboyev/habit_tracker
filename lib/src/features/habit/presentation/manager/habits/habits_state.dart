part of 'habits_cubit.dart';

class HabitsState {
  final List<Habit> habits;
  final bool isLoading;
  final bool hasError;
  final String errorMessage;

  HabitsState({
    this.habits = const [],
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage = 'Some Error',
  });

  HabitsState copyWith({
    List<Habit>? habits,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
  }) =>
      HabitsState(
          habits: habits ?? this.habits,
          isLoading: isLoading ?? false,
          hasError: hasError ?? false,
          errorMessage: errorMessage ?? this.errorMessage);
}
