import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class PdfViewState {
  final bool isReady;
  final int currentPage;
  final int totalPage;

  PdfViewState(
      {required this.currentPage,
      required this.isReady,
      required this.totalPage});

  PdfViewState copyWith({int? totalPage, int? currentPage, bool? isReady}) {
    return PdfViewState(
        currentPage: currentPage ?? this.currentPage,
        isReady: isReady ?? this.isReady,
        totalPage: totalPage ?? this.totalPage);
  }
}

class PdfViewCubit extends Cubit<PdfViewState> {
  PdfViewerController? _pdfViewerController;

  PdfViewCubit()
      : super(PdfViewState(currentPage: 0, isReady: false, totalPage: 0));

  PdfViewerController? get pdfController => _pdfViewerController;

  void listener() {
    if (state.currentPage != _pdfViewerController!.currentPageNumber) {
      emit(state.copyWith(
          currentPage: _pdfViewerController?.currentPageNumber,
          isReady: _pdfViewerController?.isReady,
          totalPage: _pdfViewerController?.pageCount));
    }
  }

  void initController(PdfViewerController pdfViewerController) {
    _pdfViewerController = pdfViewerController;
    emit(state.copyWith(
      isReady: true,
      currentPage: _pdfViewerController?.currentPageNumber,
      totalPage: _pdfViewerController?.pageCount,
    ));
    _pdfViewerController?.addListener(listener);
  }
}
