import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';

class VoiceAssistant extends StatefulWidget {
  final Function(String) onCommandDetected;

  const VoiceAssistant({Key? key, required this.onCommandDetected}) : super(key: key);

  @override
  _VoiceAssistantState createState() => _VoiceAssistantState();
}

class _VoiceAssistantState extends State<VoiceAssistant> with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _spokenText = '';
  final translator = GoogleTranslator();

  late AnimationController _animationController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _speech = stt.SpeechToText();

    // Animation controller for glowing mic effect
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() => _isListening = false);
          _animationController.stop();
        }
      },
      onError: (error) {
        setState(() => _isListening = false);
        _animationController.stop();
      },
    );

    if (available) {
      setState(() {
        _isListening = true;
        _spokenText = '';
      });
      _animationController.repeat(reverse: true);

      _speech.listen(
        onResult: (result) async {
          setState(() {
            _spokenText = result.recognizedWords;
          });

          if (result.finalResult) {
            _speech.stop();
            setState(() => _isListening = false);
            _animationController.stop();

            // Translate to English
            final translation = await translator.translate(_spokenText, to: 'en');
            final translatedText = translation.text.toLowerCase();

            widget.onCommandDetected(translatedText);
          }
        },
        listenMode: stt.ListenMode.confirmation,
      );
    } else {
      print('Speech recognition not available');
      setState(() {
        _isListening = false;
      });
      _animationController.stop();
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
    _animationController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _isListening ? _stopListening : _startListening,
          child: AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: _isListening
                      ? [
                          BoxShadow(
                            color: Colors.indigo.withOpacity(_glowAnimation.value),
                            blurRadius: 20 * _glowAnimation.value,
                            spreadRadius: 1 * _glowAnimation.value,
                          ),
                          BoxShadow(
                            color: Colors.indigo.withOpacity(_glowAnimation.value * 0.6),
                            blurRadius: 30 * _glowAnimation.value,
                            spreadRadius: 5 * _glowAnimation.value,
                          ),
                        ]
                      : [],
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: _isListening ? Colors.indigo : Colors.grey.shade300,
                  child: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: _isListening ? Colors.white : Colors.black54,
                    size: 40,
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 12),

        if (_spokenText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "You said: $_spokenText",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.indigo.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}
