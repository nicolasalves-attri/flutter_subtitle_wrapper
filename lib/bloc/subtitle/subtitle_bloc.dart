import 'dart:async';

import 'package:bitmovin_player/bitmovin_player.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';

part 'subtitle_event.dart';
part 'subtitle_state.dart';

class SubtitleBloc extends Bloc<SubtitleEvent, SubtitleState> {
  final BitmovinPlayerController videoPlayerController;
  final SubtitleRepository subtitleRepository;
  final SubtitleController subtitleController;

  late Subtitles subtitles;

  SubtitleBloc({
    required this.videoPlayerController,
    required this.subtitleRepository,
    required this.subtitleController,
  }) : super(SubtitleInitial()) {
    subtitleController.attach(this);
    on<HideSubtitle>((event, emit) => _hideSubtitle());
    on<LoadSubtitle>((event, emit) => loadSubtitle(emit: emit));
    on<InitSubtitles>((event, emit) => initSubtitles(emit: emit));
    on<UpdateLoadedSubtitle>(
      (event, emit) => emit(LoadedSubtitle(event.subtitle)),
    );
    on<CompletedShowingSubtitles>(
      (event, emit) => emit(CompletedSubtitle()),
    );
  }

  Future<void> initSubtitles({
    required Emitter<SubtitleState> emit,
  }) async {
    emit(SubtitleInitializing());
    subtitles = await subtitleRepository.getSubtitles();
    emit(SubtitleInitialized());
  }

  Future<void> loadSubtitle({
    required Emitter<SubtitleState> emit,
  }) async {
    emit(LoadingSubtitle());
    videoPlayerController.addListener(_videoListener);
  }

  @override
  Future<void> close() {
    videoPlayerController.removeListener(_videoListener);
    subtitleController.detach();

    return super.close();
  }

  void _videoListener() {
    final videoPlayerPosition = videoPlayerController.value.position;
    if (videoPlayerPosition.inMilliseconds > subtitles.subtitles.last.endTime.inMilliseconds) {
      add(CompletedShowingSubtitles());
    }

    Subtitle subtitleItem = Subtitle.empty();

    for (final Subtitle item in subtitles.subtitles) {
      final bool validStartTime = videoPlayerPosition.inMilliseconds > item.startTime.inMilliseconds;
      final bool validEndTime = videoPlayerPosition.inMilliseconds < item.endTime.inMilliseconds;
      if (validStartTime && validEndTime) {
        subtitleItem = item;
        // add(UpdateLoadedSubtitle(subtitle: subtitleItem));
      }
    }

    if (!isClosed) add(UpdateLoadedSubtitle(subtitle: subtitleItem));
  }

  void _hideSubtitle() {
    videoPlayerController.removeListener(_videoListener);
    add(UpdateLoadedSubtitle(subtitle: Subtitle.empty()));
  }
}
