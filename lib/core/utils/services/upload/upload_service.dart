import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jaga_saku/core/api/api.dart';
import 'package:jaga_saku/core/error/error.dart';

/// Resolves the uploaded file URL from the `/upload` success envelope
/// (`{ data: { url, ... } }`). Pure + [visibleForTesting].
@visibleForTesting
String? uploadedUrlFrom(Object? body) {
  if (body is! Map<String, dynamic>) return null;
  final data = body['data'];
  if (data is! Map<String, dynamic>) return null;
  final url = data['url'];
  return (url is String && url.isNotEmpty) ? url : null;
}

/// Picks an image and uploads it to `POST /upload` (multipart, field `file`),
/// returning the stored URL. The picker is injectable so callers can fake it;
/// the upload itself reuses [DioClient] so it shares the central error mapping.
class UploadService {
  UploadService(this._client, {ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  final DioClient _client;
  final ImagePicker _picker;

  /// Picks an image from [source] and uploads it. Returns the stored URL on
  /// success, `Right(null)` when the user cancels the picker, or `Left` on
  /// pick / upload failure.
  Future<Either<Failure, String?>> pickAndUploadImage({
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 85);
      if (picked == null) return const Right(null);
      final result = await uploadFile(picked.path, filename: picked.name);
      return result.map<String?>((url) => url);
    } on Exception catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  /// Uploads the file at [path] to `/upload` and returns the stored URL.
  Future<Either<Failure, String>> uploadFile(
    String path, {
    String? filename,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(path, filename: filename),
    });
    return _client.postRequest<String>(
      ListAPI.upload,
      data: formData,
      converter: (body) {
        final url = uploadedUrlFrom(body);
        if (url == null) {
          throw const ServerFailure('Upload response missing url');
        }
        return url;
      },
    );
  }
}
