import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spliteasy/HomePage.dart';

class NamePhone extends StatefulWidget {
  const NamePhone({super.key});

  @override
  State<NamePhone> createState() => _NamePhoneState();
}

class _NamePhoneState extends State<NamePhone> {
  final FocusNode _fullName = FocusNode();
  final TextEditingController _countryCode = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    _countryCode.text = '+91';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_fullName);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Sign up',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Full name',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    focusNode: _fullName,
                    controller: _nameController,
                    autofocus: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff1f2218)),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Phone # (optional)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 55,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: const Color(0xff1f2218),
                          ),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 40,
                            height: 30,
                            child: TextFormField(
                              controller: _countryCode,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const Text(
                            '|',
                            style: TextStyle(
                                fontSize: 33, color: Color(0xff1f2218)),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: TextFormField(
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Phone #(optional)'),
                          )),
                        ],
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: RichText(
                        text: const TextSpan(
                            text: 'I use ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Sofia Pro'),
                            children: [
                          TextSpan(
                              text: 'INR (₹) ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          TextSpan(text: 'as my currency.')
                        ])),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 3,
                            backgroundColor: const Color(0xffdff169),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                        fullName: _nameController.text,
                                      )),
                            );
                          },
                          child: const Text(
                            'Done',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1f2128)),
                          ))),
                  const SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: const TextSpan(
                        text: 'By registering, you accept SplitEasy ',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            height: 1.5,
                            fontFamily: 'Sofia Pro'),
                        children: [
                          TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline)),
                          TextSpan(text: ' and '),
                          TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline)),
                        ]),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
