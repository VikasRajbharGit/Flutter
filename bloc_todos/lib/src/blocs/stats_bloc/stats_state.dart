part of 'stats_bloc.dart';

abstract class StatsState extends Equatable {
  const StatsState();
  @override
  List<Object> get props => [];
}

class StatsLoading extends StatsState {}

class StatsLoaded extends StatsState{
  final int numActive;
  final int numCompleted;

  StatsLoaded(this.numActive, this.numCompleted);

  @override
  List<Object> get props => [numActive, numCompleted];

  @override
  String toString() {
    return 'StatsLoadSuccess { numActive: $numActive, numCompleted: $numCompleted }';
  }
}

class StatsError extends StatsState{
  final String error;
  StatsError({this.error});
}