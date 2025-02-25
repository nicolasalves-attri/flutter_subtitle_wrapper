import 'dart:async';

import 'package:flutter/material.dart';
import 'package:subtitle_wrapper_package/bloc/subtitle/subtitle_bloc.dart';

class SubtitleController {
  String? subtitlesContent;
  String? subtitleUrl;
  final bool showSubtitles;
  SubtitleDecoder? subtitleDecoder;
  SubtitleType subtitleType;
  final StreamController<bool> isShowingController = StreamController();
  final hide = ValueNotifier<bool>(false);

  //
  bool _attached = false;
  SubtitleBloc? _subtitleBloc;

  SubtitleController({
    this.subtitleUrl,
    this.subtitlesContent,
    this.showSubtitles = true,
    this.subtitleDecoder,
    this.subtitleType = SubtitleType.webvtt,
  });

  void attach(SubtitleBloc subtitleBloc) {
    _subtitleBloc = subtitleBloc;
    _attached = true;
  }

  void detach() {
    _attached = false;
    _subtitleBloc = null;
  }

  void updateSubtitleUrl({
    required String url,
  }) {
    if (_attached) {
      subtitleUrl = url;
      _subtitleBloc!.add(
        InitSubtitles(
          subtitleController: this,
        ),
      );
    } else {
      throw Exception('Seems that the controller is not correctly attached.');
    }
  }

  void updateSubtitleContent({
    required String content,
  }) {
    if (_attached) {
      subtitlesContent = content;
      _subtitleBloc!.add(
        InitSubtitles(
          subtitleController: this,
        ),
      );
    } else {
      throw Exception('Seems that the controller is not correctly attached.');
    }
  }

  void hideSubtitle() {
    hide.value = true;
    _subtitleBloc!.add(
      HideSubtitle(subtitleController: this),
    );
  }

  void showSubtitle() {
    hide.value = false;
    _subtitleBloc!.add(
      LoadSubtitle(),
    );
  }

  void showingController() {
    isShowingController.add(true);
  }

  void hidingController() {
    isShowingController.add(false);
  }
}

enum SubtitleDecoder {
  utf8,
  latin1,
}

enum SubtitleType {
  webvtt,
  srt,
}
