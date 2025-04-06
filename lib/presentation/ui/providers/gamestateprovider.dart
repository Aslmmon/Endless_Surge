import 'package:endless_surge/data/repositoriesImpl/character_repository_impl.dart'
    show CharacterRepositoryImpl;
import 'package:endless_surge/domain/repositories/character_repository.dart'
    show CharacterRepository;
import 'package:riverpod/riverpod.dart';

final characterRepositoryProvider = Provider<CharacterRepository>((ref) => CharacterRepositoryImpl(),
);
