import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flavour_demo/data/repositories/downloadRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

abstract class DownloadFileState {}

class DownloadFileInitial extends DownloadFileState {}

class DownloadFileInProgress extends DownloadFileState {
  final double uploadedPercentage;

  DownloadFileInProgress(this.uploadedPercentage);
}

class DownloadFileSuccess extends DownloadFileState {
  final String downloadedFileUrl;
  DownloadFileSuccess(this.downloadedFileUrl);
}

class DownloadFileProcessCanceled extends DownloadFileState {}

class DownloadFileFailure extends DownloadFileState {
  final String errorMessage;

  DownloadFileFailure(this.errorMessage);
}

class DownloadFileCubit extends Cubit<DownloadFileState> {
  final DownloadRepository _downloadRepository;
  DownloadFileCubit(this._downloadRepository) : super(DownloadFileInitial());

  final CancelToken _cancelToken = CancelToken();

  void _downloadedFilePercentage(double percentage) {
    emit(DownloadFileInProgress(percentage));
  }

  Future<void> writeFileFromTempStorage(
      {required String sourcePath, required String destinationPath}) async {
    final tempFile = File(sourcePath);
    final byteData = await tempFile.readAsBytes();
    final downloadedFile = File(destinationPath);
    //write into downloaded file
    await downloadedFile.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }

  void downloadFile(
      {required String fileUrl,
      required String savedFileName,
      required bool storeInExternalStorage}) async {
    emit(DownloadFileInProgress(0.0));
    try {
      //download file for just to see
      final Directory tempDir = await getTemporaryDirectory();
      final savePath = "${tempDir.path}/$savedFileName";

      await _downloadRepository.downloadFile(
          cancelToken: _cancelToken,
          savePath: savePath,
          updateDownloadedPercentage: _downloadedFilePercentage,
          url: fileUrl);

      emit(DownloadFileSuccess(savePath));
    } catch (e) {
      if (_cancelToken.isCancelled) {
        emit(DownloadFileProcessCanceled());
      } else {
        emit(DownloadFileFailure(e.toString()));
      }
    }
  }

  void cancelDownloadProcess() {
    _cancelToken.cancel();
  }
}
