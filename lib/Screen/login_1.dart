import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:kurdivia/Screen/country.dart';
import 'package:kurdivia/Screen/login_phonenumber.dart';
import 'package:kurdivia/constant.dart';
import 'package:kurdivia/provider/ApiService.dart';
import 'package:provider/provider.dart';

class FirstPage extends StatefulWidget {
  FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final PageController _pageController = PageController();

  int pagenum = 0;




  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Container(

                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(Colors.blue.withOpacity(0.5), BlendMode.color),
                    image: AssetImage('assets/images/4.png'),
                    opacity: 0.5,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 8,
                          child: CircleAvatar(
                            backgroundColor: pagenum == 0 ?Colors.blue.shade100 : Colors.white,
                            radius: 6,
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 4.5,
                            ),
                          )
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 8,
                            child:CircleAvatar(
                              backgroundColor: pagenum == 1 ?Colors.blue.shade100 : Colors.white,
                              radius: 6,
                              child: const CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 4.5,
                              ),
                        ),
                      ),
                      ),
                    ],
                  ),
                ],
              ),
              PageView(
                onPageChanged: (value) {
                  setState(() {
                    pagenum = value;
                  });
                },
                controller: _pageController,
                physics: const ClampingScrollPhysics(),
                children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.only(top: 530, bottom: 30),
                  height: 30,
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 30,
                            spreadRadius: 10,
                            offset: Offset(0, 10),
                          )
                        ],
                        borderRadius: BorderRadius.circular(30), color: Colors.white),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        const Text(
                          'Welcome to midQ app',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        InkWell(
                          onTap: (){
                            _pageController.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                          },
                          child: Container(
                            width: 300,
                            height: 40,
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 20,
                                    offset: Offset(0, 5),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(30), color: kDarkBlue),
                            child: const Center(
                                child: Text(
                                  'Login',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    margin: const EdgeInsets.only(top: 530, bottom: 0),
                    height: 30,
                    child: Container(
                      height: 10,
                      decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              spreadRadius: 20,
                              blurRadius: 40,
                              offset: Offset(0, 5),
                            )
                          ],
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)), color: Colors.white),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          InkWell(
                            onTap: (){
                              setState(() {});
                              context.read<ApiService>().LoginFacebook(context);

                            },
                            child: Container(
                              width: 300,
                              height: 40,
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 20,
                                      offset: Offset(0, 5),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(30), color: kDarkBlue),
                              child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.facebook),
                                      Text(
                                        'Login with facebook',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: (){
                              kNavigator(context, PhoneNumber());
                            },
                            child: Container(
                              width: 300,
                              height: 40,
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 20,
                                      offset: Offset(0, 5),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(30), color: kDarkBlue),
                              child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.phone_android),
                                      Text(
                                        'Login with phone number',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text('Terms and Conditions',style: TextStyle(decoration: TextDecoration.underline,fontWeight: FontWeight.bold,fontSize: 12),),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
        context.read<ApiService>().isloading ? const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(child: CircularProgressIndicator(
                    color: Colors.black, backgroundColor: Colors.white,))): Container(),
            ],
          ),
        ));
  }
}


