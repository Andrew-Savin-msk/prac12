// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'devto_api_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter

class _DevtoApiClient implements DevtoApiClient {
  _DevtoApiClient(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<List<DevtoArticleDto>> getArticles({
    String? tag,
    int? page,
    int? perPage,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'tag': tag,
      r'page': page,
      r'per_page': perPage,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<DevtoArticleDto>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/articles',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<DevtoArticleDto> _value;
    try {
      _value = _result.data!
          .map(
            (dynamic i) => DevtoArticleDto.fromJson(i as Map<String, dynamic>),
          )
          .toList();
    } on Object catch (e, s) {
      // errorLogger?.logError(e, s, _options); // Commented out due to Dio version incompatibility
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<DevtoArticleDto>> getLatestArticles({
    int? page,
    int? perPage,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'per_page': perPage,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<DevtoArticleDto>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/articles/latest',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<DevtoArticleDto> _value;
    try {
      _value = _result.data!
          .map(
            (dynamic i) => DevtoArticleDto.fromJson(i as Map<String, dynamic>),
          )
          .toList();
    } on Object catch (e, s) {
      // errorLogger?.logError(e, s, _options); // Commented out due to Dio version incompatibility
      rethrow;
    }
    return _value;
  }

  @override
  Future<DevtoArticleDto> getArticleById(int id) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<DevtoArticleDto>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/articles/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DevtoArticleDto _value;
    try {
      _value = DevtoArticleDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      // errorLogger?.logError(e, s, _options); // Commented out due to Dio version incompatibility
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<DevtoTagDto>> getTags({int? page, int? perPage}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'per_page': perPage,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<DevtoTagDto>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/tags',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<DevtoTagDto> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => DevtoTagDto.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      // errorLogger?.logError(e, s, _options); // Commented out due to Dio version incompatibility
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<DevtoCommentDto>> getCommentsByArticleId(int articleId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'a_id': articleId};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<DevtoCommentDto>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/comments',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<DevtoCommentDto> _value;
    try {
      _value = _result.data!
          .map(
            (dynamic i) => DevtoCommentDto.fromJson(i as Map<String, dynamic>),
          )
          .toList();
    } on Object catch (e, s) {
      // errorLogger?.logError(e, s, _options); // Commented out due to Dio version incompatibility
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
