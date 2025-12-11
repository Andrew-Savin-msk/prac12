import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const appVersion = '1.0.0';

    return Scaffold(
      appBar: AppBar(
        title: const Text('О приложении'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Трекер целей',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Версия: $appVersion',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              'Это учебное приложение для постановки целей, фокус-сессий и отслеживания прогресса. '
              'В нём реализовано несколько бизнес-функциональностей: цели, аккаунт, ачивки, журнал действий, '
              'фокус-сессии, советы и поддержка.',
            ),
          ],
        ),
      ),
    );
  }
}

