import 'package:flutter/material.dart';

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
      height: sizeHeight * 0.06,
      width: sizeWidth * 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
        ),
      ),
      child: Row(children: [
        SizedBox(
          width: sizeWidth * 0.35,
        ),
        Transform.translate(
          offset: Offset(0.0, 20.0),
          child: Image.asset(
            'assets/logo.png',
            color: Colors.black,
            height: sizeHeight * 0.45,
            width: sizeWidth * 0.08,
            fit: BoxFit.contain,
          ),
        ),
        Column(children: [
          Container(
            height: sizeHeight * 0.03,
            width: sizeWidth * 0.2,
            child: Text(
              "N  A  M  E",
              style: TextStyle(
                fontSize: sizeWidth * 0.045,
                color: Colors.black,
                fontFamily: 'SukhumvitSet-Medium',
              ),
            ),
          ),
          Container(
            width: sizeWidth * 0.2,
            child: Text(
              "R E S T A U R A N T",
              style: TextStyle(
                fontSize: sizeWidth * 0.023,
                color: Colors.black,
                fontFamily: 'SukhumvitSet-Medium',
              ),
            ),
          ),
        ]),
      ]),
    );
  }
}
