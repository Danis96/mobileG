import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpt_markdown/custom_widgets/markdown_config.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

import '../../widgets/collapse_code_block.dart';
import '../constants/app_colors.dart';

class MarkdownService {
  static Highlighter? _highlighter;

  /// Initialize syntax highlighting (call once in main.dart)
  static Future<void> initialize() async {
    await Highlighter.initialize([
      'dart',
      'java',
      'kotlin',
      'swift',
      'javascript',
      'typescript',
      'python',
      'json',
      'yaml',
      'html',
      'css',
      'sql',
      'go',
      'rust',
      'serverpod_protocol',
    ]);
    final theme = await HighlighterTheme.loadDarkTheme();
    _highlighter = Highlighter(language: 'dart', theme: theme);
  }

  /// 🧩 Split markdown into chunks for streaming simulation
  static List<String> splitIntoChunks(String text, {int chunkSize = 50}) {
    final List<String> chunks = [];

    // Split by words to avoid breaking mid-word for better visual flow
    final List<String> words = text.split(' ');
    String currentChunk = '';

    for (final String word in words) {
      if (currentChunk.length + word.length + 1 <= chunkSize) {
        currentChunk += (currentChunk.isEmpty ? '' : ' ') + word;
      } else {
        if (currentChunk.isNotEmpty) {
          chunks.add(currentChunk);
          debugPrint(
            '📦 Chunk ${chunks.length}: "${currentChunk.substring(0, currentChunk.length > 30 ? 30 : currentChunk.length)}${currentChunk.length > 30 ? '...' : ''}"',
          );
        }
        currentChunk = word;
      }
    }

    // Add the last chunk if it's not empty
    if (currentChunk.isNotEmpty) {
      chunks.add(currentChunk);
      debugPrint(
        '📦 Final Chunk ${chunks.length}: "${currentChunk.substring(0, currentChunk.length > 30 ? 30 : currentChunk.length)}${currentChunk.length > 30 ? '...' : ''}"',
      );
    }

    debugPrint('🎯 Total chunks created: ${chunks.length}');
    return chunks;
  }

  /// 🌊 Simulate streaming of markdown text
  static Stream<String> simulateStreaming(
    String fullText, {
    Duration baseDelay = const Duration(milliseconds: 80),
    Duration punctuationDelay = const Duration(milliseconds: 200),
    Duration codeBlockDelay = const Duration(milliseconds: 150),
  }) async* {
    final List<String> chunks = splitIntoChunks(fullText, chunkSize: 50);
    String buffer = '';

    debugPrint('🚀 Starting streaming simulation with ${chunks.length} chunks');

    for (int i = 0; i < chunks.length; i++) {
      final String chunk = chunks[i];

      // Determine delay based on content type
      Duration delay = baseDelay;

      // Longer delay after punctuation for natural reading rhythm
      if (buffer.isNotEmpty && RegExp(r'[.!?]\s*$').hasMatch(buffer.trim())) {
        delay = punctuationDelay;
        debugPrint('⏸️ Punctuation pause detected');
      }

      // Longer delay for code blocks
      if (chunk.contains('```') || chunk.contains('`')) {
        delay = codeBlockDelay;
        debugPrint('💻 Code block detected, using longer delay');
      }

      // Add slight randomness for more natural feel (±20ms)
      final int randomOffset = (DateTime.now().millisecondsSinceEpoch % 40) - 20;
      delay = Duration(milliseconds: delay.inMilliseconds + randomOffset);

      await Future.delayed(delay);
      buffer += (buffer.isEmpty ? '' : ' ') + chunk;

      debugPrint('📝 Streaming chunk ${i + 1}/${chunks.length} (${chunk.length} chars) - Buffer length: ${buffer.length}');

      yield buffer;
    }

    debugPrint('✅ Streaming completed! Final text length: ${buffer.length}');
  }

  /// 🧱 Standard Markdown rendering
  Widget render(String markdownText, {bool selectable = true, TableBuilder? tableBuilder}) {
    return _buildMarkdownWidget(markdownText, selectable: selectable, tableBuilder: tableBuilder);
  }

  /// 🚀 Streaming markdown renderer (rebuilds as chunks arrive)
  Widget renderStreaming(Stream<String> markdownStream, {bool selectable = true, TableBuilder? tableBuilder}) {
    return StreamBuilder<String>(
      stream: markdownStream,
      initialData: '',
      builder: (context, snapshot) {
        final text = snapshot.data ?? '';
        return _buildMarkdownWidget(text, selectable: selectable, tableBuilder: tableBuilder);
      },
    );
  }

  /// Internal builder with proper selection support
  Widget _buildMarkdownWidget(String markdownText, {bool selectable = true, TableBuilder? tableBuilder}) {
    // Wrap the entire markdown in SelectionArea for Flutter 3.3+
    Widget markdownWidget = GptMarkdownTheme(
      gptThemeData: GptMarkdownThemeData(
        highlightColor: AppColors.primaryOrange.withOpacity(0.3),
        hrLineColor: AppColors.borderGray,
        hrLineThickness: 1.5,
        linkColor: AppColors.primaryBlue,
        linkHoverColor: AppColors.primaryBlue.withOpacity(0.8),
        h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryPurple, height: 1.2),
        h2: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.primaryBlue, height: 1.3),
        h3: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.primaryGreen, height: 1.4),
        h4: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.mihFiberGreen, height: 1.4),
        h5: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.mihFiberGray, height: 1.5),
        h6: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textTertiary, height: 1.5),
        brightness: Brightness.light,
      ),
      child: GptMarkdown(
        markdownText,
        tableBuilder: tableBuilder,
        maxLines: null,
        followLinkColor: true,
        onLinkTap: (String href, String title) => debugPrint('Link tapped: $href'),

        /// 🔹 Code highlighting with selection and copy functionality
        codeBuilder: (BuildContext context, String lang, String code, bool closed) {
          final bool isLang = lang.isNotEmpty && lang.toLowerCase() != 'plaintext';
          final Color bgColor = isLang ? AppColors.textPrimary : AppColors.backgroundGray;

          return CollapsibleCodeBlock(
            code: code,
            language: lang,
            backgroundColor: bgColor,
            selectable: selectable,
            maxPreviewLines: 5, // Show first 5 lines by default
          );
        },

        /// 🔹 Image Builder (unchanged)
        imageBuilder: (BuildContext context, String imageUrl) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderGray),
              boxShadow: [BoxShadow(color: AppColors.textTertiary.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) => _buildImageError(),
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    padding: const EdgeInsets.all(16),
                    color: AppColors.backgroundGray,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                        color: AppColors.primaryBlue,
                        backgroundColor: AppColors.borderGray,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
    // Wrap with SelectionArea for text selection if selectable is true
    if (selectable) {
      return SelectionArea(child: markdownWidget);
    }

    return markdownWidget;
  }

  Widget _buildImageError() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: AppColors.backgroundGray,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.broken_image, color: AppColors.textTertiary, size: 32),
          const SizedBox(height: 8),
          Text('Failed to load image', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }

  static Widget buildHighlightedCodeStatic(String code, String language, Color bgColor, bool selectable) {
    final Color textColor = bgColor == AppColors.textPrimary
        ? AppColors.backgroundWhite
        : AppColors.textPrimary;

    final TextStyle codeStyle = TextStyle(
      fontFamily: 'monospace',
      fontSize: 14,
      color: textColor,
      height: 1.5,
    );

    if (_highlighter == null) {
      return selectable
          ? SelectableText(code, style: codeStyle)
          : Text(code, style: codeStyle);
    }

    try {
      final Highlighter highlighter = Highlighter(
        language: language.isNotEmpty ? language : 'plaintext',
        theme: _highlighter!.theme,
      );
      final TextSpan highlighted = highlighter.highlight(code);

      return selectable
          ? SelectableText.rich(TextSpan(style: codeStyle, children: [highlighted]))
          : Text.rich(TextSpan(style: codeStyle, children: [highlighted]));
    } catch (e) {
      debugPrint('Highlight error: $e');
      return selectable
          ? SelectableText(code, style: codeStyle)
          : Text(code, style: codeStyle);
    }
  }
}
