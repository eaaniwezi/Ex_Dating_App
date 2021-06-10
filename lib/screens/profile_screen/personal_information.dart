import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dating_app/data/data.dart';
import 'package:dating_app/data/user_repository.dart';
import 'package:dating_app/models/user.dart';
import 'package:dating_app/services/app_endpoints.dart';
import 'package:dating_app/services/networking_service.dart';
import 'package:dating_app/widgets/bordered_container.dart';
import 'package:dating_app/widgets/error_show.dart';
import 'package:dating_app/widgets/loading.dart';
import 'package:dating_app/services/snackbar_service.dart';
import 'package:dating_app/widgets/personal_textfield.dart';
import 'package:dating_app/widgets/my_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:dating_app/resourses/colors.dart';
import 'simple_crop_image.dart';
import '../../states.dart';
import 'package:image_picker/image_picker.dart';

class PersonalInformation extends StatefulWidget {
  @override
  _PersonalInformationState createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  AppStates appStates = Get.put(AppStates());
  TextEditingController _firstNameController;
  TextEditingController _lastNameController;
  TextEditingController _loginController;
  TextEditingController _emailController;
  TextEditingController _aboutMeController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  User user;
  bool _isMistake = false;
  FocusNode _focusNode;
  bool error = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _loginController = TextEditingController();
    _emailController = TextEditingController();
    _aboutMeController = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(() => print('focusNode updated: hasFocus: ${_focusNode.hasFocus}'));

    start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.light,
      appBar: AppBar(
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
        centerTitle: true,
        title: Text(
          'Personal information',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.lightBronze,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (_) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: error
              ? ErrorShow()
              : loading
                  ? Center(
                      child: Loading(
                      color: Colors.transparent,
                    ))
                  : ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            BorderedContainer(
                              children: [
                                SizedBox(
                                  width: context.mediaQuerySize.width,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 155,
                                        width: 155,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: user.avatar_url == null
                                                ? AssetImage(
                                                    Lists.profilePhotoEmpty,
                                                  )
                                                : NetworkingService.getImage(AppEndpoints.imageUrl + user.avatar_url),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      TextButton(
                                        onPressed: editAvatar,
                                        child: Text(
                                          'Edit avatar',
                                          style: TextStyle(
                                            color: AppColors.orange,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                context.width > 500
                                    ? Row(
                                        children: [
                                          PersonalTextField(
                                            text: 'First name',
                                            hintText: 'First name',
                                            controller: _firstNameController,
                                            isFull: false,
                                          ),
                                          SizedBox(width: 10),
                                          PersonalTextField(
                                            text: 'Last name',
                                            hintText: 'Last name',
                                            isFull: false,
                                            controller: _lastNameController,
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          PersonalTextField(
                                            text: 'First name',
                                            hintText: 'First name',
                                            isFull: true,
                                            controller: _firstNameController,
                                          ),
                                          PersonalTextField(
                                            text: 'Last name',
                                            hintText: 'Last name',
                                            isFull: true,
                                            controller: _lastNameController,
                                          ),
                                        ],
                                      ),
                                context.width > 500
                                    ? Row(
                                        children: [
                                          PersonalTextField(
                                            text: 'Login',
                                            hintText: 'Login',
                                            focusNode: _focusNode,
                                            controller: _loginController,
                                            isFull: false,
                                            isMistake: _isMistake,
                                            /*     onChanged: (login) {
                                          setState(() {
                                            _isMistake = _loginController.text.contains(RegExp(r'[#/"!@%?\)\()]|[а-яА-Я]')) ? true : false;
                                          });
                                          print(_isMistake);
                                        },*/
                                          ),
                                          SizedBox(width: 10),
                                          PersonalTextField(
                                            text: 'Email',
                                            hintText: 'Email',
                                            isFull: false,
                                            controller: _emailController,
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          PersonalTextField(
                                            text: 'Login',
                                            hintText: 'Login',
                                            focusNode: _focusNode,
                                            controller: _loginController,
                                            isFull: true,
                                            isMistake: _isMistake,
                                            /*  onChanged: (login) {
                                          setState(() {
                                            _login = login;
                                            _isMistake = _loginController.text.contains(RegExp(r'[#/"!@%?\)\()]|[а-яА-Я]')) ? true : false;
                                          });
                                          print(_isMistake);
                                        },*/
                                          ),
                                          PersonalTextField(
                                            text: 'Email',
                                            hintText: 'Email',
                                            isFull: true,
                                            controller: _emailController,
                                          ),
                                        ],
                                      ),
                                /*         context.width > 500
                                ? Row(
                                    children: [
                                      Container(
                                        width: context.width < 500 ? context.width : context.width / 2 - 30,
                                        child: PersonalCountryDropdown(
                                          text: 'Country',
                                          selectedItem: _country,
                                          onChanged: (country) {
                                            setState(() {
                                              _country = country;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      PersonalTextField(
                                        text: 'City',
                                        hintText: 'City',
                                        isFull: false,
                                        controller: _cityController,
                                        onChanged: (city) {
                                          setState(() {
                                            _city = city;
                                          });
                                        },
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      PersonalCountryDropdown(
                                        text: 'Country',
                                        selectedItem: _country,
                                        onChanged: (country) {
                                          setState(() {
                                            _country = country;
                                          });
                                        },
                                      ),
                                      SizedBox(width: 10),
                                      PersonalTextField(
                                        text: 'City',
                                        hintText: 'City',
                                        isFull: true,
                                        controller: _cityController,
                                        onChanged: (city) {
                                          setState(() {
                                            _city = city;
                                          });
                                        },
                                      ),
                                    ],
                                  ),*/
                                PersonalTextField(
                                  text: 'About me',
                                  hintText: 'About me',
                                  isFull: true,
                                  controller: _aboutMeController,
                                ),
                                SizedBox(height: 20),
                                FlatButton(
                                  color: AppColors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  onPressed: () {
                                    onSaveTap(context);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: context.mediaQuerySize.width,
                                    height: 58,
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
        ),
      ),
    );
  }

  void editAvatar() {
    getImageFile(ImageSource.gallery);
  }

  getImageFile(ImageSource source) async {
    //Clicking or Picking from Gallery
    try {
      PickedFile image = await ImagePicker().getImage(source: source);

      //Cropping the image
      if (image != null) {
        Get.to(SimpleCropRoute(), arguments: {'image': image}).then(
          (value) async {
            if (value != null) {
              Uint8List result = await FlutterImageCompress.compressWithFile(
                value.path,
                quality: 50,
              );
              NetworkingService.addAvatar(result);
            }
          },
        );
      }
    } catch (_) {
      //TODO
      print('Error $_');
      // throw _;
    }
  }

  get _row => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton.extended(
            label: Text("Camera"),
            onPressed: () => getImageFile(ImageSource.camera),
            heroTag: UniqueKey(),
            icon: Icon(Icons.camera),
          ),
          SizedBox(
            width: 20,
          ),
          FloatingActionButton.extended(
            label: Text("Gallery"),
            onPressed: () => getImageFile(ImageSource.gallery),
            heroTag: UniqueKey(),
            icon: Icon(Icons.photo_library),
          )
        ],
      );

  void start() async {
    try {
      if (UserRepository.user == null) {
        final response = await NetworkingService.getUser();
        UserRepository.user = User.fromJson(json.decode(response.body)['data']);
      }
      user = UserRepository.user;
      if (mounted)
        setState(() {
          _firstNameController.text = user.first_name ?? '';
          _lastNameController.text = user.last_name ?? '';
          _loginController.text = user.login ?? '';
          _emailController.text = user.public_email ?? '';
          _aboutMeController.text = user.about_me ?? '';
          loading = false;
        });
    } catch (_) {
      if (mounted)
        setState(() {
          error = false;
        });
    }
  }

  void onSaveTap(BuildContext context) async {
    try {
      setState(() {
        loading = true;
      });
      Map<String, dynamic> map = {};
      /*   'last_name': "",
        'first_name': "",
        'login': "",
        'about_me': "",
        'public_email': "",*/

      if ((_firstNameController.text.trim()?.length ?? 0) > 0) {
        map['first_name'] = _firstNameController.text;
      }
      if ((_lastNameController.text.trim()?.length ?? 0) > 0) {
        map['last_name'] = _lastNameController.text;
      }
      if ((_aboutMeController.text.trim()?.length ?? 0) > 0) {
        map['about_me'] = _aboutMeController.text;
      }
      if ((_loginController.text.trim()?.length ?? 0) > 0) {
        map['login'] = _loginController.text;
      }
      if ((_emailController.text.trim()?.length ?? 0) > 0) {
        map['public_email'] = _emailController.text;
      }
      String body = json.encode(map);
      await NetworkingService.updateUserData(body);
      setState(() {
        loading = false;
      });
      Get.back();
    } catch (_) {
      setState(() {
        loading = false;
      });

      SnackBarService.showMessage(context, 'error_to_load_user_data'.tr, _scaffoldKey, Colors.red);
    }
  }
}
