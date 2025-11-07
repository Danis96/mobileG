// Add this new widget class to your markdown_service.dart file

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/constants/app_colors.dart';
import '../core/services/markdown_service.dart';

class CollapsibleCodeBlock extends StatefulWidget {
  final String code;
  final String language;
  final Color backgroundColor;
  final bool selectable;
  final int maxPreviewLines;

  const CollapsibleCodeBlock({
    super.key,
    required this.code,
    required this.language,
    required this.backgroundColor,
    this.selectable = true,
    this.maxPreviewLines = 5,
  });

  @override
  State<CollapsibleCodeBlock> createState() => _CollapsibleCodeBlockState();
}

class _CollapsibleCodeBlockState extends State<CollapsibleCodeBlock>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool get _shouldShowCollapseButton {
    final List<String> lines = widget.code.split('\n');
    return lines.length > widget.maxPreviewLines;
  }

  String get _previewCode {
    if (!_shouldShowCollapseButton) return widget.code;

    final List<String> lines = widget.code.split('\n');
    final List<String> previewLines = lines.take(widget.maxPreviewLines).toList();
    return previewLines.join('\n');
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _copyCodeToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.code));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 20),
            const SizedBox(width: 8),
            const Text('Code copied to clipboard!'),
          ],
        ),
        backgroundColor: AppColors.backgroundGray,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLang = widget.language.isNotEmpty && widget.language.toLowerCase() != 'plaintext';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderGray, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.textTertiary.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with language, collapse/expand, and copy buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: widget.backgroundColor == AppColors.textPrimary
                  ? AppColors.textPrimary.withOpacity(0.8)
                  : AppColors.borderGray.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                // Language label
                if (widget.language.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
                    ),
                    child: Text(
                      widget.language.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),

                const Spacer(),

                // Collapse/Expand button
                if (_shouldShowCollapseButton)
                  GestureDetector(
                    onTap: _toggleExpanded,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.primaryOrange.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedRotation(
                            turns: _isExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              Icons.expand_more,
                              size: 16,
                              color: AppColors.primaryOrange,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _isExpanded ? 'Collapse' : 'Expand',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primaryOrange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (_shouldShowCollapseButton && widget.selectable)
                  const SizedBox(width: 8),

                // Copy button
                if (widget.selectable)
                  GestureDetector(
                    onTap: _copyCodeToClipboard,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.copy,
                            size: 14,
                            color: AppColors.primaryBlue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Copy',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Code content with animation
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Always show preview
                      MarkdownService.buildHighlightedCodeStatic(
                        _previewCode,
                        widget.language,
                        widget.backgroundColor,
                        widget.selectable,
                      ),

                      // Animated expanded content
                      if (_shouldShowCollapseButton)
                        SizeTransition(
                          sizeFactor: _expandAnimation,
                          axisAlignment: -1.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_isExpanded) ...[
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  height: 1,
                                  color: AppColors.borderGray.withOpacity(0.5),
                                ),
                                MarkdownService.buildHighlightedCodeStatic(
                                  widget.code.split('\n').skip(widget.maxPreviewLines).join('\n'),
                                  widget.language,
                                  widget.backgroundColor,
                                  widget.selectable,
                                ),
                              ],
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Footer with line count info
          if (_shouldShowCollapseButton)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: widget.backgroundColor == AppColors.textPrimary
                    ? AppColors.textPrimary.withOpacity(0.05)
                    : AppColors.borderGray.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.code,
                    size: 14,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${widget.code.split('\n').length} lines',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (!_isExpanded && _shouldShowCollapseButton) ...[
                    const SizedBox(width: 8),
                    Text(
                      '• ${widget.code.split('\n').length - widget.maxPreviewLines} more lines',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primaryOrange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}