part of 'preload_cubit.dart';

@immutable
class PreloadState {
  const PreloadState._({
    required this.status,
  });

  PreloadState.initial() : this._(status: PreloadInitialStatus());

  final PreloadStatus status;

  PreloadState copyWith({
    PreloadStatus? status,
  }) {
    return PreloadState._(
      status: status ?? this.status,
    );
  }
}

@immutable
abstract final class PreloadStatus {}

final class PreloadInitialStatus extends PreloadStatus {}

final class PreloadLoadingStatus extends PreloadStatus {}

final class PreloadLoadedStatus extends PreloadStatus {}

final class PreloadErrorStatus extends PreloadStatus {
  PreloadErrorStatus(this.message);

  final String message;
}
