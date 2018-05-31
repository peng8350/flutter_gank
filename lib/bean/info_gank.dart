/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/22 上午11:58
 */

class GankInfo {
  final String id;
  final String desc, publishedAt, source, type, url, who, img;
  final bool like;

  GankInfo(
      {this.desc,
      this.id,
      this.like:false,
      this.publishedAt,
      this.source: 'null',
      this.type,
      this.url,
      this.who: 'null',
      this.img: ''});

  factory GankInfo.fromJson(Map<String, dynamic> json) {
    return new GankInfo(
      id: json["_id"],
      like: false,
      desc: json['desc'],
      img: json['images'] != null ? json['images'][0] : '',
      publishedAt: json['publishedAt'],
      source: json['source'],
      type: json['type'],
      who: json['who'] == null ? 'null' : json['who'],
      url: json['url'],
    );
  }

  GankInfo.fromMap(Map map)
      : id = map["id"],
        img = map["img"],
        url = map["url"],
        like = map["like"]==1,
        type= map["type"],
        desc = map["desc"],
        source = map["source"],
        publishedAt = map["publishedAt"],
        who = map["who"];

  Map<String,dynamic> toMap() {
    Map<String,dynamic> map = new Map();
    if (id != null) {
      map["id"] = id;
      map["url"] = url;
      map["img"] = img;
      map["who"] = who;
      map["type"] = type;
      map["desc"] = desc;
      map["like"] = like?1:0;
      map["publishedAt"] = publishedAt;
      map["source"] = source;
    }
    return map;
  }
}

class GirlInfo {
  final String id;
  final String desc, who, url;
  final bool like;

  GirlInfo(
      {this.desc, this.who, this.url, this.id, this.like});

  factory GirlInfo.fromJson(Map<String, dynamic> json) {
    return new GirlInfo(
        id: json["_id"],
        like: false,
        desc: json['desc'],
        who: json['who'],
        url: json['url']);
  }

  GirlInfo.fromMap(Map map)
      : like = map["like"]==1,
        url = map["url"],
        id = map["id"],
        who = map["who"],
        desc = map["desc"];


  Map<String,dynamic> toMap() {
    Map<String,dynamic> map = new Map();
    if (id != null) {
      map["id"] = id;
      map["url"] = url;
      map["who"] = who;
      map["desc"] = desc;
      map["like"] = like?1:0;
    }
    return map;
  }
}
