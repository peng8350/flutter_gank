/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2018/5/22 上午11:58
 */

class GankInfo {
  final String desc, publishedAt, source, type, url, who, img;

  GankInfo(
      {this.desc,
      this.publishedAt,
      this.source,
      this.type,
      this.url,
      this.who,
      this.img});

  factory GankInfo.fromJson(Map<String, dynamic> json) {
    return new GankInfo(
      desc: json['desc'],
      img: json['images'][0],
      publishedAt: json['publishedAt'],
      source: json['source'],
      type: json['type'],
      who: json['who'],
      url: json['url'],
    );
  }
}

class GirlInfo {
  final String desc, publicshedAt, who, url;

  GirlInfo({this.desc, this.publicshedAt, this.who, this.url});

  factory GirlInfo.fromJson(Map<String, dynamic> json) {
    return new GirlInfo(
        desc: json['desc'],
        who: json['who'],
        publicshedAt: json['publishedAt'],
        url: json['url']);
  }
}
