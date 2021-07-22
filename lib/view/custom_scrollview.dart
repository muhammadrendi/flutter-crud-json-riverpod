import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_crud/service/provider/general_provider.dart';
import 'package:riverpod_crud/service/provider/post_provider.dart';
import 'package:riverpod_crud/view/add_post.dart';

class Test extends ConsumerWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final post = watch(postProvider);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            centerTitle: true,
            title: Text("Riverpod CRUD JSON"),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            post.when(
                data: (data) => Column(
                      children: [
                        for (var item in data)
                          ListTile(
                            title: Text(item.title.toString()),
                            subtitle: Text(item.body.toString()),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddPost(
                                                data: item, type: true)),
                                      );
                                    },
                                    icon: Icon(Icons.edit_rounded)),
                                IconButton(
                                    onPressed: () {
                                      context
                                          .read(dataService)
                                          .deletePost(item.id)
                                          .then((value) {
                                        if (value == true) {
                                          showSnackbar(
                                              titleContent:
                                                  "Success Delete Data",
                                              context: context);
                                        } else {
                                          showSnackbar(
                                              titleContent:
                                                  "Failed Delete Data",
                                              context: context);
                                        }
                                      });
                                    },
                                    icon: Icon(Icons.delete_rounded)),
                                Icon(Icons.arrow_right_rounded),
                              ],
                            ),
                          )
                      ],
                    ),
                loading: () => Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                error: (e, st) => Center(
                      child: Text('$e'),
                    ))
          ]))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPost(type: false)),
          );
        },
        child: Icon(Icons.add_rounded),
      ),
    );
  }

  void showSnackbar({String? titleContent, BuildContext? context}) {
    ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
      content: Text('$titleContent'),
      duration: Duration(seconds: 20),
      action: SnackBarAction(
          label: "Oke",
          onPressed: () {
            context.refresh(postProvider.notifier).getReadPost();
          }),
    ));
  }
}
