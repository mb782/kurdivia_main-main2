import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kurdivia/Screen/age.dart';
import 'package:kurdivia/Screen/sponsorpage.dart';
import 'package:kurdivia/constant.dart';
import 'package:kurdivia/provider/ApiService.dart';
import 'package:ntp/ntp.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Widgets/navigatebar.dart';
import '../Model/event.dart';
import '../Widgets/navigatebar.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> implements ApiStatusLogin{
  late BuildContext context;

  final phoneController = TextEditingController();

  final codeController = TextEditingController();

  String phone = '';

  @override
  void initState(){
    Future.delayed(Duration.zero).then((value)async{
      await Permission.location.request();
      var status = await Permission.notification.status;
      print(status);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<ApiService>();
    this.context = context;
    return Consumer<ApiService>(
      builder: (context, value, child) {
        value.apiListener(this);
        return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/2.jpg"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 30,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: value.image == ''
                              ? Text(
                            value.name.split('').first,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                                color: Colors.black),
                          )
                              : Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(35),
                              child: Image(
                                  image: NetworkImage(value.image),
                                  fit: BoxFit.fill),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          value.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 120,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: context.read<ApiService>().getAllEvents(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {

                            if (snapshot.hasData) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      height:
                                      MediaQuery.of(context).size.height * 0.745,
                                      child: RefreshIndicator(
                                        onRefresh: ()async{
                                          value.notifyListeners();
                                        },
                                        child: ListView.builder(
                                          itemCount: snapshot.data!.docs.length,
                                          itemBuilder: (context, index){
                                            {
                                              List list = snapshot.data!.docs[index].get('users');
                                              print(list);
                                              return Visibility(
                                                visible:list.isNotEmpty ? value.getvisibilymain(list) : true,
                                                child: DelayedDisplay(
                                                  delay: Duration(
                                                      milliseconds:
                                                      (0 + ((index + 1) * 400))
                                                          .toInt()),
                                                  fadeIn: true,
                                                  slidingCurve: Curves.easeIn,
                                                  child: InkWell(

                                                    child: Container(
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                      height: 200,
                                                      margin:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 20,
                                                          vertical: 10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(30),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Colors.black,
                                                              blurRadius: 20,
                                                              offset: Offset(0, 10),
                                                            )
                                                          ]
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          ClipRRect(
                                                            child: Image(
                                                              image: const AssetImage(
                                                                  'assets/images/3.png'),
                                                              width:
                                                              MediaQuery.of(context)
                                                                  .size
                                                                  .width,
                                                              height: 200,
                                                              fit: BoxFit.fill,
                                                            ),
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                30),
                                                          ),
                                                          Column(
                                                            children: [
                                                              DelayedDisplay(
                                                                child: Container(
                                                                  child: getdata(
                                                                      snapshot
                                                                          .data!
                                                                          .docs[index]
                                                                          .id),
                                                                ),
                                                                delay: Duration(
                                                                    milliseconds: (0 +
                                                                        ((index +
                                                                            1) *
                                                                            400))
                                                                        .toInt()),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    onTap: () async {

                                                    },
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                              //;
                            } else if (snapshot.hasError) {
                              return Column(
                                children: [
                                  SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height * 0.5,
                                  ),
                                  Text(snapshot.error.toString()),
                                ],
                              );
                            }

                            return Center(child: const CircularProgressIndicator(color: Colors.black,backgroundColor: Colors.white,));
                          },
                        )),
                  ),
                ],
              ),
            ));
      },
    );
  }

  @override
  void accountAvailable() {}

  @override
  void error() {
    ModeSnackBar.show(context, 'something go wrong', SnackBarMode.error);
  }

  @override
  void inputEmpty() {
    ModeSnackBar.show(
        context, 'username or password empty', SnackBarMode.warning);
  }

  @override
  void inputWrong() {
    ModeSnackBar.show(
        context, 'username or password incorrect', SnackBarMode.warning);
  }

  @override
  void login() {
    kNavigator(context, NavigateBar());
  }

  @override
  void passwordWeak() {
    ModeSnackBar.show(context, 'password is weak', SnackBarMode.warning);
  }

  getdata(x) {
    return Consumer<ApiService>(builder: (context, value, child) {
      return StreamBuilder<QuerySnapshot>(

        stream: context.read<ApiService>().getAllEventsData(x),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (snapshot.hasData) {
            return Container(
              height: 200,
              width: double.infinity,
              child: ListView(
                shrinkWrap: false,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(top: 5),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  EventData eventData = EventData.fromJson(
                      document.data()! as Map<String, dynamic>);
                  return Stack(
                    children: [
                      InkWell(
                        onTap: ()async{
                          await Permission.location.request();
                          var status = await Permission.notification.status;
                          print(status);
                          final url = eventData.link;
                          print(url);
                          await launch(url);
                          if (await canLaunch(
                              url)) {
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.19,
                              left: MediaQuery.of(context).size.width * 0.6),
                          width: 120,
                          height: 30,
                          decoration: const BoxDecoration(
                              color: kDarkBlue,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //crossAxisAlignment:CrossAxisAlignment.center,
                            children: [
                              Text(eventData.title),
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
                      Container(
                          margin: EdgeInsets.only(top: 10, left: 100),
                          width: 150,
                          height: 40,
                          decoration: BoxDecoration(
                            color: kLightBlue,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              eventData.date
                                  .toDate()
                                  .toString()
                                  .substring(0, 16),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          )),
                      Positioned(
                        top: 40,
                        left: 0,
                        child: Container(
                          padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          height: 30,
                          width: 60,
                          decoration: const BoxDecoration(
                              color: kBlue1,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                eventData.numwinner,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const Image(
                                image: AssetImage('assets/images/medal.png'),
                                height: 15,
                                width: 15,
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 75,
                        left: 0,
                        child: InkWell(
                          onTap: ()async{
                            // DateTime ntptime = await NTP.now();
                            // Timestamp ts = snapshot.data!.docs[0].get('date');
                            // print(ntptime.toUtc());
                            // print(ts.toDate().toUtc());
                            // print(ts.toDate().toUtc().difference(ntptime.toUtc()).inSeconds);
                            // print(ntptime.toUtc().difference(ts.toDate().toUtc()).inSeconds);

                          },
                          child: Container(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            height: 30,
                            width: 40,
                            decoration: const BoxDecoration(
                                color: kBlue1,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(30))),
                            child: Text(
                              eventData.opprice,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: true,
                        child: Positioned(
                          top: 100,
                          left: 130,
                          child: InkWell(
                            onTap: () async {
                              await value.getsponsor(snapshot.data!.docs[0].get('date'),x,snapshot.data!.docs[0].get('image'),snapshot.data!.docs[0].get('file'),snapshot.data!.docs[0].get('numwinner'));
                              kNavigator(context, SponsorPage(maxsecond: value.maxsecond));
                              if (kDebugMode) {
                                print(value.idevents);
                                print(value.maxsecond);
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: kBlue2,
                                  borderRadius: BorderRadius.circular(15)),
                              child: const Center(child: Text('Enter')),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );

                  // InkWell(
                  //   onTap: ()async{
                  //     DateTime ntptime = await NTP.now();
                  //     print(ntptime);
                  //     Timestamp ts = eventData.date;
                  //     value.maxsecond = ntptime.difference(ts.toDate()).inSeconds;
                  //     print(value.maxsecond);
                  //   },
                  //   child: Text(eventData.title,));
                }).toList(),
              ),
            );
            //;
          } else if (snapshot.hasError) {

            return Column(
              children: [
                Text(snapshot.error.toString()),
              ],
            );
          }

          return Center(child: const CircularProgressIndicator(color: Colors.black,backgroundColor: Colors.white,));
        },
      );
    });
  }
}
