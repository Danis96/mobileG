import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioService extends ChangeNotifier {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  // Speech to Text state
  bool _isListening = false;
  bool _isInitialized = false;
  String _transcribedText = '';
  double _confidenceLevel = 0.0;
  
  // Text to Speech state
  bool _isSpeaking = false;
  String? _currentSpeakingMessageId;
  
  // Callback for no speech detected error
  VoidCallback? _onNoSpeechDetected;
  
  // Getters
  bool get isListening => _isListening;
  bool get isInitialized => _isInitialized;
  String get transcribedText => _transcribedText;
  double get confidenceLevel => _confidenceLevel;
  bool get isSpeaking => _isSpeaking;
  String? get currentSpeakingMessageId => _currentSpeakingMessageId;

  AudioService() {
    _initializeTts();
  }

  /// Check microphone permission status
  Future<PermissionStatus> checkMicrophonePermission() async {
    return await Permission.microphone.status;
  }

  /// Request microphone permission
  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  /// Initialize Speech to Text
  Future<bool> initializeSpeechToText() async {
    try {
      // Check microphone permission first
      final status = await Permission.microphone.status;
      if (!status.isGranted) {
        debugPrint('⚠️ Microphone permission not granted');
        return false;
      }

      _isInitialized = await _speechToText.initialize(
        onError: (error) {
          debugPrint('❌ STT Error: $error');
          if (error.errorMsg == 'error_no_match') {
            debugPrint('⚠️ No speech detected - triggering callback');
            _isListening = false;
            notifyListeners();
            // Trigger the no speech detected callback
            if (_onNoSpeechDetected != null) {
              _onNoSpeechDetected!();
            }
          } else {
            _isListening = false;
            notifyListeners();
          }
        },
        onStatus: (status) {
          debugPrint('🎤 STT Status: $status');
          if (status == 'done' || status == 'notListening') {
            _isListening = false;
            notifyListeners();
          }
        },
      );

      debugPrint('✅ Speech to Text initialized: $_isInitialized');
      
      // Print available locales for debugging
      if (_isInitialized) {
        await _printAvailableLocales();
      }
      
      return _isInitialized;
    } catch (e) {
      debugPrint('❌ Failed to initialize STT: $e');
      return false;
    }
  }

  /// Debug helper: Print available locales
  Future<void> _printAvailableLocales() async {
    try {
      var locales = await _speechToText.locales();
      debugPrint('📋 Available locales: ${locales.map((l) => l.localeId).take(10).toList()}');
    } catch (e) {
      debugPrint('⚠️ Could not fetch locales: $e');
    }
  }

  /// Initialize Text to Speech
  Future<void> _initializeTts() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5); // Normal speed
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setStartHandler(() {
      _isSpeaking = true;
      notifyListeners();
      debugPrint('🔊 TTS Started');
    });

    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
      _currentSpeakingMessageId = null;
      notifyListeners();
      debugPrint('✅ TTS Completed');
    });

    _flutterTts.setErrorHandler((message) {
      _isSpeaking = false;
      _currentSpeakingMessageId = null;
      notifyListeners();
      debugPrint('❌ TTS Error: $message');
    });

    _flutterTts.setCancelHandler(() {
      _isSpeaking = false;
      _currentSpeakingMessageId = null;
      notifyListeners();
      debugPrint('🛑 TTS Cancelled');
    });
  }

  /// Start listening for speech
  Future<void> startListening({
    required Function(String) onResult,
    String locale = 'en_US',
    VoidCallback? onNoSpeechDetected,
  }) async {
    if (!_isInitialized) {
      final initialized = await initializeSpeechToText();
      if (!initialized) return;
    }

    _transcribedText = '';
    _confidenceLevel = 0.0;
    _onNoSpeechDetected = onNoSpeechDetected;
    
    debugPrint('🎤 Starting to listen with locale: $locale');
    
    await _speechToText.listen(
      onResult: (result) {
        _transcribedText = result.recognizedWords;
        _confidenceLevel = result.confidence;
        onResult(result.recognizedWords);
        notifyListeners();
        debugPrint('🎤 Transcribed: "$_transcribedText" (confidence: ${(_confidenceLevel * 100).toStringAsFixed(1)}%)');
      },
      listenFor: const Duration(seconds: 60),      // Listen for up to 60 seconds
      pauseFor: const Duration(seconds: 3),        // Shorter pause = tries harder to match
      partialResults: true,                        // Show results as you speak
      cancelOnError: false,                        // Don't cancel on temporary errors
      listenMode: ListenMode.confirmation,         // More lenient mode - tries harder to match
      localeId: locale,
      onDevice: false,                             // Use cloud recognition (more powerful)
    );

    _isListening = true;
    notifyListeners();
    debugPrint('✅ Listening started successfully');
  }

  /// Stop listening
  Future<void> stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
      _isListening = false;
      notifyListeners();
      debugPrint('🛑 Stopped listening');
    }
  }

  /// Strip markdown formatting and code blocks from text before speaking
  String _cleanTextForSpeech(String text) {
    // Remove code blocks (```...```)
    text = text.replaceAll(RegExp(r'```[\s\S]*?```'), '[code block]');
    
    // Remove inline code (`...`)
    text = text.replaceAll(RegExp(r'`[^`]+`'), '[code]');
    
    // Remove URLs but keep the link text
    text = text.replaceAll(RegExp(r'\[([^\]]+)\]\([^\)]+\)'), r'\1');
    
    // Remove image markdown
    text = text.replaceAll(RegExp(r'!\[([^\]]*)\]\([^\)]+\)'), r'Image: \1');
    
    // Remove headers (#, ##, ###, etc.)
    text = text.replaceAll(RegExp(r'^#+\s+', multiLine: true), '');
    
    // Remove bold/italic markers
    text = text.replaceAll(RegExp(r'\*\*([^\*]+)\*\*'), r'\1');
    text = text.replaceAll(RegExp(r'\*([^\*]+)\*'), r'\1');
    text = text.replaceAll(RegExp(r'__([^_]+)__'), r'\1');
    text = text.replaceAll(RegExp(r'_([^_]+)_'), r'\1');
    
    // Remove bullet points and list markers
    text = text.replaceAll(RegExp(r'^\s*[\*\-\+]\s+', multiLine: true), '');
    text = text.replaceAll(RegExp(r'^\s*\d+\.\s+', multiLine: true), '');
    
    // Remove horizontal rules
    text = text.replaceAll(RegExp(r'^---+$', multiLine: true), '');
    
    // Clean up multiple newlines
    text = text.replaceAll(RegExp(r'\n\s*\n\s*\n+'), '\n\n');
    
    // Trim whitespace
    text = text.trim();
    
    debugPrint('🧹 Cleaned text for speech: ${text.length} chars');
    return text;
  }

  /// Speak text (Text to Speech)
  Future<void> speak(String text, {String? messageId, bool cleanMarkdown = true}) async {
    if (_isSpeaking && _currentSpeakingMessageId == messageId) {
      // If already speaking this message, stop it
      await stop();
      return;
    }

    if (_isSpeaking) {
      // Stop current speech before starting new one
      await stop();
    }

    // Clean markdown from text if requested
    final textToSpeak = cleanMarkdown ? _cleanTextForSpeech(text) : text;
    
    if (textToSpeak.isEmpty) {
      debugPrint('⚠️ No text to speak after cleaning');
      return;
    }

    _currentSpeakingMessageId = messageId;
    await _flutterTts.speak(textToSpeak);
  }

  /// Stop speaking
  Future<void> stop() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      _isSpeaking = false;
      _currentSpeakingMessageId = null;
      notifyListeners();
    }
  }

  /// Change TTS language
  Future<void> setTtsLanguage(String languageCode) async {
    String ttsLanguage = 'en-US';
    switch (languageCode) {
      case 'en':
        ttsLanguage = 'en-US';
        break;
      case 'de':
        ttsLanguage = 'de-DE';
        break;
    }
    await _flutterTts.setLanguage(ttsLanguage);
  }

  /// Change STT language
  String getSttLocale(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'en_US';
      case 'de':
        return 'de_DE';
      default:
        return 'en_US';
    }
  }

  @override
  void dispose() {
    _speechToText.cancel();
    _flutterTts.stop();
    super.dispose();
  }
}

