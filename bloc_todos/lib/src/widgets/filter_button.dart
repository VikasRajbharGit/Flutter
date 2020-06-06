import 'package:bloc_todos/src/blocs/bloc.dart';
import 'package:bloc_todos/src/models/visibility_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterButton extends StatelessWidget {
  final bool visible;
  FilterButton({this.visible});

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.bodyText2;
    final activeStyle = Theme.of(context)
        .textTheme
        .bodyText2
        .copyWith(color: Theme.of(context).accentColor);
    return BlocBuilder<FilteredTodosBloc, FilteredTodosState>(
        builder: (context, state) {
      final button = _Button(
        activeFilter: state is FilteredTodosLoaded
            ? state.activeFilter
            : VisibilityFilter.all,
        activeStyle: activeStyle,
        defaultStyle: defaultStyle,
        onSelected: (filter) {
          BlocProvider.of<FilteredTodosBloc>(context).add(FilterPressed(filter));
        },
      );
      return AnimatedOpacity(
        opacity: visible?1:0,
        duration: Duration(milliseconds: 150),
        child:visible?button:IgnorePointer(child: button,),
      );
    });
  }
}

class _Button extends StatelessWidget {
  final PopupMenuItemSelected<VisibilityFilter> onSelected;
  final VisibilityFilter activeFilter;
  final TextStyle activeStyle;
  final TextStyle defaultStyle;

  _Button({
    @required this.onSelected,
    @required this.activeFilter,
    @required this.activeStyle,
    @required this.defaultStyle,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<VisibilityFilter>(
      icon: Icon(Icons.filter_list),
      onSelected: onSelected,
      tooltip: 'Filters',
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<VisibilityFilter>(
            value: VisibilityFilter.all,
            child: Text(
              'Show All',
              style: activeFilter == VisibilityFilter.all
                  ? defaultStyle
                  : activeStyle,
            ),
          ),
          PopupMenuItem<VisibilityFilter>(
            value: VisibilityFilter.active,
            child: Text(
              'Show Active',
              style: activeFilter == VisibilityFilter.active
                  ? defaultStyle
                  : activeStyle,
            ),
          ),
          PopupMenuItem<VisibilityFilter>(
            value: VisibilityFilter.completed,
            child: Text(
              'Show Completed',
              style: activeFilter == VisibilityFilter.completed
                  ? defaultStyle
                  : activeStyle,
            ),
          ),
        ];
      },
    );
  }
}
