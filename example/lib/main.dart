import 'package:bitmovin_player/bitmovin_player.dart';
import 'package:chewie/chewie.dart';
import 'package:example/data/sw_constants.dart';
import 'package:flutter/material.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String link = SwConstants.videoUrl;
  final SubtitleController subtitleController = SubtitleController(
    subtitleUrl: 'https://www.nicolasalves.dev.br/legenda-teste.vtt',
    subtitleDecoder: SubtitleDecoder.utf8,
  );

  late BitmovinPlayerController videoController;
  @override
  void initState() {
    super.initState();
    videoController = BitmovinPlayerController.network(
      'https://dacastmmod-mmd-cust.lldns.net/e2/cdd5f530-9b2d-90b1-901e-614083c77aab/stream.ismd/manifest.m3u8?stream=77d042d5-7b71-5050-e031-31ed4e0b3656_rendition%3B72871450-d4a6-4979-afb4-de8544f7d777_rendition%3B59feb029-b7c0-00a7-1640-ceb48d130f76_rendition%3B0494ca03-9289-7c1b-c9bc-4ed0eebb9744_rendition&p=90&h=617ee645698e46a4cd7d3d8fc523b52f',
      sourceConfig: BitmovinSourceConfig(
        subtitles: [
          // BSubtitleTrack(
          //   'https://www.nicolasalves.dev.br/legenda-teste.vtt',
          //   id: "br",
          //   label: 'pt-br',
          //   language: 'pt-br',
          //   isDefault: true,
          // )
        ],
        defaultSubtitleTrackId: 'br',
      ),
    );
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0b090a),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
            ),
            child: SizedBox(
              // height: 270,
              child: SubtitleWrapper(
                videoPlayerController: videoController,
                subtitleController: subtitleController,
                subtitleStyle: const SubtitleStyle(
                  textColor: Colors.white,
                  hasBorder: true,
                  fontSize: 12,
                  borderStyle: SubtitleBorderStyle(color: Colors.black54),
                ),
                backgroundColor: Colors.black45,
                videoChild: BitmovinPlayer(controller: videoController),
              ),
            ),
          ),
          Row(
            children: [
              TextButton(onPressed: () => videoController.play(), child: Text('Play')),
              TextButton(onPressed: () => videoController.pause(), child: Text('Pause')),
              TextButton(onPressed: () => videoController.seekTo(Duration.zero), child: Text('Restart')),
            ],
          ),
          Expanded(
            child: Container(
              color: const Color(
                0xff161a1d,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(
                        16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Flutter subtitle wrapper package',
                            style: TextStyle(
                              fontSize: 28.0,
                              color: Colors.white.withOpacity(
                                0.8,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 18.0,
                            ),
                            child: Text(
                              'This package can display SRT and WebVtt subtitles. With a lot of customizable options and dynamic updating support.',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white.withOpacity(
                                  0.8,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'Options.',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white.withOpacity(
                                0.8,
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum ExampleSubtitleLanguage {
  english,
  spanish,
  dutch,
}
