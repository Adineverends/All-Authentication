import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

enum MobileVerificationState{
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE
}


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  MobileVerificationState currentState=MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final phoneController=TextEditingController();
  final otpController=TextEditingController();

  FirebaseAuth auth=FirebaseAuth.instance;

  late String verificationId;

  bool showLoading=false;

  void signInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential) async{
   setState(() {
     showLoading=true;
   });




    try {
      final authcredential = await auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading=false;
      });

      if(authcredential?.user !=null){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
      }



    } on FirebaseAuthException catch(e){
            setState(() {
              showLoading=false;
            });


            scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text("you have error"),));

    }
  }

  getMobileFormWidget(context){
    return Column(
      children:  [

        SizedBox(height: 300,),
        TextField(
         controller:phoneController ,
          decoration: InputDecoration(
            hintText: "Phone Number"
          ),
        ),

       SizedBox(height: 16,),

        FlatButton(
          onPressed: () async {
            setState(() {
              showLoading=true;
            });

            await auth.verifyPhoneNumber(
                phoneNumber: phoneController.text,
                verificationCompleted:(phoneAuthCredential) async{
                  setState(() {
                    showLoading=false;
                  });
                 // signInWithPhoneAuthCredential(phoneAuthCredential);

                },
                verificationFailed: (verificationFailed) async{
                 //scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(verificationFailed.message)));
                  setState(() {
                    showLoading=false;
                  });
                },
                codeSent: (verificationId,resendingToken) async{
                  setState(() {
                    currentState=MobileVerificationState.SHOW_OTP_FORM_STATE;
                    this.verificationId=verificationId;
                    showLoading=false;
                  });


                },
                codeAutoRetrievalTimeout:(verificationId) async{

            }

            );
          },
          child: Text("SEND"),
          color: Colors.blueAccent,
          textColor: Colors.white,


        )
      ],
    );
  }


  getOtpFormWidget(context){
    return Column(
      children:  [

        SizedBox(height: 300,),
        TextField(
          controller:otpController ,
          decoration: InputDecoration(
              hintText: "Enter OTP"
          ),
        ),

        SizedBox(height: 16,),

        FlatButton(
          onPressed: () async {
            PhoneAuthCredential phoneAuthCredential=PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otpController.text);

            signInWithPhoneAuthCredential(phoneAuthCredential);
            

            },
          child: Text("VERIFY"),
          color: Colors.blueAccent,
          textColor: Colors.white,


        )
      ],
    );
        }
        final GlobalKey<ScaffoldState> scaffoldKey=GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,

      body: Container(
        child: showLoading ? Center(child: CircularProgressIndicator(),):currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE ?
        getMobileFormWidget(context):
        getOtpFormWidget(context) ,
        padding: const EdgeInsets.all(16),
      )
    );
  }
}


