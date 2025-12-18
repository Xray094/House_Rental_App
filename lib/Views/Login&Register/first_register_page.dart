import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:house_rental_app/Components/custom_text_field.dart';
import 'package:house_rental_app/Views/Login&Register/second_register_page.dart';

class FirstRegisterPage extends StatefulWidget {
  const FirstRegisterPage({super.key});

  @override
  State<FirstRegisterPage> createState() => _FirstRegisterPageState();
}

class _FirstRegisterPageState extends State<FirstRegisterPage> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    Widget roleCard(String role, IconData icon, String label) {
      final bool isSelected = selectedRole == role;
      return InkWell(
        onTap: () => setState(() => selectedRole = role),
        child: Container(
          height: 120.h,
          width: 140.w,
          decoration: BoxDecoration(
            color: isSelected
                ? Color(0xFF1E88E5).withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
              color: isSelected ? Color(0xFF1E88E5) : Colors.grey.shade300,
              width: 2.w,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40.w,
                color: isSelected ? Color(0xFF1E88E5) : Colors.grey.shade600,
              ),
              SizedBox(height: 5.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Color(0xFF1E88E5) : Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Create Account",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LinearProgressIndicator(
              value: 0.5,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF1E88E5),
              ),
              minHeight: 5.h,
            ),
            Text(
              "1/2",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
            Image.asset("assets/images/imageForFirstRegisterPage.png"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                roleCard('tenant', Icons.person_outline, "Tenant"),
                roleCard('landlord', Icons.home_outlined, "Landlord"),
              ],
            ),
            SizedBox(height: 40.h),

            CustomTextField(
              name: 'Phone Number',
              hint: 'Ex: 9xx xxx xxx',
              prefixIcon: Icons.phone_android,
              inputType: TextInputType.phone,
              controller: mobileController,
            ),
            SizedBox(height: 20.h),
            CustomTextField(
              name: 'Password',
              hint: 'Enter your password',
              prefixIcon: Icons.lock_outline,
              inputType: TextInputType.text,
              obscureText: true,
              controller: passwordController,
            ),
            SizedBox(height: 40.h),
            ElevatedButton(
              onPressed: () {
                if (selectedRole == null ||
                    mobileController.text.isEmpty ||
                    passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Please select a role and fill in credentials.",
                      ),
                    ),
                  );
                  return;
                }
                selectedRole = selectedRole!.toLowerCase();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecondRegisterPage(
                      role: selectedRole!,
                      mobile: mobileController.text,
                      password: passwordController.text,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E88E5),
                minimumSize: Size(double.infinity, 55.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                "Next",
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Have an account? ",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade700,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E88E5),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
