import 'package:flutter/material.dart';

import '../resources/color_manager.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: ColorManager.blue,
      ),
    );
  }
}
