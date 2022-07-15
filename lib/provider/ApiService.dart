import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:hive/hive.dart';

import 'package:intl/intl.dart';
import 'package:kurdivia/Model/user.dart';
import 'package:kurdivia/Screen/country.dart';
import 'package:kurdivia/Screen/mainpage.dart';
import 'package:kurdivia/Widgets/navigatebar.dart';
import 'package:kurdivia/constant.dart';
import 'package:ntp/ntp.dart';

import '../main.dart';

import 'package:http/http.dart' as http;

enum LoginStatus { error, login, isLogin, waiting, passwordWrong, emailWrong }
enum UploadData { error, upload, waiting }
enum UploadRecord { vaccine, visit, medicalExam }




class ApiService extends ChangeNotifier {
  FirebaseFirestore fs = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  //--------------------------------------------------------//
  TextEditingController fullname = TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  TextEditingController occupation = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController agenumber = TextEditingController();

  //--------------------------------------------------------//
  TextEditingController get getfullname => fullname;

  TextEditingController get getphonenumber => phonenumber;

  TextEditingController get getoccupation => occupation;

  TextEditingController get getlocation => location;

  TextEditingController get getagenumber => agenumber;

  // [Data] --------------------------------------------//
  late DateTime firstTimer;
  late DateTime lastTimer;
  late var remainTime;
  int trueAnswerCounter=0;
  String name = 'M';
  String image = '';
  String Phonnumber = '';
  DateTime? dateTime;
  int age = 0;
  int maxsecond = 0;
  String idevents = '';
  int entertime = 0;
  bool visibily = true;
  int index = 1;
  Timestamp timeevent = Timestamp.now();
  bool checkenterevent = false;
  int numwinner = 0;

  String imagesponsor = '';
  String namesponsor = '';
  String linksponsor = '';
  bool file = false;
  bool isloading = false;

  String question = '';
  String qanswer = '';
  int answera = 0;
  int answerb = 0;
  int answerc = 0;
  bool winner = true;
  Map map = {};



  // GET
  bool loadingAuth = false;
  bool isWaitingForCode = false;
  String myVerificationId = '-1';


  bool get isAuthLoading => loadingAuth;

  String get myUser => auth.currentUser!.uid;

  String? get myUserName => auth.currentUser!.email;
  late ApiStatusLogin apiStatus;
  late UploadStatus uploadStatus;

  ///////////////////phone_number///////////////////////////
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController get getPhoneNumberController => phoneNumberController;

/////////////////////verification_code//////////////////
  TextEditingController codeController = TextEditingController();

  TextEditingController get getCodeController => codeController;

  ////////////////sign_up_form///////////////////////
  TextEditingController fullNameController = TextEditingController();

  TextEditingController get getFullNameController => fullNameController;
  TextEditingController occupationController = TextEditingController();

  TextEditingController get getOccupationController => occupationController;
  TextEditingController locationController = TextEditingController();

  TextEditingController get getLocationController => locationController;
  TextEditingController ageController = TextEditingController();

  TextEditingController get getAgeController => ageController;

  final PageController _pageController = PageController();
  PageController get pageController => _pageController;




  clearInputRegisterVet() {
    // vetDirectionController.text = '';

    notifyListeners();
  }

  apiListener(ApiStatusLogin apiStatus) {
    this.apiStatus = apiStatus;
  }

  apiListenerUpload(UploadStatus uploadStatus) {
    this.uploadStatus = uploadStatus;
  }
  setDifference() {
    remainTime=lastTimer.difference(firstTimer).inMilliseconds;
  }


  setLoading(bool b) {
    loadingAuth = b;
    notifyListeners();
  }
  setquestion(String answer){
    qanswer = answer;
    notifyListeners();
  }

  initHive() async {
    if (!Hive.isBoxOpen('login')) {
      await Hive.openBox('login');
    }
  }

  bool checkLogin() {
    if (auth.currentUser == null) {
      return false;
    } else {
      return true;
    }
  }
  ////////////////////get_data///////////////////
  Future<DocumentSnapshot<Map<String, dynamic>>> getAllUserData() {
    return fs.collection('users').doc(myUser).get();

  }
  // Future<DocumentSnapshot<Map<String, dynamic>>> getAllEventsData() {
  //   return fs.collection('events').doc().get();
  //
  // }





  Stream<QuerySnapshot> getAllEvents(){
    return fs.collection('events').orderBy('date').snapshots();

  }
  // Future<DocumentSnapshot<Map<String, dynamic>>> getAllwinner(){
  //   return fs.collection('events').doc(idevents).get();
  // }

  Future<DocumentSnapshot<Map<String, dynamic>>> getAllwinnerdetail(x){
    return fs.collection('users').doc(x).get();
  }

  Stream<QuerySnapshot> getAllEventsData(id){
    return fs.collection('events').doc(id).collection('data').snapshots();

  }
  Stream<QuerySnapshot> getAllwinner(){
    return fs.collection('events').doc(idevents).collection('winner').orderBy('counter',descending:true).orderBy('time').snapshots();

  }
  Stream<QuerySnapshot> getEventDetail(){
    return fs.collection('events').doc(idevents).collection('data').snapshots();
  }
  Stream<QuerySnapshot> getallquestion(){
    return fs.collection('events').doc(idevents).collection('question').snapshots();
  }
  Future<DocumentSnapshot<Map<String, dynamic>>> getnumusers(){
    return fs.collection('events').doc(idevents).get();
  }

  getvisibilymain(List list){
    for(int i=0;i<list.length;i++){
      if(list[i]==myUser){
        return false;
      }
    }
    return true;
  }

  getpageindex(int idx){
    index = idx + 1;
    notifyListeners();
  }
  getsponsor(Timestamp timestamp,x,String image,bool files,String num)async{
    DateTime ntptime = await NTP.now();
    Timestamp ts = timestamp;
    int second = 0;
    second = ts.toDate().toUtc().difference(ntptime.toUtc()).inSeconds - 4;
    if(second > 0 && second <= 300){
      maxsecond = second;
      visibily = true;
    }
    else if(second > 300){
      maxsecond = second;
      visibily = true;
    }
    else{
      visibily = false;
      maxsecond = 50;
    }
    numwinner = int.parse(num);
    print(numwinner);
    file = files;
    imagesponsor = image;
    idevents = x;
    timeevent = timestamp;
    trueAnswerCounter = 0;
  }


  Future<bool> getvisibilyenter (DateTime dateTime)async{
    DateTime ntp = await NTP.now();
    if(ntp.toUtc().difference(dateTime.toUtc()).inSeconds <= 300){
      return true;
    }
    else{
      return false;
    }

  }


  getcheckenter()async{
    List list = [
      myUser,
    ];
    Map<String,dynamic> map = {
      'users' : FieldValue.arrayUnion(list),
    };
    await fs.collection('events').doc(idevents).update(map);
    // if(checkenterevent == true){
    //   checkenterevent =false;
    //   notifyListeners();
    //   await checkinsiduser(false);
    //   print('----------yyyyy---------------------');
    // }
    // if(checkenterevent == false){
    //   checkenterevent == true;
    //   notifyListeners();
    //   await checkinsiduser(true);
    //   print('-----------nnnnnn--------------------');
    // }
  }
  // checkinsiduser(bool enter)async{
  //   if(enter == true){
  //
  //   }
  //   else if(enter == false){
  //     List list = [
  //       myUser,
  //     ];
  //     Map<String,dynamic> map = {
  //       'users' : FieldValue.arrayRemove(list),
  //     };
  //     await fs.collection('events').doc(idevents).update(map).whenComplete((){
  //       print('complete');
  //     }
  //     );
  //   }
  // }
  getwinner()async{
    // if(winner == true){
    //   List list = [
    //     myUser,
    //   ];
    //   Map<String,dynamic> map = {
    //     'winner' : FieldValue.arrayUnion(list),
    //   };
    //   await fs.collection('events').doc(idevents).update(map).whenComplete(() {
    //     print(winner);
    //   });
    // }
    lastTimer=DateTime.now();
    setDifference();
    Map<String,dynamic> map = {
      'counter' : trueAnswerCounter,
      'time':remainTime

    };
    await fs.collection('events').doc(idevents).collection('winner').doc(myUser).set(map).whenComplete(() {
      print(idevents);
    }).onError((error, stackTrace) => print(error));

  }
  getresetanswer(){
    answera = 0;
    answerb = 0;
    answerc = 0;
  }
  getanswer(bool answer)async{
    if( qanswer == ''){
      print('--------------------dsfhdsjk----------');
      winner = false;
      await fs.collection('events').doc(idevents).collection('question').doc(question).get().then((value){
        List lista = value.get('answera');
        List listb = value.get('answerb');
        List listc = value.get('answerc');
        answera = lista.length;
        answerb = listb.length;
        answerc = listc.length;
        notifyListeners();
      });
    }
    if( qanswer != ''){
      if(!answer){
        winner = false;
      }
      print('--------------------dsfhdsjk');
      List list = [
        myUser,
      ];
      Map<String,dynamic> map = {
        'answer$qanswer' : FieldValue.arrayUnion(list),
      };
      await fs.collection('events').doc(idevents).collection('question').doc(question).update(map).whenComplete(() async{
        await fs.collection('events').doc(idevents).collection('question').doc(question).get().then((value){
          List lista = value.get('answera');
          List listb = value.get('answerb');
          List listc = value.get('answerc');
          answera = lista.length;
          answerb = listb.length;
          answerc = listc.length;
          notifyListeners();
        });
      });
    }

  }

  checkntp()async{
    DateTime ntptime = await NTP.now();
    // print(ts.toDate().toUtc().difference(ntptime.toUtc()).inSeconds);
    if(timeevent.toDate().toUtc().difference(ntptime.toUtc()).inSeconds == 0){
      checkenterevent = true;
      notifyListeners();
    }
  }

  checkenter(Timestamp ts)async{
    DateTime ntptime = await NTP.now();
    int entertime = ntptime.difference(ts.toDate()).inSeconds;
    if(entertime <= 300){
      visibily = true;
    }
    else if(entertime > 300){
      visibily = false;
    }
    notifyListeners();
  }

  updateProfileImage(String path ) async {
    String filename = '${auth.currentUser?.uid}.${path.substring(path.length-3)}';
    File file = File(path);
    TaskSnapshot snapshot = await storage.ref().child('$myUser/profilPic/$myUser/$filename').putFile(file);
    snapshot.ref.getDownloadURL().then((value){
      Map<String,dynamic> map = {};
      map['image'] = value;
      fs.collection('users').doc(myUser).update(map).whenComplete((){
        uploadStatus.uploaded();
        print('done');
      }).onError((error, stackTrace){
        uploadStatus.error();
      });
    });
  }


  signUpWithPhoneNumber(context) async {
    isloading = true;
    if (isWaitingForCode == false) {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumberController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);

          print(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          } else {
            print(e);
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          print(verificationId);

          isWaitingForCode = true;
          notifyListeners();

          myVerificationId = verificationId;
          isloading = false;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print(verificationId);
        },
      );
    } else {
      if (myVerificationId != '-1') {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: myVerificationId, smsCode: codeController.text);
        UserCredential userCredential =
        await auth.signInWithCredential(credential);
        print(userCredential.user);
        print(auth.currentUser);
        // Map<String, dynamic> newMap = Map();
        // newMap['phone_number'] = auth.currentUser!.phoneNumber;
        // fs.collection('users').add(newMap).then((v) {
        //   notifyListeners();
        //   print(v);
        // });
        await fs.collection('users').doc(myUser).get().then((value){
          isloading = false;
          if(value.data() == null){
            kNavigator(context, InfoLogin(visible: false,));
          }
          else{
            name = value.get('name');
            image = value.get('image');
            kNavigator(context, const NavigateBar());
          }
        });

        // Sign the user in (or link) with the credential
        await auth.signInWithCredential(credential);
      }
    }
    isWaitingForCode = true;
    notifyListeners();
  }

  signUpUser() {
    String fullName = fullNameController.text;
    String occupation = occupationController.text;
    String location = locationController.text;
    String age = ageController.text;
    String? phone =(phoneNumberController.text.isEmpty)?auth.currentUser?.phoneNumber:phoneNumberController.text;
    UserData userData = UserData('',
        fullName: fullName,
        occupation: occupation,
        location: location,
        age: age, phoneNumber: phone,
        image: '');
    registerUser(userData);

  }
  Future registerUser(UserData user) async {
    if (auth.currentUser != null) {
      user.id = auth.currentUser!.uid;
      signUp(user);
    } else {
      apiStatus.error();
      setLoading(false);
    }
  }
  signUp(UserData user) async {
    user.id = myUser;
    fs.collection('users').doc(user.id).set(user.toJson()).then((value) {
      apiStatus.login();
      //clearInputRegister();
      setLoading(false);
    }).onError((error, stackTrace) {
      apiStatus.error();
      setLoading(false);
    });
  }

  InfoUser() async{
    await fs.collection('users').doc(myUser).get().then((value) {
      name = value.get('name');
      image = value.get('image');
      print(value.data());
    });
    notifyListeners();
  }
  void facebook ()async{
    final fbloginresult = await FacebookAuth.instance.login();

  }


  void LoginFacebook(context) async {
    try {
      isloading = true;
      final fbloginresult = await FacebookAuth.instance.login();
      LoginBehavior loginBehavior = LoginBehavior.webOnly;
      final userdata = await FacebookAuth.instance.getUserData();
      final FacebookAuthCredential =
      FacebookAuthProvider.credential(fbloginresult.accessToken!.token);

      await FirebaseAuth.instance.signInWithCredential(FacebookAuthCredential);
      myUser;
      fullNameController.text = userdata['name'];
      image = userdata['picture']['data']['url'];
      print(myUser);
      await fs.collection('users').doc(myUser).get().then((value){
        isloading = false;
        if(value.data() == null){
          kNavigator(context, InfoLogin(visible: true,));
        }
        else{
          name = value.get('name');
          image = value.get('image');
          kNavigator(context, const NavigateBar());
        }
      });
    } on Exception catch (e) {
      isloading = false;
      print(e);
    }
  }

  void SaveUser(context) async {
    try {
      isloading = true;
      if (fullNameController.text.isNotEmpty ||
          phoneNumberController.text.isNotEmpty ||
          occupationController.text.isNotEmpty ||
          locationController.text.isNotEmpty ||
          ageController.text.isNotEmpty) {
        fs.collection('users').doc(myUser).set({
          'name': fullNameController.text,
          'image': image,
          'phonenumber': phoneNumberController.text,
          'occupation': occupationController.text,
          'location': locationController.text,
          'age': ageController.text,
          'birthday': DateTime(dateTime!.year, dateTime!.month, dateTime!.day),
        }).whenComplete(() {
          InfoUser();
          kNavigatorreplace(context, NavigateBar());
        });
      } else {
        isloading = false;
        //erroe
      }
    } on Exception catch (e) {
      isloading = false;
      print(e);
    }
  }

  void selectdate(context) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        theme: const DatePickerTheme(
            headerColor: kLightBlue,
            backgroundColor: Colors.blue,
            itemStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
        onChanged: (date) {
          print('change $date in time zone ' +
              date.timeZoneOffset.inHours.toString());
        },
        onConfirm: (date) {
          dateTime = date;
          age = calculateAge(date);
          ageController.text = age.toString();
          notifyListeners();

          print(ageController);
          print(age);
        },
        currentTime: DateTime.now(),
        locale: LocaleType.en);
  }

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  Future signOut(BuildContext context) async {
    await auth.signOut();
    fs.clearPersistence();

    // kNavigator(context,  MyHomePage());
  }
}

abstract class UploadStatus {
  void error();

  void uploading();

  void uploaded();
}

abstract class ApiStatusLogin {
  void error();

  void login();

  void inputWrong();

  void inputEmpty();

  void accountAvailable();

  void passwordWeak();
}

enum SnackBarMode {
  error,warning,success
}

class ModeSnackBar {

  static show(BuildContext context,String text , SnackBarMode snackBarMode){

    Color textColor = Colors.white;
    Color backGroundColor = Colors.green;

    switch(snackBarMode){
      case SnackBarMode.error:
        backGroundColor = Colors.redAccent;
        textColor = Colors.grey;
        break;
      case SnackBarMode.warning:
        backGroundColor = Colors.yellowAccent;
        textColor = Colors.grey;
        break;
      case SnackBarMode.success:
        backGroundColor = Colors.green;
        textColor = Colors.grey;
        break;
    }

    SnackBar snackBar = SnackBar(
      content: Text(text ,style: TextStyle(fontFamily: 'Mont'),),
      backgroundColor: backGroundColor,
      duration: const Duration(seconds: 2),
      elevation: 2,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}


