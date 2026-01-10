import 'package:flutter/material.dart';

class Dimension {
  Dimension._();
  static const paddings = _Padding._();
  static const fontSizes = _FontSize._();
  static const fontWeights = _FontWeight._();
  static const conSizes = _IconSize._();

}

class _Padding{
  const _Padding._();
  // padding
  final double sm = 8.0; /// 8
  final double md = 16.0; /// 16
  final double lg = 24.0; /// 24
}

class _FontSize {
  const _FontSize._();
  // fontSize
  final double h1 = 21.0; /// 21
  final double h2 = 16.0; /// 16
  final double md = 14.0; /// 14
  final double rg =  12.0; /// 12
  final double sm = 11.0; /// 11
  final double esm = 10.0; /// 10
}

class _IconSize {
  const  _IconSize._();
  // iconSize
  final double sm = 16.0; /// 16
  final double md = 24.0; /// 24
  final double lg = 32.0; /// 32

}

class _FontWeight {
  const _FontWeight._();
  // fontWeight
  final FontWeight bold = FontWeight.w700;
  final FontWeight semiBold = FontWeight.w600;
  final FontWeight medium = FontWeight.w500;
  final FontWeight regular = FontWeight.w400;
}