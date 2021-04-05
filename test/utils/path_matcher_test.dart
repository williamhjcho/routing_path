import 'package:flutter_test/flutter_test.dart';
import 'package:routing_path/src/utils/path_matcher.dart';

void main() {
  Map<String, String>? matches(String pathPattern, String path) {
    final pattern = buildPathPattern(pathPattern);
    return pathMatches(pattern, path);
  }

  test('simple valid path matches', () {
    // leading and trailing slash should be consumed when matching
    expect(matches('', ''), {});
    expect(matches('/', '/'), {});
    expect(matches('/', ''), {});

    expect(matches('/path/to/somewhere', '/path/to/somewhere'), {});
    expect(matches('/path/to/somewhere', '/path/to/somewhere/'), {});
    expect(matches('/path/to/somewhere', 'path/to/somewhere'), {});

    expect(matches('/path_to-somewhere', '/path_to-somewhere'), {});
  });

  test('simple invalid path matches', () {
    expect(matches('/path/to/somewhere', '/'), isNull);
    expect(matches('/path/to/somewhere', '/path'), isNull);
    expect(matches('/path/to/somewhere', '/path/to'), isNull);

    // must be a exact match
    expect(matches('/path/to/somewhere', '/path/to/somewhereeee'), isNull);
    expect(matches('/path/to/somewhere', '/path/to/somewhere/here'), isNull);
  });

  test('replaceable valid path matches', () {
    expect(matches('/:id', '/123'), {'id': '123'});

    expect(
      matches(
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
      matches(
        '/path/:id/:name',
        '/path/123/path-name',
      ),
      {
        'id': '123',
        'name': 'path-name',
      },
    );
    expect(
      matches(
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
    expect(matches('/', '/:id'), isNull);
    expect(matches('/123', '/:id'), isNull);

    expect(matches('/:id', '/'), isNull);
    expect(matches('/:id', '/123/456'), isNull);

    expect(
      matches(
        '/path/:name/somewhere',
        '/path/path-name',
      ),
      isNull,
    );
    expect(
      matches(
        '/path/:id/to/:name',
        '/path/123/path-name',
      ),
      isNull,
    );
  });
}
