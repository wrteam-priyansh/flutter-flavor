import 'package:flavour_demo/utils/utils.dart';
import 'package:flutter/material.dart';

class ImageParallaxScreen extends StatefulWidget {
  const ImageParallaxScreen({super.key});

  @override
  State<ImageParallaxScreen> createState() => _ImageParallaxScreenState();
}

class _ImageParallaxScreenState extends State<ImageParallaxScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));

  late AnimationController scrollAnimationController =
      AnimationController(vsync: this);

  late Animation<double> positionAnimation =
      Tween<double>(begin: 0, end: -20).animate(scrollAnimationController);

  late final ScrollController scrollController = ScrollController()
    ..addListener(scrollListener);

  int selectedIndex = -1;

  final imagesCount = 12;

  List<ScrollController> innerImageScrollControllers = [];

  void scrollListener() {
    scrollAnimationController.value = Utils.inRange(
        currentValue: scrollController.offset,
        minValue: scrollController.position.minScrollExtent,
        maxValue: scrollController.position.maxScrollExtent,
        newMaxValue: 1.0,
        newMinValue: 0.0);

    for (var controller in innerImageScrollControllers) {
      controller.jumpTo(
        Utils.inRange(
            currentValue: scrollController.offset,
            minValue: scrollController.position.minScrollExtent,
            maxValue: scrollController.position.maxScrollExtent,
            newMaxValue: controller.position.maxScrollExtent * (0.5),
            newMinValue: controller.position.minScrollExtent * (0.5)),
      );
    }
  }

  @override
  void initState() {
    for (var i = 0; i < 12; i++) {
      innerImageScrollControllers.add(ScrollController());
    }
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in innerImageScrollControllers) {
      controller.dispose();
    }
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    scrollAnimationController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(),
        body: GridView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15),
            itemCount: imagesCount,
            itemBuilder: (context, index) {
              return LayoutBuilder(builder: (context, boxConstraints) {
                return GestureDetector(
                  onTap: () {
                    selectedIndex = index;
                    if (animationController.isCompleted) {
                      animationController.reverse();
                    } else {
                      animationController.forward();
                    }
                  },
                  child: SizedBox(
                    height: boxConstraints.maxHeight,
                    width: boxConstraints.maxWidth,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          AnimatedBuilder(
                            animation: scrollAnimationController,
                            builder: (context, child) {
                              //positionAnimation.value
                              return Positioned(top: 0, child: child!);
                            },
                            child: Container(
                              width: boxConstraints.maxWidth,
                              height: boxConstraints.maxHeight,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              child: IgnorePointer(
                                ignoring: true,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: ListView(
                                    controller:
                                        innerImageScrollControllers[index],
                                    children: [
                                      Image.asset(
                                        "assets/images/minion.jpeg",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AnimatedBuilder(
                              animation: animationController,
                              builder: (context, _) {
                                return Container(
                                  width: boxConstraints.maxWidth,
                                  height: boxConstraints.maxHeight,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: selectedIndex == index
                                          ? 0
                                          : animationController.value * 5,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
                );
              });
            }));
  }
}
