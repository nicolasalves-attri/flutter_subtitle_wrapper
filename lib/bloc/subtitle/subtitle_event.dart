part of 'subtitle_bloc.dart';

abstract class SubtitleEvent {
  const SubtitleEvent();
}

class InitSubtitles extends SubtitleEvent {
  final SubtitleController subtitleController;

  InitSubtitles({required this.subtitleController});
}

class LoadSubtitle extends SubtitleEvent {}

class UpdateLoadedSubtitle extends SubtitleEvent {
  final Subtitle subtitle;

  UpdateLoadedSubtitle({required this.subtitle});
}

class HideSubtitle extends SubtitleEvent {
  final SubtitleController subtitleController;

  HideSubtitle({required this.subtitleController});
}

class CompletedShowingSubtitles extends SubtitleEvent {}
