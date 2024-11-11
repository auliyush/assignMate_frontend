import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class CloudinaryApiService {
  Future<String?> uploadPdfToCloudinary(File pdfFile) async {
    try {
      // Cloudinary API URL
      String cloudinaryUrl = 'https://api.cloudinary.com/v1_1/dvpoajf1s/auto/upload';
      // The name of your upload preset
      String uploadPreset = 'AssignMate'; // Ensure this matches your Cloudinary preset

      // Verify the PDF file exists
      print('Picked file path: ${pdfFile.path}');
      if (!await pdfFile.exists()) {
        print('File does not exist at path: ${pdfFile.path}');
        return null;
      }

      // Prepare the form data for the PDF upload
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(pdfFile.path, contentType: MediaType.parse('application/pdf')),
        'upload_preset': uploadPreset,
      });

      // Create a Dio instance for HTTP request
      Response response = await Dio().post(cloudinaryUrl, data: formData);

      // Check the status of the response
      if (response.statusCode == 200) {
        print('PDF uploaded successfully: ${response.data['secure_url']}');
        return response.data['secure_url']; // Return the secure URL of the uploaded file
      } else {
        print('Failed to upload PDF: ${response.data}');
        print('Status Code: ${response.statusCode}');
        print('Response: ${response.statusMessage}');
        return null;
      }
    } catch (e) {
      print('Error uploading PDF: $e');
      return null;
    }
  }

}
