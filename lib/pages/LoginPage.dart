import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lapor_book_bk/components/input_widget.dart';
import 'package:lapor_book_bk/components/styles.dart';
import 'package:lapor_book_bk/components/validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String? password;
  String? email;
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  void login() async {
  setState(() {
    _isLoading = true;
  });

  try {
    await _auth.signInWithEmailAndPassword(
        email: email!, password: password!);

    Navigator.pushNamedAndRemoveUntil(
        context, '/dashboard', ModalRoute.withName('/dashboard'));
  } catch (e) {
    final snackbar = SnackBar(content: Text(e.toString()));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),
                    Text('Login', style: headerStyle(level:2)),
                    Container(
                      child: const Text(
                        'Login menggunakan akun anda',style: TextStyle(color: Colors.grey),
                      )
                ),
                const SizedBox(height: 50),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              InputLayout('Email', TextFormField(onChanged: (String value)=> setState(() {
                                email = value;
                              }),
                              validator: notEmptyValidator,
                              decoration: customInputDecoration("email@gmail.com"),
                              )),
                              InputLayout('Password', TextFormField(onChanged: (String value)=> setState(() {
                                password = value;
                              }),
                              validator: notEmptyValidator,
                              decoration: customInputDecoration(""),
                              )),
                              Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: double.infinity,
                            child: FilledButton(
                                style: buttonStyle,
                                child: Text('Login', style: headerStyle(level: 2)),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // aksi registrasi
                                    login();
                                  }
                                  }),
                                )
                              ],
                            )
                          )
                        ),
                        const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Belum punya akun? '),
                        InkWell(
                          onTap: () =>
                              Navigator.pushNamed(context, '/register'),
                          child: const Text('Daftar di sini',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                            )
                          ],
                        )
                      ],
                    ),
                  )),
                  );
                }
              }