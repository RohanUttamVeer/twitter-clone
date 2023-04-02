import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/views/twitter_reply_view.dart';
import 'package:twitter_clone/features/tweet/widgets/carousel_image.dart';
import 'package:twitter_clone/features/tweet/widgets/hashtag_text.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_icon_button.dart';
import 'package:twitter_clone/features/user_profile/view/user_profile_view.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/theme/pallete.dart';
import 'package:timeago/timeago.dart' as timeago;

class TweetCard extends ConsumerWidget {
  final Tweet tweet;
  const TweetCard({
    super.key,
    required this.tweet,
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
        : ref.watch(userDetailsProvider(tweet.uid)).when(
              data: (user) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      TwitterReplyScreen.route(tweet),
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
                                  if (tweet.rePostedBy.isNotEmpty)
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AssetsConstants.retweetIcon,
                                          color: Pallete.lightPurpleColor,
                                          height: 20,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          '${tweet.rePostedBy} retweeted',
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
                                          tweet.postedAt,
                                          locale: 'en_short',
                                        )}',
                                        style: const TextStyle(
                                          color: Pallete.lightPurpleColor,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (tweet.repliedTo.isNotEmpty)
                                    ref
                                        .watch(getTweetByIdProvider(
                                            tweet.repliedTo))
                                        .when(
                                          data: (repliedToTweet) {
                                            final replyingToUser = ref
                                                .watch(
                                                  userDetailsProvider(
                                                    repliedToTweet.uid,
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
                                                          .deepPurpleAccentColor,
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
                                  HashtagText(text: tweet.text),
                                  if (tweet.postType == TweetType.image)
                                    CarouselImage(imageLinks: tweet.imageLinks),
                                  if (tweet.link.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    AnyLinkPreview(
                                      displayDirection:
                                          UIDirection.uiDirectionHorizontal,
                                      link: 'https://${tweet.link}',
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
                                        TweetIconButton(
                                          pathName: AssetsConstants.viewsIcon,
                                          text: (tweet.commentIds.length +
                                                  tweet.reshareCount +
                                                  tweet.likes.length)
                                              .toString(),
                                          onTap: () {},
                                        ),
                                        TweetIconButton(
                                          pathName: AssetsConstants.commentIcon,
                                          text: tweet.commentIds.length
                                              .toString(),
                                          onTap: () {},
                                        ),
                                        TweetIconButton(
                                          pathName: AssetsConstants.retweetIcon,
                                          text: tweet.reshareCount.toString(),
                                          onTap: () {
                                            ref
                                                .read(tweetControllerProvider
                                                    .notifier)
                                                .reshareTweet(
                                                  tweet,
                                                  currentUser,
                                                  context,
                                                );
                                          },
                                        ),
                                        LikeButton(
                                          size: 25,
                                          onTap: (isLiked) async {
                                            ref
                                                .read(tweetControllerProvider
                                                    .notifier)
                                                .likeTweet(
                                                  tweet,
                                                  currentUser,
                                                );
                                            return !isLiked;
                                          },
                                          isLiked: tweet.likes
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
                                          likeCount: tweet.likes.length,
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
