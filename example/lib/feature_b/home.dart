import 'package:flutter/material.dart';
import 'package:routing_path/routing_path.dart';

class FeatureBHomePage extends StatelessWidget {
  const FeatureBHomePage({Key? key, required this.openedBy}) : super(key: key);

  final String openedBy;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('FEATURE B'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('This page was opened by "$openedBy"'),
            const SizedBox(height: 16),
            OutlinedButton(
              style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.all(Colors.deepPurpleAccent),
              ),
              onPressed: () => PathRouter.of(context).open(
                '/feature-a',
                RouteArguments({'opened_by': 'FEATURE B'}),
              ),
              child: const Text(
                'OPEN FEATURE A',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
