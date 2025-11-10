import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:presentationgenie/l10n/app_localizations.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_assets.dart';
import '../core/services/markdown_service.dart';
import '../core/services/audio_service.dart';
import '../core/services/language_service.dart';
import '../core/providers/localization_provider.dart';
import '../core/helpers/audio_ui_helper.dart';
import 'settings_screen.dart';

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String id;

  ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
    String? id,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
}

class ChatHistoryItem {
  final String id;
  final String title;
  final DateTime timestamp;

  ChatHistoryItem({required this.id, required this.title, required this.timestamp});
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _hasText = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  late AudioService _audioService;
  String _currentTranscription = '';

  // Mock chat history data
  final List<ChatHistoryItem> _chatHistory = [
    ChatHistoryItem(id: '1', title: 'Marketing Strategy Presentation', timestamp: DateTime.now().subtract(const Duration(hours: 2))),
    ChatHistoryItem(id: '2', title: 'Q4 Financial Report', timestamp: DateTime.now().subtract(const Duration(days: 1))),
    ChatHistoryItem(id: '3', title: 'Product Launch Slides', timestamp: DateTime.now().subtract(const Duration(days: 2))),
    ChatHistoryItem(id: '4', title: 'Team Meeting Agenda', timestamp: DateTime.now().subtract(const Duration(days: 3))),
    ChatHistoryItem(id: '5', title: 'Sales Performance Review', timestamp: DateTime.now().subtract(const Duration(days: 5))),
    ChatHistoryItem(id: '6', title: 'Customer Feedback Analysis', timestamp: DateTime.now().subtract(const Duration(days: 7))),
    ChatHistoryItem(id: '7', title: 'Project Timeline Overview', timestamp: DateTime.now().subtract(const Duration(days: 10))),
    ChatHistoryItem(id: '8', title: 'Budget Planning Session', timestamp: DateTime.now().subtract(const Duration(days: 12))),
    ChatHistoryItem(id: '9', title: 'Competitive Analysis Report', timestamp: DateTime.now().subtract(const Duration(days: 15))),
    ChatHistoryItem(id: '10', title: 'Training Workshop Materials', timestamp: DateTime.now().subtract(const Duration(days: 18))),
    ChatHistoryItem(id: '11', title: 'Annual Company Review', timestamp: DateTime.now().subtract(const Duration(days: 20))),
    ChatHistoryItem(id: '12', title: 'Innovation Strategy Deck', timestamp: DateTime.now().subtract(const Duration(days: 25))),
  ];

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
    _audioService.initializeSpeechToText();
    
    _messageController.addListener(() {
      setState(() {
        _hasText = _messageController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen to locale changes (this is called on first build and when provider changes)
    final localizationProvider = Provider.of<LocalizationProvider>(context);
    if (localizationProvider.isLoaded) {
      final languageCode = localizationProvider.currentLocale.languageCode;
      _updateAudioLanguage(languageCode);
    }
  }

  /// Update audio service language when locale changes
  void _updateAudioLanguage(String languageCode) {
    _audioService.setTtsLanguage(languageCode);
    debugPrint('🌍 Audio language updated to: $languageCode');
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _audioService.dispose();
    super.dispose();
  }

  /// Handle microphone button press
  void _handleMicrophonePress() async {
    if (_audioService.isListening) {
      // Stop listening and send the message
      await _audioService.stopListening();
      if (_currentTranscription.isNotEmpty) {
        _messageController.text = _currentTranscription;
        _sendMessage();
        _currentTranscription = '';
      } else {
        // Show dialog if no text was captured
        if (mounted) {
          AudioUIHelper.showNoSpeechDetectedDialog(
            context,
            _handleMicrophonePress, // Try again callback
          );
        }
      }
    } else {
      // Reset transcription state
      _currentTranscription = '';

      // Use helper to start listening with all error handling
      await AudioUIHelper.startListeningWithErrorHandling(
        context: context,
        audioService: _audioService,
        onResult: (text) {
          setState(() {
            _currentTranscription = text;
            _messageController.text = text;

            // Just log the transcription for debugging
            final confidence = _audioService.confidenceLevel;
            if (text.length > 5 && confidence > 0) {
              debugPrint('🎤 Transcribed: "$text" (confidence: ${(confidence * 100).toStringAsFixed(1)}%)');
            }
          });

          // Show feedback on first text
          if (text.isNotEmpty && _currentTranscription.isEmpty) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Listening... Keep speaking!'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
        },
        onTryAgain: _handleMicrophonePress, // Try again callback
      );
    }
  }

  void _sendMessage() {
    final String messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    // Stop any ongoing TTS playback when sending a new message
    _audioService.stop();

    setState(() {
      _messages.add(ChatMessage(content: messageText, isUser: true, timestamp: DateTime.now()));
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        // Stop TTS when new response arrives
        _audioService.stop();
        
        setState(() {
          _messages.add(ChatMessage(content: AppLocalizations.of(context)!.aiResponseMessage, isUser: false, timestamp: DateTime.now()));
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  void _navigateToSettings() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsScreen()));
  }

  void _startNewChat() {
    setState(() {
      _messages.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.newChatStarted)));
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _showDeleteChatDialog(ChatHistoryItem chatItem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          AppLocalizations.of(context)!.deleteChat,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        content: Text(
          AppLocalizations.of(context)!.areYouSureYouWantToDeleteChat(chatItem.title),
          style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _chatHistory.removeWhere((item) => item.id == chatItem.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.chatDeleted(chatItem.title))));
            },
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final Duration difference = DateTime.now().difference(timestamp);
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    if (difference.inDays > 0) {
      return difference.inDays == 1 ? l10n.dayAgo(1) : l10n.daysAgo(difference.inDays);
    } else if (difference.inHours > 0) {
      return difference.inHours == 1 ? l10n.hourAgo(1) : l10n.hoursAgo(difference.inHours);
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1 ? l10n.minuteAgo(1) : l10n.minutesAgo(difference.inMinutes);
    } else {
      return l10n.justNow;
    }
  }

  final markdownService = MarkdownService();


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _audioService,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.backgroundWhite,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundWhite,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              GestureDetector(
                onTap: _openDrawer,
                child: const Icon(Icons.menu, color: AppColors.textPrimary),
              ),
              const SizedBox(width: 12),
            ],
          ),
          actions: [
            IconButton(
              onPressed: _startNewChat,
              icon: const Icon(Icons.edit_outlined, color: AppColors.textSecondary),
            ),
          ],
        ),
        drawer: _buildDrawer(),
        body: Column(
          children: [
            // Chat messages
            Expanded(
              child: _messages.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return _messages[index].isUser ? _buildMessageBubble(_messages[index]) : markdownService.renderStreaming(mockStream);
                      },
                    ),
            ),

            // Show transcription indicator if listening
            if (_audioService.isListening) _buildTranscriptionIndicator(),
            
            // Show language hint banner if listening
            if (_audioService.isListening) _buildLanguageHintBanner(),

            // Message input
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  /// Transcription indicator widget
  Widget _buildTranscriptionIndicator() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.mihFiberAccent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.mihFiberGreen, width: 2),
      ),
      child: Row(
        children: [
          // Animated listening indicator
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.mihFiberGreen),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Listening...',
                  style: TextStyle(
                    color: AppColors.mihFiberGreen,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                if (_currentTranscription.isNotEmpty)
                  Text(
                    _currentTranscription,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          // Audio wave animation
          _buildAudioWaveAnimation(),
        ],
      ),
    );
  }

  /// Audio wave animation
  Widget _buildAudioWaveAnimation() {
    return Row(
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 100)),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 3,
          height: 12 + (index * 4).toDouble(),
          decoration: BoxDecoration(
            color: AppColors.mihFiberGreen,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }

  /// Language hint banner
  Widget _buildLanguageHintBanner() {
    final localizationProvider = Provider.of<LocalizationProvider>(context);
    final currentLanguageCode = localizationProvider.currentLocale.languageCode;
    final languageFlag = localizationProvider.getLanguageFlag(currentLanguageCode);
    final languageName = LanguageService.getLanguageName(currentLanguageCode);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.mihFiberGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.mihFiberGreen.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            languageFlag,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 8),
          Text(
            'Speaking in $languageName',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.mihFiberGreen,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.mihFiberAccent, AppColors.mihFiberAccent.withOpacity(0.7)],
              ),
              borderRadius: BorderRadius.circular(45),
              border: Border.all(color: AppColors.mihFiberGreen.withOpacity(0.3), width: 2),
              boxShadow: [BoxShadow(color: AppColors.mihFiberGreen.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(AppColors.mihFiberGreen, BlendMode.srcIn),
              child: Image.asset(AppAssets.genieIcon, width: 24, height: 24),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.whatsOnTheAgendaToday,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              AppLocalizations.of(context)!.startAConversationWithPresentationGenie,
              style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.backgroundWhite,
      child: Column(
        children: [
          // Drawer header with mihFIBER branding
          Container(
            height: 120,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: AppColors.mihFiberGreen.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: const Icon(Icons.menu, color: AppColors.mihFiberGreen, size: 24),
                ),
                const SizedBox(width: 16),
                Text(
                  AppLocalizations.of(context)!.hiJohnDoe,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.mihFiberGreenDark),
                ),
              ],
            ),
          ),

          // Settings option with mihFIBER accent
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.mihFiberGreen.withOpacity(0.2)),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.mihFiberAccent, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.settings_outlined, color: AppColors.mihFiberGreen, size: 20),
              ),
              title: Text(
                AppLocalizations.of(context)!.settings,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
              ),
              trailing: const Icon(Icons.chevron_right, color: AppColors.mihFiberGreen),
              onTap: () {
                Navigator.pop(context);
                _navigateToSettings();
              },
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            height: 1,
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, AppColors.mihFiberGreen.withOpacity(0.3), Colors.transparent])),
          ),

          // Chat History section with accent
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(color: AppColors.mihFiberGreen, borderRadius: BorderRadius.circular(2)),
                ),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.chatHistory,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),

          // Chat history list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _chatHistory.length,
              itemBuilder: (context, index) {
                return _buildChatHistoryItem(_chatHistory[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatHistoryItem(ChatHistoryItem chatItem) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          // Here you could load the specific chat
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.loadingChat(chatItem.title))));
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.backgroundGray.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.mihFiberGreen.withOpacity(0.1)),
            boxShadow: [BoxShadow(color: AppColors.mihFiberGreen.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 1))],
          ),
          child: Row(
            children: [
              // Chat icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: AppColors.backgroundGray, borderRadius: BorderRadius.circular(20)),
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn),
                  child: Image.asset(AppAssets.genieIcon, width: 20, height: 20),
                ),
              ),
              const SizedBox(width: 12),

              // Chat info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chatItem.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(_formatTimestamp(chatItem.timestamp), style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                  ],
                ),
              ),

              // Delete icon
              GestureDetector(
                onTap: () => _showDeleteChatDialog(chatItem),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final String contentToMark = "Here's some detailed Markdown content for you to test, including headings, paragraphs, lists, code blocks, tables, hyperlinks, and image placeholders.\n\n---\n\n# Exploring the Wonders of Ancient Pyramids\n\nPyramids, those enigmatic structures reaching for the sky, have captivated humanity for millennia. From the scorching sands of Egypt to the lush jungles of Mesoamerica, these monumental constructions stand as testaments to ancient civilizations' ingenuity, beliefs, and organizational prowess.\n\n## The Great Pyramids of Giza: A Marvel of Engineering\n\nThe **Giza Necropolis** in Egypt is perhaps the most famous pyramid site, home to the iconic Great Pyramid of Khufu. Built around 2580–2560 BC, it remained the tallest man-made structure for over 3,800 years.\n\n### Construction Theories\n\nThe methods used to construct these colossal structures are still debated by archaeologists and engineers. Some prominent theories include:\n\n*   **Ramp Systems:** Various ramp designs (straight, spiral, internal) have been proposed to explain how massive stone blocks were moved to such heights.\n*   **Leverage and Rollers:** Simple machines like levers and wooden rollers might have been employed for horizontal movement.\n*   **Water-based Systems:** Some speculative theories suggest the use of water locks or flotation, though evidence is scarce.\n\nFor more in-depth information, you can visit the [Wikipedia page on Egyptian Pyramids](https://en.wikipedia.org/wiki/Egyptian_pyramids).\n\n### Internal Structure of the Great Pyramid\n\nThe Great Pyramid contains several key chambers:\n\n1.  **King's Chamber:** Located near the heart of the pyramid, housing a granite sarcophagus.\n2.  **Queen's Chamber:** Despite its name, it's believed to have held a statue of the pharaoh.\n3.  **Grand Gallery:** A magnificent, corbelled passageway leading to the King's Chamber.\n4.  **Subterranean Chamber:** Carved into the bedrock beneath the pyramid.\n\n```python\n# A simple Python function to calculate pyramid volume (square base)\ndef calculate_pyramid_volume(base_side, height):\n    \"\"\"\n    Calculates the volume of a square-based pyramid.\n    Formula: V = (1/3) * base_side^2 * height\n    \"\"\"\n    volume = (1/3) * (base_side ** 2) * height\n    return volume\n\n# Example usage for a hypothetical pyramid\nside = 230  # meters (approx. base side of Great Pyramid)\nh = 146    # meters (approx. original height of Great Pyramid)\nvol = calculate_pyramid_volume(side, h)\nprint(f\"Approximate volume of the Great Pyramid: {vol:.2f} cubic meters\")\n```\n\n## Mesoamerican Pyramids: Temples to the Gods\n\nAcross the Atlantic, civilizations like the Maya, Aztec, and Teotihuacan also built impressive pyramids, though with distinct purposes and architectural styles.\n\n### Key Differences from Egyptian Pyramids\n\n| Feature             | Egyptian Pyramids                               | Mesoamerican Pyramids                               |\n| :------------------ | :---------------------------------------------- | :-------------------------------------------------- |\n| **Primary Function**| Tombs for pharaohs                              | Platforms for temples, rituals, sacrifices          |\n| **Shape**           | Smooth, pointed apex                            | Stepped, often with a temple structure on top       |\n| **Construction**    | Solid stone blocks                              | Earth and rubble core, faced with stone/stucco      |\n| **Internal Space**  | Burial chambers, passages                       | Often solid, or small rooms for priests/offerings   |\n| **Orientation**     | Cardinal directions, celestial alignment        | Cardinal directions, astronomical events (e.g., equinoxes)|\n\n### The Pyramid of the Sun, Teotihuacan\n\nThis colossal structure in Mexico is one of the largest pyramids in Mesoamerica. It was built around 200 CE and is part of the vast ancient city of Teotihuacan.\n\n![Pyramid of the Sun at Teotihuacan](https://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Pir%C3%A1mide_del_Sol_desde_la_Calzada_de_los_Muertos.jpg/800px-Pir%C3%A1mide_del_Sol_desde_la_Calzada_de_los_Muertos.jpg \"The majestic Pyramid of the Sun\")\n*Caption: The Pyramid of the Sun, viewed from the Avenue of the Dead.*\n\n### El Castillo (Chichen Itza)\n\nAlso known as the Temple of Kukulcan, this Mayan pyramid is famous for its astronomical alignments. During the spring and autumn equinoxes, shadows create the illusion of a serpent (Kukulcan) slithering down the staircase.\n\nYou can learn more about this phenomenon here: [Chichen Itza Equinox Phenomenon](https://www.chichenitza.com/chichen-itza-equinox).\n\n---\n\nThis Markdown content should provide a good range of elements for your testing purposes!";
  late final mockStream = MarkdownService.simulateStreaming(contentToMark);

  Widget _buildMessageBubble(ChatMessage message) {
    return Consumer<AudioService>(
      builder: (context, audioService, child) {
        final isPlayingThisMessage = audioService.isSpeaking && 
                                      audioService.currentSpeakingMessageId == message.id;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!message.isUser) ...[
                Image.asset(AppAssets.genieIcon, width: 32, height: 32),
                const SizedBox(width: 12)
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: message.isUser 
                      ? CrossAxisAlignment.end 
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: message.isUser 
                            ? AppColors.mihFiberGreen 
                            : AppColors.backgroundGray,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.content,
                            style: TextStyle(
                              color: message.isUser 
                                  ? Colors.white 
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Audio playback button
                          GestureDetector(
                            onTap: () {
                              audioService.speak(
                                message.content,
                                messageId: message.id,
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isPlayingThisMessage 
                                      ? Icons.stop_circle_outlined 
                                      : Icons.play_circle_outline,
                                  size: 20,
                                  color: message.isUser 
                                      ? Colors.white.withOpacity(0.8)
                                      : AppColors.mihFiberGreen,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isPlayingThisMessage ? 'Stop' : 'Play',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: message.isUser 
                                        ? Colors.white.withOpacity(0.8)
                                        : AppColors.mihFiberGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (message.isUser) ...[
                const SizedBox(width: 12),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundGray,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person_outline,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.borderGray, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),

            // Menu items
            _buildMenuOption(
              icon: Icons.photo_library_outlined,
              title: AppLocalizations.of(context)!.addPhotos,
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.addPhotosSelected)));
              },
            ),
            _buildMenuOption(
              icon: Icons.camera_alt_outlined,
              title: AppLocalizations.of(context)!.takePhoto,
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.takePhotoSelected)));
              },
            ),
            _buildMenuOption(
              icon: Icons.attach_file,
              title: AppLocalizations.of(context)!.addFiles,
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.addFilesSelected)));
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({required IconData icon, required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, size: 24, color: AppColors.mihFiberGreen),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Consumer<AudioService>(
      builder: (context, audioService, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: AppColors.backgroundWhite,
            border: Border(
              top: BorderSide(color: AppColors.borderGray, width: 1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundGray,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mihFiberGreen.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      // Plus button
                      IconButton(
                        onPressed: _showAttachmentMenu,
                        icon: const Icon(
                          Icons.add,
                          color: AppColors.mihFiberGreen,
                          size: 24,
                        ),
                        padding: const EdgeInsets.all(8),
                      ),
                      // Text field
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: audioService.isListening 
                                ? 'Listening...' 
                                : AppLocalizations.of(context)!.askAnything,
                            hintStyle: TextStyle(
                              color: audioService.isListening 
                                  ? AppColors.mihFiberGreen 
                                  : AppColors.textTertiary,
                              fontSize: 16,
                              fontWeight: audioService.isListening 
                                  ? FontWeight.w500 
                                  : FontWeight.normal,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 12,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      // Microphone button
                      IconButton(
                        onPressed: _handleMicrophonePress,
                        icon: audioService.isListening
                            ? AvatarGlow(
                                glowColor: AppColors.mihFiberGreen,
                                duration: const Duration(milliseconds: 2000),
                                repeat: true,
                                child: const Icon(
                                  Icons.mic,
                                  color: AppColors.error,
                                  size: 24,
                                ),
                              )
                            : const Icon(
                                Icons.mic_none,
                                color: AppColors.mihFiberGreen,
                                size: 24,
                              ),
                        padding: const EdgeInsets.all(8),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Send button
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _hasText
                      ? AppColors.mihFiberGreen
                      : AppColors.backgroundGray,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: _hasText
                      ? [
                          BoxShadow(
                            color: AppColors.mihFiberGreen.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: IconButton(
                  onPressed: _hasText ? _sendMessage : null,
                  icon: Icon(
                    Icons.arrow_upward,
                    color: _hasText ? Colors.white : AppColors.textTertiary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
