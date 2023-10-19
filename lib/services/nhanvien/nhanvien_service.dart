import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thuc_tap_flutter/model/nhan_vien.dart';

// String url = 'http://192.168.1.6:3000/api/user';
String url = 'https://650d823ca8b42265ec2c502e.mockapi.io/api/user';

Future<void> createNhanVien(NhanVien nhanVien) async {
  final response = await http.post(
    Uri.parse(url),
    headers:{'Content-Type': 'application/json; charset=UTF-8',},
    body: jsonEncode(nhanVien.toJson()),
  );

  if (response.statusCode == 201) {
    print(response.body);
    print("Thêm thành công");
  } else {
    print("Thêm thất bại");
    throw Exception('Failed to create album.');
  }
}

Future<void> updateNhanVien(NhanVien nhanVien, String id) async {
  String urlPut = '$url/$id';
  final response = await http.put(
    Uri.parse(urlPut),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(nhanVien.toJson()),
  );

  if (response.statusCode == 200) {
    print('sua thanh cong');
  } else {
    print('Xóa Thất bại');
    throw Exception('Failed to update album.');
  }
}

Future<void> deleteNhanVien(String id) async {
  String urlDel = '$url/$id';
  final http.Response response = await http.delete(
    Uri.parse(urlDel),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    print('Xóa thành công');
  } else {
    print('Failed to delete album.');
    throw Exception('Failed to delete album.');
  }
}