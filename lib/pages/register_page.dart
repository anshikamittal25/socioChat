import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/pages/feed_page.dart';
import 'package:instagram_clone/pages/verify_email.dart';
import 'package:instagram_clone/services/my_auth_class.dart';
import 'package:email_validator/email_validator.dart';
import 'package:instagram_clone/services/shared_pref.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey =new GlobalKey<ScaffoldState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(
                flex: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width / 8),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.black,
                      size: MediaQuery.of(context).size.width / 5,
                    )),
              ),
              Form(
                key: _formKey,
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 20,
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            validator: (s) {
                              if (s.isEmpty) {
                                return 'Please enter Email Id';
                              }
                              else if (!EmailValidator.validate(s)) {
                                return 'Invalid email.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              hintText: 'Email',
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 20,
                          child: TextFormField(
                            controller: _passwordController,
                            validator: (s) {
                              if (s.isEmpty) {
                                return 'Please enter Password';
                              }
                              return null;
                            },
                            obscureText: isObscure,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              hintText: 'Password',
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey)),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: IconButton(
                                  icon: SvgPicture.asset(
                                    (isObscure)
                                        ? ('assets/icons/eye-off-outline.svg')
                                        : ('assets/icons/eye-outline.svg'),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isObscure = !isObscure;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 20,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            color: Colors.blue,
                            child: Text(
                              'Register',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              await register(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(
                flex: 10,
              ),
              Container(
                height: 1,
                color: Colors.grey,
                width: MediaQuery.of(context).size.width,
              ),
              Spacer(
                flex: 1,
              ),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account? '),
                      Text(
                        'Log in',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  register(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      String s = await MyAuthClass.registerEmail(
          context, _emailController.text, _passwordController.text);
      if (s == 'success') {
        addBoolToSF(true);
        Navigator.push(
            context,
            MaterialPageRoute(
              //builder: (context) => VerifyEmail(email: _emailController.text,),
              builder: (context) => FeedPage(),
            ),
        );
      }
      else if (s != null) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(s),
        ));
      }
      else{
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Some error occurred.'),
        ));
      }
    }
  }
}