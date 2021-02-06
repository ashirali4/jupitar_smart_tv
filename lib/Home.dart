import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:image_picker/image_picker.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController invoicenumber=TextEditingController();
  TextEditingController name=TextEditingController();
  TextEditingController amount=TextEditingController();
  bool sendercheck=false;
  String checkfront="Check Front";
  String checkback="Check Back";
  File front_image;
  File back_image;
  List<Attachment> list=[];
  final picker = ImagePicker();
  Future getfrontimage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        front_image = File(pickedFile.path);
        checkfront="Image Choosed";
        list.add(FileAttachment(front_image));
      } else {
        print('No image selected.');
      }
    });
  }
  Future getbackimage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        back_image = File(pickedFile.path);
        checkback="Image Choosed";
        list.add(FileAttachment(back_image));

      } else {
        print('No image selected.');
      }
    });
  }
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  final _formKey = GlobalKey<FormState>();

  Future<void> sender() async {
    String username = 'jupitercheck@gmail.com';
    String password = 'Garyelba';

    final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    final message = Message()
      ..from = Address(username, 'Jupitar Smart TV')
      ..recipients.add('jupitersmarttv@gmail.com')
      ..subject = 'Jupiter Check & Payment Submission: ${DateTime.now()}'
      ..text = 'Below are the Customer Name & Invoice Details'
      ..html = "<h1>Invoice Details</h1>\n<p>Name : ${name.text}</p>\n<p>Invoice Number : ${invoicenumber.text}</p>\n<p>Amount : ${amount.text}</p>"
       ..attachments.addAll(list);

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      sendercheck=true;
    } on MailerException catch (e) {
      print('Message not sent.' +e.toString());
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
  @override
  void initState() {
    //sender();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
    appBar: AppBar(
        title: Text(
          "Jupiter Smart Check Payment System",
          style: GoogleFonts.poppins(
               fontSize: 16,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  Text("PAYABLE TO : JUPITER SMART",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  SizedBox(height:  10,),

                  TextFormField(
                    controller: invoicenumber,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your Invoice Number';
                      }
                      return null;
                    },
                    decoration: new InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(   color: Colors.white.withOpacity(.7), width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(   color: Colors.white.withOpacity(.7), width: 1.0),
                      ),
                      hintText: 'Invoice Number',
                      hintStyle: GoogleFonts.poppins(

                      ),
                      labelText: 'Whats your Invoice Number?',
                      labelStyle: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(.7)
                      )
                    ),),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: name,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your Full Name';
                      }
                      return null;
                    },
                    decoration: new InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(   color: Colors.white.withOpacity(.7), width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(   color: Colors.white.withOpacity(.7), width: 1.0),
                        ),
                        hintText: 'Full Name',
                        hintStyle: GoogleFonts.poppins(

                        ),
                        labelText: 'Whats your Name?',
                        labelStyle: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(.7)
                        )
                    ),),
                  SizedBox(height: 20,),

                  Text("AMOUNT",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                  SizedBox(height:  10,),

                  TextFormField(
                    controller: amount,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your Amount';
                      }
                      return null;
                    },
                    decoration: new InputDecoration(

                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(   color: Colors.white.withOpacity(.7), width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(   color: Colors.white.withOpacity(.7), width: 1.0),
                        ),
                        hintText: 'Amount',
                        hintStyle: GoogleFonts.poppins(

                        ),
                        labelText: 'Payment Amount?',
                        labelStyle: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(.7)
                        ),
                      prefixIcon: Icon(Icons.attach_money,color: Colors.white,),
                    ),),
                  SizedBox(height: 30,),
                  Row(
                    children: [

                     Expanded(child:  Padding(
                       padding: const EdgeInsets.only(right: 10),
                       child: InkWell(
                         onTap: getfrontimage,
                         child: Container(
                           height: 100,
                           decoration: BoxDecoration(
                             color: Colors.black54,
                             borderRadius: BorderRadius.circular(10),
                           ),
                           child: Column(
                             children: [
                               SizedBox(height: 20,),
                               Icon(Icons.flip_to_front_outlined,color: Colors.white,size: 35,),
                               SizedBox(height: 05,),
                               Text(checkfront,
                                 style: GoogleFonts.poppins(
                                     fontWeight: FontWeight.bold
                                 ),
                               ),
                             ],
                           ),
                         ),
                       ),
                     ),flex: 1,),
                      Expanded(child:  Padding(
                        padding: const EdgeInsets.only(left:10.0),
                        child: InkWell(
                          onTap: getbackimage,
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 20,),
                                Icon(Icons.flip_to_back,color: Colors.white,size: 35,),
                                SizedBox(height: 05,),
                                Text(checkback,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),flex: 1,),


                    ],
                  ),
                  SizedBox(height: 40,),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Colors.white)),
                      onPressed: () {

                        if (_formKey.currentState.validate()) {


                          sender();

                          final snackBar = SnackBar(content: Text('Information Sent!'));
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                            name.clear();
                            invoicenumber.clear();
                            amount.clear();
                            checkfront="Check Front";
                            checkback="Check Back";
                            setState(() {

                            });

                        }
                      },
                      color: Colors.white,
                      textColor: Colors.black54,
                      child: Text("SUBMIT".toUpperCase(),
                          style: TextStyle(fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}
