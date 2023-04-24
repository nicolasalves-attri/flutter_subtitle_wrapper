library subtitle_wrapper_package;

import 'package:bitmovin_player/bitmovin_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtitle_wrapper_package/bloc/subtitle/subtitle_bloc.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';

class SubtitleWrapper extends StatelessWidget {
  final Widget videoChild;
  final SubtitleController subtitleController;
  final BitmovinPlayerController videoPlayerController;
  final SubtitleStyle subtitleStyle;
  final Color? backgroundColor;

  const SubtitleWrapper({
    Key? key,
    required this.videoChild,
    required this.subtitleController,
    required this.videoPlayerController,
    this.subtitleStyle = const SubtitleStyle(),
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: subtitleController.isShowingController.stream,
      builder: (_, showingController) => Stack(
        // fit: StackFit.expand,
        children: <Widget>[
          videoChild,
          if (subtitleController.showSubtitles)
            BlocProvider(
              create: (context) => SubtitleBloc(
                videoPlayerController: videoPlayerController,
                subtitleRepository: SubtitleDataRepository(subtitleController: subtitleController),
                subtitleController: subtitleController,
              )..add(InitSubtitles(subtitleController: subtitleController)),
              child: ValueListenableBuilder<bool>(
                valueListenable: subtitleController.hide,
                builder: (_, hide, __) => !hide
                    ? SubtitleTextView(
                        subtitleStyle: subtitleStyle,
                        backgroundColor: backgroundColor,
                        showingController: showingController.data == true,
                      )
                    : const Offstage(),
              ),
            )
          else
            Container(),
        ],
      ),
    );
  }
}
