import 'package:flutter/material.dart';

class PillWidget extends StatelessWidget {
  final String text;
  final IconData icon;

  const PillWidget({
    Key? key,
    required this.text,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const ShapeDecoration(
        shape: StadiumBorder(),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  color: Theme.of(context).backgroundColor,
                ),
          ),
        ],
      ),
    );
  }
}
