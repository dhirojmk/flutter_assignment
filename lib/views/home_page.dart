import 'package:flutter/material.dart';
import 'package:flutter_assignment/views/user_card.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';


class HomePage extends StatelessWidget {
  final userController = Get.put(UserController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: _buildAppBar(size),
      body: _buildBody(size),
    );
  }

  PreferredSizeWidget _buildAppBar(Size size) {
    return PreferredSize(
      preferredSize: Size.fromHeight(size.height * 0.1),
      child: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'User Management App',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25,color: Colors.white70),
        ),
        centerTitle: true,
      ),
    );
  }

  Widget _buildBody(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Obx(
            () => ListView.builder(
          padding: EdgeInsets.only(top: size.height * 0.02),
          itemCount: userController.users.length,
          itemBuilder: (context, index) {
            final user = userController.users[index];
            return UserCard(user: user);
          },
        ),
      ),
    );
  }
}
