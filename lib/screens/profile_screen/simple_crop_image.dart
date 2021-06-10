import 'dart:io';
import 'package:dating_app/resourses/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_image_crop/simple_image_crop.dart';

class SimpleCropRoute extends StatefulWidget {
  @override
  _SimpleCropRouteState createState() => _SimpleCropRouteState();
}

class _SimpleCropRouteState extends State<SimpleCropRoute> {
  final cropKey = GlobalKey<ImgCropState>();

  Future<Null> showImage(BuildContext context, File file) async {
    new FileImage(file).resolve(new ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo info, bool _) {
          print('-------------------------------------------$info');
        },
      ),
    );
    return showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(
              'Current screenshot：',
              style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w300, color: Theme.of(context).primaryColor, letterSpacing: 1.1),
            ),
            content: Image.file(file));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final PickedFile args = Get.arguments['image'];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Zoom and Crop',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.lightBronze,
        leading: IconButton(
          highlightColor: Colors.transparent,
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset(
            'assets/images/appbar_arrow_left.svg',
            height: 20,
            width: 20,
          ),
        ),
      ),
      body: Center(
        child: ImgCrop(
          key: cropKey,
          chipRadius: 100,
          chipShape: ChipShape.rect,
          chipRatio: 1,
          maximumScale: 3,
          image: FileImage(File(args.path)),
          // handleSize: 0.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final crop = cropKey.currentState;
          final croppedFile = await crop.cropCompleted(File(args.path), preferredSize: 1000);
          Get.back(result: croppedFile);
        },
        tooltip: 'Increment',
        child: Text('Crop'),
      ),
    );
  }
}
