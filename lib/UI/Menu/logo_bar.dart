import 'package:flutter/material.dart';
import 'package:screen/alert/backhome.dart';

class logoUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final List<Color> gradientColors = [
      Color.fromRGBO(227, 227, 227, 1), // สีเทา
      for (int i = 0; i < 15; i++) Color.fromRGBO(255, 255, 255, 1), // สีขาว
    ];

    return Container(
      height: sizeHeight * 0.1,
      width: sizeWidth * 1,
      decoration: BoxDecoration(
      gradient: LinearGradient(
      begin: Alignment.topCenter,  // จุดเริ่มต้นของการไล่ระดับสี (ด้านบน)
      end: Alignment.bottomCenter, // จุดสิ้นสุดของการไล่ระดับสี (ด้านล่าง)
      colors: [
      Color.fromRGBO(223, 223, 223, 1),  // สีเข้มสุดด้านบน
      Color.fromRGBO(223, 223, 223, 0),  // สีจางสุดด้านล่าง (โปร่งใส)
        ],
       )
      ),
      child: Row(children: [
        SizedBox(
          width: sizeWidth * 0.02,
        ),
        Row(
          children: [
           GestureDetector(
                  onTap: () {
                    backHome(context);
                  },
                  child: Container(
                    height: sizeHeight *0.2,
                    width:  sizeWidth * 0.2,
                     child: Image.asset(
                          'assets/Homes.png',
                          scale: 1,
                         // ความสูงของรูปภาพ
                         alignment: Alignment.bottomLeft,
                        ),
                        ),
                    ),
                    SizedBox(width: sizeWidth *0.15,),
              Container(
             // color: Colors.blue,
              height: sizeHeight *0.06,
              width:  sizeWidth * 0.3,
              child: Image.asset(
                  'assets/logo.png',
                  scale: 0.8,
                ),
            ),
          ],
        ),
      ]),
    );
  }
}
