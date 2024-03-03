import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music_player/theme/theme_provider.dart';

class NueBox extends StatelessWidget {
  final Widget? child;
  const NueBox({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.background,
        boxShadow: [
          // darker shadow on bottom right
          BoxShadow(
            color: isDarkMode ? Colors.black : Colors.grey.shade500,
            blurRadius: 15,
            offset: const Offset(4, 4)
          ),

          //lighter shadow on top left
          BoxShadow(
              color: isDarkMode? Colors.grey.shade800 : Colors.white,
              blurRadius: 15,
              offset: const Offset(-4, -4)
          )
        ]
      ),
      padding: const EdgeInsets.all(12),
      child: child,
    );
  }
}
