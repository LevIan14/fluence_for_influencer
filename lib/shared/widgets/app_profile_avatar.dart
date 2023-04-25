import 'package:flutter/material.dart';

class AppProfileAvatar extends StatelessWidget {
  const AppProfileAvatar({super.key, required this.verticalMargin, required this.parentWidth, required this.avatarUrl});

  final double verticalMargin;
  final double parentWidth;
  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: verticalMargin),
      child:
          Container(
        width: parentWidth * 0.3,
        height: parentWidth * 0.3,
        child: CircleAvatar(
          radius: 14,
          backgroundImage: NetworkImage(
            avatarUrl,
          ),
        ),
      ),
    );
  }
}

