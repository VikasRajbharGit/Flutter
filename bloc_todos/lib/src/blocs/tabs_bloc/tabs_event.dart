part of 'tabs_bloc.dart';

abstract class TabsEvent extends Equatable {
  const TabsEvent();
}

class TabUpdated extends TabsEvent{
  final AppTab tab;
  TabUpdated(this.tab);
  @override
  List<Object> get props => [tab];

  @override
  String toString() => 'TabUpdated { tab: $tab }';
}