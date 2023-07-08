import 'package:flavour_demo/app/appConfig.dart';
import 'package:flavour_demo/cubits/botConversationCubit.dart';
import 'package:flavour_demo/cubits/botQueryCubit.dart';
import 'package:flavour_demo/data/repositories/botRepository.dart';
import 'package:flavour_demo/ui/screens/botScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  //To animate the white container, logo scale
  late final AnimationController _animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 800));

  //To chaneg the offset of the white container, logo, text icon (fade and slide)
  late final AnimationController _translateAnimationController =
      AnimationController(
          vsync: this, duration: const Duration(milliseconds: 500));

  late final Animation<double> _whiteContainerAnimation =
      Tween<double>(begin: 1.0, end: 0.2).animate(CurvedAnimation(
          parent: _animationController, curve: Curves.easeInOut));

  //To increase the scale
  late final Animation<double> _iconfirstAnimation =
      Tween<double>(begin: 0.0, end: 1.5).animate(CurvedAnimation(
          parent: _animationController, curve: const Interval(0.1, 0.7)));

  //To decrease the scale
  late final Animation<double> _iconsecondAnimation =
      Tween<double>(begin: 0.0, end: 0.5).animate(CurvedAnimation(
          parent: _animationController, curve: const Interval(0.7, 1.0)));

  late final Animation<Offset> _whiteContainerAndIconTranslateAnimation =
      Tween<Offset>(
              begin: const Offset(0.0, 0.0), end: const Offset(0.0, -0.075))
          .animate(CurvedAnimation(
              parent: _translateAnimationController, curve: Curves.easeInOut));

  //Transalte the text icon animation
  late final Animation<Offset> _appNameTranslateAnimation = Tween<Offset>(
          begin: const Offset(0.0, 0.075), end: const Offset(0.0, 0.0))
      .animate(CurvedAnimation(
          parent: _translateAnimationController, curve: Curves.easeInOut));

  @override
  void initState() {
    _animationController
        .forward()
        .then((value) => _translateAnimationController.forward());
    super.initState();
  }

  @override
  void dispose() {
    _translateAnimationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        title: Text(AppConfig().baseUrl),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        // if (_translateAnimationController.isCompleted) {
        //   _translateAnimationController
        //       .reverse()
        //       .then((value) => _animationController.reverse());
        // } else {
        //   _animationController
        //       .forward()
        //       .then((value) => _translateAnimationController.forward());
        // }
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (_) => MultiBlocProvider(providers: [
        //           BlocProvider(
        //             create: (context) => PdfViewCubit(),
        //           ),
        //           BlocProvider(
        //             create: (context) =>
        //                 DownloadFileCubit(DownloadRepository()),
        //           ),
        //         ], child: const PdfViewScreen())));

        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => BotQueryCubit(BotRepository()),
                    ),
                    BlocProvider(
                      create: (context) =>
                          BotConversationCubit(BotRepository()),
                    ),
                  ],
                  child: const BotScreen(),
                )));
      }),
      body: Stack(
        children: [
          SlideTransition(
            position: _whiteContainerAndIconTranslateAnimation,
            child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, _) {
                  return Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          //To change the border radius
                          borderRadius: BorderRadius.circular(
                              20 * (1.0 - _whiteContainerAnimation.value))),
                      //To change the height
                      height: MediaQuery.of(context).size.height *
                          (_whiteContainerAnimation.value),
                      //To change the width
                      width: MediaQuery.of(context).size.height *
                          (_whiteContainerAnimation.value),
                    ),
                  );
                }),
          ),
          SlideTransition(
            position: _whiteContainerAndIconTranslateAnimation,
            child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, _) {
                  //Calculate the final scale based on two animation(interval) given
                  double scale =
                      _iconfirstAnimation.value - _iconsecondAnimation.value;
                  return Center(
                    child: Transform.scale(
                        scale: scale,
                        child: SvgPicture.asset("assets/images/mainlogo.svg")),
                  );
                }),
          ),
          FadeTransition(
            opacity: _translateAnimationController,
            child: SlideTransition(
              position: _appNameTranslateAnimation,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * (0.2)),
                  child: SvgPicture.asset("assets/images/textlogo.svg"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
