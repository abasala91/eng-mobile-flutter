import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eng/screens/change_user_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class UserProfileScreen extends StatefulWidget {
  static const routeName = '/user-profile';

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  var isInit = true;
  var _phoneController = TextEditingController();
  var _emailController = TextEditingController();
  var _addressController = TextEditingController();

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Auth>(context, listen: false).getUser();
    }
    isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshPage() async {
    await Provider.of<Auth>(context, listen: false).getUser();
  }

  File _pickedImage;

  final ImagePicker _picker = ImagePicker();
  void _pickImage() async {
    var pickedImageFile = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);

    if (pickedImageFile == null) return;
    // File newFile = File(pickedImageFile.path);
    setState(() {
      _pickedImage = File(pickedImageFile.path);
      print(_pickedImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<Auth>(context).userData;
    _phoneController.text = userData.phoneNo;
    _emailController.text = userData.emial;
    _addressController.text = userData.address;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<Auth>(context, listen: false)
                    .updateUser(_phoneController.text, _emailController.text,
                        _addressController.text, _pickedImage)
                    .then((value) => _pickedImage = null);

                _refreshPage();
              },
              icon: Icon(Icons.save))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                          height: 100,
                          width: 100,
                          child: _pickedImage != null
                              ? Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      image: DecorationImage(
                                          image: FileImage(_pickedImage))))
                              : userData.imgUrl == null
                                  ? CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                    )
                                  : Image.network(userData.imgUrl)
                          // CircleAvatar(
                          //   radius: 40,
                          //   backgroundImage: _pickedImage != null
                          //       ? FileImage(_pickedImage)
                          //       : Image.network(userData.imgUrl),
                          //   backgroundColor: Colors.grey,
                          // ),
                          ),
                      TextButton.icon(
                          onPressed: _pickImage,
                          icon: Icon(Icons.image),
                          label: Text('choose image')),
                    ],
                  ),
                ),
                Divider(),
                Text(
                  'Name',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                Text(
                  userData.name,
                  style: TextStyle(
                      fontSize: 25, color: Colors.blue, fontFamily: 'Tajawal'),
                ),
                SizedBox(height: 10),
                Text(
                  'Subcreption ID',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                Text(
                  userData.engId,
                  style: TextStyle(
                      fontSize: 25, color: Colors.blue, fontFamily: 'Tajawal'),
                ),
                SizedBox(height: 10),
                Text(
                  'Department',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                Text(
                  userData.department,
                  style: TextStyle(
                      fontSize: 25, color: Colors.blue, fontFamily: 'Tajawal'),
                ),
                SizedBox(height: 10),
                Text(
                  'Graduation Year',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                Text(
                  userData.graduatedYear,
                  style: const TextStyle(
                      fontSize: 25, color: Colors.blue, fontFamily: 'Tajawal'),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Phone No',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                        SizedBox(
                            width: 250,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _phoneController,
                            ))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'E-mail',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                        SizedBox(
                            width: 250,
                            child: TextField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                            ))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Address',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                        SizedBox(
                            width: 250,
                            child: TextField(
                              controller: _addressController,
                            ))
                      ],
                    ),
                  ],
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(ChangeUserPasswordScreen.routeName);
                    },
                    child: Text('change password'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
