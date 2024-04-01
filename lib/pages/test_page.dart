import 'package:flutter/material.dart';
import 'package:geoestate/provider/dataset_provider.dart';
import 'package:provider/provider.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<DatasetProvider>(builder: (
        context,
        datasetProvider,
        child,
      ) {
        return Column(
          children: [
            Text(datasetProvider.datasets.toString()),
          ],
        );
      }),
    );
  }
}
