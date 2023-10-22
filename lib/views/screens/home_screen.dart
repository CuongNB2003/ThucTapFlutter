import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thuc_tap_flutter/services/auth/auth_service.dart';
import 'package:thuc_tap_flutter/views/screens/chat/list_chat_screen.dart';
import 'package:thuc_tap_flutter/views/screens/manage/add_nv_screen.dart';
import 'package:thuc_tap_flutter/views/screens/manage/manage_screen.dart';
import 'package:thuc_tap_flutter/views/widgets/my_dialog.dart';
import 'package:thuc_tap_flutter/views/widgets/my_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userName;

  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    ListChatScreen(),
    ManageScreen(),
    Text('Cài đặt'),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void showDialogLogout() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MyDialog(
        onTap: () {
          final authService = Provider.of<AuthService>(context, listen: false);
          authService.signOut();
          Navigator.pop(context);
        },
        title: "Đăng xuất",
        content: "Bạn có muốn đăng xuất",
      ),
    );
  }

  void setName() async {
    var docSnapshot = await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .get();
    if (docSnapshot.data()!.containsKey('name')) {
      if(mounted){
        setState(() {
          userName = docSnapshot['name'];
        });
      }
    } else {
      // Handle the error or set a default value
      userName = "";
    }
  }

  void setStatus(bool status) async {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser.uid).update({
        "status": status,
      });
    } else {
      print("No current user");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setName();
    setStatus(true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      setStatus(true);
    }else {
      setStatus(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Text('Welcome '),
            userName == null
                ? const MyLoading(
                    withLoading: 15,
                    heightLoading: 15,
                    color: Colors.white,
                  )
                : Text('$userName'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddScreen(),
                ),
              );
            },
            icon: const Icon(Icons.person_add),
          ),
          IconButton(
            onPressed: showDialogLogout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_sharp),
            label: 'Manage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
