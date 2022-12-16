import 'package:eng/models/http_exception.dart';
import 'package:eng/screens/auth-screen.dart';
import 'package:flutter/material.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';

class ChangeUserPasswordScreen extends StatefulWidget {
  static const routeName = '/change-password';

  @override
  State<ChangeUserPasswordScreen> createState() =>
      _ChangeUserPasswordScreenState();
}

class _ChangeUserPasswordScreenState extends State<ChangeUserPasswordScreen> {
  var _oldPassController = TextEditingController();

  var _newPassController = TextEditingController();

  var _confirmPassController = TextEditingController();

  void _showDialoge(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Error'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Okay'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        actions: [],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              child: Column(
            children: [
              TextField(
                obscureText: true,
                keyboardType: TextInputType.text,
                controller: _oldPassController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Old Password',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                obscureText: true,
                keyboardType: TextInputType.text,
                controller: _newPassController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'New Password',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                obscureText: true,
                keyboardType: TextInputType.text,
                controller: _confirmPassController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm',
                ),
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_oldPassController.text.isEmpty ||
                        _newPassController.text.isEmpty ||
                        _confirmPassController.text.isEmpty) {
                      return ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('this field cannot be empty')));
                    }
                    if (_newPassController.text !=
                        _confirmPassController.text) {
                      return ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('password not match')));
                    }
                    try {
                      await Provider.of<Auth>(context, listen: false)
                          .changePassword(
                              _oldPassController.text, _newPassController.text);
                      Navigator.of(context)
                          .pushReplacementNamed(AuthScreen.routeName);

                      // Navigator.of(context).pop();
                    } on HttpException catch (error) {
                      var errorMessage = '${error}';

                      _showDialoge(errorMessage);
                    } catch (e) {
                      var errorMessage = 'Something failed!';
                      _showDialoge(e);
                    }
                  },
                  child: Text('save')),
            ],
          )),
        ),
      ),
    );
  }
}
