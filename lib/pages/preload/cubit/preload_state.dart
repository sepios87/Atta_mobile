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
class PreloadStatus {
  const PreloadStatus();
}

@immutable
class PreloadInitialStatus extends PreloadStatus {}

@immutable
class PreloadLoadingStatus extends PreloadStatus {}

@immutable
class PreloadLoadedStatus extends PreloadStatus {}

@immutable
class PreloadErrorStatus extends PreloadStatus {
  const PreloadErrorStatus(this.message);

  final String message;
}
