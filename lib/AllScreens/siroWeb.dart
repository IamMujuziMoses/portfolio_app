import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:portfolio_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:portfolio_app/AllScreens/bookAppointmentScreen.dart';
import 'package:portfolio_app/Utilities/permissions.dart';
import 'package:portfolio_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
/*
* Created by Mujuzi Moses
*/

class SiroWeb extends StatefulWidget {
  final String url;
  const SiroWeb({Key key, this.url}) : super(key: key);

  @override
  _SiroWebState createState() => _SiroWebState();
}

class _SiroWebState extends State<SiroWeb> {
  InAppWebViewController webView;
  int progressInt = 0;
  bool progressVisible = false;
  ReceivePort _port = ReceivePort();
  String id = "";
  DownloadTaskStatus status;
  int progress = 0;

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState((){});
    });

    FlutterDownloader.registerCallback(downloadCallBack);
  }

  static void downloadCallBack(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  Future<bool> _onBackPressed() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Exit the browser?"),
        actions: <Widget>[
          FlatButton(
            child: Text("No"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: Text("Yes"),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig();
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: PickUpLayout(
        scaffold: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: Colors.grey[100],
            title: Container(
              child: Row(
                children: <Widget>[
                  Text("Siro", style: TextStyle(
                      fontFamily: "Brand Bold",
                      color: Color(0xFFa81845)
                  ),),
                  Spacer(),
                  FlatButton(
                    child: Row(
                      children: <Widget>[
                        Icon(CupertinoIcons.arrowshape_turn_up_right, color: Color(0xFFa81845),),
                        Text("forward", style: TextStyle(
                          fontFamily: "Brand-Regular",
                        ),),
                      ],
                    ),
                    onPressed: () async {
                      if (await webView.canGoForward()) {
                        webView.goForward();
                      } else {
                        displaySnackBar(message: "No forward history", context: context, label: "OK");
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(CupertinoIcons.refresh_thin),
                    onPressed: () => webView.reload(),
                  ),
                  FlatButton(
                    child: Row(
                      children: <Widget>[
                        Icon(CupertinoIcons.arrowshape_turn_up_left, color: Color(0xFFa81845),),
                        Text("back", style: TextStyle(
                          fontFamily: "Brand-Regular",
                        ),),
                      ],
                    ),
                    onPressed: () async {
                      if (await webView.canGoBack()) {
                        webView.goBack();
                      } else {
                        displaySnackBar(message: "No back history", context: context, label: "OK");
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          body: Container(
            child: Stack(
              children: <Widget>[
                InAppWebView(
                  initialUrl: widget.url,
                  initialHeaders: {},
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      debuggingEnabled: true,
                      useOnDownloadStart: true,
                    ),
                  ),
                  onWebViewCreated: (controller) {
                    this.webView = controller;
                  },
                  onLoadStart: (controller, url) {
                    Future.delayed(Duration(seconds: 1), () {
                      controller.evaluateJavascript(source: "document.getElementsByTagName('header')[0].style.display='none'");
                      controller.evaluateJavascript(source: "document.getElementsByTagName('footer')[0].style.display='none'");
                    });
                  },
                  onProgressChanged: (controller, progress) {
                    setState(() {
                      progressVisible = true;
                      progressInt = progress;
                    });
                    if (progress == 100) {
                      setState(() {
                        progressVisible = false;
                      });
                    }
                  },
                  onDownloadStart: (controller, url) async {
                    if (await Permissions.cameraAndMicrophonePermissionsGranted()) {
                      await FlutterDownloader.enqueue(
                        url: url,
                        savedDir: (await getExternalStorageDirectory()).path,
                        fileName: "siro_file_${Random().nextInt(100000)}_(${Random().nextInt(100)})",
                        showNotification: true,
                        openFileFromNotification: true,
                      );
                    }
                  },
                ),
                Visibility(
                  visible: progressVisible,
                  child: Container(
                    height: 0.2 * SizeConfig.heightMultiplier,
                    child: LinearProgressIndicator(
                      value: progressInt / 100,
                      backgroundColor: Colors.grey[100],
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFa81845)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
