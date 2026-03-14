abstract class TutorialContentBlock {}

class ParagraphBlock extends TutorialContentBlock {
  final String text;

  ParagraphBlock({required this.text});
}

class PrefixBlock extends TutorialContentBlock {
  final String prefix;
  final String text;

  PrefixBlock({required this.prefix, required this.text});
}

class BulletBlock extends TutorialContentBlock {
  final String? boldTitle;
  final String text;

  BulletBlock({this.boldTitle, required this.text});
}

class NumberedBlock extends TutorialContentBlock {
  final int number;
  final String? boldTitle;
  final String text;

  NumberedBlock({required this.number, this.boldTitle, required this.text});
}
