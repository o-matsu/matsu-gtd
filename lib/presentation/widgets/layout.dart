import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:matsu_gtd/model/task.dart';

class CommonLayout extends ConsumerWidget {
  const CommonLayout({
    super.key,
    required this.titleText,
    required this.stream,
    required this.builder,
  });

  final String titleText;
  final Stream<QuerySnapshot<Task>> stream;
  final Widget Function(BuildContext, List<QueryDocumentSnapshot<Task>>)
      builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              flexibleSpace: FlexibleSpaceBar(
                title: Text(titleText),
              ),
              expandedHeight: 200.0,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          ];
        },
        body: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint(snapshot.error.toString());
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }
            final docs = snapshot.data!.docs;

            return builder(context, docs);
          },
        ),
      ),
    );
  }
}
