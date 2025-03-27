import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:whatsapp_blast/config/theme/app_pallet.dart';
import 'package:whatsapp_blast/core/di/init_dependencies.dart';
import 'package:whatsapp_blast/core/network/token_manager.dart';
import 'package:whatsapp_blast/features/history/presentation/bloc/message_history_bloc.dart';
import 'package:whatsapp_blast/features/history/presentation/widgets/message_history_group_card.dart';

import '../../domain/entities/message_history.dart';
import '../../domain/entities/message_history_group.dart';
import '../widgets/message_history_list_card.dart';
import '../widgets/message_history_table.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String email = '';
  List<MessageHistoryGroup> groupList = [];
  Map<String, List<MessageHistoryGroup>> senderGroups = {};
  Map<String, List<MessageHistory>> listMessage = {};
  Map<String, int> currentPageMap = {};
  String selectedNumber = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? token = serviceLocator<TokenManager>().accessToken;
      email = token != null ? JwtDecoder.decode(token)['email'] : '';
      if (email.isNotEmpty) {
        context
            .read<MessageHistoryBloc>()
            .add(GetMessageHistoryGroupEvent(email: email));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MessageHistoryBloc, MessageHistoryState>(
      listener: (context, state) {
        if (state is DeleteMessageHistoryState) {
          context
              .read<MessageHistoryBloc>()
              .add(GetMessageHistoryGroupEvent(email: email));
        }
      },
      builder: (context, state) {
        if (state is GetMessageHistoryGroupState) {
          groupList = state.list;
          senderGroups = {}; // Clear old data

          for (var group in groupList) {
            senderGroups.putIfAbsent(group.sender, () => []).add(group);
          }
          if (senderGroups.isEmpty) {
            selectedNumber = '';
          } else if (!senderGroups.containsKey(selectedNumber)) {
            selectedNumber = senderGroups.keys.first;
          }
          if (selectedNumber.isEmpty && senderGroups.isNotEmpty) {
            selectedNumber = senderGroups.keys.first;
          }
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.minHeight < 50) {
              return SizedBox.shrink();
            }
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    _dropdownNumber(),
                    if (senderGroups.isNotEmpty)
                      SizedBox(
                        height: constraints.maxHeight - 32,
                        child: _list(constraints, context),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _dropdownNumber() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      color: AppPallete.green,
      child: Container(
        width: 220,
        height: 32,
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
            color: AppPallete.white, borderRadius: BorderRadius.circular(8)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: senderGroups.isNotEmpty ? selectedNumber : null,
            padding: EdgeInsets.symmetric(horizontal: 8),
            isExpanded: true,
            items: senderGroups.keys.map((clientId) {
              return DropdownMenuItem(
                value: clientId,
                child: Row(
                  children: [
                    Icon(Icons.add),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 30,
                        child: Text(
                          clientId,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              selectedNumber = value ?? '';
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  Widget _list(BoxConstraints constraints, BuildContext context) {
    final group =
        groupList.where((element) => element.sender == selectedNumber);

    return BlocBuilder<MessageHistoryBloc, MessageHistoryState>(
      builder: (context, state) {
        if (state is GetMessageHistoryState) {
          if (state.list.isNotEmpty) {
            listMessage[state.messageID] = state.list;
            currentPageMap.putIfAbsent(state.messageID, () => 1);
          }
        }
        return ListView.builder(
          itemCount: group.length,
          itemBuilder: (context, index) {
            final item = group.elementAt(index);
            GlobalKey btnKey = GlobalKey();
            ScrollController scrollController = ScrollController();
            return ExpansionTile(
              showTrailingIcon: false,
              backgroundColor: AppPallete.green.withAlpha(50),
              collapsedBackgroundColor: AppPallete.white.withAlpha(160),
              shape: RoundedRectangleBorder(),
              childrenPadding: EdgeInsets.only(left: 8, right: 16),
              title: MessageHistoryGroupCard(
                btnKey: btnKey,
                item: item,
                indeX100: index * 100,
              ),
              onExpansionChanged: (isExpanded) {
                if (isExpanded) {
                  context
                      .read<MessageHistoryBloc>()
                      .add(GetMessageHistoryEvent(messageID: item.messageID));
                }
              },
              children: constraints.maxWidth > 600
                  ? [
                      MessageHistoryTable(
                        constraints: constraints,
                        scrollController: scrollController,
                        listMessage: listMessage[item.messageID] ?? [],
                      ),
                    ]
                  : [
                      MessageHistoryListCard(
                        messageID: item.messageID,
                        messages: listMessage[item.messageID] ?? [],
                        currentPageMap: currentPageMap,
                        onPageChange: () {
                          setState(() {});
                        },
                      ),
                    ],
            );
          },
        );
      },
    );
  }
}
