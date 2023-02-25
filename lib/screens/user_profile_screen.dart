import 'dart:io';
import '../widgets/app_drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eng/screens/change_user_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

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

  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (isInit) {
      _isLoading = true;
      Provider.of<Auth>(context, listen: false)
          .getUser()
          .then((value) => _isLoading = false);
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
        source: ImageSource.gallery, imageQuality: 100, maxWidth: 500);

    if (pickedImageFile == null) return;
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
          ElevatedButton.icon(
              onPressed: () {
                Provider.of<Auth>(context, listen: false).updateUser(
                    _phoneController.text,
                    _emailController.text,
                    _addressController.text,
                    _pickedImage);
                _pickedImage = null;
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.success,
                  // animType: AnimType.rightSlide,
                  title: 'Done!',
                  desc: 'Successfully Saved',
                  // btnCancelOnPress: () {},
                  btnOkOnPress: () {
                    setState(() {
                      _refreshPage();
                    });
                  },
                ).show();
              },
              label: Text("Save"),
              icon: Icon(Icons.save))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            InkWell(
                              onTap: _pickImage,
                              child: Container(
                                  height: 200,
                                  width: 200,
                                  child: _pickedImage != null
                                      ? Container(
                                          height: 200,
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              image: DecorationImage(
                                                  image:
                                                      FileImage(_pickedImage))))
                                      : userData.imgUrl == null
                                          ? CircleAvatar(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                            )
                                          : CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  userData.imgUrl))),
                            ),
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
                            fontSize: 25,
                            color: Colors.blue,
                            fontFamily: 'Tajawal'),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Membership ID',
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                      Text(
                        userData.engId,
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.blue,
                            fontFamily: 'Tajawal'),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Department',
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                      Text(
                        userData.department,
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.blue,
                            fontFamily: 'Tajawal'),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Graduation Year',
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                      Text(
                        userData.graduatedYear,
                        style: const TextStyle(
                            fontSize: 25,
                            color: Colors.blue,
                            fontFamily: 'Tajawal'),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Phone No',
                                style:
                                    TextStyle(fontSize: 15, color: Colors.grey),
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
                                style:
                                    TextStyle(fontSize: 15, color: Colors.grey),
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
                              const Text(
                                'Address',
                                style:
                                    TextStyle(fontSize: 15, color: Colors.grey),
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
                          child: const Text('Change password')),
                      userData.isSubPaid == false
                          ? Transform(
                              transform: Matrix4.identity()..scale(0.9),
                              child: const Chip(
                                backgroundColor:
                                    Color.fromARGB(255, 245, 103, 38),
                                label: Text(
                                  ' يوجد مديونيات',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 7, 0)),
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
      ),
      drawer: AppDrawer(),
    );
  }
}
