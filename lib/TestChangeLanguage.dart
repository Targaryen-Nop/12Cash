// import 'package:_12sale_app/core/styles/style.dart';
// import 'package:_12sale_app/main.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_localization/flutter_localization.dart';

// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   final FlutterLocalization _localization = FlutterLocalization.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(AppLocale.title.getString(context))),
//       body: Container(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     child: Text(
//                       'English',
//                       style: Styles.black18(context),
//                     ),
//                     onPressed: () {
//                       _localization.translate('en');
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 16.0),
//                 Expanded(
//                   child: ElevatedButton(
//                     child: Text(
//                       'ភាសាខ្មែរ',
//                       style: Styles.black18(context),
//                     ),
//                     onPressed: () {
//                       _localization.translate('km');
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 16.0),
//                 Expanded(
//                   child: ElevatedButton(
//                     child: Text(
//                       '日本語',
//                       style: Styles.black18(context),
//                     ),
//                     onPressed: () {
//                       _localization.translate('ja', save: false);
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 16.0),
//                 Expanded(
//                   child: ElevatedButton(
//                     child: Text(
//                       'ไทย',
//                       style: Styles.black18(context),
//                     ),
//                     onPressed: () {
//                       _localization.translate('th', save: false);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16.0),
//             ItemWidget(
//               title: 'Current Language',
//               content: _localization.getLanguageName(),
//             ),
//             ItemWidget(
//               title: 'Font Family',
//               content: _localization.fontFamily,
//             ),
//             ItemWidget(
//               title: 'Locale Identifier',
//               content: _localization.currentLocale.localeIdentifier,
//             ),
//             ItemWidget(
//               title: 'String Format',
//               content: Strings.format(
//                 'Hello %a, this is me %a.',
//                 ['Dara', 'Sopheak'],
//               ),
//             ),
//             ItemWidget(
//               title: 'Context Format String',
//               content: context.formatString(
//                 AppLocale.thisIs,
//                 [AppLocale.title, 'LATEST'],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ItemWidget extends StatelessWidget {
//   const ItemWidget({
//     super.key,
//     required this.title,
//     required this.content,
//   });

//   final String? title;
//   final String? content;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(child: Text(title ?? '', style: Styles.black18(context))),
//           Text(' : ', style: Styles.black18(context)),
//           Expanded(child: Text(content ?? '', style: Styles.black18(context))),
//         ],
//       ),
//     );
//   }
// }
