import 'package:dio/dio.dart';
import 'package:flavour_demo/utils/api.dart';

class DownloadRepository {
  Future<void> downloadFile(
      {required String url,
      required String savePath,
      required CancelToken cancelToken,
      required Function updateDownloadedPercentage}) async {
    try {
      await Api.download(
          cancelToken: cancelToken,
          url: url,
          savePath: savePath,
          updateDownloadedPercentage: updateDownloadedPercentage);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
