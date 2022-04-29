import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SessionOptionsWidget extends StatelessWidget {
  const SessionOptionsWidget(this.currentLocaleId, this.switchLang,
      this.localeNames, this.logEvents, this.switchLogging,
      {Key? key})
      : super(key: key);

  final String currentLocaleId;
  final void Function(String?) switchLang;
  final void Function(bool?) switchLogging;
  final List<LocaleName> localeNames;
  final bool logEvents;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Language: '),
            DropdownButton<String>(
              onChanged: (selectedVal) => switchLang(selectedVal),
              value: currentLocaleId,
              items: localeNames
                  .map(
                    (localeName) => DropdownMenuItem(
                      value: localeName.localeId,
                      child: Text(
                        localeName.name,
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ],
    );
  }
}
