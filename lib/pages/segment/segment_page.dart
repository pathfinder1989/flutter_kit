import 'package:base_lib/widgets/segment.dart';
import 'package:flutter/material.dart';

class XKSegmentPage extends StatefulWidget {
  const XKSegmentPage({Key? key}) : super(key: key);

  @override
  State<XKSegmentPage> createState() => _XKSegmentPageState();
}

class _XKSegmentPageState extends State<XKSegmentPage> {

  final _selectedSegmentController = ValueNotifier('1');
  

  @override
  void initState() {
    super.initState();

    _selectedSegmentController.addListener(() {
      print('clicked value is ${_selectedSegmentController.value} ');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('segment'),
      ),
      body: Center(
        child: XKSegment(
          controller: _selectedSegmentController,
          segments: const {'0': '悬浮', '1': '固定顶部', '2' : '固定底部'},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.play_arrow_rounded),
        onPressed: () {
          
        },
      ),
    );
  }

  // _initController(int selectedIndex, Function? callback) {
  //   String data = stringForObject(selectedIndex);
  //   var controller = ValueNotifier(data);
  //   controller.addListener(() {
  //     if (callback != null) {
  //       callback(intForObject(controller.value));
  //     }
  //   });
  //   return controller;
  // }

  // Map<String, String> _drawingfilterValue = {'0': '悬浮', '1': '固定顶部', '2' : '固定底部'};
  // _initDrawingfilterController(int selectedIndex, Function? callback) {
  //   String data = stringForObject(selectedIndex);
  //   var controller = ValueNotifier(data);
  //   controller.addListener(() {
  //     if (callback != null) {
  //       callback(intForObject(controller.value));
  //     }
  //   });
  //   return controller;
  // }

  // Color normalTextColor = getThemeColor('text_middle');
  // Color highTextColor = getThemeColor('button_text');

  // Widget drawingFilterWidget(int selectedIndex, Function? callback) {
  //   Widget segment = CustomizedSegment(
  //     segments: _drawingfilterValue,
  //     controller: _initDrawingfilterController(selectedIndex, callback),
  //     backgroundColor: getThemeColor('container_gray'),
  //     itemSize: Size(72, 32),
  //     sliderColor: themeColorSrc.main,
  //     activeStyle: TextStyle(
  //       fontWeight: FontWeight.w400,
  //       fontSize: 14,
  //       color: highTextColor,
  //     ),
  //     inactiveStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: normalTextColor),
  //     borderRadius: const BorderRadius.all(Radius.circular(4.0)),
  //   );
  //   return segment;
  // }

}
