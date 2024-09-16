import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';


class Bottombar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    var dateNow = DateFormat('HH:mm').format(DateTime.now());
    return Container(
      height: sizeHeight * 0.01,
      width: sizeWidth * 1,
      child: Row(
        children: [
          Container(
            width: sizeWidth * 0.15,
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: StreamBuilder<DateTime>(
                stream: Stream.periodic(
                    Duration(seconds: 1), (i) => DateTime.now()),
                builder: (context, snapshot) {
                  // ใส่เวลาปัจจุบันไม่ให่ขึ้นโหลดเวลา
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text(
                      '${dateNow}',
                      style: TextStyle(
                        fontSize: sizeWidth * 0.023,
                        fontFamily: 'SukhumvitSet-Medium',
                        color: Colors.white,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
                  } else {
                    var formattedDate =
                        DateFormat('HH:mm').format(snapshot.data!);
                    return Text(
                      '${formattedDate}',
                      style: TextStyle(
                        fontSize: sizeWidth * 0.023,
                        fontFamily: 'SukhumvitSet-Medium',
                        color: Colors.white,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Container(
              width: sizeWidth * 0.85,
              child: Marquee(
                text: 'พบปัญหาการใช้งานติดต่อเจ้าหน้าที่',
                style: TextStyle(
                  fontSize: sizeWidth * 0.023,
                  fontFamily: 'SukhumvitSet-Medium',
                  color: Colors.white,
                ),

                scrollAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                blankSpace: sizeWidth * 0.45,
                velocity: sizeWidth * 0.05,
                //pauseAfterRound: Duration(microseconds: 10),
                showFadingOnlyWhenScrolling: true,
                fadingEdgeStartFraction: 0.1,
                fadingEdgeEndFraction: 0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
