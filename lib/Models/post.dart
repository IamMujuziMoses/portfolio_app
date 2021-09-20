import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
/*
* Created by Mujuzi Moses
*/

class Post{
  String senderName;
  String senderPic;
  String type;
  String heading;
  int likeCounter;
  String uid;
  String postImageUrl;
  String postText;
  String postVideoUrl;
  Uint8List thumbnail;
  FieldValue time;

  Post.textPost({this.senderName, this.senderPic, this.type, this.uid,
    this.postText, this.time, this.likeCounter, this.heading,
  });
  Post.imagePost({this.senderName, this.senderPic, this.type, this.heading, this.postImageUrl,
    this.time, this.likeCounter, this.postText, this.uid,
  });
  Post.videoPost({this.senderName, this.senderPic, this.type, this.heading, this.thumbnail,
    this.postVideoUrl, this.time, this.likeCounter, this.postText, this.uid,
  });
  Post.sharedPost({this.senderName, this.senderPic, this.type,
    this.heading, this.time, this.likeCounter, this.postText, this.uid,
  });

  Map toTextMap(Post post) {
    Map<String, dynamic> postMap = Map();
    postMap["sender_name"] = post.senderName;
    postMap["sender_pic"] = post.senderPic;
    postMap["type"] = post.type;
    postMap["like_counter"] = post.likeCounter;
    postMap["post_text"] = post.postText;
    postMap["heading"] = post.heading;
    postMap["time"] = post.time;
    postMap["uid"] = post.uid;

    return postMap;
  }

  Map toSharedMap(Post post) {
    Map<String, dynamic> postMap = Map();
    postMap["sender_name"] = post.senderName;
    postMap["sender_pic"] = post.senderPic;
    postMap["type"] = post.type;
    postMap["post_text"] = post.postText;
    postMap["like_counter"] = post.likeCounter;
    postMap["heading"] = post.heading;
    postMap["time"] = post.time;
    postMap["uid"] = post.uid;

    return postMap;
  }

   Map toVideoMap(Post post) {
    Map<String, dynamic> postMap = Map();
    postMap["sender_name"] = post.senderName;
    postMap["sender_pic"] = post.senderPic;
    postMap["type"] = post.type;
    postMap["post_text"] = post.postText;
    postMap["heading"] = post.heading;
    postMap["thumbnail"] = post.thumbnail;
    postMap["like_counter"] = post.likeCounter;
    postMap["post_video_url"] = post.postVideoUrl;
    postMap["time"] = post.time;
    postMap["uid"] = post.uid;

    return postMap;
  }

   Map toImageMap(Post post) {
    Map<String, dynamic> postMap = Map();
    postMap["sender_name"] = post.senderName;
    postMap["sender_pic"] = post.senderPic;
    postMap["type"] = post.type;
    postMap["post_text"] = post.postText;
    postMap["heading"] = post.heading;
    postMap["like_counter"] = post.likeCounter;
    postMap["post_image_url"] = post.postImageUrl;
    postMap["time"] = post.time;
    postMap["uid"] = post.uid;

    return postMap;
  }

  Post.fromMap(Map postMap) {
    this.senderName = postMap["sender_name"];
    this.senderPic = postMap["sender_pic"];
    this.type = postMap["type"];
    this.heading = postMap["heading"];
    this.likeCounter = postMap["like_counter"];
    this.postImageUrl = postMap["post_image_url"];
    this.postText = postMap["post_text"];
    this.postVideoUrl = postMap["post_video_url"];
    this.time = postMap["time"];
    this.time = postMap["uid"];
  }
}

class SharedPost{

  String sharedUserName;
  String sharedUserPic;
  String sharedType;
  String sharedHeading;
  String sharedImageUrl;
  String sharedText;
  String sharedVideoUrl;
  Timestamp sharedTime;
  Uint8List sharedThumbnail;

  SharedPost.textPost({this.sharedUserName, this.sharedUserPic, this.sharedType,
    this.sharedText, this.sharedTime, this.sharedHeading,
  });
  SharedPost.imagePost({this.sharedUserName, this.sharedUserPic, this.sharedType, this.sharedHeading,
    this.sharedImageUrl, this.sharedTime, this.sharedText,
  });
  SharedPost.videoPost({this.sharedUserName, this.sharedUserPic, this.sharedType, this.sharedHeading,
    this.sharedThumbnail, this.sharedVideoUrl, this.sharedTime, this.sharedText,
  });

  Map<String, dynamic> toTextMap(SharedPost sharedPost) {
    Map<String, dynamic> sharedPostMap = Map();
    sharedPostMap["shared_user_name"] = sharedPost.sharedUserName;
    sharedPostMap["shared_user_pic"] = sharedPost.sharedUserPic;
    sharedPostMap["shared_type"] = sharedPost.sharedType;
    sharedPostMap["shared_heading"] = sharedPost.sharedHeading;
    sharedPostMap["shared_text"] = sharedPost.sharedText;
    sharedPostMap["shared_time"] = sharedPost.sharedTime;

    return sharedPostMap;
  }

  Map<String, dynamic> toVideoMap(SharedPost sharedPost) {
    Map<String, dynamic> sharedPostMap = Map();
    sharedPostMap["shared_user_name"] = sharedPost.sharedUserName;
    sharedPostMap["shared_user_pic"] = sharedPost.sharedUserPic;
    sharedPostMap["shared_type"] = sharedPost.sharedType;
    sharedPostMap["shared_text"] = sharedPost.sharedText;
    sharedPostMap["shared_thumbnail"] = sharedPost.sharedThumbnail;
    sharedPostMap["shared_heading"] = sharedPost.sharedHeading;
    sharedPostMap["shared_video_url"] = sharedPost.sharedVideoUrl;
    sharedPostMap["shared_time"] = sharedPost.sharedTime;

    return sharedPostMap;
  }

  Map<String, dynamic> toImageMap(SharedPost sharedPost) {
    Map<String, dynamic> sharedPostMap = Map();
    sharedPostMap["shared_user_name"] = sharedPost.sharedUserName;
    sharedPostMap["shared_user_pic"] = sharedPost.sharedUserPic;
    sharedPostMap["shared_type"] = sharedPost.sharedType;
    sharedPostMap["shared_text"] = sharedPost.sharedText;
    sharedPostMap["shared_heading"] = sharedPost.sharedHeading;
    sharedPostMap["shared_image_url"] = sharedPost.sharedImageUrl;
    sharedPostMap["shared_time"] = sharedPost.sharedTime;

    return sharedPostMap;
  }

  SharedPost.fromMap(Map sharedPostMap) {
    this.sharedUserName = sharedPostMap["shared_user_name"];
    this.sharedUserPic = sharedPostMap["shared_user_pic"];
    this.sharedType = sharedPostMap["shared_type"];
    this.sharedHeading = sharedPostMap["shared_heading"];
    this.sharedImageUrl = sharedPostMap["shared_image_url"];
    this.sharedText = sharedPostMap["shared_text"];
    this.sharedVideoUrl = sharedPostMap["shared_video_url"];
    this.sharedTime = sharedPostMap["shared_time"];
  }
}

class Like{
  String name;
  String pic;

  Like({this.name, this.pic});

  Map<String, dynamic> toMap(Like like) {
    Map<String, dynamic> likeMap = Map();
    likeMap["name"] = like.name;
    likeMap["pic"] = like.pic;

    return likeMap;
  }

  Like.fromMap(Map likeMap) {
    this.name = likeMap["name"];
    this.pic = likeMap["pic"];
  }
}