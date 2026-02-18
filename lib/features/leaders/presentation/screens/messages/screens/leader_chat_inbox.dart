import 'package:faith_connect/core/common/widgets/common_snackbar.dart';
import 'package:faith_connect/core/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../../../core/common/widgets/app_network_image.dart';
import '../../../../../../core/common/widgets/chat_inbox_loading.dart';
import '../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../core/theme/app_colors/app_colors.dart';
import '../leader_chat_bloc/leader_chat_bloc.dart';

class LeaderInboxPage extends StatefulWidget {
  const LeaderInboxPage({super.key});

  @override
  State<LeaderInboxPage> createState() => _LeaderInboxPageState();
}

class _LeaderInboxPageState extends State<LeaderInboxPage> {
  @override
  void initState() {
    super.initState();
  }

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
            color: Colors.black.withValues(alpha: 0.1),
            height: 1.h,
          ),
        ),
      ),
      body: BlocListener<LeaderChatBloc, LeaderChatState>(
        listener: (context, state) {
          if (state is LeaderChatError) {
            showSnackBar(context: context, message: state.message);
          }
        },
        child: BlocBuilder<LeaderChatBloc, LeaderChatState>(
          buildWhen: (previous, current) => current is InboxLoaded,
          builder: (context, state) {
            if (state is LeaderChatLoading) {
              return ListView.builder(
                itemCount: 7,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => const ChatInboxLoading(),
              );
            } else if (state is InboxLoaded) {
              if (state.chats.isEmpty) {
                return const Center(child: Text("No messages yet."));
              }
              return RefreshIndicator(
                color: AppColors.white,
                backgroundColor: AppColors.black,
                onRefresh: () async {
                  context.read<LeaderChatBloc>().add(WatchLeaderInboxEvent());
                  await context
                      .read<LeaderChatBloc>()
                      .stream
                      .firstWhere((state) => state is InboxLoaded);
                },
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  itemCount: state.chats.length,
                  itemBuilder: (context, index) {
                    final chat = state.chats[index];
                    return ListTile(
                      key: ValueKey(chat.id + chat.lastMessageAt.toString()),
                      onTap: () =>
                          context.pushNamed(RouteNames.leaderMainChatScreenName,
                              extra: chat),
                      leading: AppNetworkImage(
                        width: 42.w,
                        height: 45.w,
                        showBorder: false,
                        url: chat.otherUserPhoto ?? '',
                      ),
                      title: CustomText(text: chat.otherUserName,
                        textColor: AppColors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        textAlign: TextAlign.left,),
                      subtitle: CustomText(text: chat.lastMessage,
                        textColor: Colors.grey,
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        textOverflow: TextOverflow.ellipsis,),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomText(
                            key: ValueKey(chat.lastMessage),
                            text: timeago.format(
                                chat.lastMessageAt, locale: 'en_short',
                                allowFromNow: true),
                            maxLines: 2,
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
    );
  }
}
