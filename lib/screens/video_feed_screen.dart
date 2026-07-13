import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/video_model.dart';
import '../services/video_service.dart';
import '../services/like_service.dart';
import '../services/comment_service.dart';
import '../services/auth_service.dart';

class VideoFeedScreen extends StatefulWidget {
  @override
  State<VideoFeedScreen> createState() => _VideoFeedScreenState();
}

class _VideoFeedScreenState extends State<VideoFeedScreen> {
  final VideoService _videoService = VideoService();
  final LikeService _likeService = LikeService();
  final CommentService _commentService = CommentService();
  final AuthService _authService = AuthService();
  
  late PageController _pageController;
  List<VideoModel> videos = [];
  bool isLoading = true;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    final loadedVideos = await _videoService.getAllVideos();
    setState(() {
      videos = loadedVideos;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (videos.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text('لا توجد فيديوهات حتى الآن'),
        ),
      );
    }

    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: (index) {
          setState(() => currentIndex = index);
          // زيادة المشاهدات
          _videoService.incrementViews(videos[index].videoId);
        },
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return VideoPlayerWidget(
            video: videos[index],
            videoService: _videoService,
            likeService: _likeService,
            commentService: _commentService,
            authService: _authService,
          );
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final VideoModel video;
  final VideoService videoService;
  final LikeService likeService;
  final CommentService commentService;
  final AuthService authService;

  const VideoPlayerWidget({
    required this.video,
    required this.videoService,
    required this.likeService,
    required this.commentService,
    required this.authService,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoController;
  bool _isLiked = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _checkIfLiked();
  }

  Future<void> _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.network(widget.video.videoUrl)
        ..initialize().then((_) {
          setState(() {
            _isInitialized = true;
          });
          _videoController.play();
        });
    } catch (e) {
      print('خطأ في تحميل الفيديو: $e');
    }
  }

  Future<void> _checkIfLiked() async {
    final user = await widget.authService.getCurrentUser();
    if (user != null) {
      final liked = await widget.likeService.isLiked(widget.video.videoId, user.uid);
      setState(() {
        _isLiked = liked;
      });
    }
  }

  Future<void> _toggleLike() async {
    final user = await widget.authService.getCurrentUser();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى تسجيل الدخول أولاً')),
      );
      return;
    }

    if (_isLiked) {
      await widget.likeService.unlikeVideo(widget.video.videoId, user.uid);
    } else {
      await widget.likeService.likeVideo(widget.video.videoId, user.uid);
    }

    setState(() {
      _isLiked = !_isLiked;
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // الفيديو
        _isInitialized
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _videoController.value.isPlaying
                        ? _videoController.pause()
                        : _videoController.play();
                  });
                },
                child: AspectRatio(
                  aspectRatio: _videoController.value.aspectRatio,
                  child: VideoPlayer(_videoController),
                ),
              )
            : Container(
                color: Colors.black,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
        // معلومات الفيديو
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black87,
                  Colors.transparent,
                ],
              ),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.video.username,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.video.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        // أزرار التفاعل (اليمين)
        Positioned(
          right: 10,
          bottom: 100,
          child: Column(
            children: [
              // زر الإعجاب
              GestureDetector(
                onTap: _toggleLike,
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black26,
                      ),
                      child: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: _isLiked ? Colors.red : Colors.white,
                        size: 28,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.video.likes.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // زر التعليقات
              GestureDetector(
                onTap: () {
                  _showCommentsSheet(context);
                },
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black26,
                      ),
                      child: Icon(
                        Icons.comment,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.video.comments.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // زر المشاهدات
              Column(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black26,
                    ),
                    child: Icon(
                      Icons.visibility,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.video.views.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCommentsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CommentsSheet(
        videoId: widget.video.videoId,
        commentService: widget.commentService,
        authService: widget.authService,
      ),
    );
  }
}

class CommentsSheet extends StatefulWidget {
  final String videoId;
  final CommentService commentService;
  final AuthService authService;

  const CommentsSheet({
    required this.videoId,
    required this.commentService,
    required this.authService,
  });

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final TextEditingController _commentController = TextEditingController();
  bool _isPosting = false;

  Future<void> _postComment() async {
    if (_commentController.text.isEmpty) return;

    setState(() => _isPosting = true);

    try {
      final user = await widget.authService.getCurrentUser();
      if (user != null) {
        await widget.commentService.addComment(
          videoId: widget.videoId,
          uid: user.uid,
          username: user.username,
          text: _commentController.text.trim(),
        );
        _commentController.clear();
      }
    } catch (e) {
      print('خطأ في نشر التعليق: $e');
    } finally {
      setState(() => _isPosting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'التعليقات',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: widget.commentService.commentsStream(widget.videoId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final comments = snapshot.data ?? [];

                  if (comments.isEmpty) {
                    return Center(
                      child: Text(
                        'لا توجد تعليقات حتى الآن',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: scrollController,
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment.username,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              comment.text,
                              style: TextStyle(color: Colors.white70),
                            ),
                            SizedBox(height: 8),
                            Text(
                              comment.createdAt.toString().split('.')[0],
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Divider(color: Colors.grey[700]),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // حقل إدخال التعليق
            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'أضف تعليقاً...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                        fillColor: Colors.grey[800],
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: _isPosting ? null : _postComment,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF6A1B9A),
                      ),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
