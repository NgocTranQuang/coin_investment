import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';


class ChewieDemo extends StatefulWidget {
  const ChewieDemo({this.title = 'Chewie Demo'});

  final String title;
  @override
  _ChewieDemoState createState() => _ChewieDemoState();
}

class _ChewieDemoState extends State<ChewieDemo> {
  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController1;
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController1 = VideoPlayerController.network(
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4');
    await _videoPlayerController1.initialize();
    _videoPlayerController2 = VideoPlayerController.network(
        'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4');
    await _videoPlayerController2.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: true,
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: _chewieController != null &&
                _chewieController
                    .videoPlayerController.value.initialized
                ? Chewie(
              controller: _chewieController,
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Loading'),
              ],
            ),
          ),
        ),
        // FlatButton(
        //   onPressed: () {
        //     _chewieController.enterFullScreen();
        //   },
        //   child: const Text('Fullscreen'),
        // ),
        // Row(
        //   children: <Widget>[
        //     Expanded(
        //       child: FlatButton(
        //         onPressed: () {
        //           setState(() {
        //             _chewieController.dispose();
        //             _videoPlayerController1.pause();
        //             _videoPlayerController1.seekTo(const Duration());
        //             _chewieController = ChewieController(
        //               videoPlayerController: _videoPlayerController1,
        //               autoPlay: true,
        //               looping: true,
        //             );
        //           });
        //         },
        //         child: const Padding(
        //           padding: EdgeInsets.symmetric(vertical: 16.0),
        //           child: Text("Landscape Video"),
        //         ),
        //       ),
        //     ),
        //     Expanded(
        //       child: FlatButton(
        //         onPressed: () {
        //           setState(() {
        //             _chewieController.dispose();
        //             _videoPlayerController2.pause();
        //             _videoPlayerController2.seekTo(const Duration());
        //             _chewieController = ChewieController(
        //               videoPlayerController: _videoPlayerController2,
        //               autoPlay: true,
        //               looping: true,
        //             );
        //           });
        //         },
        //         child: const Padding(
        //           padding: EdgeInsets.symmetric(vertical: 16.0),
        //           child: Text("Portrait Video"),
        //         ),
        //       ),
        //     )
        //   ],
        // ),
        // Row(
        //   children: <Widget>[
        //     Expanded(
        //       child: FlatButton(
        //         onPressed: () {
        //           setState(() {
        //             _platform = TargetPlatform.android;
        //           });
        //         },
        //         child: const Padding(
        //           padding: EdgeInsets.symmetric(vertical: 16.0),
        //           child: Text("Android controls"),
        //         ),
        //       ),
        //     ),
        //     Expanded(
        //       child: FlatButton(
        //         onPressed: () {
        //           setState(() {
        //             _platform = TargetPlatform.iOS;
        //           });
        //         },
        //         child: const Padding(
        //           padding: EdgeInsets.symmetric(vertical: 16.0),
        //           child: Text("iOS controls"),
        //         ),
        //       ),
        //     )
        //   ],
        // )
      ],
    ),);
  }
}