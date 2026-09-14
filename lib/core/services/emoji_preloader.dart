import 'package:flutter/material.dart';

class EmojiPreloader extends StatefulWidget {
  const EmojiPreloader({super.key, required this.child});

  final Widget child;

  @override
  State<EmojiPreloader> createState() => _EmojiPreloaderState();
}

class _EmojiPreloaderState extends State<EmojiPreloader> {
  bool _preload = false;

  static const String _emojis =
      '😀 😃 😄 😁 😆 😅 😂 🙂 🙃 😉 😊 😍 🥰 😎 🤓 🤔 '
      '😐 😑 😶 🙄 😏 😣 😥 😮 🤐 😯 😪 😫 😴 😌 🤗 🤩 '
      '🥳 😇 🤠 🥺 😢 😭 😤 😠 😡 🤬 😱 😨 😰 😳 🤪 '
      '😋 😛 😜 🤓 🧐 🤭 🤫 🤥 🤗 🫡 '
      '🍎 🍐 🍊 🍋 🍌 🍉 🍇 🍓 🍒 🥝 🍍 🥭 🥑 '
      '🥕 🌽 🥔 🍅 🥒 🥦 🍞 🧀 🍕 🍔 🍟 🍪 🎂 '
      '🐶 🐱 🐭 🐹 🐰 🦊 🐻 🐼 🐨 🐯 🦁 🐮 🐷 '
      '🐸 🐵 🐙 🦋 🐝 🐞 🐳 🐬 🦈 🐊 🦄 '
      '⚽ 🏀 🏈 🎾 🏆 ⭐ 🌟 ❤️ 💙 💚 💛 💜 🧡 '
      '👍 👎 👏 🙌 👋 ✋ 💪 👀 🎉 🔥 💡 ✅ ❌'
      '🐌 🐢 🦔 🐇 🐕 🦌';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _preload = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,

        if (_preload)
          const Positioned(
            left: -100,
            top: -100,
            child: IgnorePointer(
              child: Text(
                _emojis,
                style: TextStyle(
                  fontSize: 8,
                  height: 1,
                  color: Color.fromRGBO(0, 0, 0, 0.01),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
