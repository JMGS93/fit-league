import 'package:flutter/material.dart';
import 'package:nuevo_proyecto/main_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExerciseItem extends StatefulWidget {
  final String name;
  final String videoUrl;
  final bool showControls;

  const ExerciseItem({
    Key? key,
    required this.name,
    required this.videoUrl,
    required this.showControls,
  }) : super(key: key);

  @override
  ExerciseItemState createState() => ExerciseItemState();
}

class ExerciseItemState extends State<ExerciseItem> {
  @override
  Widget build(BuildContext context) {
    final parts = widget.name.split(RegExp(r':\s*'));
    final title = parts.first;
    final subtitle = parts.length > 1 ? parts.sublist(1).join(': ') : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (widget.showControls) ...[
            const AnimatedArrow(),
            const SizedBox(width: 20),
            Transform.translate(
              offset: const Offset(-10, -12),
              child: IconButton(
                icon: const Icon(
                  Icons.play_circle_fill,
                  size: 32,
                  color: Colors.yellow,
                ),
                onPressed: _showVideoDialog,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showVideoDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: _VideoDialogContent(videoUrl: widget.videoUrl),
      ),
    );
  }
}

class _VideoDialogContent extends StatefulWidget {
  final String videoUrl;
  const _VideoDialogContent({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  State<_VideoDialogContent> createState() => _VideoDialogContentState();
}

class _VideoDialogContentState extends State<_VideoDialogContent> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      })
      ..setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.yellow, width: 2),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_controller.value.isInitialized)
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          else
            const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  _controller.value.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  color: Colors.red,
                  size: 32,
                ),
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(loc.close, style: const TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}