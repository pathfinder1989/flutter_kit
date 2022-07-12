import 'package:flutter/material.dart';
import 'package:flutter_kit/pages/home/home_data.dart';
import 'package:flutter_kit/pages/home/home_list_tile.dart';

class XKHomePage extends StatefulWidget {
  XKHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<XKHomePage> createState() => _XKHomePageState();
}

class _XKHomePageState extends State<XKHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.separated(
        itemCount: pageList.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(height: 1);
        },
        itemBuilder: (BuildContext context, int index) {
          var item = pageList[index];
          return XKHomeListTile(
            leading: '${index + 1}',
            title: item.title,
            pushPage: item.page,
          );
        },
      ),
    );
  }
}