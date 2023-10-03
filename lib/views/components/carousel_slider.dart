import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/explore.dart';
import '../../models/poster.dart';

class CarouselSlider extends StatefulWidget {
  final List<Poster> posterList;
  final bool autoSlide, hasLink;
  final double height;

  const CarouselSlider(
      {Key? key,
      required this.posterList,
      required this.autoSlide,
      required this.hasLink,
      required this.height})
      : super(key: key);

  @override
  _CarouselSliderState createState() => _CarouselSliderState();
}

class _CarouselSliderState extends State<CarouselSlider> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void didChangeDependencies() {
    if (widget.autoSlide) {
      Timer.periodic(const Duration(seconds: 4), (timer) {
        if (_currentIndex < widget.posterList.length) {
          _currentIndex++;
        } else {
          _currentIndex = 0;
        }
        _pageController.animateToPage(_currentIndex,
            duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: List.generate(widget.posterList.length, (i) {
              return InkWell(
                onTap: () {
                  if (widget.hasLink) {
                    Get.to(() =>
                        Explore(keywords: widget.posterList[i].keywords![0]));
                  }
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.posterList[i].thumbnail),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.posterList.length, (index) {
                return Container(
                  margin: const EdgeInsets.only(right: 4),
                  height: (index == _currentIndex) ? 6 : 4,
                  width: (index == _currentIndex) ? 10 : 8,
                  decoration: BoxDecoration(
                    color:
                        (index == _currentIndex) ? Colors.grey : Colors.white,
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(6),
                  ),
                );
              }),
            )),
      ],
    );
  }
}
