import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_crud/service/provider/general_provider.dart';
import 'package:riverpod_crud/service/provider/post_provider.dart';
import 'package:riverpod_crud/view/add_post.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Riverpod CRUD JSON"),
      ),
      body: Consumer(builder: (context, watch, child) {
        final post = watch(postProvider);
        return post.when(
            data: (data) => ListView(
                  padding: EdgeInsets.all(20),
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
                                        builder: (context) =>
                                            AddPost(data: item, type: true)),
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
                                          titleContent: "Success Delete Data");
                                    } else {
                                      showSnackbar(
                                          titleContent: "Failed Delete Data");
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
            loading: () => Center(
                  child: CircularProgressIndicator(),
                ),
            error: (e, st) => Center(
                  child: Text('$e'),
                ));
      }),
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

  void showSnackbar({String? titleContent}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
