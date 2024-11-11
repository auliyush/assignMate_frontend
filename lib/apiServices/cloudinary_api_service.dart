import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class CloudinaryApiService {
  // Future<String?> uploadPdfToCloudinary(File pdfFile) async {
  //   try {
  //     String cloudinaryUrl = 'https://api.cloudinary.com/v1_1/dsa4kjdif/auto/upload';
  //     String uploadPreset = 'assignmate';
  //
  //     FormData formData = FormData.fromMap({
  //       'file': await MultipartFile.fromFile(pdfFile.path, contentType: MediaType.parse('multipart/form-data')),
  //       'upload_preset': uploadPreset,
  //     });
  //
  //     Response response = await Dio().post(cloudinaryUrl, data: formData);
  //
  //     if (response.statusCode == 200) {
  //         String uploadedImageUrl = response.data['secure_url'];
  //         print(uploadedImageUrl);
  //         return uploadedImageUrl;
  //     } else {
  //       print('Failed to upload image: ${response.statusMessage}');
  //     }
  //   } catch (e) {
  //     print('Error uploading image: $e');
  //   }
  // }

}
