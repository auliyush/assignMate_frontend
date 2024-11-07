import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryApiService{
  Future<String?> uploadPdfToCloudinary(File pdfFile) async {
    final cloudName = 'dvpoajf1s';
    final preset = 'AssignMate';

    final uri = Uri.parse('https://api.cloudinary.com/v1_1/dvpoajf1s/auto/upload');

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = preset
      ..files.add(await http.MultipartFile.fromPath('file', pdfFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final responseJson = jsonDecode(responseData);
      return responseJson['secure_url']; // This is the URL of the uploaded file
    } else {
      print('Failed to upload PDF: ${response.statusCode}');
      return null;
    }
  }
}