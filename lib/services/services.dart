import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Ganti dengan URL API Flask Anda (Ngrok atau localhost)
  static const String apiUrl =
      "https://2f80-103-208-204-253.ngrok-free.app/predict";

  // Fungsi untuk mengirim gambar ke API
  static Future<Map<String, dynamic>> predictImage(File image) async {
    try {
      // Buat request multipart
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Tambahkan file gambar ke request
      var fileStream = http.ByteStream(image.openRead());
      var length = await image.length();
      var multipartFile = http.MultipartFile('file', fileStream, length,
          filename: image.path.split('/').last);
      request.files.add(multipartFile);

      // Kirim request
      var response = await request.send();

      // Cek status response
      if (response.statusCode == 200) {
        // Baca response
        var responseData = await response.stream.bytesToString();
        var result = jsonDecode(responseData);
        return result;
      } else {
        // Jika gagal, kembalikan pesan error
        return {"error": "Failed to get prediction"};
      }
    } catch (e) {
      // Tangani error
      return {"error": e.toString()};
    }
  }
}
