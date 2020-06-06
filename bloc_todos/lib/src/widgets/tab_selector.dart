import 'package:bloc_todos/src/blocs/bloc.dart';
import 'package:flutter/material.dart';


class TabSelector extends StatelessWidget {
  final AppTab activeTab;
  final Function(AppTab) onTabPressed;
  TabSelector({@required this.activeTab,this.onTabPressed});
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar( 
      currentIndex: AppTab.values.indexOf(activeTab),
      onTap: (tabIndex)=>onTabPressed(AppTab.values[tabIndex]),
      items: AppTab.values.map((tab){
        return BottomNavigationBarItem(
          title: tab==AppTab.todos? Text('Todos'):Text('Stats'), 
          icon: tab==AppTab.todos? Icon(Icons.event_note):Icon(Icons.insert_chart),
          
        );
      } ).toList(),
      
    );
  }
}