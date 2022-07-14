import 'package:flutter/material.dart';

///custom segment
class XKSegment<K extends Object, V extends String> extends StatefulWidget {
  const XKSegment({
    Key? key,
    required this.segments,
    this.controller,
    this.activeStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
    ),
    this.inactiveStyle,
    this.itemSize = const Size(72, 32),
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.backgroundColor = const Color(0x42000000),
    this.sliderColor = const Color(0xFFFFFFFF),
    this.sliderOffset = 0.0,
    this.animationDuration = const Duration(milliseconds: 250),
    this.shadow = const <BoxShadow>[
      BoxShadow(
        color: Color(0x42000000),
        blurRadius: 8.0,
      ),
    ],
    this.sliderDecoration,
  })  : assert(segments.length > 1, 'Minimum segments amount is 2'),
        super(key: key);

  final ValueNotifier<K>? controller;

  final Map<K, V> segments;

  final TextStyle activeStyle;

  final TextStyle? inactiveStyle;

  final BorderRadius borderRadius;

  final Color sliderColor;

  final Color backgroundColor;

  final double sliderOffset;

  final Duration animationDuration;

  final List<BoxShadow>? shadow;

  final BoxDecoration? sliderDecoration;

  final Size itemSize;

  @override
  State<XKSegment> createState() => _XKSegmentState();
}

class _XKSegmentState<K extends Object, V extends String> extends State<XKSegment<K, V>> with SingleTickerProviderStateMixin {
  static const _defaultTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Color(0xFF000000),
  );
  late final AnimationController _animationController;
  late final ValueNotifier<K> _defaultController;
  late ValueNotifier<K> _controller;
  late Size _itemSize;
  late Size _containerSize;

  @override
  void dispose() {
    _animationController.dispose();

    _controller.removeListener(_handleControllerChanged);

    _defaultController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _initSizes();

    _defaultController = ValueNotifier<K>(widget.segments.keys.first);

    _controller = widget.controller ?? _defaultController;
    _controller.addListener(_handleControllerChanged);

    _animationController = AnimationController(
      vsync: this,
      value: _obtainAnimationValue(),
      duration: widget.animationDuration,
    );
  }

  void _handleControllerChanged() {
    final animationValue = _obtainAnimationValue();

    _animationController.animateTo(
      animationValue,
      duration: widget.animationDuration,
    );
  }

  void _initSizes() {
    _itemSize = widget.itemSize;

    _containerSize = Size(
      _itemSize.width * widget.segments.length,
      _itemSize.height,
    );
  }

  @override
  void didUpdateWidget(covariant XKSegment<K, V> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_handleControllerChanged);
      _controller = widget.controller ?? _defaultController;

      _handleControllerChanged();

      _controller.addListener(_handleControllerChanged);
    }

    if (oldWidget.segments != widget.segments) {
      _initSizes();

      _animationController.value = _obtainAnimationValue();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _containerSize.width,
      height: _containerSize.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
      ),
      child: Opacity(
        opacity: widget.controller != null ? 1 : 0.75,
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (_, child) {
                return Transform.translate(
                  offset: Tween<Offset>(
                    begin: Offset.zero,
                    end: _obtainEndOffset(Directionality.of(context)),
                  )
                      .animate(CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.linear,
                      ))
                      .value,
                  child: child,
                );
              },
              child: FractionallySizedBox(
                widthFactor: 1 / widget.segments.length,
                heightFactor: 1,
                child: Container(
                  margin: EdgeInsets.all(widget.sliderOffset),
                  // height: _itemSize.height - widget.sliderOffset * 2,
                  decoration: widget.sliderDecoration ??
                      BoxDecoration(
                        color: widget.sliderColor,
                        borderRadius: widget.borderRadius.subtract(BorderRadius.all(Radius.circular(widget.sliderOffset))),
                        boxShadow: widget.shadow,
                      ),
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _controller,
              builder: (_, value, __) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: widget.segments.entries.map((entry) {
                    return GestureDetector(
                      onHorizontalDragUpdate: (details) => _handleSegmentMove(
                        details,
                        entry.key,
                        Directionality.of(context),
                      ),
                      onTap: () => _handleSegmentPressed(entry.key),
                      child: Container(
                        width: _itemSize.width,
                        height: _itemSize.height,
                        color: const Color(0x00000000),
                        child: AnimatedDefaultTextStyle(
                          duration: widget.animationDuration,
                          style: _defaultTextStyle.merge(value == entry.key ? widget.activeStyle : widget.inactiveStyle),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          softWrap: false,
                          child: Center(
                            child: Text(entry.value),
                          ),
                        ),
                      ),
                    );
                  }).toList(growable: false),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  double _obtainAnimationValue() {
    return widget.segments.keys.toList(growable: false).indexOf(_controller.value).toDouble() / (widget.segments.keys.length - 1);
  }

  void _handleSegmentPressed(K key) {
    if (widget.controller != null) {
      _controller.value = key;
    }
  }

  void _handleSegmentMove(
    DragUpdateDetails touch,
    K value,
    TextDirection textDirection,
  ) {
    if (widget.controller != null) {
      final indexKey = widget.segments.keys.toList().indexOf(value);

      final indexMove = textDirection == TextDirection.rtl ? (_itemSize.width * indexKey - touch.localPosition.dx) / _itemSize.width + 1 : (_itemSize.width * indexKey + touch.localPosition.dx) / _itemSize.width;

      if (indexMove >= 0 && indexMove <= widget.segments.keys.length) {
        _controller.value = widget.segments.keys.elementAt(indexMove.toInt());
      }
    }
  }

  Offset _obtainEndOffset(TextDirection textDirection) {
    final dx = _itemSize.width * (widget.segments.length - 1);

    return Offset(textDirection == TextDirection.rtl ? -dx : dx, 0);
  }
}
