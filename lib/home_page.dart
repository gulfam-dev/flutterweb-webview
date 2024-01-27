import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late bool isOnline;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        isOnline = result != ConnectivityResult.none;
      });
    });

  }


  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      await Permission.camera.request();
    }
  }



  Future<void> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isOnline = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: showExitDialog,
        child: SafeArea(
          child: isOnline
              ? const WebView(
            initialUrl: 'https://www.glamastay.co.uk/',
            javascriptMode: JavascriptMode.unrestricted,
          )
              : Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 200),
                child: Container(child: Image.asset('images/nointernet.png')),
              )),
        ),
      ),
    );
  }

  Widget loading() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.green),
      ),
    );
  }

  Future<bool> showExitDialog() async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Glamastay'),
          content: const Text('Do you want to exit the app?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        ));
  }
}
