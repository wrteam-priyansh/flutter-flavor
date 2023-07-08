import 'package:flavour_demo/cubits/downloadFileCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class PdfViewContainer extends StatefulWidget {
  final String url;
  final String savedFileName;
  final Axis? scrollDirection;
  final Function(PdfViewerController)? initPdfController;
  const PdfViewContainer(
      {super.key,
      required this.url,
      required this.savedFileName,
      this.initPdfController,
      this.scrollDirection});

  @override
  State<PdfViewContainer> createState() => _PdfViewContainerState();
}

class _PdfViewContainerState extends State<PdfViewContainer> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (context.read<DownloadFileCubit>().state is! DownloadFileSuccess) {
        context.read<DownloadFileCubit>().downloadFile(
            fileUrl: widget.url,
            savedFileName: widget.savedFileName,
            storeInExternalStorage: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadFileCubit, DownloadFileState>(
      builder: (context, state) {
        if (state is DownloadFileSuccess) {
          return PdfViewer.openFile(
            state.downloadedFileUrl,
            params: PdfViewerParams(
                pageDecoration: BoxDecoration(border: Border.all()),
                onViewerControllerInitialized: (controller) {
                  widget.initPdfController?.call(controller);
                },
                scrollDirection: widget.scrollDirection ?? Axis.vertical),
          );
        }
        if (state is DownloadFileFailure) {
          return Center(child: Text(state.errorMessage));
        }

        if (state is DownloadFileInProgress) {
          return Center(
            child: Text(
              "Loading file ${state.uploadedPercentage.toStringAsFixed(2)}%",
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
