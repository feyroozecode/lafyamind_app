// lib/src/features/feed/presentation/widgets/video_item_widget.dart
import 'package:flutter/material.dart';
import 'package:lafyamind_app/src/features/feed/domain/feed_item.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoItemWidget extends StatefulWidget {
  // Changed to StatefulWidget for player state
  final VideoItem item;

  const VideoItemWidget({super.key, required this.item});

  @override
  State<VideoItemWidget> createState() => _VideoItemWidgetState();
}

class _VideoItemWidgetState extends State<VideoItemWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController; // Make nullable for initialization phase
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    // Use Uri.parse for robustness
    final videoUri = Uri.parse(widget.item.videoUrl);
    _videoPlayerController = VideoPlayerController.networkUrl(videoUri);

    try {
      await _videoPlayerController.initialize(); // Initialize the player

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: 16 / 9, // Or get from video metadata if needed
        autoInitialize:
            true, // Initializes the video player when the widget is built
        autoPlay: false, // Don't autoplay in a feed
        looping: false,
        placeholder: _buildThumbnail(), // Show thumbnail while loading
        // Add more customization options as needed:
        // showControls: true,
        // materialProgressColors: ChewieProgressColors(...),
        // errorBuilder: (context, errorMessage) { ... }
      );
      setState(() {
        _isLoading = false; // Loading complete
      });
    } catch (e) {
      // Handle initialization errors (e.g., network issues, invalid URL)
      print("Error initializing video player: $e");
      setState(() {
        _isLoading = false; // Stop loading on error
        // Optionally show an error state in the UI
      });
    }
  }

  @override
  void dispose() {
    // IMPORTANT: Dispose controllers to free up resources
    _videoPlayerController.dispose();
    _chewieController?.dispose(); // Use null-aware call
    super.dispose();
  }

  Widget _buildThumbnail() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          widget.item.thumbnailUrl,
          fit: BoxFit.cover,
          // Add error builder for thumbnail loading errors
          errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(Icons.error_outline, color: Colors.grey)),
        ),
        const Center(
          child:
              CircularProgressIndicator(), // Show loading indicator over thumbnail
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      clipBehavior:
          Clip.antiAlias, // Ensures Chewie corners are rounded with the card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Player Area
          AspectRatio(
            aspectRatio: 16 / 9, // Maintain aspect ratio
            child: _isLoading
                ? _buildThumbnail() // Show thumbnail/loader while initializing
                : _chewieController != null
                    ? Chewie(controller: _chewieController!)
                    : Container(
                        // Fallback/Error state if controller failed
                        color: Colors.black,
                        child: const Center(
                          child: Icon(Icons.error, color: Colors.red, size: 50),
                        ),
                      ),
          ),
          // Video Info Area
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.item.title,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4.0),
                Text('Channel: ${widget.item.channel}',
                    style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 8.0),
                Text(
                  'Uploaded: ${widget.item.timestamp.toLocal()}', // Format as needed
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
