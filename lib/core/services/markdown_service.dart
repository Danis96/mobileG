import 'package:flutter/material.dart';
import 'package:gpt_markdown/custom_widgets/markdown_config.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

import '../constants/app_colors.dart';

class MarkdownService {
  static Highlighter? _highlighter;

  /// Initialize the syntax highlighter (call this once in main.dart)
  static Future<void> initialize() async {
    await Highlighter.initialize(
      [
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
      ],
    );

    // Create a default highlighter instance
    final theme = await HighlighterTheme.loadDarkTheme(); // or loadLightTheme()
    _highlighter = Highlighter(
      language: 'dart',
      theme: theme,
    );
  }

  /// Renders markdown text with custom colors and syntax highlighting.
  Widget render(String markdownText, {bool selectable = true, TableBuilder? tableBuilder}) {
    return GptMarkdownTheme(
      gptThemeData: GptMarkdownThemeData(
        // Color parameters from theme
        highlightColor: AppColors.primaryOrange.withOpacity(0.3),
        hrLineColor: AppColors.borderGray,
        hrLineThickness: 1.5,
        linkColor: AppColors.primaryBlue,
        linkHoverColor: AppColors.primaryBlue.withOpacity(0.8),

        // Heading styles (h1 to h6) with different colors from AppColors
        h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryPurple, height: 1.2),
        h2: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.primaryBlue, height: 1.3),
        h3: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.primaryGreen, height: 1.4),
        h4: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.mihFiberGreen, height: 1.4),
        h5: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.mihFiberGray, height: 1.5),
        h6: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textTertiary, height: 1.5),
        // Theme brightness
        brightness: Brightness.light,
      ),
      child: GptMarkdown(
        markdownText,
        tableBuilder: tableBuilder,

        // GptMarkdown widget parameters
        maxLines: null,
        followLinkColor: true,

        // Link handling with AppColors styling
        onLinkTap: (String href, String title) {
          debugPrint('Link tapped: $href, Title: $title');
        },

        // Custom code builder with syntax highlighting
        codeBuilder: (BuildContext context, String name, String code, bool closed) {
          return Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderGray, width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textTertiary.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: _buildHighlightedCode(code, name),
          );
        },

        // Custom image builder with AppColors styling
        imageBuilder: (BuildContext context, String imageUrl) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderGray, width: 1.0),
              boxShadow: [BoxShadow(color: AppColors.textTertiary.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
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
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    color: AppColors.backgroundGray,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
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

        // Custom LaTeX builder with AppColors styling
        latexBuilder: (BuildContext context, String latex, TextStyle? style, bool isInline) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
              color: AppColors.mihFiberAccent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.mihFiberGreen.withOpacity(0.3), width: 1.0),
            ),
            child: Text(
              latex,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 14, color: AppColors.mihFiberGreenDark, fontWeight: FontWeight.w500),
            ),
          );
        },

        // Custom link builder with AppColors styling
        linkBuilder: (BuildContext context, InlineSpan linkSpan, String? href, TextStyle? style) {
          return GestureDetector(
            onTap: () {
              if (href != null) {
                debugPrint('Link tapped: $href');
              }
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Text.rich(
                linkSpan,
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primaryBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },

        // LaTeX workaround function
        latexWorkaround: (String latex) {
          return latex;
        },

        // Custom components (can be extended later)
        components: null,
        inlineComponents: null,
      ),
    );
  }

  /// Build syntax highlighted code
  Widget _buildHighlightedCode(String code, String language) {
    if (_highlighter == null) {
      // Fallback if highlighter not initialized
      return SelectableText(
        code,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 14,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
      );
    }

    try {
      // Create a highlighter for this specific language
      final highlighter = Highlighter(
        language: language.isNotEmpty ? language : 'plaintext',
        theme: _highlighter!.theme,
      );

      final highlighted = highlighter.highlight(code);

      return SelectableText.rich(
        TextSpan(
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 14,
            height: 1.5,
          ),
          children: [highlighted],
        ),
      );
    } catch (e) {
      // Fallback on error
      debugPrint('Syntax highlighting error: $e');
      return SelectableText(
        code,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 14,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
      );
    }
  }
}