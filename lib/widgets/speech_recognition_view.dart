import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import '../l10n/l10n.dart';

class SpeechRecognitionView extends StatefulWidget {
  const SpeechRecognitionView({super.key});

  @override
  State<SpeechRecognitionView> createState() => _SpeechRecognitionViewState();
}

class _SpeechRecognitionViewState extends State<SpeechRecognitionView> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  late String _status;
  bool _isNavigating = false; // 追加: ナビゲーション中フラグ

  @override
  void initState() {
    super.initState();
    _status = S.of(context)!.tapMicToStart;
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onStatus: (status) {
        if (mounted) {
          setState(() => _status = status);
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() => _status = S.of(context)!.speechError(error.errorMsg));
        }
      },
    );
    // Automatically start listening once initialized
    if (_speechEnabled && mounted) {
      _startListening();
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });

    // Automatically close and return result when speech is final
    if (result.finalResult && !_isNavigating) {
      _isNavigating = true;
      Navigator.pop(context, _lastWords);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.5,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: <Widget>[
            // Draggable handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              S.of(context)!.searchByVoice,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Text(
                  _speechToText.isListening
                      ? _lastWords.isEmpty
                            ? S.of(context)!.pleaseSpeak
                            : _lastWords
                      : _status,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_speechToText.isNotListening) {
                  _startListening();
                } else {
                  _stopListening();
                  // Pop with the result we have so far
                  if (_lastWords.isNotEmpty && !_isNavigating) {
                    _isNavigating = true;
                    Navigator.pop(context, _lastWords);
                  }
                }
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _speechToText.isListening
                      ? Colors.red[400]
                      : const Color(0xFF4D6FFF),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color:
                          (_speechToText.isListening
                              ? Colors.red[200]
                              : const Color(
                                  0xFF4D6FFF,
                                ).withValues(alpha: 0.5)) ??
                          Colors.transparent,
                      blurRadius: 16,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  _speechToText.isNotListening ? Icons.mic_none : Icons.mic,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                if (!_isNavigating) {
                  _isNavigating = true;
                  _stopListening();
                  Navigator.pop(
                    context,
                    _lastWords.isNotEmpty ? _lastWords : null,
                  );
                }
              },
              child: Text(
                S.of(context)!.complete,
                style: TextStyle(fontSize: 16, color: Color(0xFF4D6FFF)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
