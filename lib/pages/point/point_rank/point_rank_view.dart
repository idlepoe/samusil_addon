import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../define/define.dart';
import '../../../utils/util.dart';
import 'point_rank_controller.dart';

class PointRankView extends GetView<PointRankController> {
  const PointRankView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "point_rank".tr,
          style: const TextStyle(color: Define.APP_BAR_TITLE_TEXT_COLOR),
        ),
        backgroundColor: Define.APP_BAR_BACKGROUND_COLOR,
        iconTheme: const IconThemeData(color: Define.APP_BAR_TITLE_TEXT_COLOR),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: controller.scrollToMyProfile,
            icon: const Icon(Icons.perm_contact_calendar_outlined),
          ),
        ],
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: List.generate(controller.profileList.length, (index) {
              final profileItem = controller.profileList[index];
              bool me = controller.isMyProfile(profileItem);
              return ListTile(
                key: me ? controller.dataKey : null,
                tileColor: me ? Colors.teal : null,
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      (index + 1).toString(),
                      style: TextStyle(color: me ? Colors.white : Colors.black),
                    ),
                  ],
                ),
                title: Row(
                  children: [
                    if (Utils.isValidNilEmptyStr(
                      controller.getProfileImageUrl(profileItem),
                    ))
                      CachedNetworkImage(
                        imageUrl: controller.getProfileImageUrl(profileItem),
                        imageBuilder:
                            (context, imageProvider) => Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                        placeholder:
                            (context, url) => const CircularProgressIndicator(),
                        errorWidget:
                            (context, url, error) => const CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/anon_icon.jpg',
                              ),
                            ),
                      ),
                    if (!Utils.isValidNilEmptyStr(
                      controller.getProfileImageUrl(profileItem),
                    ))
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/anon_icon.jpg'),
                      ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.getProfileName(profileItem),
                          style: TextStyle(
                            color: me ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          controller.getProfileCreatedAt(profileItem),
                          style: TextStyle(
                            color: me ? Colors.white : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Text(
                  "${controller.getProfilePoint(profileItem)}P",
                  style: TextStyle(color: me ? Colors.white : Colors.black),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
