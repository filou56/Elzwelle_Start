import 'package:intl/intl.dart';

class TimestampEntity {
  String time;
  String stamp;
  String number;
  String tag;

  TimestampEntity({
    required this.time,
    required this.stamp,
    required this.number,
    required this.tag,
  });

  // factory TimestampEntity.fromSheets(List<String> input) {
  //   int       _epoch;
  //   DateTime  _time;
  //   double    _seconds;
  //   String    _number;
  //
  //   if ( input.length < 2 ) {
  //     return TimestampEntity(time: '00:00:00', stamp: '0.00', number: '0');
  //   }
  //   try {
  //     try {
  //       _epoch = (double.parse(input[0]) * 86400000.0).round();
  //     } on FormatException catch (e) {
  //       _epoch = 0;
  //     }
  //     _time = DateTime.fromMillisecondsSinceEpoch(_epoch, isUtc: true);
  //     try {
  //       _seconds = double.parse(input[1]);
  //     } on FormatException catch (e) {
  //       _seconds = 0.0;
  //     }
  //     try {
  //       _number = input[2] ?? '0';
  //     } on RangeError catch (e) {
  //       _number = '0';
  //     }
  //   } catch (e) {
  //     print(e);
  //     return TimestampEntity(time: '00:00:00', stamp: '0.00', number: '0');
  //   }
  //
  //   return TimestampEntity(time:   DateFormat.Hms().format(_time),
  //                          stamp:  _seconds.toStringAsFixed(2),
  //                          number: _number,
  //   );
  // }

}
