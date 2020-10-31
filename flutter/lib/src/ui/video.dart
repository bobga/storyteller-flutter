import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';


class VideoClip extends StatefulWidget {
  final String url;

  const VideoClip({Key key, this.url}) : super(key: key);
  @override
  _VideoClipState createState() => _VideoClipState();
}

class _VideoClipState extends State<VideoClip> {
  CachedVideoPlayerController controller;
  
  bool showController = false;
  

  @override
  void initState() {
    controller = CachedVideoPlayerController.network(widget.url);
    controller.initialize().then((_) {
      setState(() {});
      controller.setLooping(true);
      controller.play();
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

VisibilityDetector(
   key: Key("unique key"),
   onVisibilityChanged: (VisibilityInfo info) {
       debugPrint("${info.visibleFraction} of my widget is visible");
       if(info.visibleFraction == 2.0){
           controller.play();
                controller.setVolume(0);
       }
       else{
           controller.play();
                controller.setVolume(0);
       }
   },
   child:
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
),
        Positioned.fill(
          child: Container(
            alignment: Alignment.topLeft,
            child:

            AnimatedOpacity(
      opacity: controller.value.isPlaying ? 0.0 : 1.0,
      duration: Duration(milliseconds: 500),
      child:
          Container(
          decoration: new BoxDecoration(
            color: new Color.fromRGBO(0, 0, 0, 0.66),
            borderRadius: BorderRadius.circular(50),
          ),
          width: 25,
          height: 25,
          margin: EdgeInsets.only(left: 14.5, top: 14.5),
          child: Icon(
            controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            color: Color.fromRGBO(255, 255, 255, 0.96),
            size: 15,
          ),
        ),
          
        )

      )
        ),
      ],
    );
  }
}
