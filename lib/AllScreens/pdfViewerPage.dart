import 'dart:io';

import 'package:portfolio_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart' as p;
/*
* Created by Mujuzi Moses
*/

class PDFViewerPage extends StatefulWidget {
  final File file;
  const PDFViewerPage({Key key, this.file}) : super(key: key);

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  PDFViewController controller;
  int pages = 0;
  int indexPage = 0;

  Future<bool> _onBackPressed() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Exit the PDF Viewer?"),
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
    String name = "siroDoc_${p.basename(widget.file.path)}";
    String pagesCounter = '${indexPage + 1} of $pages';

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: PickUpLayout(
        scaffold: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            backgroundColor: Colors.grey[100],
            elevation: 0,
            title: Text(name, style: TextStyle(
              fontFamily: "Brand Bold",
              color: Color(0xFFa81845),
            ),),
            actions: pages >= 2 ? <Widget>[
              Center(
                child: Text(pagesCounter, style: TextStyle(
                  fontFamily: "Brand-Regular",
                    color: Color(0xFFa81845),
                ),),
              ),
              IconButton(
                onPressed: () {
                  int page = indexPage == 0 ? pages : indexPage - 1;
                  controller.setPage(page);
                },
                icon: Icon(CupertinoIcons.chevron_back,
                  color: Color(0xFFa81845),
                ),
              ),
              IconButton(
                onPressed: () {
                  int page = indexPage == pages - 1 ? 0 : indexPage + 1;
                  controller.setPage(page);
                },
                icon: Icon(CupertinoIcons.chevron_forward,
                  color: Color(0xFFa81845),
                ),
              ),
            ] : null,
          ),
          body: PDFView(
            filePath: widget.file.path,
            swipeHorizontal: true,
            pageSnap: false,
            autoSpacing: false,
            onRender: (pages) => setState(() => this.pages = pages),
            onViewCreated: (controller) => setState(() => this.controller = controller),
            onPageChanged: (indexPage, _) => setState(() => this.indexPage = indexPage),
          ),
        ),
      ),
    );
  }
}
