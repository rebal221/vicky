import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:body_detection/models/body_mask.dart';
import 'package:body_detection/models/image_result.dart';
import 'package:body_detection/models/pose.dart';
import 'package:body_detection/png_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:body_detection/body_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import '../classes/language.dart';
import '../components/theme/app.dart';
import '../localization/language_constants.dart';
import '../main.dart';
import '../pose_mask_painter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'imageselection.dart';

class PoseDetectionPage2 extends StatefulWidget {
  final bool selectedM;
  final bool selectedF;
  final Map user;
  final String image;
  const PoseDetectionPage2(
      {key, this.selectedM, this.selectedF, this.user, this.image});
  @override
  _PoseDetectionPage2State createState() => _PoseDetectionPage2State();
}

class _PoseDetectionPage2State extends State<PoseDetectionPage2> {
  int _selectedTabIndex = 1;
  bool _isDetectingPose = false;
  bool _isDetectingBodyMask = false;
  Image _selectedImage;
  bool detect = false;
  bool save = false;
  Pose _detectedPose;
  ui.Image _maskImage;
  Image _cameraImage;
  Size _imageSize = Size.zero;
  Future<void> _selectImage() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null || result.files.isEmpty) return;
    final path = result.files.single.path;
    if (path != null) {
      _resetState();
      setState(() {
        _selectedImage = Image.file(File(path));
      });
    }
  }

  Future<void> _detectImagePose() async {
    PngImage pngImage = await _selectedImage?.toPngImage();
    if (pngImage == null) return;
    setState(() {
      _imageSize = Size(pngImage.width.toDouble(), pngImage.height.toDouble());
    });
    final pose = await BodyDetection.detectPose(image: pngImage);
    _handlePose(pose);
  }

  Future<void> _detectImageBodyMask() async {
    PngImage pngImage = await _selectedImage?.toPngImage();
    if (pngImage == null) return;
    setState(() {
      _imageSize = Size(pngImage.width.toDouble(), pngImage.height.toDouble());
    });
    final mask = await BodyDetection.detectBodyMask(image: pngImage);
    _handleBodyMask(mask);
  }

  Future<void> _startCameraStream() async {
    final request = await Permission.camera.request();
    if (request.isGranted) {
      await BodyDetection.startCameraStream(
        onFrameAvailable: _handleCameraImage,
        onPoseAvailable: (pose) {
          if (!_isDetectingPose) return;
          _handlePose(pose);
        },
        onMaskAvailable: (mask) {
          if (!_isDetectingBodyMask) return;
          _handleBodyMask(mask);
        },
      );
      _toggleDetectPose();
    }
  }

  Future<void> _stopCameraStream() async {
    await BodyDetection.stopCameraStream();
    setState(() {
      _cameraImage = null;
      _imageSize = Size.zero;
    });
  }

  Future<XFile> saveImage() async {
    if (!detect || save) {
      return null;
    }
    // Create a temporary file to store the image
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path + "/temp_image.png";
    final tempFile = File(tempPath);
    // Write the bytes to the temporary file
    await tempFile.writeAsBytes(_result.bytes);
    setState(() {
      aa = XFile(tempPath);
      save = true;
    });
    save = true;
    _toggleDetectPose();
    _stopCameraStream();
    widget.user['level'] = 0;
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ImageSelectionScreen(
          image: XFile(tempPath).path,
          user: widget.user,
          selectedF: widget.selectedF,
          selectedM: widget.selectedM,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
    return XFile(tempPath);
  }

  Future<String> getCsrfToken() async {
    var url = Uri.parse('http://192.168.1.38:8000/csrf_token');
    http.Response response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset-UTF-8'
    });
    String csrfToken = jsonDecode(response.body)['csrf_token'];
    print(csrfToken);
    return csrfToken;
  }

  void sendData(String name, String phone, String gender, String dir,
      String img, String level) async {
    final token = await getCsrfToken();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.1.38:8000/api'),
    );
    var image = await http.MultipartFile.fromPath('image_before', img);
    request.files.add(image);
    request.fields['name'] = name;
    request.fields['phone'] = phone;
    request.fields['gender'] = gender;
    request.fields['type'] = dir;
    request.fields['level'] = level;
    request.headers['X-CSRFToken'] = token;
    request.headers['Cookie'] = 'csrftoken=$token';
    request.headers['Referer'] = 'http://192.168.1.38:8000';
    // Send the request
    var response = await request.send();
    var responseString = await response.stream.bytesToString().then((value) {
      print(jsonDecode(value));
    });
  }

  ImageResult _result;
  XFile aa = new XFile('');
  dynamic _handleCameraImage(ImageResult result) {
    // Ignore callback if navigated out of the page.
    if (!mounted) return;

    // To avoid a memory leak issue.
    PaintingBinding.instance?.imageCache?.clear();
    PaintingBinding.instance?.imageCache?.clearLiveImages();
    final image = Image.memory(
      result.bytes,
      gaplessPlayback: true,
      fit: BoxFit.contain,
    );
    setState(() {
      _cameraImage = image;
      _imageSize = result.size;
      _result = result;
    });
  }

  void _handlePose(Pose pose) {
    // Ignore if navigated out of the page.
    if (!mounted) return;
    setState(() {
      _detectedPose = pose;
    });
  }

  void _handleBodyMask(BodyMask mask) {
    // Ignore if navigated out of the page.
    if (!mounted) return;
    if (mask == null) {
      setState(() {
        _maskImage = null;
      });
      return;
    }

    final bytes = mask.buffer
        .expand(
          (it) => [0, 0, 0, (it * 255).toInt()],
        )
        .toList();
    ui.decodeImageFromPixels(Uint8List.fromList(bytes), mask.width, mask.height,
        ui.PixelFormat.rgba8888, (image) {
      setState(() {
        _maskImage = image;
      });
    });
  }

  Future<void> _toggleDetectPose() async {
    if (_isDetectingPose) {
      await BodyDetection.disablePoseDetection();
    } else {
      await BodyDetection.enablePoseDetection();
    }

    setState(() {
      _isDetectingPose = !_isDetectingPose;
      _detectedPose = null;
    });
  }

  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }

  Widget get _selectedTab => _selectedTabIndex == 0
      ? _imageDetectionView
      : _selectedTabIndex == 1
          ? _cameraDetectionView
          : null;

  void _resetState() {
    setState(() {
      _maskImage = null;
      _detectedPose = null;
      _imageSize = Size.zero;
    });
  }

  Widget get _imageDetectionView => SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              GestureDetector(
                child: ClipRect(
                  child: CustomPaint(
                    child: _selectedImage,
                    foregroundPainter: PoseMaskPainter(
                      pose: _detectedPose,
                      mask: _maskImage,
                      imageSize: _imageSize,
                    ),
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: _selectImage,
                child: const Text('Select image'),
              ),
              OutlinedButton(
                onPressed: _detectImagePose,
                child: const Text('Detect pose'),
              ),
              OutlinedButton(
                onPressed: _detectImageBodyMask,
                child: const Text('Detect body mask'),
              ),
              OutlinedButton(
                onPressed: _resetState,
                child: const Text('Clear'),
              ),
            ],
          ),
        ),
      );

  Widget get _cameraDetectionView => SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              ClipRect(
                child: CustomPaint(
                  child: _cameraImage,
                  foregroundPainter: PoseMaskPainter(
                    pose: _detectedPose,
                    mask: _maskImage,
                    imageSize: _imageSize,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
    _startCameraStream();
  }

  @override
  Widget build(BuildContext context) {
    if (_detectedPose != null) {
      if (_detectedPose.landmarks != null &&
          _detectedPose.landmarks.isNotEmpty) {
        if (widget.user['direction'] == 'Side') {
          if (_detectedPose.landmarks[12].position.x < 170 &&
              _detectedPose.landmarks[12].position.x > 120 &&
              _detectedPose.landmarks[12].position.y < 190 &&
              _detectedPose.landmarks[12].position.y > 160) {
            detect = true;
            setState(() {
              detect = true;
            });
          } else {
            detect = false;
            setState(() {
              detect = false;
            });
          }
        } else {
          if (_detectedPose.landmarks[11].position.x < 350 &&
              _detectedPose.landmarks[11].position.x > 300 &&
              _detectedPose.landmarks[12].position.x < 170 &&
              _detectedPose.landmarks[12].position.x > 120 &&
              _detectedPose.landmarks[11].position.y < 190 &&
              _detectedPose.landmarks[11].position.y > 160 &&
              _detectedPose.landmarks[12].position.y < 190 &&
              _detectedPose.landmarks[12].position.y > 160) {
            detect = true;
          } else {
            detect = false;
          }
          setState(() {
            detect = detect;
          });
        }
      }
    }

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: AnimatedContainer(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 1000),
            height: 110,
            alignment: Alignment.bottomCenter,
            color: AppColors.backgroundColor,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 70,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 8),
                    child: Image.asset(
                      'assets/images/OndaLogo.png',
                      height: 70,
                      width: 150,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20.0, left: 20),
                  child: Container(
                    height: 70,
                    width: 150,
                    child: Center(
                      child: DropdownButton<Language>(
                        underline: SizedBox(),
                        icon: const Icon(
                          Icons.language,
                          size: 25,
                          color: AppColors.primaryColor,
                        ),
                        onChanged: (Language language) {
                          _changeLanguage(language);
                        },
                        items: Language.languageList()
                            .map<DropdownMenuItem<Language>>(
                              (e) => DropdownMenuItem<Language>(
                                value: e,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      e.flag,
                                      style: TextStyle(fontSize: 30),
                                    ),
                                    Text(e.name)
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRect(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: CustomPaint(
                            child: _cameraImage,
                            foregroundPainter: PoseMaskPainter(
                              pose: _detectedPose,
                              mask: _maskImage,
                              imageSize: _imageSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height *
                            (widget.user['direction'] == 'Side' ? 0.4 : 0.3),
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height *
                                (widget.user['direction'] == 'Side'
                                    ? 0.15
                                    : 0.17)),
                        child: Builder(
                          builder: (BuildContext context) {
                            bool isDetect = detect;
                            return Image.asset(
                              widget.user['direction'] == 'Side'
                                  ? 'assets/images/${detect ? 'goodSideBody.png' : 'wrongSideBody.png'}'
                                  : 'assets/images/${detect ? 'goodBody.png' : 'wrongBody.png'}',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    children: [
                      Text(
                        "Keep your Waist in aim and Wait for Detection",
                        style: TextStyle(fontSize: 27),
                      ),
                      Visibility(
                        visible: detect,
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            CountDownIndicator(
                              countDownFrom: 4,
                              saveImage: saveImage,
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Detection in progress...",
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class CountDownIndicator extends StatefulWidget {
  final int countDownFrom;
  final Color color;
  final void Function() saveImage;

  CountDownIndicator({
    @required this.countDownFrom,
    @required this.color,
    @required this.saveImage,
  })  : assert(countDownFrom > 0),
        assert(color != null);

  @override
  _CountDownIndicatorState createState() => _CountDownIndicatorState();
}

class _CountDownIndicatorState extends State<CountDownIndicator> {
  int _currentCount;

  @override
  void initState() {
    super.initState();
    _currentCount = widget.countDownFrom;
    _startCountdown();
  }

  void _startCountdown() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_currentCount < 1) {
          timer.cancel();
          widget.saveImage?.call();
        } else {
          _currentCount--;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(widget.color),
        ),
        Text(
          '$_currentCount',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: widget.color,
          ),
        ),
      ],
    );
  }
}
