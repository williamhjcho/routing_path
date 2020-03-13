import 'package:flutter_test/flutter_test.dart';
import 'package:routing_path/src/utils/path_matcher.dart';

void main() {
  Map<String, String> match(String pathPattern, String path) {
    final pattern = buildPathPattern(pathPattern);
    return pathMatches(pattern, path);
  }

  test('simple valid path matches', () {
    // leading and trailing slash should be consumed when matching
    expect(match('', ''), {});
    expect(match('/', '/'), {});
    expect(match('/', ''), {});

    expect(match('/path/to/somewhere', '/path/to/somewhere'), {});
    expect(match('/path/to/somewhere', '/path/to/somewhere/'), {});
    expect(match('/path/to/somewhere', 'path/to/somewhere'), {});

    expect(match('/path_to-somewhere', '/path_to-somewhere'), {});
  });

  test('simple invalid path matches', () {
    expect(match('/path/to/somewhere', '/'), isNull);
    expect(match('/path/to/somewhere', '/path'), isNull);
    expect(match('/path/to/somewhere', '/path/to'), isNull);

    // must be a exact match
    expect(match('/path/to/somewhere', '/path/to/somewhereeee'), isNull);
    expect(match('/path/to/somewhere', '/path/to/somewhere/here'), isNull);
  });

  test('replaceable valid path matches', () {
    expect(match('/:id', '/123'), {'id': '123'});

    expect(
      match(
        '/:id/:name/:value',
        '/123/path-name/456-789',
      ),
      {
        'id': '123',
        'name': 'path-name',
        'value': '456-789',
      },
    );

    expect(
      match(
        '/path/:id/:name',
        '/path/123/path-name',
      ),
      {
        'id': '123',
        'name': 'path-name',
      },
    );
    expect(
      match(
        '/:id/path/:name',
        '/123/path/path-name',
      ),
      {
        'id': '123',
        'name': 'path-name',
      },
    );
  });

  test('replaceable invalid path matches', () {
    expect(match('/', '/:id'), isNull);
    expect(match('/123', '/:id'), isNull);

    expect(match('/:id', '/'), isNull);
    expect(match('/:id', '/123/456'), isNull);

    expect(
      match(
        '/path/:name/somewhere',
        '/path/path-name',
      ),
      isNull,
    );
    expect(
      match(
        '/path/:id/to/:name',
        '/path/123/path-name',
      ),
      isNull,
    );
  });
}
