import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_crud/service/data_service.dart';

final dataService = Provider((_) => DataService());
