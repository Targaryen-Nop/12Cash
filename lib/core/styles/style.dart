import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Styles {
  static double getResponsiveFontSize(BuildContext context, double fontSize) {
    return fontSize *
        MediaQuery.of(context).size.width /
        600; // Assuming 375 is the base screen width
  }

  // static TextStyle headerBlack18 = GoogleFonts.kanit(
  //     textStyle: const TextStyle(
  //   fontSize: 18,
  //   fontWeight: FontWeight.bold,
  //   color: Colors.black,
  // ));
  static TextStyle headerBlack18(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 18),
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
  // static TextStyle black18 = GoogleFonts.kanit(
  //     textStyle: const TextStyle(
  //   fontSize: 18,
  //   fontWeight: FontWeight.normal,
  //   color: Colors.black,
  // ));
  static TextStyle black18(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 18),
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      );
  // static TextStyle headerBlack24 = GoogleFonts.kanit(
  //     textStyle: const TextStyle(
  //   fontSize: 24,
  //   fontWeight: FontWeight.bold,
  //   color: Colors.black,
  // ));
  static TextStyle headerBlack24(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 24),
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
  // static TextStyle black24 = GoogleFonts.kanit(
  //     textStyle: const TextStyle(
  //   fontSize: 24,
  //   fontWeight: FontWeight.normal,
  //   color: Colors.black,
  // ));
  static TextStyle black24(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 24),
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      );

  // static TextStyle headerBlack32 = GoogleFonts.kanit(
  //     textStyle: const TextStyle(
  //   fontSize: 32,
  //   fontWeight: FontWeight.bold,
  //   color: Colors.black,
  // ));
  static TextStyle headerBlack32(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 32),
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );

  // static TextStyle black32 = GoogleFonts.kanit(
  //     textStyle: const TextStyle(
  //   fontSize: 32,
  //   fontWeight: FontWeight.normal,
  //   color: Colors.black,
  // ));
  static TextStyle black32(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 32),
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      );

  // static TextStyle headergrey18 = GoogleFonts.kanit(
  //     textStyle: const TextStyle(
  //   fontSize: 18,
  //   fontWeight: FontWeight.bold,
  //   color: Color(0xFF6B7280),
  // ));

  static TextStyle headergrey18(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 18),
          fontWeight: FontWeight.bold,
          color: Color(0xFF6B7280),
        ),
      );

  // static TextStyle grey18 = GoogleFonts.kanit(
  //     textStyle: const TextStyle(
  //   fontSize: 18,
  //   fontWeight: FontWeight.normal,
  //   color: Color(0xFF6B7280),
  // ));

  static TextStyle grey18(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 18),
          fontWeight: FontWeight.normal,
          color: Color(0xFF6B7280),
        ),
      );

  // static TextStyle headergrey24 = GoogleFonts.kanit(
  //     textStyle: const TextStyle(
  //   fontSize: 24,
  //   fontWeight: FontWeight.bold,
  //   color: Color(0xFF6B7280),
  // ));
  static TextStyle headergrey24(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 24),
          fontWeight: FontWeight.bold,
          color: Color(0xFF6B7280),
        ),
      );

  // static TextStyle grey24 = GoogleFonts.kanit(
  //     textStyle: const TextStyle(
  //   fontSize: 24,
  //   fontWeight: FontWeight.normal,
  //   color: Color(0xFF6B7280),
  // ));
  static TextStyle grey24(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 24),
          fontWeight: FontWeight.bold,
          color: Color(0xFF6B7280),
        ),
      );

  // static TextStyle headergrey32 = GoogleFonts.kanit(
  //     textStyle: const TextStyle(
  //   fontSize: 32,
  //   fontWeight: FontWeight.bold,
  //   color: Color(0xFF6B7280),
  // ));

  static TextStyle headergrey32(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 32),
          fontWeight: FontWeight.bold,
          color: Color(0xFF6B7280),
        ),
      );

  // static TextStyle grey32 = GoogleFonts.kanit(
  //     textStyle: const TextStyle(
  //   fontSize: 32,
  //   fontWeight: FontWeight.normal,
  //   color: Color(0xFF6B7280),
  // ));

  static TextStyle grey32(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 32),
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
      );

  // static TextStyle headerWhite18 = GoogleFonts.kanit(
  //   textStyle: const TextStyle(
  //     fontSize: 18,
  //     fontWeight: FontWeight.bold,
  //     color: Colors.white,
  //   ),
  // );
  static TextStyle headerWhite18(BuildContext context) => GoogleFonts.kanit(
        textStyle: TextStyle(
          fontSize: getResponsiveFontSize(context, 18),
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );

  // static TextStyle white18 = GoogleFonts.kanit(
  //   textStyle: const TextStyle(
  //     fontSize: 18,
  //     fontWeight: FontWeight.normal,
  //     color: Colors.white,
  //   ),
  // );
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
          fontWeight: FontWeight.bold,
          color: Colors.white,
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
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );

  static TextStyle white32 = GoogleFonts.kanit(
    textStyle: const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
  );

// --------------------- Primary Color----------------------
  static const Color primaryColor = Color(0xFF00569D);
  static const Color secondaryColor = Color(0xFFD1F0F6);
  static const Color grey = Colors.grey;
  static const Color white = Colors.white;

  // --------------------- Common Color----------------------
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

  // --------------------- Button Color---------------------
  static const Color successButtonColor = Color(0xFF198754);
}
