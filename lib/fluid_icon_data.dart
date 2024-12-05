import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/material.dart';

class FluidFillIconData {
  final List<ui.Path> paths;
  FluidFillIconData(this.paths);
}

class FluidFillIcons {
  static final platform = FluidFillIconData([
    ui.Path()
      ..moveTo(0, -6)
      ..lineTo(10, -6),
    ui.Path()
      ..moveTo(5, 0)
      ..lineTo(-5, 0),
    ui.Path()
      ..moveTo(-10, 6)
      ..lineTo(0, 6),
  ]);
  static final window = FluidFillIconData([
    ui.Path()..addRRect(RRect.fromLTRBXY(-12, -12, -2, -2, 2, 2)),
    ui.Path()..addRRect(RRect.fromLTRBXY(2, -12, 12, -2, 2, 2)),
    ui.Path()..addRRect(RRect.fromLTRBXY(-12, 2, -2, 12, 2, 2)),
    ui.Path()..addRRect(RRect.fromLTRBXY(2, 2, 12, 12, 2, 2)),
  ]);
  static final arrow = FluidFillIconData([
    ui.Path()
      ..moveTo(-10, 6)
      ..lineTo(10, 6)
      ..moveTo(10, 6)
      ..lineTo(3, 0)
      ..moveTo(10, 6)
      ..lineTo(3, 12),
    ui.Path()
      ..moveTo(10, -6)
      ..lineTo(-10, -6)
      ..moveTo(-10, -6)
      ..lineTo(-3, 0)
      ..moveTo(-10, -6)
      ..lineTo(-3, -12),
  ]);
  static final user = FluidFillIconData([
    ui.Path()..arcTo(Rect.fromLTRB(-5, -16, 5, -6), 0, 1.9 * math.pi, true),
    ui.Path()..arcTo(Rect.fromLTRB(-10, 0, 10, 20), 0, -1.0 * math.pi, true),
  ]);
  static final home = FluidFillIconData([
    ui.Path()..addRRect(RRect.fromLTRBXY(-10, -2, 10, 10, 2, 2)),
    ui.Path()
      ..moveTo(-14, -2)
      ..lineTo(14, -2)
      ..lineTo(0, -16)
      ..close(),
  ]);
  static final heart = FluidFillIconData([
    ui.Path()
      ..moveTo(0, 8)
      ..cubicTo(0, 8, -12, 0, -12, -8)
      ..cubicTo(-12, -14, -8, -18, 0, -12)
      ..cubicTo(8, -18, 12, -14, 12, -8)
      ..cubicTo(12, 0, 0, 8, 0, 8)
      ..close(),
  ]);
  static final news = FluidFillIconData([
    // Tạo hình chữ nhật chính cho tờ báo
    ui.Path()..addRRect(RRect.fromLTRBXY(-10, -14, 10, 10, 2, 2)),

    // Tạo tiêu đề lớn của tờ báo
    ui.Path()
      ..moveTo(-8, -12)
      ..lineTo(8, -12)
      ..moveTo(-8, -11)
      ..lineTo(8, -11),

    // Tạo các dòng văn bản
    ui.Path()
      ..moveTo(-8, -9)
      ..lineTo(4, -9)
      ..moveTo(-8, -8)
      ..lineTo(4, -8)
      ..moveTo(-8, -7)
      ..lineTo(4, -7)
      ..moveTo(-8, -6)
      ..lineTo(4, -6)
      ..moveTo(-8, -5)
      ..lineTo(4, -5),
  ]);
}
