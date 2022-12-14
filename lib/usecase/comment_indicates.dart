import 'package:elixir/data/keys.dart';
import 'package:elixir/data/model/comment.dart';
import 'package:elixir/data/model/indicate.dart';
import 'package:elixir/data/repository/github.dart';
import 'package:elixir/extension/iterable.dart';
import 'package:meta/meta.dart';

class CommentIndicatesUseCase {
  const CommentIndicatesUseCase({
    required GitHubRepository gitHubRepository,
  }) : _gitHubRepository = gitHubRepository;

  final GitHubRepository _gitHubRepository;

  Future<String> call({
    required String repo,
    required int num,
    required Iterable<Indicate> indicates,
  }) async {
    final commentKeyGroup = indicates.groupBy<_CommentKey>(
      (indicate) => _CommentKey(
        path: indicate.path,
        line: indicate.line,
      ),
    );

    final comments = commentKeyGroup.entries.map((entry) {
      final key = entry.key;
      final value = entry.value;
      final body = '''
<!-- $elixirKey -->
<table>
  <tbody>
${value.map((e) => e.message).join('\n')}
  </tbody>
</table>''';
      return Comment(
        path: key.path,
        line: key.line,
        body: body,
      );
    }).toList();

    return _gitHubRepository.createReview(
      repo: repo,
      num: num,
      comments: comments,
    );
  }
}

@immutable
class _CommentKey {
  const _CommentKey({
    required this.path,
    required this.line,
  });

  final String path;
  final int line;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _CommentKey &&
          runtimeType == other.runtimeType &&
          path == other.path &&
          line == other.line;

  @override
  int get hashCode => path.hashCode ^ line.hashCode;
}
