import 'package:flutter/material.dart';
import 'package:grock/grock.dart';

class AnimatedListView extends StatefulWidget {
  const AnimatedListView({Key? key}) : super(key: key);

  @override
  State<AnimatedListView> createState() => _AnimatedListViewState();
}

class _AnimatedListViewState extends State<AnimatedListView> {
  final _items = List.generate(15, (index) => 'Item $index');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedListView'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        itemCount: _items.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 15);
        },
        itemBuilder: (BuildContext context, int index) {
          return AnimatedItem(_itemCard(index: index), index);
        },
      ),
    );
  }

  Widget _itemCard({required int index}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.maxFinite,
        height: 100,
        color: context.randomColor,
      ),
    );
  }
}

class AnimatedItem extends StatefulWidget {
  Widget item;
  int index;
  AnimatedItem(this.item, this.index);

  @override
  State<AnimatedItem> createState() => _AnimatedItemState();
}

class _AnimatedItemState extends State<AnimatedItem>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isOpacity = false;

  int _duration(int index) {
    if (index >= 1 && index <= 3) {
      return index * 400;
    } else if (index >= 4 && index <= 7) {
      return index * 300;
    } else if (index >= 8 && index <= 11) {
      return index * 200;
    } else if (index >= 12 && index <= 15) {
      return index * 100;
    } else if (index == 0) {
      return 500;
    } else {
      return index * 200;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _duration(widget.index)),
    );
    _animation = Tween<double>(begin: -200, end: 0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 1, curve: Curves.fastLinearToSlowEaseIn)))
      ..addListener(() {
        _isOpacity = true;
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isOpacity ? 1 : 0,
      duration: const Duration(milliseconds: 500),
      child: Transform.translate(
        offset: Offset(0, _animation.value),
        child: widget.item,
      ),
    );
  }
}
