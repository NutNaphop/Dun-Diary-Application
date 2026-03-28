import 'package:dun_diary_app/shared/constant/app_strings.dart';
import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/custom/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CitationSource extends StatelessWidget {
  final String sourceName;
  final String url;
  final TextAlign? textAlign;
  final double? fontSize;
  final Color? color;

  const CitationSource({
    super.key,
    required this.sourceName,
    required this.url,
    this.textAlign = TextAlign.center,
    this.fontSize,
    this.color,
  });

  Future<void> _launchUrl() async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _launchUrl,
      child: CustomText(
        text: AppStrings.stat.sourceFrom(sourceName),
        textAlign: textAlign,
        fontSize: fontSize ?? Dimension.fontSizes.rg,
        fontWeight: Dimension.fontWeights.regular,
        color: color ?? CustomColor.gray500,
        decoration: TextDecoration.underline,
      ),
    );
  }
}
