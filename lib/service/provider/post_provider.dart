import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_crud/model/post_model.dart';
import 'package:riverpod_crud/service/data_service.dart';
import './general_provider.dart';

final postProvider = StateNotifierProvider.autoDispose<PostProvider,
    AsyncValue<List<PostModel>>>((ref) {
  final serviceData = ref.read(dataService);
  return PostProvider(serviceData);
});

class PostProvider extends StateNotifier<AsyncValue<List<PostModel>>> {
  PostProvider(this._serviceData, [AsyncValue<List<PostModel>>? state])
      : super(AsyncValue.data([])) {
    getReadPost();
  }

  final DataService? _serviceData;

  Future<void> getReadPost() async {
    state = AsyncValue.loading();
    final posts = await _serviceData!.readPost();
    if (mounted) {
      state = AsyncValue.data([...posts]);
    }
  }

  Future creatPost(PostModel post) async {
    final posts = await _serviceData!.createPost(post);
    return posts;
  }

  Future editPost(PostModel post) async {
    final posts = await _serviceData!.editPost(post);
    return posts;
  }
}
