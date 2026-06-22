import 'package:json_annotation/json_annotation.dart';

// 这行代码会报错红线，别慌！这是告诉 Flutter ：“一会儿生成的代码会放在这个文件里”
part 'daily_quote.g.dart';

// 给这个类打个标记，说明它需要被自动序列化
@JsonSerializable()
class DailyQuote {
  // 我们只想要服务器返回的 'test' 字段
  final String text;

  DailyQuote({required this.text});

  // 这是一个工厂构造函数，专门用来把 JSON 字典转换成 Dart 对象
  // _$DailyQuoteFromJson 这个方法我们不自己写，等会用命令自动生成！
  factory DailyQuote.fromJson(Map<String,dynamic> json) => _$DailyQuoteFromJson(json);

  // 把 Dart 对象转换回 JSON 字典（比如你要提交数据给服务器时用）
  Map<String,dynamic> toJson() => _$DailyQuoteToJson(this);
}
