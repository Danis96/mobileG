import 'package:flutter/material.dart';
import 'package:presentationgenie/l10n/app_localizations.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_assets.dart';
import '../core/services/markdown_service.dart';
import 'settings_screen.dart';

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.content, required this.isUser, required this.timestamp});
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
    _messageController.addListener(() {
      setState(() {
        _hasText = _messageController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final String messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(content: messageText, isUser: true, timestamp: DateTime.now()));
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
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
    return Scaffold(
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
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _messages[index].isUser ? _buildMessageBubble(_messages[index]) : markdownService.render(contentTomark);
                    },
                  ),
          ),

          // Message input
          _buildMessageInput(),
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

  final String contentTomark = "```csharp\npublic class MyClass\n{\n    public void MyMethod()\n    {\n        // This is a code block in C#\n        int x = 10;\n        if (x > 5)\n        {\n            Console.WriteLine(\"x is greater than 5\");\n        }\n        else\n        {\n            Console.WriteLine(\"x is not greater than 5\");\n        }\n    }\n}\n```";

  Widget _buildMessageBubble(ChatMessage message) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[Image.asset(AppAssets.genieIcon, width: 32, height: 32), const SizedBox(width: 12)],
          Expanded(
            child: Column(
              crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: message.isUser ? AppColors.mihFiberGreen : AppColors.backgroundGray,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(message.content),
                ),
              ],
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 12),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: AppColors.backgroundGray, borderRadius: BorderRadius.circular(16)),
              child: const Center(child: Icon(Icons.person_outline, size: 16, color: AppColors.textSecondary)),
            ),
          ],
        ],
      ),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.backgroundWhite,
        border: Border(top: BorderSide(color: AppColors.borderGray, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundGray,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: AppColors.mihFiberGreen.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Row(
                children: [
                  // Plus button
                  IconButton(
                    onPressed: _showAttachmentMenu,
                    icon: const Icon(Icons.add, color: AppColors.mihFiberGreen, size: 24),
                    padding: const EdgeInsets.all(8),
                  ),
                  // Text field
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.askAnything,
                        hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 16),
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.mihFiberGreen)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      ),
                      style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _hasText ? AppColors.mihFiberGreen : AppColors.backgroundGray,
              borderRadius: BorderRadius.circular(22),
              boxShadow: _hasText ? [BoxShadow(color: AppColors.mihFiberGreen.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))] : null,
            ),
            child: IconButton(
              onPressed: _hasText ? _sendMessage : null,
              icon: Icon(Icons.arrow_upward, color: _hasText ? Colors.white : AppColors.textTertiary, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
