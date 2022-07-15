import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:kurdivia/Screen/country.dart';
import 'package:kurdivia/constant.dart';
import 'package:kurdivia/provider/ApiService.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../Widgets/video_player_widget.dart';

class Winners extends StatefulWidget {
  Winners({Key? key}) : super(key: key);

  @override
  State<Winners> createState() => _WinnersState();
}

class _WinnersState extends State<Winners> implements ApiStatusLogin {
  late BuildContext context;

  final phoneController = TextEditingController();

  final codeController = TextEditingController();

  String phone = '';
  late VideoPlayerController controller2;


  final controller = ConfettiController();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value){
      controller2 = VideoPlayerController.network(Provider.of<ApiService>(context, listen: false).imagesponsor)
        ..addListener(() => setState(() {}))
        ..setLooping(true)
        ..initialize().then((_) => controller2.play());
      controller.play();
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    controller2.pause();
    controller2.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<ApiService>();
    this.context = context;
    return Consumer<ApiService>(builder: (context, value, child) {
      value.apiListener(this);
      return SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/2.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(right: 20, top: 20, left: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(
                            width: 130,
                          ),
                          Text(
                            value.namesponsor,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 80,
                          ),
                          InkWell(
                            onTap: () {
                              kNavigatorBack(context);
                            },
                            child: Container(
                              child: const Image(
                                image: AssetImage('assets/images/cancel.png'),
                                height: 30,
                                width: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 10,
                                  spreadRadius: 5,
                                  offset: Offset(0, 10),
                                )
                              ],
                            ),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            height: 250,
                            child: value.file == true ? ClipRRect(
                              child: Image(
                                image: NetworkImage(value.imagesponsor),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ) : VideoPlayerWidget(controller: controller2),
                          ),
                        ),
                      ),
                    ],
                  )),
              InkWell(
                onTap: ()async{
                  final url = value.linksponsor;
                  await launch(url);
                  if (await canLaunch(
                      url)) {
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery
                        .of(context)
                        .size
                        .height * 0.45,
                    left: MediaQuery
                        .of(context)
                        .size
                        .width * 0.34,
                  ),
                  width: 140,
                  height: 50,
                  decoration: BoxDecoration(
                      color: kLightBlue, borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //crossAxisAlignment:CrossAxisAlignment.center,
                    children: [
                      Text(value.namesponsor),
                      const Center(
                          child: Image(
                            image: AssetImage('assets/images/share.png'),
                            height: 15,
                            width: 15,
                          ))
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: controller,
                  shouldLoop: true,
                  blastDirectionality: BlastDirectionality.explosive,
                  numberOfParticles: 5,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: DelayedDisplay(
                  slidingCurve: Curves.bounceInOut,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 5),
                    height: 300,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 30,
                            spreadRadius: 10,
                            offset: Offset(0, 10),
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // const SizedBox(
                        //   child: Text(
                        //     'WINNERS ',
                        //     style: TextStyle(
                        //         fontWeight: FontWeight.bold, fontSize: 15),
                        //   ),
                        //
                        // ),
                        Container(
                          height: 90,
                          width: 250,
                          child: Image.asset(
                            'assets/images/winner.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.24,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: context.read<ApiService>().getAllwinner(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {

                              if (snapshot.hasData) {
                                return ListView.builder(
                                    itemCount: (snapshot.data!.size >= value.numwinner) ? value.numwinner: snapshot.data!.size,

                                    itemBuilder: (context,index){
                                      return Container(
                                          margin: EdgeInsets.symmetric(vertical: 5),
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          height: 75,
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.8,
                                          decoration: BoxDecoration(
                                              color: kLightBlue,
                                              borderRadius: BorderRadius.circular(30)),
                                          child: getwinnerdetail(snapshot.data?.docs[index].id));
                                    });
                                //;
                              } else if (snapshot.hasError) {
                                return SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height:
                                        MediaQuery.of(context).size.height * 0.5,
                                      ),
                                      Text(snapshot.error.toString()),
                                    ],
                                  ),
                                );
                              }

                              return Center(child: const CircularProgressIndicator(color: Colors.black,backgroundColor: Colors.white,));
                            },
                          ),
                        ),
                        ListView(
                          shrinkWrap: true,
                          children: const[

                            // Container(
                            //     height: 75,
                            //     width: MediaQuery
                            //         .of(context)
                            //         .size
                            //         .width * 0.8,
                            //     decoration: BoxDecoration(
                            //         color: Colors.pinkAccent,
                            //         borderRadius: BorderRadius.circular(30)),
                            //     child: const Center(
                            //       child: Text('samuel el jack'),
                            //     )),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // Container(
                            //     height: 75,
                            //     width: MediaQuery
                            //         .of(context)
                            //         .size
                            //         .width * 0.8,
                            //     decoration: BoxDecoration(
                            //         color: Colors.pinkAccent,
                            //         borderRadius: BorderRadius.circular(30)),
                            //     child: const Center(
                            //       child: Text('antony hapkings'),
                            //     ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.black,
        ),
      );
    });
  }

  getwinnerdetail(id) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: context.read<ApiService>().getAllwinnerdetail(id),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if(snapshot.hasData){
            return Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: snapshot.data!.get('image') == ''
                        ? Text(
                      snapshot.data!.get('name').split('').first,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    )
                        : Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Image(
                            image: NetworkImage(snapshot.data!.get('image')),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Center(
                    child: Text(snapshot.data!.get('name'),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                  ),
                ]
            );
          }
          return Center(child: const CircularProgressIndicator(color: Colors.black,backgroundColor: Colors.white,));
        });
  }

  @override
  void accountAvailable() {
    // TODO: implement accountAvailable
  }

  @override
  void error() {
    // TODO: implement error
  }

  @override
  void inputEmpty() {
    // TODO: implement inputEmpty
  }

  @override
  void inputWrong() {
    // TODO: implement inputWrong
  }

  @override
  void login() {
    // TODO: implement login
  }

  @override
  void passwordWeak() {
    // TODO: implement passwordWeak
  }
}
