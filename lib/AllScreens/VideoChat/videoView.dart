import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
/*
* Created by Mujuzi Moses
*/

class VideoView extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final bool showControls;
  final bool isAd;
  VideoView({Key key, @required this.videoPlayerController, this.looping, this.showControls, this.isAd}) : super(key: key);

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  VideoPlayerController _controller;
  ChewieController _chewieController;
  Future<void> _future;

  @override
  void initState() {
    super.initState();
    _controller = widget.videoPlayerController;
    _future = initVideoPlayer();
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<void> initVideoPlayer() async {
    IconData icon = CupertinoIcons.volume_off;
    await _controller.initialize();
    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _controller,
        aspectRatio: _controller.value.aspectRatio,
        autoPlay: true,
        looping: widget.looping != null ? widget.looping : false,
        placeholder: buildPlaceholderImage(),
        customControls: widget.isAd != null && widget.isAd == true ? StatefulBuilder(
          builder: (context, setState) {
            return GestureDetector(
              onTap: () {
                if (icon == CupertinoIcons.volume_off) {
                  setState(() {
                    icon = CupertinoIcons.volume_up;
                  });
                  _controller.setVolume(0.0);
                } else if (icon == CupertinoIcons.volume_up) {
                  setState(() {
                    icon = CupertinoIcons.volume_off;
                  });
                  _controller.setVolume(10.0);
                }
              },
              child: Container(
                height: 5 * SizeConfig.heightMultiplier,
                width: 10 * SizeConfig.widthMultiplier,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Icon(icon, color: Colors.red[300],),
                ),
              ),
            );
          },
        ) : null,
        showControls: widget.showControls != null ? widget.showControls : true,
      );
    });
  }

  buildPlaceholderImage() {
    return Container(
      color: Colors.black,
      child: Center(
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red[300]),),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return buildPlaceholderImage();
          }
          return Container(
            color: Colors.black,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 2 * SizeConfig.widthMultiplier,
                  right: 2 * SizeConfig.widthMultiplier,
                ),
                child: Chewie(
                  controller: _chewieController,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
