import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_virtual_camera/widgets/text_button_widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool light = false;

  final MaterialStateProperty<Icon?> thumbIcon =
  MaterialStateProperty.resolveWith<Icon?>(
        (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );


  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context , child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Simple Virtual Camera',
          home: Scaffold(
            body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: RichText(
                              text: TextSpan(
                                  text: "Release volume button",
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.indigoAccent),
                                  children: [
                                    WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Switch(
                                          thumbIcon: thumbIcon,
                                          value: light,
                                          onChanged: (bool value){
                                            setState(() {
                                              if(light = value){
                                                _getImage();
                                              }
                                            });
                                          },
                                        )
                                    )
                                  ]
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text_button("Enabled Virtual", (){_getImage();}),
                          text_button("Disabled Virtual", (){
                            setState(() {
                              image = null;
                            });
                          }),
                        ],
                      ),
                      SizedBox(height: 10.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text_button("Select Video", (){_getVideo();}),
                        ],
                      ),
                      SizedBox(height: 10.h,),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              Container(
                                height: 220.h,
                                width: MediaQuery.of(context).size.width,
                                child: Center(child: image == null ? Text("No Data"): Image.file(image!, fit: BoxFit.cover,)),
                              ),
                              SizedBox(height: 5.h,),
                              Container(
                                  height: 220.h,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: [
                                      if(video != null)
                                        _videoPlayerController.value.isInitialized ? AspectRatio(
                                          aspectRatio: _videoPlayerController.value.aspectRatio,
                                          child: VideoPlayer(_videoPlayerController),
                                        ) : Container()
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
            ),
          ),
        );
      },
    );
  }
  File? image;

  Future _getImage() async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 80);

    if(pickedFile == null)return;
    setState(() {
      image = File(pickedFile.path);
    });
  }

  late VideoPlayerController _videoPlayerController;
  File? video;

  Future _getVideo() async {
    final XFile? cameraVideo = await ImagePicker().pickVideo(source: ImageSource.gallery);

    video = File(cameraVideo!.path);
    _videoPlayerController = VideoPlayerController.file(video!)..initialize().then((_) {
      setState(() {

      });
      _videoPlayerController.play();
    });
  }
  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
}
