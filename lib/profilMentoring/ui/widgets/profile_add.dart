import 'package:flutter/material.dart';
import 'package:ticeo/profilMentoring/utils/theme.dart';

class ProfileAddCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Card(
            color: AppTheme.addCardColor,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }
}
