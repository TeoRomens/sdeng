import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/model/note.dart';
import 'package:sdeng/utils/constants.dart';

part 'board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  BoardCubit() : super(BoardInitial());

  /// Map of app posts cache in memory with id as the key
  final Map<String, Note?> _posts = {};

  bool _haveCalledGetPosts = false;

  Future<void> getPost(String id) async {
    if (_posts[id] != null) {
      return;
    }

    emit(BoardLoaded(posts: _posts));
  }

  Future<void> getAllPosts() async {

    if (_haveCalledGetPosts) {
      log('Posts form cache.');
      return;
    }
    _haveCalledGetPosts = true;

    emit(BoardLoaded(posts: _posts));
  }

  Future<void> addPost(String author, String content) async {
    final post = Note(
        id: 'new',
        author: author,
        content: content,
        createdAt: DateTime.now()
    );

    emit(BoardLoaded(posts: _posts));
  }
}
