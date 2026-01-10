import 'package:dun_diary_app/feature/home/presentation/widgets/card/home_card_widget.dart';
import 'package:flutter/material.dart';

class StatRow extends StatelessWidget {
  final Widget leading;
  final String label;
  final String description;
  final String value;

  const StatRow({
    super.key,
    required this.leading,
    required this.label,
    required this.description,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ContentCard(
      leading: leading,
      label: label,
      description: description,
      value: value,
    );
  }
}