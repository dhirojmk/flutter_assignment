import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserCard extends StatefulWidget {
  final dynamic user;

  const UserCard({super.key, required this.user});

  @override
  UserCardState createState() => UserCardState();
}

class UserCardState extends State<UserCard> {
  final userController = Get.find<UserController>();
  File? _image;

  @override
  void initState() {
    super.initState();
    final storedImage = userController.getImage(widget.user['id'].toString());
    if (storedImage != null) {
      _image = File(storedImage);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      userController.saveImage(widget.user['id'].toString(), pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.03,
        vertical: size.height * 0.01,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 6,
      shadowColor: Colors.deepPurpleAccent.withOpacity(0.2),
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.04),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatar(size), // Avatar
            SizedBox(width: size.width * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTitle(size), // Title
                  SizedBox(height: size.height * 0.01),
                  _buildSubtitle(size), // Subtitle
                ],
              ),
            ),
            _buildMenu(size), // Menu Icon
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(Size size) {
    return CircleAvatar(
      radius: size.width * 0.1,
      backgroundImage: _image != null
          ? FileImage(_image!)
          : NetworkImage(widget.user['avatar']) as ImageProvider,
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildTitle(Size size) {
    return Text(
      "${widget.user['first_name']} ${widget.user['last_name']}",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: size.width * 0.045,
        color: Colors.black87,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSubtitle(Size size) {
    return Text(
      widget.user['email'],
      style: TextStyle(
        fontSize: size.width * 0.035,
        color: Colors.grey[600],
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMenu(Size size) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'Camera') {
          _pickImage(ImageSource.camera);
        } else if (value == 'Gallery') {
          _pickImage(ImageSource.gallery);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'Camera',
          child: Text('Upload from Camera'),
        ),
        const PopupMenuItem(
          value: 'Gallery',
          child: Text('Upload from Gallery'),
        ),
      ],
      icon: Icon(
        Icons.cloud_upload,
        color: Colors.deepPurple,
        size: size.width * 0.06,
      ),
    );
  }
}
