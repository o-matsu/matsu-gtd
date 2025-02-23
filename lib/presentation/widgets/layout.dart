import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:matsu_gtd/controller/auth_controller.dart';
import 'package:matsu_gtd/presentation/widgets/firestore_stream.dart';
import 'package:matsu_gtd/presentation/widgets/wip_task.dart';

class CommonLayout<T> extends ConsumerWidget {
  const CommonLayout({
    super.key,
    required this.titleText,
    required this.stream,
    required this.builder,
  });

  final String titleText;
  final Stream<QuerySnapshot<T>> stream;
  final Widget Function(BuildContext, List<QueryDocumentSnapshot<T>>) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProvider = ref.read(authControllerProvider.notifier);
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
              actions: [
                IconButton(
                  onPressed: () => authProvider.signInWithGoogle(),
                  icon: Icon(Icons.account_circle),
                ),
              ],
            ),
          ];
        },
        body: WipWatcher(
          child: FirestoreStream(
            stream: stream,
            builder: builder,
          ),
        ),
      ),
    );
  }
}
