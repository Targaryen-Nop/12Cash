import 'package:_12sale_app/page/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:_12sale_app/styles/gobalStyle.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 150,
                  width: 200,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    image: DecorationImage(
                      image: AssetImage('assets/images/12TradingLogo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // const Text(
                      //   'Login',
                      //   style: TextStyle(
                      //     fontSize: 28,
                      //     fontWeight: FontWeight.bold,
                      //     color: Colors.blue,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      const SizedBox(height: 20),
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'ชื่อผู้ใช้งา่น',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'รหัสผ่าน',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: GobalStyles.primaryColor,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                        },
                        child: const Text(
                          'เข้าสู่ระบบ',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
