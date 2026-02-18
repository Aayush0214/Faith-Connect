import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../../core/common/entities/chat_entity.dart';
import '../../../../../../core/common/widgets/app_network_image.dart';
import '../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../core/theme/app_colors/app_colors.dart';
import '../../../../../../injection.dart';
import '../leader_chat_bloc/leader_chat_bloc.dart';

class LeaderChatDetailPage extends StatefulWidget {
  final ChatEntity chat;
  const LeaderChatDetailPage({super.key, required this.chat});

  @override
  State<LeaderChatDetailPage> createState() => _LeaderChatDetailPageState();
}

class _LeaderChatDetailPageState extends State<LeaderChatDetailPage> {
  late final String _currentUserId;
  late LeaderChatBloc _leaderChatBloc;
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _currentUserId = sl<SupabaseClient>().auth.currentUser!.id;
    _leaderChatBloc = context.read<LeaderChatBloc>();
    _leaderChatBloc.add(WatchMessagesEvent(conversationId: widget.chat.id));
    _leaderChatBloc.add(MarkAsReadEvent(conversationId: widget.chat.id));
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    _leaderChatBloc.add(CloseMessagesStreamEvent());
    super.dispose();
  }

  void _handleSendPressed(String text) {
    if (text.trim().isEmpty) return;
    context.read<LeaderChatBloc>().add(SendMessageEvent(
      conversationId: widget.chat.id,
      receiverId: widget.chat.otherUserId,
      text: _msgController.text.trim(),
    ));
    _msgController.clear();
  }

  String _getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) return "TODAY";
    if (dateToCheck == yesterday) return "YESTERDAY";

    // Agar purana hai toh proper date dikhao (e.g., 25 Jan)
    return DateFormat('d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffefe7de), // WhatsApp Background
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        backgroundColor: AppColors.white,
        title: Row(
          children: [
            AppNetworkImage(
              url: widget.chat.otherUserPhoto ?? "",
              width: 38.w,
              height: 38.w,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: CustomText(
                text: widget.chat.otherUserName,
                fontWeight: FontWeight.bold,
                textColor: AppColors.black,
                fontSize: 16.sp,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert, color: Colors.black)),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0.5.h),
          child: Container(color: Colors.black.withValues(alpha: 0.1), height: 0.5.h),
        ),
      ),
      body: BlocListener<LeaderChatBloc, LeaderChatState>(
        listener: (context, state) {
          if (state is MessagesLoaded) {
            final hasUnread = state.messages.any((m) => !m.isMine && !m.isRead);

            if (hasUnread) {
              context.read<LeaderChatBloc>().add(MarkAsReadEvent(conversationId: widget.chat.id));
            }
          }
        },
        child: BlocBuilder<LeaderChatBloc, LeaderChatState>(
          buildWhen: (prev, curr) => curr is MessagesLoaded,
          builder: (context, state) {
            List<types.Message> uiMessages = [];
            if (state is MessagesLoaded) {
              uiMessages = state.messages.map((m) {
                return types.TextMessage(
                  id: m.id,
                  author: types.User(id: m.senderId),
                  text: m.messageText,
                  showStatus: true,
                  createdAt: m.createdAt.millisecondsSinceEpoch,
                  // Ticks Logic
                  status: m.senderId == _currentUserId
                      ? (m.isRead ? types.Status.seen : types.Status.delivered)
                      : null,
                );
              }).toList();

              uiMessages.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
            }
            return Chat(
              messages: uiMessages,
              onSendPressed: (partialText) => _handleSendPressed(partialText.text),
              user: types.User(id: _currentUserId),
              showUserAvatars: false,
              showUserNames: false,
              dateHeaderThreshold: 86400000, // 24 hrs
              dateHeaderBuilder: (date) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xffd1e4f3), // WhatsApp date bubble color
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      _getFormattedDate(date.dateTime),
                      style: TextStyle(fontSize: 12.sp, color: Colors.black54, fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              },
              customBottomWidget: _buildCustomInput(),
              textMessageBuilder: (types.TextMessage message, {required int messageWidth, required bool showName}) {
                final bool isMine = message.author.id == _currentUserId;

                // Time formatting (e.g., 10:30 AM)
                final String timeStr = DateFormat('hh:mm a').format(
                  DateTime.fromMillisecondsSinceEpoch(message.createdAt!),
                );

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        message.text,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: isMine ? Colors.white : Colors.black,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            timeStr,
                            style: TextStyle(
                              color: (isMine ? Colors.white70 : Colors.black45),
                              fontSize: 10.sp,
                            ),
                          ),
                          if (isMine) ...[
                            SizedBox(width: 4.w),
                            Icon(
                              message.status == types.Status.seen ? Icons.done_all : Icons.done,
                              size: 15.sp,
                              // WhatsApp ki tarah seen hone par blue, varna halka white/grey
                              color: message.status == types.Status.seen ? Colors.blue : Colors.white70,
                            ),
                          ]
                        ],
                      ),
                    ],
                  ),
                );
              },
              theme: DefaultChatTheme(
                primaryColor: const Color(0xff005c4b),
                secondaryColor: Colors.white,
                backgroundColor: Colors.transparent,
                messageBorderRadius: 12.r,
                deliveredIcon: const SizedBox.shrink(),
                seenIcon: const SizedBox.shrink(),
                sendingIcon: const SizedBox.shrink(),
                errorIcon: const SizedBox.shrink(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCustomInput() {
    return Container(
      padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 20.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.r),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Row(
                children: [
                  const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      maxLines: 5,
                      minLines: 1,
                      decoration: const InputDecoration(
                        hintText: "Message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Icon(Icons.attach_file, color: Colors.grey),
                  SizedBox(width: 10.w),
                  const Icon(Icons.camera_alt, color: Colors.grey),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () => _handleSendPressed(_msgController.text),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: AppColors.black, shape: BoxShape.circle),
              child: const Icon(Icons.send, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}