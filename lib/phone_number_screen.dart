import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({Key? key});

  @override
   _PhoneNumberScreenState createState() =>  _PhoneNumberScreenState();
}

class  _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpCodeController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  String verificationIDReceived = "";

  bool otpCodeVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone OTPAuthentication"),
      ),
      
      body: Container(
        margin: const EdgeInsets.all(10),
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          TextField(
          controller: phoneController,

          decoration: const InputDecoration(
            labelText: "Phone"

          ),
         keyboardType: TextInputType.phone,),
         const SizedBox(height: 10,),
         Visibility(
          visible: otpCodeVisible,

          child: TextField(
          controller: otpCodeController,
            decoration: const InputDecoration(
                labelText: "code"
            ),
          ),
         ),
         const SizedBox(height: 10,),
          ElevatedButton(onPressed: (){
            if(otpCodeVisible){
              verifyCode();
            }

            else {
              verifyNumber();
            }


          }, child: Text(otpCodeVisible ? "login" : "verify"))
        ],

      )
      )
    );
  }


void verifyNumber(){

auth.verifyPhoneNumber(phoneNumber: phoneController.text,
verificationCompleted: (PhoneAuthCredential credential) async{
  await auth.signInWithCredential(credential).then((value) => {
    print("you are logged in successfully")
  });

}, verificationFailed:(FirebaseAuthException exception){
  print(exception.message);
}, codeSent: (String verificationID, int? resendToken){
 
 verificationIDReceived = verificationID;
 otpCodeVisible = true;
 setState(() {
   
 });

}, codeAutoRetrievalTimeout: (String verificationID){

});


}


void verifyCode() async {

PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationIDReceived, smsCode: otpCodeController.text);
await auth.signInWithCredential(credential).then((value) => {
   print("you are logged in successfully")
});


}






}