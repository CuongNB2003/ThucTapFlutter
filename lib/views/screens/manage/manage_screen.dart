import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:thuc_tap_flutter/model/nhan_vien.dart';
import 'package:thuc_tap_flutter/views/screens/manage/detail_nv_screen.dart';
import 'package:thuc_tap_flutter/views/widgets/my_text_field_send.dart';

class ManageScreen extends StatefulWidget {
  const ManageScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return ManageScreenState();
  }
}

class ManageScreenState extends State<ManageScreen> {
  final TextEditingController searchUser = TextEditingController();
  //page
  int numberOfPage = 5;
  int currentPage = 0;
  List<NhanVien> _data = [];
  List<NhanVien> searchResult = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Hàm lấy tất cả dữ liệu
  Future<void> fetchData() async {
    String url = 'https://650d823ca8b42265ec2c502e.mockapi.io/api/user';
    // String url = 'http://192.168.1.6:3000/api/user';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      // ['data'];
      final List<NhanVien> userList =
          jsonData.map((user) => NhanVien.fromJson(user)).toList();
      if(mounted){
        setState(() {
          _data = userList;
        });
      }
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  // Hàm tìm kiếm
  Future<void> searchData(String search) async {
    String url = 'https://650d823ca8b42265ec2c502e.mockapi.io/api/user';
    // String url = 'http://192.168.1.6:3000/api/user';
    final response = await http.get(Uri.parse('$url?name=$search'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      // ['data'];
      List<NhanVien> searchResult =
          jsonData.map((user) => NhanVien.fromJson(user)).toList();
      if(mounted){
        setState(() {
          _data = searchResult;
        });
      }
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    int itemsPerPage = 8; // Số phần tử trên mỗi trang
    List<Widget> pages = [];

    final displayedData = (searchResult.isNotEmpty) ? searchResult : _data;

    for (int i = 0; i < displayedData.length; i += itemsPerPage) {
      final startIndex = i;
      final endIndex = (i + itemsPerPage) < displayedData.length
          ? (i + itemsPerPage)
          : displayedData.length;

      final dataShow = displayedData.sublist(startIndex, endIndex);
      pages.add(
        Container(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                border: TableBorder.all(
                  color: Colors.blue,
                  width: 2,
                ),
                columns: [
                  DataColumn(
                    label: SizedBox(
                      width: width * .2,
                      child: const Text("Tên",
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center),
                    ),
                  ),
                  DataColumn(
                      label: SizedBox(
                          width: width * .2,
                          child: const Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ))),
                  DataColumn(
                      label: SizedBox(
                          width: width * .2,
                          child: const Text(
                            "Phone",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ))),
                ],
                rows: dataShow
                    .map(
                      (user) => DataRow(
                          cells: [
                            DataCell(
                              Text(
                                user.name.toString(),
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            DataCell(
                              Text(
                                user.email.toString(),
                                style: const TextStyle(fontSize: 18),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DataCell(
                              Text(
                                user.phone.toString(),
                                style: const TextStyle(fontSize: 18),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                          onSelectChanged: (newValue) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailScreen(data: user),
                                ));
                          }),
                    )
                    .toList()),
          ),
        ),
      );
    }

    return SafeArea(
      child: Container(
        alignment: AlignmentDirectional.center,
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: MyTextFieldSend(
                  controller: searchUser,
                  hintText: 'Nhập tên nhân viên',
                  onTap: () => searchData(searchUser.text),
                  icon: const Icon(
                    Icons.search,
                    size: 35,
                    color: Colors.blue,
                  ),
                  messOrSearch: false),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: 650,
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      children: [
                        Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 590,
                                child: currentPage < pages.length
                                    ? pages[currentPage]
                                    : null,
                              ),
                              NumberPaginator(
                                numberPages: numberOfPage,
                                onPageChange: (index) {
                                  if(mounted){
                                    setState(() {
                                      currentPage = index;
                                    });
                                  }
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
