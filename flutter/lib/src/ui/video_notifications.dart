import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';


class VideoClip extends StatefulWidget {
  final String url;

  const VideoClip({Key key, this.url}) : super(key: key);
  @override
  _VideoClipState createState() => _VideoClipState();
}

class _VideoClipState extends State<VideoClip> {
  CachedVideoPlayerController controller;

  @override
  void initState() {
    controller = CachedVideoPlayerController.network(widget.url);
    controller.initialize().then((_) {
      setState(() {});
      controller.setLooping(true);
      controller.pause();
      controller.setVolume(0);
    });
    super.initState();
    print("Controller **************" + controller.toString());
    print("url *****************" + widget.url);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (controller.value.isPlaying) {
                controller.pause();
                controller.setVolume(0);
              } else {
                controller.play();
                controller.setVolume(1);
                
              }
              
            });
          },
          child:
        Container(
          constraints: BoxConstraints(
              minHeight: 370, minWidth: double.infinity, ),
          color: Colors.transparent,
          child:
        Center(
          child: controller.value.initialized
              ? AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: CachedVideoPlayer(controller),
                )
              : CircularProgressIndicator(
                 strokeWidth: 2.0,
                 ),
        ),
        ),
        ),
        
      ],
    );
  }
}
