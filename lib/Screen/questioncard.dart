import 'dart:async';

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:kurdivia/Screen/winners.dart';
import 'package:kurdivia/provider/ApiService.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../constant.dart';



class QuestionCard extends StatefulWidget {
  QuestionCard({
    required this.question,
    required this.a,
    required this.b,
    required this.c,
    required this.maxsecond,
    required this.image,
    required this.isLast,
    required this.answer,
  });

  var answer;
  bool isLast;
  String question;
  String a;
  String b;
  String c;
  int maxsecond;
  String image;

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> with TickerProviderStateMixin {
  late BuildContext context;
  @override
  int Second = 1;
  int timeout = 5;
  double percent = 0;
  double value = 0;
  Timer? timer;
  bool selecteda = false;
  bool selectedb = false;
  bool selectedc = false;
  bool loading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((valuee) {
      Second = widget.maxsecond;
      percent = 100 / Second;
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (Second > 0) {
            Second--;
            value += percent;
          }
          if (Second == 0) {
            if (loading == false) {
              // Provider.of<ApiService>(context, listen: false).getanswer();
              if(checkanswer() == false){
                print('${checkanswer()}--------11111----');
                Provider.of<ApiService>(context, listen: false).getanswer(false);
              }
              else if (checkanswer() == true){
                print('${checkanswer()}-------22222-----');
                Provider.of<ApiService>(context, listen: false).getanswer(true);
              }
              loading = true;
            } else if (timeout > 0) {
              timeout--;
            } else if (timeout == 0) {
              timer.cancel();
              Provider.of<ApiService>(context, listen: false).getresetanswer();
              Provider.of<ApiService>(context, listen: false)
                  .pageController
                  .nextPage(
                  duration: const Duration(seconds: 1), curve: Curves.ease);
              if(widget.isLast== true){
                if((selectedc && widget.answer == widget.c) || (selectedb && widget.answer == widget.b) || (selecteda && widget.answer == widget.a) ||(selecteda != false && selectedb != false && selectedc != false)){
                  Provider.of<ApiService>(context, listen: false).trueAnswerCounter++;
                }
                Provider.of<ApiService>(context, listen: false).getwinner();
                kNavigatorreplace(context, Winners());

              }
              else{
                if((selectedc && widget.answer == widget.c) || (selectedb && widget.answer == widget.b) || (selecteda && widget.answer == widget.a) ||(selecteda != false && selectedb != false && selectedc != false)){
                  Provider.of<ApiService>(context, listen: false).trueAnswerCounter++;
                }
              }
              // (widget.isLast == true) ? kNavigator(context, Winners()) : null;
            }
          }
        });
      });
    });
    // TODO: implement initState
    super.initState();
  }




  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<ApiService>();
    this.context = context;
    return Consumer<ApiService>(builder: (context, value, child) {
      return Stack(
        children: [
          Positioned(
            top: 130,
            left: 20,
            child: Container(
              padding:
              EdgeInsets.only(left: 20, right: 20, bottom: 35, top: 15),
              height: 250,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.question),
                      widget.image != ''
                          ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(
                            image: NetworkImage(widget.image),
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ))
                          : Container(),
                    ]),
              ),
            ),
          ),
          Positioned(
            top: 390,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30)),
              width: MediaQuery.of(context).size.width * 0.9,
              height: 335,
              child: Column(
                children: [
                  // Container(
                  //     margin: const EdgeInsets.symmetric(horizontal: 20),
                  //     child: LinearProgressIndicator(
                  //       minHeight: 40,
                  //       value: 0.8,
                  //       valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  //     )),
                  const SizedBox(
                    height: 50,
                  ),
                  DelayedDisplay(
                    delay: Duration(milliseconds: 500),
                    slidingCurve: Curves.elasticInOut,
                    child: InkWell(
                        onTap: () {
                          if (
                          Second != 0 && value.visibily
                          // && value.visibily
                          //  && value.winner
                          //
                          ) {
                            selecteda = true;
                            selectedb = false;
                            selectedc = false;
                            value.setquestion('a');

                            value.notifyListeners();
                          }
                        },
                        child: Container(
                            alignment: Alignment.centerLeft,
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                            margin:
                            const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: selecteda
                                  ? (Second == 0)
                                  ? (widget.answer == widget.a.toString())
                                  ? Colors.lightGreenAccent
                                  : Colors.red
                                  : Colors.yellow.shade400.withOpacity(0.8)
                                  : kLightBlue,
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: LinearProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(kDarkBlue.withOpacity(0.3)),
                                    backgroundColor: Colors.transparent,
                                    minHeight: double.infinity,
                                    value: value.answera / 1000,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('A : ${widget.a}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                                      Text(value.answera.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Second != 0 ? Colors.transparent : Colors.black.withOpacity(0.4)),),
                                    ],
                                  ),
                                ),
                              ],
                            ))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DelayedDisplay(
                    delay: Duration(milliseconds: 800),
                    slidingCurve: Curves.elasticInOut,
                    child: InkWell(
                      onTap: () {
                        if (Second != 0 && value.visibily
                        //&& value.visibily
                        // && value.winner
                        ) {
                          selecteda = false;
                          selectedb = true;
                          selectedc = false;
                          value.setquestion('b');
                          value.notifyListeners();
                        }
                      },
                      child: Container(
                          height: 80,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: selectedb
                                ? (Second == 0 )
                                ? (widget.answer == widget.b.toString())
                                ? Colors.lightGreenAccent
                                : Colors.red
                                : Colors.yellow.shade400.withOpacity(0.8)
                                : kLightBlue,
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: LinearProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(kDarkBlue.withOpacity(0.3)),
                                  backgroundColor: Colors.transparent,
                                  minHeight: double.infinity,
                                  value: value.answerb / 1000,
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('B : ${widget.b}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                                    Text(value.answerb.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Second != 0 ? Colors.transparent : Colors.black.withOpacity(0.4)),),
                                  ],
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DelayedDisplay(
                    delay: Duration(milliseconds: 1100),
                    slidingCurve: Curves.elasticInOut,
                    child: InkWell(
                      onTap: () {
                        if (Second != 0 && value.visibily
                        //&& value.visibily
                        // && value.winner
                        ) {
                          selecteda = false;
                          selectedb = false;
                          selectedc = true;
                          value.setquestion('c');
                          value.notifyListeners();
                        }
                      },
                      child: Container(
                          height: 80,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: selectedc
                                ? (Second == 0 &&(selectedc || !selectedc))
                                ? (widget.answer == widget.c.toString())
                                ? Colors.lightGreenAccent
                                : Colors.red
                                : Colors.yellow.shade400.withOpacity(0.8)
                                : kLightBlue,
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: LinearProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(kDarkBlue.withOpacity(0.3)),
                                  backgroundColor: Colors.transparent,
                                  minHeight: double.infinity,
                                  value: value.answerc / 1000,
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('C : ${widget.c}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                                    Text(value.answerc.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Second != 0 ? Colors.transparent : Colors.black.withOpacity(0.4)),),
                                  ],
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 350,
            left: 170,
            child: CircleAvatar(
                backgroundColor: kDarkBlue,
                radius: 35,
                child: Stack(
                  children: [
                    getFilledProgressStyle(),
                    Align(
                      alignment: Alignment.center,
                      child:Second != 0 ? Text(
                        Second.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ) :(selectedc && widget.answer == widget.c) || (selectedb && widget.answer == widget.b) || (selecteda && widget.answer == widget.a) ||(selecteda != false && selectedb != false && selectedc != false) ? Image(image: AssetImage('assets/images/check-mark.png'),height: 40,width: 40,) : Image(image: AssetImage('assets/images/close.png'),height: 35,width: 35,),
                    ),
                  ],
                )),
          ),
        ],
      );
    });
  }

  Widget getFilledProgressStyle() {
    return Container(
        height: 120,
        width: 120,
        child: SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 100,
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            radiusFactor: 0.95,
            axisLineStyle: const AxisLineStyle(
              thickness: 0.14,
              color: kLightBlue,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: value,
                width: 0.95,
                pointerOffset: 0.05,
                sizeUnit: GaugeSizeUnit.factor,
                enableAnimation: true,
                animationType: AnimationType.ease,
                animationDuration: 500,
              )
            ],
          )
        ]));
  }
  bool checkanswer(){
    if((selecteda && widget.answer == widget.a) ||(selectedb && widget.answer == widget.b) || (selectedc && widget.answer == widget.c) ){
      return true;
    }
    else{
      return false;
    }
  }
}
