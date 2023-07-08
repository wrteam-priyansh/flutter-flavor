import 'package:flavour_demo/cubits/pdfViewCubit.dart';
import 'package:flavour_demo/ui/widgets/pdfViewContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PdfViewScreen extends StatefulWidget {
  const PdfViewScreen({super.key});

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  final pdfUrl = "https://www.africau.edu/images/default/sample.pdf";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * (0.7),
              child: PdfViewContainer(
                  scrollDirection: Axis.horizontal,
                  initPdfController: (controller) {
                    context.read<PdfViewCubit>().initController(controller);
                  },
                  url: pdfUrl,
                  savedFileName: "temp.pdf")),
          BlocBuilder<PdfViewCubit, PdfViewState>(
            builder: (context, state) {
              if (!state.isReady) {
                return const SizedBox();
              }
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                margin: const EdgeInsets.only(top: 15),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      color: Colors.amber,
                      width: 50,
                      height: 50,
                      child: const Text("A"),
                    ),
                    Container(
                      alignment: Alignment.center,
                      color: Colors.amber,
                      width: 50,
                      height: 50,
                      child: const Text("B"),
                    ),
                    Container(
                      alignment: Alignment.center,
                      color: Colors.amber,
                      width: 50,
                      height: 50,
                      child: const Text("C"),
                    ),
                    Container(
                      alignment: Alignment.center,
                      color: Colors.amber,
                      width: 50,
                      height: 50,
                      child: const Text("D"),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
