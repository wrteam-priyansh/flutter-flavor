import 'package:flavour_demo/cubits/botConversationCubit.dart';
import 'package:flavour_demo/cubits/botQueryCubit.dart';
import 'package:flavour_demo/data/models/botQuery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BotScreen extends StatefulWidget {
  const BotScreen({super.key});

  @override
  State<BotScreen> createState() => _BotScreenState();
}

class _BotScreenState extends State<BotScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<BotConversationCubit>().loadConversation();
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Widget _buildBuildMessageContainer({required BotQuery botQuery}) {
    final sendByMe = botQuery.byUser;

    const double radius = 5;
    return Align(
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment:
              sendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: sendByMe
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(sendByMe ? radius : 0),
                    bottomRight: Radius.circular(sendByMe ? 0 : radius),
                    topLeft: Radius.circular(sendByMe ? radius : 0),
                    topRight: Radius.circular(sendByMe ? 0 : radius),
                  )),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * (0.1),
                  maxWidth: MediaQuery.of(context).size.width * (0.75)),
              child: Column(
                children: [
                  Text(
                    botQuery.value,
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).colorScheme.background),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 3.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  "${botQuery.createdAt.day}-${botQuery.createdAt.month}-${botQuery.createdAt.year} : ${TimeOfDay(hour: botQuery.createdAt.hour, minute: botQuery.createdAt.minute).format(context)}",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 13.0)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bot"),
      ),
      body: Column(
        children: [
          Expanded(
              child: BlocBuilder<BotConversationCubit, BotConversationState>(
            builder: (context, state) {
              if (state is BotConversationFetchSuccess) {
                return ListView.builder(
                    reverse: true,
                    itemCount: state.conversation.length,
                    itemBuilder: (context, index) {
                      return _buildBuildMessageContainer(
                          botQuery: state.conversation[index]);
                    });
              }

              if (state is BotConversationFetchFailure) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(state.errorMessage),
                        const SizedBox(
                          height: 15,
                        ),
                        CupertinoButton(
                            onPressed: () {
                              context
                                  .read<BotConversationCubit>()
                                  .loadConversation();
                            },
                            child: const Text("Try again"))
                      ],
                    ),
                  ),
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(border: Border.all()),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Ask anything sensibly"),
                    controller: _textEditingController,
                  ),
                ),
                BlocConsumer<BotQueryCubit, BotQueryState>(
                  listener: (context, state) {
                    if (state is BotQueryFetchSuccess) {
                      context.read<BotConversationCubit>().addConversation(
                          botQuery: BotQuery(
                              byUser: false,
                              createdAt: DateTime.now(),
                              value: state.response));
                    } else if (state is BotQueryFetchFailure) {
                      context.read<BotConversationCubit>().addConversation(
                          botQuery: BotQuery(
                              byUser: false,
                              createdAt: DateTime.now(),
                              value: "Sorry. Failed to get the response"));
                    }
                  },
                  builder: (context, state) {
                    if (state is BotQueryFetchInProgress) {
                      return const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                        ),
                      );
                    }
                    return IconButton(
                        onPressed: () {
                          if (_textEditingController.text.trim().isEmpty) {
                            return;
                          }
                          context.read<BotConversationCubit>().addConversation(
                              botQuery: BotQuery(
                                  byUser: true,
                                  createdAt: DateTime.now(),
                                  value: _textEditingController.text.trim()));

                          context.read<BotQueryCubit>().getQueryResponse(
                              query: _textEditingController.text.trim());
                          _textEditingController.text = "";
                        },
                        icon: const Icon(Icons.send));
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
