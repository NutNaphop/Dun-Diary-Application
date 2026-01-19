import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // สำหรับ format วันที่ไทย
import 'components/calendar_header.dart';
import 'views/month_view.dart';
import 'views/week_view.dart';
import 'views/year_view.dart';

// Enum เพื่อกำหนดว่าหน้าไหนต้องการปฏิทินแบบไหน (Target)
enum CalendarType { week, month, year }

// Enum เพื่อกำหนดว่าตอนนี้กำลังโชว์หน้าอะไรอยู่ (Current View)
enum _ViewState { week, month, year }

class CalendarSDK extends StatefulWidget {
  final CalendarType type; // ต้องการปฏิทินแบบไหน (Week / Month / Year)
  final DateTime? initialDate;

  const CalendarSDK({
    super.key,
    this.type = CalendarType.week, // ค่า Default เป็นแบบสัปดาห์
    this.initialDate,
  });

  @override
  State<CalendarSDK> createState() => _CalendarSDKState();
}

class _CalendarSDKState extends State<CalendarSDK> {
  late _ViewState _currentView; // เอาไว้สลับหน้าจอ
  late DateTime _selectedDate; // วันที่ user เลือกจริง (จะส่งค่านี้กลับ)
  late DateTime _focusedDate; // วันที่กำลังดูอยู่ (ใช้เลื่อนปฏิทิน)

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('th_TH'); // เตรียมภาษาไทย

    // ตั้งค่าเริ่มต้น
    _selectedDate = widget.initialDate ?? DateTime.now();
    _focusedDate = _selectedDate;

    // กำหนดหน้าแรกที่จะโชว์ ตาม type ที่ขอมา
    switch (widget.type) {
      case CalendarType.week:
        _currentView = _ViewState.week;
        break;
      case CalendarType.month:
        _currentView = _ViewState.month;
        break;
      case CalendarType.year:
        _currentView = _ViewState.year;
        break;
    }
  }

  // --- Logic การสลับหน้า (State Machine) ---

  void _onHeaderMonthTap() {
    // กดเลือกเดือน -> สลับไปหน้า MonthView
    setState(() {
      _currentView = _ViewState.month;
    });
  }

  void _onHeaderYearTap() {
    // กดเลือกปี -> สลับไปหน้า YearView
    setState(() {
      _currentView = _ViewState.year;
    });
  }

  DateTime _clampDay(int year, int month, int day) {
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    // ถ้าวันที่เลือก (เช่น 31) มากกว่าวันที่มีจริงในเดือนใหม่ (เช่น 28) ให้ลดลงมาเหลือ 28
    final clampedDay = day > daysInMonth ? daysInMonth : day;
    return DateTime(year, month, clampedDay);
  }

  void _onYearSelected(int year) {
    setState(() {
      // 1. อัปเดต _focusedDate โดยใช้ปีใหม่ (พร้อมกันวันที่ทะลุ)
      _focusedDate = _clampDay(year, _focusedDate.month, _focusedDate.day);

      if (widget.type == CalendarType.year) {
        _selectedDate = _clampDay(year, _selectedDate.month, _selectedDate.day);
      } else if (widget.type == CalendarType.month) {
        _currentView = _ViewState.month;
      } else if (widget.type == CalendarType.week) {
        _currentView = _ViewState.week;
      }
    });
  }

  void _onMonthSelected(int month) {
    setState(() {
      _focusedDate = _clampDay(_focusedDate.year, month, _focusedDate.day);
      if (widget.type == CalendarType.month) {
        _selectedDate = _clampDay(_focusedDate.year, month, _selectedDate.day);
      } else {
        _currentView = _ViewState.week;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: 350,
          child: Column(
            spacing: 20,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Drop Down Header
              CalendarHeader(
                currentDate: _focusedDate,
                style: _getHeaderStyle(),
                // ถ้าอยู่หน้าเลือกปีอยู่แล้ว ไม่ต้องกดซ้ำ
                onYearTap: _currentView == _ViewState.year
                    ? () {}
                    : _onHeaderYearTap,
                // ถ้าอยู่หน้าเลือกเดือน หรือโหมดหลักเป็นปี (เลือกเดือนไม่ได้) -> ปิดปุ่ม
                onMonthTap:
                    (_currentView == _ViewState.month ||
                        widget.type == CalendarType.year)
                    ? () {}
                    : _onHeaderMonthTap,
              ),
        
              // 2. Body Change as Stage
              Flexible(
                child: SingleChildScrollView(
                  child: _buildBody(),
                ),
              ),
        
              // 3. Footer Button (Select)
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // ส่งค่ากลับไปให้หน้าหลัก
                      Navigator.pop(context, _selectedDate);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009688), // สี Teal ตามภาพ
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'เลือก',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentView) {
      case _ViewState.week:
        return WeekPickerView(
          selectedDate: _selectedDate,
          focusedDay: _focusedDate,
          onDaySelected: (selected, focused) {
            setState(() {
              _selectedDate = selected;
              _focusedDate = focused;
            });
          },
          onPageChanged: (focused) {
            setState(() => _focusedDate = focused);
          },
        );

      case _ViewState.month:
        return MonthPickerView(
          selectedMonth: _focusedDate.month, // ส่งเดือนที่ "ดูอยู่" ไปไฮไลท์
          viewingYear: _focusedDate.year, // ส่งปีไปด้วย เพื่อเช็คว่าอนาคตไหม
          onMonthSelected: _onMonthSelected,
        );

      case _ViewState.year:
        return YearPickerView(
          selectedYear: _focusedDate.year,
          onYearSelected: _onYearSelected,
        );
    }
  }

  CalendarHeaderStyle _getHeaderStyle() {
    switch (_currentView) {
      case _ViewState.week:
        return CalendarHeaderStyle.week;
      case _ViewState.month:
        return CalendarHeaderStyle.month;
      case _ViewState.year:
        return CalendarHeaderStyle.year;
    }
  }
}
