import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucky_depot/vm/logincontroller.dart';



class MyApp extends StatelessWidget {
  MyApp({super.key});
  final LoginController loginController = Get.find();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lucky Depot Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        textTheme: GoogleFonts.poppinsTextTheme(), // Google Fonts 적용
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends HookWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    final idController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoading = useState(false);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 로고
            Image.asset("images/luckydepot.png", height: 120), // 로고 추가 (assets 폴더 필요)
            const SizedBox(height: 20),

            // 로그인 폼
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ID 입력 필드
                    TextField(
                      controller: idController,
                      decoration: const InputDecoration(
                        labelText: "ID",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 비밀번호 입력 필드
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 로그인 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading.value
                            ? null
                            : () async {
                                isLoading.value = true;
                                await loginAction(idController.text.trim(), passwordController.text.trim());
                                // await Future.delayed(const Duration(seconds: 2)); // API 요청 대체
                                isLoading.value = false;
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isLoading.value
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Login",
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  loginAction(id, password)async{
    Get.find<LoginController>().login(id, password);
  }
}
