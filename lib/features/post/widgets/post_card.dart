import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:socially/common/common.dart';
import 'package:socially/constants/assets_constants.dart';
import 'package:socially/features/auth/controller/auth_controller.dart';
import 'package:socially/features/post/views/post_reply_view.dart';
import 'package:socially/features/post/widgets/carousel_image.dart';
import 'package:socially/features/post/widgets/hashtag_text.dart';
import 'package:socially/features/user_profile/view/user_profile_view.dart';
import 'package:socially/models/post_model.dart';
import 'package:socially/theme/pallete.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/enums/post_type_enum.dart';
import '../controller/post_controller.dart';
import 'post_icon_button.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    var colorList = [
      Pallete.purpleColor,
      Pallete.deepPurpleColor,
    ];
    colorList.shuffle();
    return currentUser == null
        ? const SizedBox()
        : ref.watch(userDetailsProvider(post.uid)).when(
              data: (user) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PostReplyScreen.route(post),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Pallete.darkPurpleColor,
                          Pallete.purpleColor,
                          Pallete.darkPurpleColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    UserProfileView.route(user),
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(user.profilePic),
                                  radius: 35,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (post.rePostedBy.isNotEmpty)
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AssetsConstants.repostIcon,
                                          color: Pallete.lightPurpleColor,
                                          height: 20,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          '${post.rePostedBy} reposted',
                                          style: const TextStyle(
                                            color: Pallete.lightPurpleColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                          right: user.isTwitterBlue ? 1 : 5,
                                        ),
                                        child: Text(
                                          user.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 19,
                                          ),
                                        ),
                                      ),
                                      if (user.isTwitterBlue)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5.0),
                                          child: SvgPicture.asset(
                                            AssetsConstants.verifiedIcon,
                                          ),
                                        ),
                                      Text(
                                        '@${user.name} · ${timeago.format(
                                          post.postedAt,
                                          locale: 'en_short',
                                        )}',
                                        style: const TextStyle(
                                          color: Pallete.lightPurpleColor,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (post.repliedTo.isNotEmpty)
                                    ref
                                        .watch(
                                            getPostByIdProvider(post.repliedTo))
                                        .when(
                                          data: (repliedTopost) {
                                            final replyingToUser = ref
                                                .watch(
                                                  userDetailsProvider(
                                                    repliedTopost.uid,
                                                  ),
                                                )
                                                .value;
                                            return RichText(
                                              text: TextSpan(
                                                text: 'Replying to',
                                                style: const TextStyle(
                                                  color:
                                                      Pallete.lightPurpleColor,
                                                  fontSize: 16,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        ' @${replyingToUser?.name}',
                                                    style: const TextStyle(
                                                      color: Pallete
                                                          .lightPurpleColor,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          error: (error, st) => ErrorText(
                                            error: error.toString(),
                                          ),
                                          loading: () => const SizedBox(),
                                        ),
                                  HashtagText(text: post.text),
                                  if (post.postType == PostType.image)
                                    CarouselImage(imageLinks: post.imageLinks),
                                  if (post.link.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    AnyLinkPreview(
                                      displayDirection:
                                          UIDirection.uiDirectionHorizontal,
                                      link: 'https://${post.link}',
                                    ),
                                  ],
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 10,
                                      right: 20,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        PostIconButton(
                                          pathName: AssetsConstants.viewsIcon,
                                          text: (post.commentIds.length +
                                                  post.reshareCount +
                                                  post.likes.length)
                                              .toString(),
                                          onTap: () {},
                                        ),
                                        PostIconButton(
                                          pathName: AssetsConstants.commentIcon,
                                          text:
                                              post.commentIds.length.toString(),
                                          onTap: () {},
                                        ),
                                        PostIconButton(
                                          pathName: AssetsConstants.repostIcon,
                                          text: post.reshareCount.toString(),
                                          onTap: () {
                                            ref
                                                .read(postControllerProvider
                                                    .notifier)
                                                .resharePost(
                                                  post,
                                                  currentUser,
                                                  context,
                                                );
                                          },
                                        ),
                                        LikeButton(
                                          size: 25,
                                          onTap: (isLiked) async {
                                            ref
                                                .read(postControllerProvider
                                                    .notifier)
                                                .likePost(
                                                  post,
                                                  currentUser,
                                                );
                                            return !isLiked;
                                          },
                                          isLiked: post.likes
                                              .contains(currentUser.uid),
                                          likeBuilder: (isLiked) {
                                            return isLiked
                                                ? Image.asset(
                                                    AssetsConstants
                                                        .likeFilledIcon,
                                                    color: Pallete
                                                        .lightPurpleColor,
                                                  )
                                                : Image.asset(
                                                    AssetsConstants
                                                        .likeOutlinedIcon,
                                                    color: Pallete
                                                        .lightPurpleColor,
                                                  );
                                          },
                                          likeCount: post.likes.length,
                                          countBuilder:
                                              (likeCount, isLiked, text) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 2.0),
                                              child: Text(
                                                text,
                                                style: TextStyle(
                                                  color: isLiked
                                                      ? Pallete.lightPurpleColor
                                                      : Pallete.whiteColor,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.share_outlined,
                                            size: 25,
                                            color: Pallete.lightPurpleColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // const Divider(color: Pallete.lightPurpleColor),
                      ],
                    ),
                  ),
                );
              },
              error: (error, stackTrace) => ErrorText(
                error: error.toString(),
              ),
              loading: () => const Loader(),
            );
  }
}
