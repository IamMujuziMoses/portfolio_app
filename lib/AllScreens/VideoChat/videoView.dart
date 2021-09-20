import 'package:creativedata_app/sizeConfig.dart';
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
  const VideoView({Key key, @required this.videoPlayerController, this.looping, this.showControls}) : super(key: key);

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
    await _controller.initialize();
    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _controller,
        aspectRatio: _controller.value.aspectRatio,
        autoPlay: true,
        looping: widget.looping != null ? widget.looping : false,
        placeholder: buildPlaceholderImage(),
        showControls: widget.showControls != null ? widget.showControls : true,
      );
    });
  }

  buildPlaceholderImage() {
    return Container(
      color: Colors.black,
      child: Center(
        child: CircularProgressIndicator(),
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
