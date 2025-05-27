import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ImgurUploader {
  static Future<String?> pickAndUploadImageToImgur() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return null;

    final imageFile = File(pickedFile.path);

    final clientId = dotenv.env['IMGUR_CLIENT_ID']!;

    final request =
        http.MultipartRequest(
            'POST',
            Uri.parse('https://api.imgur.com/3/image'),
          )
          ..headers['Authorization'] = clientId
          ..files.add(
            await http.MultipartFile.fromPath('image', imageFile.path),
          );

    final response = await request.send();
    final responseBody = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody.body);
      return data['data']['link'];
    } else {
      debugPrint('Erro ao enviar imagem: ${responseBody.body}');
      return null;
    }
  }
}
