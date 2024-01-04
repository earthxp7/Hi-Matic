import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../timeControl/connect_internet.dart';
import 'package:flutter/services.dart';

class NotAvailable extends StatelessWidget {
  const NotAvailable({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    final int connect = 300;
    final connectnetwork = Get.put(connectNetwork(connect));
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    connectnetwork.notcon.value = true;
    return Scaffold(
      body: Container(
        height: sizeHeight * 1,
        width: sizeWidth * 1,
        color: Color.fromARGB(255, 212, 212, 212),
        child: Center(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 500),
              child: Container(
                height: sizeHeight * 0.25,
                width: sizeWidth * 0.7,
                child: Lottie.asset('assets/notAvailable.json'),
              ),
            ),
            Text(
              'Sorry, Customers',
              style: GoogleFonts.kanit(
                fontSize: sizeWidth * 0.07,
              ),
            ),
            Text(
              'The System Is Not Available',
              style: GoogleFonts.kanit(
                fontSize: sizeWidth * 0.055,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
