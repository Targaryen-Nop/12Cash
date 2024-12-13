import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Styles {
  static double getResponsiveFontSize(BuildContext context, double fontSize) {
    return fontSize *
        MediaQuery.of(context).size.width /
        600; // Assuming 375 is the base screen width
  }

  static TextStyle kanit(BuildContext context) => GoogleFonts.kanit();

  static TextStyle grey12(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 12),
          fontWeight: FontWeight.normal,
          color: const Color(0xFF6B7280),
        ),
      );

  static TextStyle headerBlack18(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      );

  static TextStyle strikeBlack18(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          decoration: TextDecoration.lineThrough,
          decorationThickness: 2.0,
          fontSize: getResponsiveFontSize(context, 18),
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      );

  static TextStyle black18(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 18),
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      );
  static TextStyle black20(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 20),
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      );

  static TextStyle headerBlack20(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 20),
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );

  static TextStyle black12(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 12),
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      );

  static TextStyle red12(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 12),
          fontWeight: FontWeight.normal,
          color: const Color(0xFF9B1C1C),
        ),
      );
  static TextStyle red18(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 18),
          fontWeight: FontWeight.normal,
          color: const Color(0xFF9B1C1C),
        ),
      );
  static TextStyle headerBlack24(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 24),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      );

  static TextStyle headerRed18(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 18),
          fontWeight: FontWeight.w600,
          color: const Color(0xFF9B1C1C),
        ),
      );

  static TextStyle headerRed24(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 24),
          fontWeight: FontWeight.w600,
          color: const Color(0xFF9B1C1C),
        ),
      );
  static TextStyle strikeBlack24(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          decoration: TextDecoration.lineThrough,
          decorationThickness: 2.0,
          fontSize: getResponsiveFontSize(context, 24),
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      );
  static TextStyle black24(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 24),
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      );
  static TextStyle headerBlack32(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 32),
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      );
  static TextStyle strikeBlack32(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          decoration: TextDecoration.lineThrough,
          decorationThickness: 2.0,
          fontSize: getResponsiveFontSize(context, 32),
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      );
  static TextStyle black32(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 32),
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      );
  static TextStyle headergrey18(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 18),
          fontWeight: FontWeight.w600,
          color: const Color(0xFF6B7280),
        ),
      );
  static TextStyle strikeGrey18(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          decoration: TextDecoration.lineThrough,
          decorationThickness: 2.0,
          fontSize: getResponsiveFontSize(context, 18),
          fontWeight: FontWeight.normal,
          color: const Color(0xFF6B7280),
        ),
      );
  static TextStyle grey18(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 18),
          fontWeight: FontWeight.normal,
          color: const Color(0xFF6B7280),
        ),
      );
  static TextStyle headergrey24(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 24),
          fontWeight: FontWeight.w600,
          color: const Color(0xFF6B7280),
        ),
      );
  static TextStyle strikeGrey24(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          decoration: TextDecoration.lineThrough,
          decorationThickness: 2.0,
          fontSize: getResponsiveFontSize(context, 24),
          fontWeight: FontWeight.normal,
          color: const Color(0xFF6B7280),
        ),
      );
  static TextStyle grey24(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 24),
          fontWeight: FontWeight.w600,
          color: const Color(0xFF6B7280),
        ),
      );
  static TextStyle headergrey32(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 32),
          fontWeight: FontWeight.w600,
          color: const Color(0xFF6B7280),
        ),
      );
  static TextStyle strikeGrey32(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          decoration: TextDecoration.lineThrough,
          decorationThickness: 2.0,
          fontSize: getResponsiveFontSize(context, 32),
          fontWeight: FontWeight.normal,
          color: const Color(0xFF6B7280),
        ),
      );
  static TextStyle grey32(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 32),
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
      );
  static TextStyle headerWhite18(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 18),
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
  static TextStyle strikeWhite18(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          decoration: TextDecoration.lineThrough,
          decorationThickness: 2.0,
          fontSize: getResponsiveFontSize(context, 18),
          fontWeight: FontWeight.normal,
          color: const Color(0xFF6B7280),
        ),
      );
  static TextStyle white18(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 18),
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
      );

  static TextStyle headerWhite24(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 24),
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
  static TextStyle strikeWhite24(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          decoration: TextDecoration.lineThrough,
          decorationThickness: 2.0,
          fontSize: getResponsiveFontSize(context, 24),
          fontWeight: FontWeight.normal,
          color: const Color(0xFF6B7280),
        ),
      );

  static TextStyle white24(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 24),
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
      );

  static TextStyle headerWhite32(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 32),
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );

// --------------------- Primary Color ---------------------------------
  static const Color primaryColor = Color(0xFF00569D);
  static const Color secondaryColor = Color(0xFF94d3f2);
  static const Color grey = Colors.grey;
  static const Color white = Colors.white;

  // --------------------- Common Color --------------------------------
  static const Color backgroundTableColor = Color(0xFFF9FAFB);
  static const Color successBackgroundColor = Color(0xFFDEF7EC);
  static const Color successTextColor = Color(0xFF03543F);

  static const Color failBackgroundColor = Color(0xFFFBD5D5);
  static const Color failTextColor = Color(0xFF9B1C1C);

  static const Color paddingBackgroundColor = Color(0xFFE1EFFE);
  static const Color paddingTextColor = Color(0xFF1E429F);

  static const Color warningBackgroundColor = Color(0xFFFFF3CD);
  static const Color warningTextColor = Color(0xFFEDB900);

  static const Color accentColor = Colors.orange;

  // --------------------- Button Color --------------------------------
  static const Color successButtonColor = Color(0xFF198754);
}
