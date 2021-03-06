import 'dart:io';

import 'package:darker_slate/screens/welcome_screen.dart';
import 'package:darker_slate/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String userName,
    File image,
    bool isLogin,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File _userImageFile;
  String _error;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      setState(() {
        _error = 'You must pick an image';
      });
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(_userEmail.trim(), _userPassword.trim(), _userName.trim(),
          _userImageFile, _isLogin);
    }
  }

  Widget showAlert() {
    if (_error != null) {
      return Container(
        color: Colors.amber,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 22.0),
              child: Icon(Icons.warning),
            ),
            Expanded(
              child: Text(
                _error,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  setState(() {
                    _error = null;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox(height: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              //mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                showAlert(),
                if (_isLogin)
                  Hero(
                    tag: 'logo',
                    child: Wrap(children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, WelcomeScreen.id);
                        },
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 120,
                        ),
                      ),
                    ]),
                  ),
                SizedBox(
                  height: 18,
                ),
                if (!_isLogin) UserImagePicker(_pickedImage),
                TextFormField(
                  key: ValueKey('email'),
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  decoration: kTextFieldDecoration.copyWith(
                      prefixIcon: Icon(Icons.email),
                      hintText: 'Enter your email'),
                  onSaved: (value) {
                    _userEmail = value;
                  },
                ),
                SizedBox(
                  height: 12.0,
                ),
                if (!_isLogin)
                  TextFormField(
                    key: ValueKey('username'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 4) {
                        return 'Please enter at least 4 characters.';
                      }
                      if (value.length > 24) {
                        return 'Username must be less than 25 characters.';
                      }
                      return null;
                    },
                    textAlign: TextAlign.center,
                    decoration: kTextFieldDecoration.copyWith(
                        prefixIcon: Icon(Icons.account_circle),
                        hintText: 'Enter a username'),
                    onSaved: (value) {
                      _userName = value;
                    },
                  ),
                if (!_isLogin)
                  SizedBox(
                    height: 12.0,
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  validator: (value) {
                    if (value.isEmpty || value.length < 7) {
                      return 'Password must be at least 7 characters long.';
                    }
                    return null;
                  },
                  obscureText: true,
                  textAlign: TextAlign.center,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password'),
                  onSaved: (value) {
                    _userPassword = value;
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: FlatButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_left, color: Colors.red[900]),
                            Text(
                              _isLogin ? 'Register' : 'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (widget.isLoading) CircularProgressIndicator(),
                    if (!widget.isLoading)
                      Expanded(
                        flex: 1,
                        child: RoundedButton(
                          title: (_isLogin ? 'Login' : 'Register'),
                          colour: Colors.red[900],
                          onPressed: _trySubmit,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {}, // Handle your callback.
                      splashColor: Colors.brown.withOpacity(0.5),
                      child: Ink(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/fb.png'),
                            //fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {}, // Handle your callback.
                      splashColor: Colors.brown.withOpacity(0.5),
                      child: Ink(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/gmail.png'),
                            //fit: BoxFit.cover,
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
    );
  }
}
