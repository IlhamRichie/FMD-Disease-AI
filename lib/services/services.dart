import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = "https://b431-103-208-204-251.ngrok-free.app/predict";

  static Future<Map<String, dynamic>> predictImage(File image) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.headers.addAll({"Content-Type": "multipart/form-data"});
      var fileStream = http.ByteStream(image.openRead());
      var length = await image.length();
      request.files.add(http.MultipartFile('file', fileStream, length, filename: image.path.split('/').last));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      return response.statusCode == 200 ? jsonDecode(responseData) : {"error": "Failed to get prediction"};
    } catch (e) {
      return {"error": e.toString()};
    }
  }
}
