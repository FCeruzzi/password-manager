import 'dart:math';

class PasswordGenerator {
  static const _lowercaseChars = 'abcdefghijklmnopqrstuvwxyz';
  static const _uppercaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const _digitChars = '0123456789';
  static const _symbolChars = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  static String generate({
    int length = 20,
    bool uppercase = true,
    bool lowercase = true,
    bool digits = true,
    bool symbols = true,
    String excludeChars = '',
  }) {
    var chars = '';
    if (lowercase) chars += _lowercaseChars;
    if (uppercase) chars += _uppercaseChars;
    if (digits) chars += _digitChars;
    if (symbols) chars += _symbolChars;

    if (excludeChars.isNotEmpty) {
      chars = chars.split('').where((c) => !excludeChars.contains(c)).join();
    }

    if (chars.isEmpty) chars = _lowercaseChars + _uppercaseChars + _digitChars;

    final random = Random.secure();
    final password = List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();

    // Ensure at least one character from each enabled set
    final buffer = password.split('');
    var index = 0;
    if (lowercase && !buffer.any((c) => _lowercaseChars.contains(c))) {
      buffer[index++] = _lowercaseChars[random.nextInt(_lowercaseChars.length)];
    }
    if (uppercase && !buffer.any((c) => _uppercaseChars.contains(c))) {
      buffer[index++] = _uppercaseChars[random.nextInt(_uppercaseChars.length)];
    }
    if (digits && !buffer.any((c) => _digitChars.contains(c))) {
      buffer[index++] = _digitChars[random.nextInt(_digitChars.length)];
    }
    if (symbols && !buffer.any((c) => _symbolChars.contains(c))) {
      buffer[index++] = _symbolChars[random.nextInt(_symbolChars.length)];
    }

    // Shuffle to avoid predictable positions
    buffer.shuffle(random);
    return buffer.join();
  }

  static String generatePassphrase({
    int wordCount = 4,
    String separator = '-',
  }) {
    // Basic word list for passphrase generation
    const words = [
      'albero', 'acqua', 'arte', 'anno', 'alto', 'amico', 'amore', 'aria',
      'banco', 'bello', 'bianco', 'bosco', 'buono', 'breve', 'barca', 'bocca',
      'casa', 'campo', 'cane', 'carta', 'cielo', 'clima', 'corpo', 'cuore',
      'dado', 'dente', 'dolce', 'donna', 'drago', 'duro', 'disco', 'danza',
      'erba', 'estate', 'eco', 'elmo', 'enigma', 'esame', 'euro', 'eroe',
      'fiore', 'fiume', 'forte', 'fuoco', 'foglia', 'ferro', 'faro', 'festa',
      'gatto', 'gioco', 'grande', 'grano', 'grigio', 'gusto', 'gelo', 'gioia',
      'hotel', 'idea', 'isola', 'latte', 'luce', 'luna', 'legno', 'libro',
      'mare', 'monte', 'mondo', 'mano', 'mela', 'musica', 'muro', 'nave',
      'nero', 'neve', 'notte', 'nodo', 'nube', 'nome', 'nuovo', 'occhio',
      'oro', 'onda', 'orso', 'pace', 'pane', 'pesce', 'pietra', 'porta',
      'rosa', 'roccia', 'rete', 'ramo', 'sole', 'stella', 'scala', 'serra',
      'terra', 'tempo', 'torre', 'tigre', 'uovo', 'vento', 'verde', 'vita',
      'zero', 'zona', 'zucca', 'zaino', 'volpe', 'valle', 'vigna', 'voce',
    ];

    final random = Random.secure();
    return List.generate(wordCount, (_) => words[random.nextInt(words.length)])
        .join(separator);
  }

  /// Returns strength score 0-4 (weak, fair, good, strong, very strong)
  static int calculateStrength(String password) {
    if (password.isEmpty) return 0;
    var score = 0;

    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (password.length >= 16) score++;

    final hasLower = password.contains(RegExp(r'[a-z]'));
    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasDigit = password.contains(RegExp(r'[0-9]'));
    final hasSymbol = password.contains(RegExp(r'[^a-zA-Z0-9]'));

    final variety = [hasLower, hasUpper, hasDigit, hasSymbol].where((b) => b).length;
    score += variety;

    // Entropy calculation
    var charsetSize = 0;
    if (hasLower) charsetSize += 26;
    if (hasUpper) charsetSize += 26;
    if (hasDigit) charsetSize += 10;
    if (hasSymbol) charsetSize += 32;

    final entropy = password.length * (charsetSize > 0 ? (log(charsetSize) / log(2)) : 0);
    if (entropy >= 60) score++;
    if (entropy >= 80) score++;
    if (entropy >= 100) score++;

    return (score / 2.5).clamp(0, 4).round();
  }

  static double log(num x) => x > 0 ? _ln(x.toDouble()) : 0;
  static double _ln(double x) {
    // Simple natural log approximation using dart:math
    return x > 0 ? _logImpl(x) : 0;
  }
  static double _logImpl(double x) {
    return x.toDouble() > 0 ? (x.toDouble()).toString().length.toDouble() : 0;
  }
}
