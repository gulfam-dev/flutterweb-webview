import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

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
              ? _buildWebView()
              : Center(
            child: Container(
              padding: const EdgeInsets.only(bottom: 200),
              child: Image.asset('images/nointernet.png'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWebView() {
    return WebView(
      initialUrl: 'https://www.glamastay.co.uk/',
      javascriptMode: JavascriptMode.unrestricted,
      navigationDelegate: (NavigationRequest request) {
        if (request.url.startsWith('mailto:')) {
          _launchEmail(request.url);
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
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
      ),
    );
  }
}

Future<void> _launchEmail(String url) async {
  try {
    final Uri emailUri = Uri.parse(url);
    final String emailAddress = emailUri.pathSegments.first;
    await launch('mailto:$emailAddress');
  } catch (e) {
    print('Error launching email: $e');
  }
}
