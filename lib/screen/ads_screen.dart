import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:screen/Appbar/report.dart';
import 'package:screen/screen/logo_screen.dart';
import '../Appbar/language.dart';
import '../api/Kios_API.dart';
import '../getxController.dart/save_menu.dart';
import '../timeControl/adtime.dart';
import 'package:video_player/video_player.dart';
import '../timeControl/connect_internet.dart';

final Random random = Random();
final dataKios _dataKios = Get.put(dataKios());

class Ads_screen extends StatelessWidget {
  final FoodOptionController _foodOptionController =
      Get.put(FoodOptionController());
  final randomIndex = random.nextInt(_dataKios.advertlist.length);
  final int connect = 20;
  final int admob_time = 60;
  bool isEditing = false;
  late VideoPlayerController controller;
  @override
  Widget build(BuildContext context) {
    _dataKios.status.value = '';
    final connectnetwork = Get.put(connectNetwork(connect: connect));
    connectnetwork.Internet.value = false;
    //  print('Token ${ _dataKios.reqKiosdata[0]['kiosks']['access_token']}');
    String Log = 'Start Application : ${_foodOptionController.formattedDate}';
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final admob_times = Get.put(AdMobTimeController(admob_time: admob_time));
    final int index;
    final String videoUrl;
    return Scaffold(
        body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: sizeHeight * 0.042,
                      width: sizeWidth * 1,
                      decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      borderRadius: BorderRadius.circular(sizeWidth * 0.01),
                      boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 3),
                  ),
                ],
              ),
              child: languageBar()),
Container(
  height: sizeHeight * 0.937,
  width: sizeWidth * 1,
  color: Colors.white,
  child: ListView.builder(
    physics: NeverScrollableScrollPhysics(),
    itemCount: 1,
    itemBuilder: (BuildContext context, int index) {
      final advert = _dataKios.advertlist[0];
      final advertisingImages = advert.advertisingImage;
      final advertisingImageType = advert.advertisingImageType;
      final videoController = VideoPlayerController.file(File(advertisingImages));

      return (advertisingImageType == "video")
          ? FutureBuilder(
              future: videoController.initialize(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  videoController.setLooping(false);
                 // videoController.play();

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          videoController.dispose();
                          LogFile(Log);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => logo_screen(),
                            ),
                          );
                        },
                        child: Transform.translate(
                              offset: Offset(0.0, sizeHeight * -0.05),
                              child:Container(
                          height: sizeHeight * 1, // ใช้ขนาดที่เหมาะสม
                          width: sizeWidth * 1,
                          color: Colors.black,
                          child: AspectRatio(
                            aspectRatio: videoController.value.aspectRatio,
                            child: VideoPlayer(videoController),
                          ),
                        ),
                      ),
                      ),
                      Container(
                        height: sizeHeight * 0.2,
                        width: sizeWidth * 1,
                        child: Column(
                          children: [
                            Transform.translate(
                              offset: Offset(0.0, sizeHeight * -0.23),
                              child: GestureDetector(
                                onTap: () {
                                  videoController.dispose();
                                  LogFile(Log);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => logo_screen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: sizeHeight * 0.06,
                                  width: sizeWidth * 0.5,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(sizeWidth * 0.05),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.touch,
                                      style: TextStyle(
                                        fontSize: sizeWidth * 0.042,
                                        fontFamily: 'SukhumvitSet-Medium',
                                        fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          ),
                                        ),),
                                       ]))
                                     ]);
                                        } else {
                                          return Container(
                                            width: sizeWidth * 1,
                                            height: sizeHeight * 1,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 650, bottom: 50),
                                                  child: Container(
                                                    height: sizeHeight * 0.25,
                                                    width: sizeWidth * 0.8,
                                                    child: Image.asset(
                                                      'assets/loading.gif',
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  'Please Wait A Moment',
                                                  style: GoogleFonts.kanit(
                                                    fontSize: sizeWidth * 0.07,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    )
                                  : Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            videoController.dispose();
                                            LogFile(Log);
                                         //   admob_times.startTimer(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    logo_screen(),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: sizeHeight * 1,
                                            width: sizeWidth * 1,
                                            child:  Transform.translate(
                                            offset: Offset(0.0, sizeHeight * -0.05),
                                           child:Image.file(
                                              File(advertisingImages),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        ),
                                        Transform.translate(
                                            offset: Offset(0.0, sizeHeight *-0.23),
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    //    videoController.Rdispose();
                                                    LogFile(Log);
                                                    videoController.dispose();
                                                   /* admob_times
                                                        .startTimer(context);*/
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            logo_screen(),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    height: sizeHeight * 0.06,
                                                    width: sizeWidth * 0.5,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              sizeWidth * 0.05),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.2),
                                                          spreadRadius: 2,
                                                          blurRadius: 4,
                                                          offset: Offset(2, 2),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,

                                                      ///แตะเพื่อเริ่ม
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .touch,
                                                        style: TextStyle(
                                                          fontSize:
                                                              sizeWidth * 0.042,
                                                          fontFamily:
                                                              'SukhumvitSet-Medium',
                                                              fontWeight: FontWeight.w700
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                               
                                              ],
                                            ))
                                      ],
                                    );
                            })),    
                        Container(
                          height: sizeHeight * 0.023,
                          width: sizeWidth * 1,
                          color: Color.fromRGBO(237, 28, 36, 1.0), // ค่าสีที่คุณต้องการใช้
                          child: Bottombar(),
                        )
                  ],
                ),
              )
            ])));
  }

  void _initializeVideoPlayer(String assetPath) async {
    final controller = VideoPlayerController.asset(assetPath);
    await controller.initialize();

    // เริ่มเล่นวิดีโอในส่วนอื่นของโค้ด
    controller.play();
  }
}
