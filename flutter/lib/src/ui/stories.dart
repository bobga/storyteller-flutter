import 'package:flutter/material.dart';
import 'package:Storyteller/src/models/story_model.dart';
import 'package:story_view/story_view.dart';
import '../resources/story_teller_api_provider.dart';
import '../blocs/photos_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:Storyteller/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'globals.dart' as global;
import 'package:timeago/timeago.dart' as timeago;

class Stories extends StatelessWidget {
  final int toUserIdController;
  final String toUserNameController;
  final String toUserAvatarController;
  final String toUserBadgeController;
  Stories(this.toUserIdController, this.toUserNameController,
      this.toUserAvatarController, this.toUserBadgeController,
      {Key key10})
      : super(key: key10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return StoryViewDelegate(
                stories: snapshot.data,
                userId: toUserIdController,
                userAvatar: toUserAvatarController,
                userName: toUserNameController,
                userBadge: toUserBadgeController,
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
  final String userName;
  final String userAvatar;
  final String userBadge;
  StoryViewDelegate(
      {this.stories,
      this.userId,
      this.userName,
      this.userAvatar,
      this.userBadge});
  @override
  _StoryViewDelegateState createState() => _StoryViewDelegateState();
}

class _StoryViewDelegateState extends State<StoryViewDelegate> {
  final StoryController controller = StoryController();
  List<StoryItem> storyItems = [];
  int _id;
  int pos;
  String when;
  bool user = false;
  @override
  void initState() {
    super.initState();
    when = widget.stories[0].createdAt;

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
            imageFit: BoxFit.cover,
            duration: parseDuration(story.duration),
          ),
        );
      }

      if (story.type == 'image') {
        storyItems.add(
          StoryItem.pageImage(
            url: story.path,
            imageFit: BoxFit.cover,
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
    final screenSize = MediaQuery.of(context).size;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Stack(
      children: [
        StoryView(
          storyItems: storyItems,
          controller: controller,
          onStoryShow: (storyItem) {
            pos = storyItems.indexOf(storyItem);
            _id = widget.stories[pos].id;
            if (pos > 0) {
              setState(() {
                when = widget.stories[pos].createdAt;
              });
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
                            // Navigator.pop(context);
                          }
                        });
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            margin: EdgeInsets.only(
                                bottom: 38, left: 30, right: 30),
                            elevation: 0,
                            backgroundColor: Colors.white,
                            content: Text(
                              "Successful deleted.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                            duration: Duration(seconds: 3),
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
          bottom: 14,
          left: 13,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.black45.withOpacity(0.2),
            ),
            child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: 48,
            left: 16,
            right: 16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(widget.userAvatar),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.userName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        widget.userBadge == "true"
                            ? Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent),
                                child: Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: SvgPicture.network(
                                      "https://teling.app/wp-content/uploads/2020/09/check.svg",
                                      width: 14,
                                      height: 14),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    Text(
                      timeago.format(DateTime.parse(when).toLocal(),
                          locale: AppLocalizations.instance.mlangCode),
                      style: TextStyle(
                        color: Colors.white38,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
