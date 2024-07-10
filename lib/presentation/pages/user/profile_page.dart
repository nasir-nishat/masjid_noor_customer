import 'package:flutter/material.dart';import 'package:flutter_screenutil/flutter_screenutil.dart';import 'package:get/get.dart';import 'package:masjid_noor_customer/mgr/dependency/supabase_dep.dart';import 'package:masjid_noor_customer/presentation/pages/user/user_controller.dart';import 'package:masjid_noor_customer/presentation/widgets/spaced_column.dart';class ProfilePage extends GetView<UserController> {  const ProfilePage({super.key});  @override  Widget build(BuildContext context) {    final nameController = TextEditingController();    final emailController = TextEditingController();    final phoneController = TextEditingController();    return Padding(      padding: const EdgeInsets.all(16.0),      child: Obx(() {        nameController.text = controller.userName.value;        emailController.text = controller.userEmail.value;        phoneController.text = controller.userPhone.value;        return SpacedColumn(          crossAxisAlignment: CrossAxisAlignment.center,          verticalSpace: 20.h,          children: [            TextField(              controller: nameController,              decoration: const InputDecoration(labelText: 'Name'),            ),            TextField(              controller: emailController,              decoration: const InputDecoration(labelText: 'Email'),            ),            TextField(              controller: phoneController,              decoration: const InputDecoration(labelText: 'Phone'),            ),            const SizedBox(height: 20),            ElevatedButton(              onPressed: () {                controller.updateUserProfile(                  nameController.text,                  emailController.text,                  phoneController.text,                );              },              child: const Text('Update Profile'),            ),            ElevatedButton(                onPressed: () {                  SupabaseDep.impl.auth.signOut();                },                child: const Text('Sign Out')),          ],        );      }),    );  }}