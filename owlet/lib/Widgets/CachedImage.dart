import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration(milliseconds: 0),
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];
  final VideoPlayerController controller;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
            color: Colors.black26,
            child: const Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 50.0,
                semanticLabel: 'Play',
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if(controller.value.isInitialized)
            controller.value.isPlaying ? controller.pause() : controller.play();
            else
              {
                controller.initialize();

              }

          },
        ),
        // Align(
        //   alignment: Alignment.topLeft,
        //   child: PopupMenuButton<Duration>(
        //     initialValue: controller.value.captionOffset,
        //     tooltip: 'Caption Offset',
        //     onSelected: (Duration delay) {
        //       controller.setCaptionOffset(delay);
        //     },
        //     itemBuilder: (BuildContext context) {
        //       return <PopupMenuItem<Duration>>[
        //         for (final Duration offsetDuration in _exampleCaptionOffsets)
        //           PopupMenuItem<Duration>(
        //             value: offsetDuration,
        //             child: Text('${offsetDuration.inMilliseconds}ms'),
        //           )
        //       ];
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(
        //         // Using less vertical padding as the text is also longer
        //         // horizontally, so it feels like it would need more spacing
        //         // horizontally (matching the aspect ratio of the video).
        //         vertical: 12,
        //         horizontal: 16,
        //       ),
        //       child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
        //     ),
        //   ),
        // ),
        // Align(
        //   alignment: Alignment.topRight,
        //   child: PopupMenuButton<double>(
        //     initialValue: controller.value.playbackSpeed,
        //     tooltip: 'Playback speed',
        //     onSelected: (double speed) {
        //       controller.setPlaybackSpeed(speed);
        //     },
        //     itemBuilder: (BuildContext context) {
        //       return <PopupMenuItem<double>>[
        //         for (final double speed in _examplePlaybackRates)
        //           PopupMenuItem<double>(
        //             value: speed,
        //             child: Text('${speed}x'),
        //           )
        //       ];
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(
        //         // Using less vertical padding as the text is also longer
        //         // horizontally, so it feels like it would need more spacing
        //         // horizontally (matching the aspect ratio of the video).
        //         vertical: 12,
        //         horizontal: 16,
        //       ),
        //       child: Text('${controller.value.playbackSpeed}x'),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class CachedImage extends StatefulWidget {
  const CachedImage({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  final String imageUrl;

  @override
  State<CachedImage> createState() => _CachedImageState();
}
class _CachedImageState extends State<CachedImage> {
  late VideoPlayerController _controller;
  //`
  // @override
  // void initState() {
  //   super.initState();
  //   _controller = VideoPlayerController.network(
  //       'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
  //     ..initialize().then((_) {
  //       // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
  //       setState(() {});
  //     });
  // }`
  @override
  void initState() {
    super.initState();
    if(widget.imageUrl.contains(".mp4")) {
      _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      _controller.addListener(() {
        setState(() {});
      });
      _controller.setLooping(true);
      _controller.initialize();
      if (_controller.value.isInitialized) {
        _controller.play();
      }
      else {
        _controller.initialize();
      }
    }

  }


  @override
  void dispose() {
    if (_controller.value.isInitialized) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoPlayerController = VideoPlayerController.network(widget.imageUrl);
    String ext = widget.imageUrl.toString().split(".").last;
    return ext != "mp4"
        ? CachedNetworkImage(
      imageUrl: widget.imageUrl,
      fit: BoxFit.cover,
      progressIndicatorBuilder: (_, st, status) =>
          CupertinoActivityIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
      // useOldImageOnUrlChange: true,
    )
        :
     Container(
       child: AspectRatio(
         aspectRatio: _controller.value.aspectRatio,
         child: Stack(
           alignment: Alignment.bottomCenter,
           children: <Widget>[
             VideoPlayer(_controller),

             // ClosedCaption(text: _controller.value.caption.text),
             _ControlsOverlay(controller: _controller),
             VideoProgressIndicator(_controller, allowScrubbing: true),
             Image.asset("assets/images/transbase.png")
           ],
         ),
       ),
     );
  }
}
