import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:subtitle_wrapper_package/bloc/subtitle/subtitle_bloc.dart';
import 'package:subtitle_wrapper_package/data/constants/view_keys.dart';
import 'package:subtitle_wrapper_package/data/models/style/subtitle_style.dart';
import 'package:subtitle_wrapper_package/data/models/subtitle.dart';

class SubtitleTextView extends StatelessWidget {
  final SubtitleStyle subtitleStyle;
  final Color? backgroundColor;

  const SubtitleTextView({
    super.key,
    required this.subtitleStyle,
    this.backgroundColor,
  });

  TextStyle get _textStyle {
    return subtitleStyle.hasBorder
        ? TextStyle(
            fontSize: subtitleStyle.fontSize,
            foreground: Paint()
              ..style = subtitleStyle.borderStyle.style
              ..strokeWidth = subtitleStyle.borderStyle.strokeWidth
              ..color = subtitleStyle.borderStyle.color,
          )
        : TextStyle(
            fontSize: subtitleStyle.fontSize,
            color: subtitleStyle.textColor,
          );
  }

  double percentToPositionOffset(double percent) {
    return (percent - 50) / 50;
  }

  @override
  Widget build(BuildContext context) {
    final subtitleBloc = BlocProvider.of<SubtitleBloc>(context);

    // TODO (Joran-Dob), improve this workaround.
    void _subtitleBlocListener(BuildContext _, SubtitleState state) {
      if (state is SubtitleInitialized) {
        subtitleBloc.add(LoadSubtitle());
      }
    }

    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocConsumer<SubtitleBloc, SubtitleState>(
          listener: _subtitleBlocListener,
          builder: (context, state) {
            if (state is LoadedSubtitle) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return Align(
                    alignment:
                        Alignment(percentToPositionOffset(state.subtitle!.position ?? 50), percentToPositionOffset(state.subtitle!.line ?? 100)),
                    child: Container(
                      constraints:
                          state.subtitle?.size != null ? BoxConstraints(maxWidth: constraints.maxWidth * (state.subtitle!.size! / 100)) : null,
                      child: Stack(
                        children: [
                          IntrinsicWidth(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                              color: backgroundColor,
                              child: _TextContent(
                                state.subtitle!,
                                textStyle: _textStyle,
                              ),
                            ),
                          ),
                          if (subtitleStyle.hasBorder)
                            IntrinsicWidth(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                child: _TextContent(
                                  state.subtitle!,
                                  textStyle: TextStyle(
                                    color: subtitleStyle.textColor,
                                    fontSize: subtitleStyle.fontSize,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Offstage();
            }
            // print('reload');
            return state is LoadedSubtitle
                ? ColoredBox(
                    color: Colors.green,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            color: backgroundColor,
                            padding: const EdgeInsets.all(3),
                            child: _TextContent(
                              state.subtitle!,
                              textStyle: _textStyle,
                            ),
                          ),
                        ),
                        if (subtitleStyle.hasBorder)
                          ColoredBox(
                            color: Colors.green,
                            child: Center(
                              child: Container(
                                color: backgroundColor,
                                padding: const EdgeInsets.all(3),
                                child: _TextContent(
                                  state.subtitle!,
                                  textStyle: TextStyle(
                                    color: subtitleStyle.textColor,
                                    fontSize: subtitleStyle.fontSize,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                : Container();
          },
        ),
      ),
    );
  }
}

class _TextContent extends StatelessWidget {
  const _TextContent(
    this.subtitle, {
    super.key,
    required this.textStyle,
  });

  final TextStyle textStyle;
  final Subtitle subtitle;

  String? get cssTextAlign {
    switch (subtitle.align) {
      case 'start':
        return 'left';
      case 'end':
        return 'right';
      default:
        return subtitle.align;
    }
  }

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      '<div>${subtitle.text}</div>',
      key: ViewKeys.subtitleTextContent,
      textStyle: textStyle,
      customStylesBuilder: (element) => {'text-align': cssTextAlign ?? 'center'},
    );
  }
}
