import 'package:flutter/material.dart' hide Router;
import 'package:routing_path/routing_path.dart';

class FeatureAHomePage extends StatelessWidget {
  const FeatureAHomePage({Key? key, required this.openedBy}) : super(key: key);

  final String openedBy;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text('FEATURE A'),
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
                foregroundColor: MaterialStateProperty.all(Colors.indigo),
              ),
              onPressed: () => Router.of(context).open(
                '/feature-b',
                RouteArguments({'opened_by': 'FEATURE A'}),
              ),
              child: const Text(
                'OPEN FEATURE B',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
