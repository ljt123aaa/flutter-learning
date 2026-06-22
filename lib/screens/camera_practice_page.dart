import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CameraPracticePage extends StatefulWidget {
  @override
  State<CameraPracticePage> createState() => _CameraPracticePageState();
}

class _CameraPracticePageState extends State<CameraPracticePage> {
  File? _image; // 用来存放单张照片
  List<XFile>? _imageFileList; // 用来存放多张照片
  final ImagePicker _picker = ImagePicker(); // 实例化拍照工具

  // 点击拍照按钮执行的方法
  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    // 如果用户拍了照并且没有点取消
    if (photo != null) {
      setState(() {
        _image = File(photo.path); // 把照片路径存起来，触发页面刷新
        _imageFileList = null; // 🌟 新加这行：如果拍了单张照，就把之前的多图清空
      });
    }
  }

  Future<void> _pickMultipleImages() async {
    // 调用 pickMultiImage，这会唤起系统相册并允许用户勾选多张
    final List<XFile> selectedImages = await _picker.pickMultiImage();

    // 如果用户确实选了图片（没有中途点取消）
    if (selectedImages.isNotEmpty) {
      setState(() {
        _imageFileList = selectedImages; // 把选中的图片路径存起来，触发页面刷新
        _image = null; // 清空单图展示
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('危险权限：相机测试')),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // 🌟 第一部分：照片展示区 (用 Expanded 撑开剩余空间)
          Expanded(
            child: _image != null // 如果有单张图，就显示单张
                ? Image.file(_image!, height: 300, fit: BoxFit.cover)
                : _imageFileList != null && _imageFileList!.isNotEmpty
                    ? GridView.builder(
                        padding: EdgeInsets.all(10),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // 每行显示3张图
                          crossAxisSpacing: 5, // 图片左右间距
                          mainAxisSpacing: 5, // 图片上下间距
                        ),
                        itemCount: _imageFileList!.length, // 列表有多长就画几个
                        itemBuilder: (context, index) {
                          return Image.file(
                            // 把 XFile 的路径转换成 File 并显示
                            File(_imageFileList![index].path),
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Text('你还没选择照片',
                        style: TextStyle(fontSize: 18, color: Colors.grey)),
          ),

          // 🌟 第二部分：底部的操作按钮区
          Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _takePhoto, // 点击按钮调用拍照方法
                    icon: Icon(Icons.camera_alt),
                    label: Text('拍照'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _pickMultipleImages, // 点击按钮调用拍照方法
                    icon: Icon(Icons.photo_library),
                    label: Text('相册选择多图'),
                  ),
                ],
              ))

          // // 如果有照片，就显示照片；如果没有，就显示一段文字
          // if (_image != null)
          //   Image.file(_image!, height: 300, fit: BoxFit.cover)
          // else
          //   Text('你还没拍照呢', style: TextStyle(fontSize: 18, color: Colors.grey)),
          // SizedBox(
          //   height: 30,
          // ),
          // ElevatedButton.icon(
          //   onPressed: _takePhoto, // 点击按钮调用拍照方法
          //   icon: Icon(Icons.camera_alt),
          //   label: Text('点击唤起相机'),
          // )
        ]),
      ),
    );
  }
}
