import 'package:dun_diary_app/shared/style/color.dart';
import 'package:dun_diary_app/shared/style/dimension.dart';
import 'package:dun_diary_app/shared/widgets/card/card_item.dart';
import 'package:dun_diary_app/shared/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HealthStatusCard extends StatelessWidget {
  // รับค่าเข้ามาเพื่อแสดงผล (รองรับ State ที่คุณจะจัดการเอง)
  final String sysValue;
  final String diaValue;
  final String pulValue;

  const HealthStatusCard({
    Key? key,
    this.sysValue = '115', // ค่า Default (เอาออกได้ถ้าไม่ใช้)
    this.diaValue = '75',
    this.pulValue = '72',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 10, 16, 10),
      child: Material(
        color: Colors.transparent,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: 360.9,
          decoration: BoxDecoration(
            color: CustomColor.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Header: สุขภาพของคุณวันนี้ ---
                Align(
                  alignment: AlignmentDirectional(-1, -1),
                  child: CustomText(
                    text: 'สุขภาพของคุณวันนี้',
                    color: CustomColor.gray900,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // --- Rows: SYS, DIA, PUL ---
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _buildStatRow(
                      context,
                      'SYS',
                      'ความดันโลหิตขณะหัวใจบีบตัว',
                      sysValue,
                    ),
                    _buildStatRow(
                      context,
                      'DIA',
                      'ความดันโลหิตขณะหัวใจคลายตัว',
                      diaValue,
                    ),
                    _buildStatRow(
                      context,
                      'PUL',
                      'อัตราการเต้นของหัวใจ',
                      pulValue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widget เพื่อลดโค้ดที่ซ้ำซ้อนกัน 3 รอบ
  Widget _buildStatRow(
    BuildContext context,
    String label,
    String description,
    String value,
  ) {
    return Column(
      children: [
        CardItem(
          leading: SvgPicture.asset(
            'assets/icons/image.svg',
            width: 34,
            height: 34,
            colorFilter: ColorFilter.mode(CustomColor.gray600, BlendMode.srcIn),
          ),
          title: label,
          subtitle: description,
          trailing: CustomText(
            text: value,
            fontSize: Dimension.fontSizeHeading1,
            fontWeight: Dimension.fontWeightSemiBold,
          ),
        ),
        if (label != 'PUL') Divider()
      ],
    );
  }
}
