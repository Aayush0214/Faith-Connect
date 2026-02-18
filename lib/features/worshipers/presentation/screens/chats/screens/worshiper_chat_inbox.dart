import 'package:faith_connect/core/common/widgets/app_network_image.dart';
import 'package:faith_connect/core/common/widgets/common_snackbar.dart';
import 'package:faith_connect/core/common/widgets/custom_text.dart';
import 'package:faith_connect/core/theme/app_colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../../../core/common/widgets/chat_inbox_loading.dart';
import '../chat_bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/common/entities/chat_entity.dart';
import 'package:faith_connect/core/routes/route_names.dart';

class WorshiperChatInbox extends StatefulWidget {
  const WorshiperChatInbox({super.key});

  @override
  State<WorshiperChatInbox> createState() => _WorshiperChatInboxState();
}

class _WorshiperChatInboxState extends State<WorshiperChatInbox> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.white,
        title: CustomText(
          text: "Messages",
          fontSize: 20.sp,
          textAlign: TextAlign.left,
          textColor: AppColors.black,
          fontWeight: FontWeight.bold,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(
            color: Colors.black.withValues(alpha: 0.1), // Ekdum halki black line
            height: 1.h,
          ),
        ),
      ),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatInitiationSuccess) {
            context.pushNamed(
              RouteNames.mainChatScreenName,
              extra: ChatEntity(
                id: state.conversationId,
                otherUserId: state.leaderId,
                otherUserName: state.leaderName,
                otherUserPhoto: state.leaderPhoto,
                lastMessageAt: DateTime.now(),
                lastMessage: "",
              ),
            );
          }
          if (state is ChatError){
            showSnackBar(context: context, message: state.message);
          }
        },
        child: BlocBuilder<ChatBloc, ChatState>(
          buildWhen: (previous, current) => current is InboxLoaded || current is InboxLoading,
          builder: (context, state) {
            if (state is InboxLoading){
              return ListView.builder(
                itemCount: 7,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => const ChatInboxLoading(),
              );
            }

            if (state is InboxLoaded) {
              if (state.chats.isEmpty) return const Center(child: Text("Start a conversation via the button below!"));

              return RefreshIndicator(
                color: AppColors.white,
                backgroundColor: AppColors.black,
                onRefresh: () async{
                  context.read<ChatBloc>().add(WatchInboxEvent());
                  await context.read<ChatBloc>().stream.firstWhere((state) => state is InboxLoaded);
                },
                child: ListView.builder(
                  itemCount: state.chats.length,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  itemBuilder: (context, index) {
                    final chat = state.chats[index];
                    return ListTile(
                      key: ValueKey(chat.id + chat.lastMessageAt.toString()),
                      onTap: () => context.pushNamed(RouteNames.mainChatScreenName,extra: chat),
                      leading: AppNetworkImage(
                        width: 45.w,
                        height: 45.w,
                        showBorder: false,
                        url: chat.otherUserPhoto ?? '',
                      ),
                      title: CustomText(text: chat.otherUserName, textColor: AppColors.black, fontWeight: FontWeight.bold, fontSize: 14.sp, textAlign: TextAlign.left,),
                      subtitle: CustomText(text: chat.lastMessage, textColor: Colors.grey, maxLines: 1, textAlign: TextAlign.left, textOverflow: TextOverflow.ellipsis,),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomText(
                            key: ValueKey(chat.lastMessage),
                            text: timeago.format(chat.lastMessageAt, locale: 'en_short', allowFromNow: true),
                            maxLines: 1,
                            fontSize: 12.sp,
                            textColor: AppColors.black,
                            textAlign: TextAlign.right,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(height: 5),
                          if (chat.unreadCount > 0)
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${chat.unreadCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        onPressed: () {
          context.read<ChatBloc>().add(FetchFollowedLeadersForChat());
          _showNewChatSheet(context);
        },
        child: const Icon(Icons.add_comment),
      ),
    );
  }

  void _showNewChatSheet(BuildContext parentContext) {
    showModalBottomSheet(
      context: parentContext,
      backgroundColor: AppColors.white,
      builder: (context) {
        return BlocProvider.value(
          value: parentContext.read<ChatBloc>(),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text("Select Leader", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const Divider(),
                Expanded(
                  child: BlocBuilder<ChatBloc, ChatState>(
                    buildWhen: (previous, current) => current is FollowedLeadersLoaded || current is ChatError,
                    builder: (context, state) {
                      if (state is FollowedLeadersLoaded) {
                        if (state.leaders.isEmpty) return const Center(child: Text("Follow some leaders first!"));

                        return ListView.builder(
                          itemCount: state.leaders.length,
                          itemBuilder: (context, index) {
                            final leader = state.leaders[index];
                            return ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                parentContext.read<ChatBloc>().add(InitiateChat(
                                  leaderId: leader.id,
                                  leaderName: leader.name,
                                  leaderPhoto: leader.photoUrl ?? '',
                                ));
                              },
                              leading: AppNetworkImage(
                                width: 45.w,
                                height: 45.w,
                                showBorder: false,
                                url: leader.photoUrl ?? '',
                              ),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: leader.name,
                                    fontSize: 14.sp,
                                    textAlign: TextAlign.left,
                                    textColor: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  CustomText(
                                    text: leader.bio ?? 'Leader',
                                    maxLines: 1,
                                    fontSize: 12.sp,
                                    textAlign: TextAlign.left,
                                    fontWeight: FontWeight.normal,
                                    textOverflow: TextOverflow.ellipsis,
                                    textColor: AppColors.textDisabledDark,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
