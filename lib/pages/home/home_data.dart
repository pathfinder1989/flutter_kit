import 'package:flutter/material.dart';
import 'package:flutter_kit/pages/animated_container/animated_container_page.dart';
import 'package:flutter_kit/pages/segment/segment_page.dart';

class PageEntity {
  PageEntity({
    required this.title,
    required this.page,
  });

  final String title;
  final Widget page;
}

/// 页面列表
List<PageEntity> pageList = [
  PageEntity(
    title: 'AnimatedContainer',
    page: const XKAnimatedContainerPage(),
  ),

  PageEntity(
    title: 'segment',
    page: const XKSegmentPage(),
  ),

  
];
