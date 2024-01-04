import 'dart:io';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:screen/screen/logo_screen.dart';
import '../Appbar/language.dart';
import '../api/Kios_API.dart';
import '../getxController.dart/save_menu.dart';
import '../printer/printer_getx.dart';
import '../timeControl/adtime.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import '../timeControl/connect_internet.dart';

class Ads_screen extends StatefulWidget {
  final int index;
  final String videoUrl;
  Ads_screen({this.index, this.videoUrl});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Ads_screen> {
  bool isEditing = false;
  VideoPlayerController controller;
  final UsbDeviceController usbDeviceController =
      Get.put(UsbDeviceController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    final dataKios _dataKios = Get.put(dataKios());
    final int connect = 20;
    _dataKios.status.value = '';
    final connectnetwork = Get.put(connectNetwork(connect));
    connectnetwork.notcon.value = false;
    final FoodOptionController _foodOptionController =
        Get.put(FoodOptionController());
    String Log = 'Start Application : ${_foodOptionController.formattedDate}';
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;
    final int admob_time = 60;
    final admob_times = Get.put(AdMobTimeController(admob_time));
    final Random random = Random();
    return Scaffold(
        body: Column(children: [
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: sizeHeight * 0.045,
              width: sizeWidth * 1,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(sizeWidth * 0.01),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: languageBar(),
            ),
            Container(
                height: sizeHeight * 0.955,
                width: sizeWidth * 1,
                color: Colors.white,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      String videoUrl;
                      final random = Random();
                      final randomIndex =
                          random.nextInt(_dataKios.advertlist.length);
                      final advert = _dataKios.advertlist[randomIndex];
                      final kiosksId = advert.kiosksId;
                      final advertisingsId = advert.advertisingsId;
                      final advertisingName = advert.advertisingName;
                      final advertisingImages = advert.advertisingImage;
                      final advertisingImageType = advert.advertisingImageType;
                      final advertisingStartTime = advert.advertisingStartTime;
                      final advertisingEndTime = advert.advertisingEndTime;
                      final videoController =
                          VideoPlayerController.file(File(advertisingImages));

                      return (advertisingImageType == "video/mp4")
                          ? FutureBuilder(
                              future: videoController.initialize(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  videoController.setLooping(true);
                                  videoController.play();

                                  return Column(children: [
                                    GestureDetector(
                                      onTap: () {
                                        videoController.dispose();
                                        LogFile(Log);
                                        //   admob_times.startTimer(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return WillPopScope(
                                                onWillPop: () async {
                                                  // Return false to prevent the user from navigating back
                                                  return false;
                                                },
                                                child: logo_screen(),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: sizeHeight * 1,
                                        width: sizeWidth * 1,
                                        child: AspectRatio(
                                          aspectRatio:
                                              videoController.value.aspectRatio,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                            ),
                                            child: VideoPlayer(videoController),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                        height: sizeHeight * 0.2,
                                        width: sizeWidth * 1,
                                        child: Column(children: [
                                          Transform.translate(
                                            offset: Offset(0.0, -350.0),
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                    onTap: () {
                                                      videoController.dispose();
                                                      LogFile(Log);
                                                      /*  admob_times
                                                          .startTimer(context);*/

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) {
                                                            return WillPopScope(
                                                              onWillPop:
                                                                  () async {
                                                                // Return false to prevent the user from navigating back
                                                                return false;
                                                              },
                                                              child:
                                                                  logo_screen(),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    child: Column(children: [
                                                      Container(
                                                        height:
                                                            sizeHeight * 0.06,
                                                        width: sizeWidth * 0.5,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              255, 255, 255, 1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      sizeWidth *
                                                                          0.05),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.2),
                                                              spreadRadius: 2,
                                                              blurRadius: 4,
                                                              offset:
                                                                  Offset(2, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,

                                                          ///แตะเพื่อเริ่ม
                                                          child: Text(
                                                            'แตะเพื่อเริ่มต้น',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  sizeWidth *
                                                                      0.047,
                                                              fontFamily:
                                                                  'SukhumvitSet-Medium',
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Transform.translate(
                                                        offset:
                                                            Offset(0.0, -35.0),
                                                        child: Image.asset(
                                                          'assets/Tap.png',
                                                          height:
                                                              sizeHeight * 0.05,
                                                          width:
                                                              sizeWidth * 0.5,
                                                        ),
                                                      )
                                                    ])),
                                              ],
                                            ),
                                          ),
                                        ]))
                                  ]);
                                } else {
                                  return Container(
                                    width: sizeWidth * 1,
                                    height: sizeHeight * 1,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
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
                                        builder: (context) {
                                          return WillPopScope(
                                            onWillPop: () async {
                                              // Return false to prevent the user from navigating back
                                              return false;
                                            },
                                            child: logo_screen(),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: sizeHeight * 1,
                                    width: sizeWidth * 1,
                                    child: Image.file(
                                      File(advertisingImages),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Transform.translate(
                                    offset: Offset(0.0, -350.0),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            videoController.dispose();
                                            LogFile(Log);
                                            // admob_times.startTimer(context);

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return WillPopScope(
                                                    onWillPop: () async {
                                                      // Return false to prevent the user from navigating back
                                                      return false;
                                                    },
                                                    child: logo_screen(),
                                                  );
                                                },
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
                                              alignment: Alignment.center,

                                              ///แตะเพื่อเริ่ม
                                              child: Text(
                                                "แตะเพื่อเริ่มต้น",
                                                style: TextStyle(
                                                  fontSize: sizeWidth * 0.047,
                                                  fontFamily:
                                                      'SukhumvitSet-Medium',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(0.0, -35.0),
                                          child: Image.asset(
                                            'assets/Tap.png',
                                            height: sizeHeight * 0.05,
                                            width: sizeWidth * 0.5,
                                          ),
                                        )
                                      ],
                                    ))
                              ],
                            );
                    }))
          ],
        ),
      )
    ]));
  }

  void _initializeVideoPlayer(String assetPath) async {
    final controller = VideoPlayerController.asset(assetPath);
    await controller.initialize();

    // เริ่มเล่นวิดีโอในส่วนอื่นของโค้ด
    controller.play();
  }
}
