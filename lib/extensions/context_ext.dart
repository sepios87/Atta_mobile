import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

extension ContextExtension on BuildContext {
  Future<T?> adapativePushNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    if (!_goNamedWeb(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    )) {
      return pushNamed<T>(
        name,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );
    }
    return Future<T>.value();
  }

  void adapativePushReplacementNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    if (!_goNamedWeb(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    )) {
      pushReplacementNamed(
        name,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );
    }
  }

  void adapativeReplacementNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    if (!_goNamedWeb(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    )) {
      replaceNamed(
        name,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );
    }
  }

  void adaptativePopNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
    Object? result,
  }) {
    if (!_goNamedWeb(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    )) {
      pop(result);
    }
  }

  bool _goNamedWeb(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    if (kIsWeb) {
      goNamed(
        name,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );
      return true;
    }
    return false;
  }
}
