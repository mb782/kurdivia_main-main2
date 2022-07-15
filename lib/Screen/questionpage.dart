import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:kurdivia/Screen/questioncard.dart';
import 'package:kurdivia/provider/ApiService.dart';
import 'package:provider/provider.dart';

import '../constant.dart';

class QuestionPage extends StatefulWidget {
  QuestionPage({Key? key}) : super(key: key);

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  late BuildContext context;

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    context.read<ApiService>();
    this.context = context;
    return Consumer<ApiService>(builder: (context, value, child) {
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
                  top: 20,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          color: kDarkBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Image(
                              image: AssetImage('assets/images/user.png'),
                              height: 20,
                              color: Colors.white,
                            ),
                            FutureBuilder<DocumentSnapshot>(
                                future: value.getnumusers(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    List list = snapshot.data!.get('users');
                                    return Text(
                                      list.length.toString(),style: TextStyle(color: Colors.white),);
                                  }
                                  return CircularProgressIndicator();
                                }),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 55,
                      ),
                      Text(
                        value.namesponsor,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 100,
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     kNavigatorBack(context);
                      //   },
                      //   child: Container(
                      //     margin: EdgeInsets.symmetric(horizontal: 20),
                      //     child: const Image(
                      //       image: AssetImage('assets/images/cancel.png'),
                      //       height: 30,
                      //       width: 30,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 75,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            child: Image(
                              image: AssetImage('assets/images/speaker.png'),
                              height: 30,
                              width: 30,
                            ),
                          ),
                          const SizedBox(
                            width: 120,
                          ),
                          CircleAvatar(
                            child: Text(value.index.toString()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: context.read<ApiService>().getallquestion(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        print('hasError');
                        return const Text('Something went wrong');
                      }
                      // if (snapshot.connectionState == ConnectionState.waiting) {
                      //   return const Center(
                      //     child: Center(child: CircularProgressIndicator()),
                      //
                      // );
                      // }
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text('No Data'),
                          );
                        }
                        return PageView.builder(
                            onPageChanged: value.getpageindex,
                            physics: NeverScrollableScrollPhysics(),
                            controller: value.pageController,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              value.question = snapshot.data!.docs[index].id;
                              return QuestionCard(
                                question:
                                snapshot.data!.docs[index].get('question'),
                                a: snapshot.data!.docs[index].get('a'),
                                b: snapshot.data!.docs[index].get('b'),
                                c: snapshot.data!.docs[index].get('c'),
                                maxsecond: snapshot.data!.docs[index].get('time'),
                                image: snapshot.data!.docs[index].get('image'),
                                isLast: (index + 1 == snapshot.data?.size)
                                    ? true
                                    : false,
                                answer: snapshot.data!.docs[index].get('answer'),
                              );


                            });
                      }

                      return Center(child: CircularProgressIndicator());

                    }
                ),
              ],
            ),
          ));
    });
  }
}
