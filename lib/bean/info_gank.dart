/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/22 上午11:58
 */

class GankInfo {
  final String id;
  final String desc, publishedAt, source, type, url, who, img;
  bool like;

  bool isAvailableSearch(String searchText){
    if(searchText.isEmpty)return false;
    if(desc.contains(searchText)||publishedAt.contains(searchText)||who.contains(searchText)||url.contains(searchText)){
      return true;
    }
    return false;
  }

  GankInfo(
      {this.desc:'这是一个描述的文字',
      this.id:'33cxx',
      this.like:false,
      this.publishedAt:'2018-5-13',
      this.source: 'ccc',
      this.type:'前端',
      this.url:'http://www.baidu.com',
      this.who: 'ccc',
      this.img: ''});

  factory GankInfo.fromJson(Map json) {
    return new GankInfo(
      id: json["_id"] ?? 'id',
      like: false,
      desc: json['desc']?? '这是描述',
      img: json['images']==null ? '':json['images'][0],
      publishedAt: json['publishedAt'] ?? '2018-5-13',
      source: json['source'] ?? 'Web',
      type: json['type'] ?? 'type' ,
      who: json['who'] ?? 'null' ,
      url: json['url'] ?? 'url',
    );
  }

  GankInfo.fromMap(Map map)
      : id = map["id"] ?? 'id',
        img = map["img"] ?? '',
        url = map["url"] ?? 'http://www.baidu.com',
        like = map["like"]==1,
        type= map["type"],
        desc = map["desc"] ?? '这是描述',
        source = map["source"] ?? 'Web',
        publishedAt = map["publishedAt"] ?? '2018-5-13',
        who = map["who"] ?? 'null';

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
  bool like;

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
        desc = map["publishedAt"];


  Map<String,dynamic> toMap() {
    Map<String,dynamic> map = new Map();
    if (id != null) {
      map["id"] = id;
      map["url"] = url;
      map["who"] = who;
      map["publishedAt"] = desc;
      map["like"] = like?1:0;

    }
    return map;
  }
}
