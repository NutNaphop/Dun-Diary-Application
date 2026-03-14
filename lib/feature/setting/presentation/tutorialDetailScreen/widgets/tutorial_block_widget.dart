import 'package:dun_diary_app/feature/setting/data/model/tutorial_content_block.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';

class TutorialBlockWidget extends StatelessWidget {
  final TutorialContentBlock block;

  const TutorialBlockWidget({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    if (block is ParagraphBlock) {
      return _buildParagraphBlock(block as ParagraphBlock);
    } else if (block is PrefixBlock) {
      return _buildPrefixBlock(block as PrefixBlock);
    } else if (block is BulletBlock) {
      return _buildBulletBlock(block as BulletBlock);
    } else if (block is NumberedBlock) {
      return _buildNumberedBlock(block as NumberedBlock);
    }
    return const SizedBox.shrink();
  }

  Widget _buildParagraphBlock(ParagraphBlock block) {
    return Padding(
      padding: EdgeInsets.zero,
      child: CustomText(
        text: block.text,
        fontSize: Dimension.fontSizes.h2,
        fontWeight: Dimension.fontWeights.regular,
        textAlign: TextAlign.center,
        color: CustomColor.gray600,
      ),
    );
  }

  Widget _buildPrefixBlock(PrefixBlock block) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: '${block.prefix}    ',
            fontSize: Dimension.fontSizes.h2,
            fontWeight: Dimension.fontWeights.bold,
          ),
          Expanded(
            child: CustomText(
              text: block.text,
              fontSize: Dimension.fontSizes.h2,
              fontWeight: Dimension.fontWeights.regular,
              color: CustomColor.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletBlock(BulletBlock block) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          CustomText(
            text: '•  ',
            fontSize: Dimension.fontSizes.h2,
            fontWeight: Dimension.fontWeights.bold,
            color: CustomColor.gray900,
          ),
          Expanded(
            child: CustomText(
              text: "${block.boldTitle ?? ''}${block.text}",
              fontSize: Dimension.fontSizes.h2,
              fontWeight: Dimension.fontWeights.regular,
              color: CustomColor.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedBlock(NumberedBlock block) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          CustomText(
            text: "${block.number}. ",
            fontSize: Dimension.fontSizes.h2,
            fontWeight: Dimension.fontWeights.regular,
            color: CustomColor.gray600,
          ),
          Expanded(
            child: CustomText(
              text: "${block.boldTitle ?? ''}${block.text}",
              fontSize: Dimension.fontSizes.h2,
              fontWeight: Dimension.fontWeights.regular,
              color: CustomColor.gray600,
            ),
          ),
        ],
      ),
    );
  }
}
