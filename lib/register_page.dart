import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

import 'model/user_model.dart';
import 'service/api_service.dart';

class UserRegister extends StatefulWidget {
  @override
  _UserRegisterState createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  UserModel userModel;

  @override
  void initState() {
    super.initState();
    userModel = new UserModel();
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        key: _scaffoldKey,
        body: ProgressHUD(
          child: loginUISetup(),
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
        ),
      ),
    );
  }

  Widget loginUISetup() {
    return new SingleChildScrollView(
      child: new Container(
        child: new Form(
          key: globalFormKey,
          child: _loginUI(context),
        ),
      ),
    );
  }

  Widget _loginUI(BuildContext context) {
    return new SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [HexColor("#3f517e"), HexColor("#182545")],
              ),
              borderRadius: BorderRadius.only(
                // topLeft: Radius.circular(500),
                //topRight: Radius.circular(150),
                bottomRight: Radius.circular(150),
                //bottomLeft: Radius.circular(150),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: Image.network(
                    "https://avatars.githubusercontent.com/u/64971583?s=460&u=ccc349dd8eaafbfa73533c3316d7d729ec223e9b&v=4",
                    fit: BoxFit.contain,
                    width: 140,
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20, top: 40),
              child: Text(
                "User Signup",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
          ),
          FormHelper.inputFieldWidget(
            context,
            Icon(Icons.verified_user),
            "name",
            "Username",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return 'Username can\'t be empty.';
              }

              return null;
            },
            (onSavedVal) => {
              this.userModel.userName = onSavedVal.toString().trim(),
            },
            initialValue: "",
            paddingBottom: 20,
            onChange: (val) {},
          ),
          FormHelper.inputFieldWidget(
            context,
            Icon(Icons.email),
            "name",
            "Email Id",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return 'Email can\'t be empty.';
              }

              bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(onValidateVal);

              if (!emailValid) {
                return 'Email Invalid!';
              }

              return null;
            },
            (onSavedVal) => {
              this.userModel.emailId = onSavedVal.toString().trim(),
            },
            initialValue: "",
            paddingBottom: 20,
          ),
          FormHelper.inputFieldWidget(
            context,
            Icon(Icons.lock),
            "password",
            "Password",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return 'Password can\'t be empty.';
              }

              return null;
            },
            (onSavedVal) => {
              this.userModel.password = onSavedVal.toString().trim(),
            },
            initialValue: "",
            obscureText: hidePassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  hidePassword = !hidePassword;
                });
              },
              color: Colors.redAccent.withOpacity(0.4),
              icon: Icon(
                hidePassword ? Icons.visibility_off : Icons.visibility,
              ),
            ),
            paddingBottom: 20,
            onChange: (val) {
              this.userModel.password = val;
            },
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: FormHelper.inputFieldWidget(
              context,
              Icon(Icons.lock),
              "confirmpassword",
              "Confirm Password",
              (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return 'Confirm Password can\'t be empty.';
                }

                if (this.userModel.password != this.userModel.confirmPassword) {
                  return 'Password Mismatched!';
                }

                return null;
              },
              (onSavedVal) => {
                this.userModel.confirmPassword = onSavedVal.toString().trim(),
              },
              initialValue: "",
              obscureText: hideConfirmPassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hideConfirmPassword = !hideConfirmPassword;
                  });
                },
                color: Colors.redAccent.withOpacity(0.4),
                icon: Icon(
                  hideConfirmPassword ? Icons.visibility_off : Icons.visibility,
                ),
              ),
              onChange: (val) {
                this.userModel.confirmPassword = val;
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          new Center(
            child: FormHelper.submitButton(
              "Register",
              () {
                if (validateAndSave()) {
                  setState(() {
                    this.isApiCallProcess = true;
                  });

                  APIServices.registerUser(this.userModel)
                      .then((UserResponseModel response) {
                    setState(() {
                      this.isApiCallProcess = false;
                    });
                    if (response.code == 200) {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        "Wordpress Register",
                        response.message,
                        "Ok",
                        () {
                          Navigator.of(context).pop();
                        },
                      );
                    } else {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        "Wordpress Register",
                        response.message,
                        "Ok",
                        () {
                          Navigator.of(context).pop();
                        },
                      );
                    }
                  });
                }
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
