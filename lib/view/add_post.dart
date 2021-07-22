import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_crud/model/post_model.dart';
import 'package:riverpod_crud/service/provider/post_provider.dart';

class AddPost extends StatefulWidget {
  AddPost({
    Key? key,
    required this.type,
    this.data,
  }) : super(key: key);

  final bool type;
  final PostModel? data;

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  late TextEditingController titleController = TextEditingController();
  late TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    setState(() {
      if (widget.type == true) {
        titleController = TextEditingController(text: widget.data!.title);
        bodyController = TextEditingController(text: widget.data!.body);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Title'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: bodyController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Body',
              ),
            ),
            SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  //Add
                  if (widget.type == false) {
                    context
                        .read(postProvider.notifier)
                        .creatPost(PostModel(
                          title: titleController.text,
                          body: bodyController.text,
                          userId: 1,
                        ))
                        .then((value) {
                      if (value == true) {
                        showSnackbar(
                            titleContent: "Succesfully Add Data",
                            clearController: true);
                      } else {
                        showSnackbar(
                            titleContent: "Failed Add Data",
                            clearController: false);
                      }
                    });
                    context.refresh(postProvider.notifier).getReadPost();
                  }
                  //Edit
                  else {
                    context
                        .read(postProvider.notifier)
                        .editPost(PostModel(
                          title: titleController.text,
                          body: bodyController.text,
                          id: widget.data!.id,
                          userId: widget.data!.userId,
                        ))
                        .then((value) {
                      if (value == true) {
                        showSnackbar(
                            titleContent: "Succesfully Edit Data",
                            clearController: true);
                      } else {
                        showSnackbar(
                            titleContent: "Failed Edit Data",
                            clearController: false);
                      }
                    });
                    context.refresh(postProvider.notifier).getReadPost();
                  }
                },
                child: widget.type == true ? Text("Update") : Text("Save"),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showSnackbar({String? titleContent, bool? clearController}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$titleContent'),
      duration: Duration(seconds: 20),
      action: SnackBarAction(
          label: "Oke",
          onPressed: () {
            //Clear Controller
            setState(() {
              if (clearController == true) {
                bodyController.clear();
                titleController.clear();
                Navigator.pop(context);
              }
            });
          }),
    ));
  }
}
