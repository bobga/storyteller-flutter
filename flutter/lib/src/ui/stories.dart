import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Storyteller/src/models/story_model.dart';
import 'package:story_view/story_view.dart';
import '../resources/story_teller_api_provider.dart';
import '../blocs/photos_bloc.dart';

import 'globals.dart' as global;

class Stories extends StatelessWidget {
  final int toUserIdController;
  Stories(this.toUserIdController, {Key key10}) : super(key: key10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return StoryViewDelegate(
              stories: snapshot.data,
              userId: toUserIdController,
            );
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        },
        future: StoryTellerApiProvider.getStories(toUserIdController),
      ),
    );
  }
}

Duration parseDuration(String s) {
  int hours = 0;
  int minutes = 0;
  int micros;
  List<String> parts = s.split(':');
  if (parts.length > 2) {
    hours = int.parse(parts[parts.length - 3]);
  }
  if (parts.length > 1) {
    minutes = int.parse(parts[parts.length - 2]);
  }
  micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
  return Duration(hours: hours, minutes: minutes, microseconds: micros);
}

class StoryViewDelegate extends StatefulWidget {
  final List<Story> stories;
  final int userId;
  StoryViewDelegate({this.stories, this.userId});
  @override
  _StoryViewDelegateState createState() => _StoryViewDelegateState();
}

class _StoryViewDelegateState extends State<StoryViewDelegate> {
  final StoryController controller = StoryController();
  List<StoryItem> storyItems = [];
  int _id;
  int pos;
  bool user = false;
  @override
  void initState() {
    super.initState();

    bloc.fetchUser(0);
    bloc.userDetail.listen(
      (data) {
        if (data != null) {
          if (user == true) {
            global.userId = data.user.id;
            user = false;
          }
        }
      },
    );
    widget.stories.forEach((story) {
      if (story.type == 'video') {
        storyItems.add(
          StoryItem.pageVideo(
            story.path,
            controller: controller,
            duration: parseDuration(story.duration),
          ),
        );
      }

      if (story.type == 'image') {
        storyItems.add(
          StoryItem.pageImage(
            url: story.path,
            controller: controller,
            duration: parseDuration(story.duration),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StoryView(
          storyItems: storyItems,
          controller: controller,
          onStoryShow: (storyItem) {
            pos = storyItems.indexOf(storyItem);
            _id = widget.stories[pos].id;

            if(pos > 0){
              setState((){});
            }
          },
          onComplete: () {
            Navigator.pop(context);
          },
        ),
        widget.userId == global.userId
            ? Positioned(
                bottom: 14,
                right: 20,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black.withOpacity(0.2),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (_id != null) {
                        bloc.destoryStory(_id).then((value) {
                          storyItems.removeAt(pos);
                          if (storyItems.length == 0) {
                            Navigator.pop(context);
                          }
                        });
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            content: Text(
                              "Successful deleted.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                            duration: Duration(seconds: 5),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                  ),
                ),
              )
            : Container(),
        Positioned(
          bottom: 20,
          left: 20,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.black.withOpacity(0.2),
              ),
              child: Container()),
        )
      ],
    );
  }
}
