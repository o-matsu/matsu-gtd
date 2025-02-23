import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreStream<T> extends StatelessWidget {
  const FirestoreStream({
    super.key,
    required this.stream,
    required this.builder,
  });

  final Stream<QuerySnapshot<T>> stream;
  final Widget Function(BuildContext, List<QueryDocumentSnapshot<T>>) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
    );
  }
}
