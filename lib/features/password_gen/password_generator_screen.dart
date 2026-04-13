import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/l10n/app_localizations.dart';
import '../../core/crypto/password_generator.dart';

class PasswordGeneratorScreen extends StatefulWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  State<PasswordGeneratorScreen> createState() => _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  String _password = '';
  double _length = 20;
  bool _uppercase = true;
  bool _lowercase = true;
  bool _digits = true;
  bool _symbols = true;
  String _excludeChars = '';
  bool _passphraseMode = false;
  int _wordCount = 4;
  String _separator = '-';

  @override
  void initState() {
    super.initState();
    _generate();
  }

  void _generate() {
    setState(() {
      if (_passphraseMode) {
        _password = PasswordGenerator.generatePassphrase(
          wordCount: _wordCount,
          separator: _separator,
        );
      } else {
        _password = PasswordGenerator.generate(
          length: _length.round(),
          uppercase: _uppercase,
          lowercase: _lowercase,
          digits: _digits,
          symbols: _symbols,
          excludeChars: _excludeChars,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final strength = PasswordGenerator.calculateStrength(_password);
    final strengthColors = [Colors.red, Colors.orange, Colors.yellow.shade700, Colors.lightGreen, Colors.green];
    final strengthLabels = [l10n.weak, l10n.fair, 'Buona', l10n.strong, l10n.veryStrong];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.passwordGenerator)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Generated password display
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SelectableText(
                    _password,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: 'monospace',
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: (strength + 1) / 5,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation(strengthColors[strength]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${l10n.passwordStrength}: ${strengthLabels[strength]}',
                    style: TextStyle(color: strengthColors[strength], fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _password));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.copiedToClipboard)),
                          );
                        },
                        icon: const Icon(Icons.copy),
                        label: Text(l10n.copy),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: _generate,
                        icon: const Icon(Icons.refresh),
                        label: Text(l10n.generatePassword),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Mode toggle
          SwitchListTile(
            title: Text(l10n.passphraseMode),
            value: _passphraseMode,
            onChanged: (v) {
              setState(() => _passphraseMode = v);
              _generate();
            },
          ),

          if (!_passphraseMode) ...[
            // Length slider
            ListTile(
              title: Text('${l10n.passwordLength}: ${_length.round()}'),
              subtitle: Slider(
                value: _length,
                min: 4,
                max: 64,
                divisions: 60,
                label: _length.round().toString(),
                onChanged: (v) {
                  setState(() => _length = v);
                  _generate();
                },
              ),
            ),

            // Character set toggles
            SwitchListTile(
              title: Text(l10n.uppercase),
              subtitle: const Text('A-Z'),
              value: _uppercase,
              onChanged: (v) {
                setState(() => _uppercase = v);
                _generate();
              },
            ),
            SwitchListTile(
              title: Text(l10n.lowercase),
              subtitle: const Text('a-z'),
              value: _lowercase,
              onChanged: (v) {
                setState(() => _lowercase = v);
                _generate();
              },
            ),
            SwitchListTile(
              title: Text(l10n.digits),
              subtitle: const Text('0-9'),
              value: _digits,
              onChanged: (v) {
                setState(() => _digits = v);
                _generate();
              },
            ),
            SwitchListTile(
              title: Text(l10n.symbols),
              subtitle: const Text('!@#\$%^&*'),
              value: _symbols,
              onChanged: (v) {
                setState(() => _symbols = v);
                _generate();
              },
            ),

            // Exclude chars
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  labelText: l10n.excludeChars,
                  hintText: 'es: 0OlI1',
                ),
                onChanged: (v) {
                  _excludeChars = v;
                  _generate();
                },
              ),
            ),
          ] else ...[
            // Passphrase options
            ListTile(
              title: Text('${l10n.wordCount}: $_wordCount'),
              subtitle: Slider(
                value: _wordCount.toDouble(),
                min: 3,
                max: 8,
                divisions: 5,
                label: _wordCount.toString(),
                onChanged: (v) {
                  setState(() => _wordCount = v.round());
                  _generate();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  labelText: l10n.separator,
                  hintText: '-',
                ),
                controller: TextEditingController(text: _separator),
                onChanged: (v) {
                  _separator = v.isEmpty ? '-' : v;
                  _generate();
                },
              ),
            ),
          ],

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
