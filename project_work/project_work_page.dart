import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro4umanager/packages/drag_and_drop_lists-0.2.10/drag_and_drop_item.dart';
import 'package:pro4umanager/packages/drag_and_drop_lists-0.2.10/drag_and_drop_lists.dart';
import 'package:pro4umanager/src/app/page/project/project_work/project_work_page_viewmodel.dart';
import 'package:pro4umanager/src/app/theme/theme_primary.dart';

class ProjectWorkPage extends GetView<ProjectWorkPageController> {
  static const routeName = "/projectWorkPage";
  const ProjectWorkPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemePrimary.greenColor,
      appBar: AppBar(
        title: Text("Pro4u Manager"),
        flexibleSpace: Container(
            decoration:
                BoxDecoration(gradient: ThemePrimary.gradientColorAppbar)),
      ),
      body: GetBuilder<ProjectWorkPageController>(
          id: controller.keyDragAndDropContent,
          builder: (controller) {
            return Column(
              children: [
                Expanded(
                  child: DragAndDropLists(
                    // scrollController: controller.scrollController,
                    //Khoảng cách khi drag item với 2 bên màn hình để kích hoạt scrool
                    scrollAreaSize: Get.width * 0.15,
                    //Chiều rộng của từng danh sách riêng lẻ
                    listWidth: MediaQuery.of(context).size.width * 0.9,
                    // Danh sách
                    children: controller.listDragAndDropContent,
                    // onItemAdd:controller.onItemAdd,
                    // Sự kiện khi drag hoàn tất
                    onItemReorder: controller.onItemReorder,

                    /// Vị trí tab hiện tại
                    tabIndexCallBack: (vt) => controller.tabsIndex.value = vt,

                    // onListReorder: controller.onListReorder,
                    //Padding giữa các list
                    // listPadding: EdgeInsets.symmetric(
                    //     horizontal: MediaQuery.of(context).size.width * 0.05,
                    //     vertical: 10),

                    onItemDraggingChanged: (DragAndDropItem item, value) {
                      print(item);
                    },

                    listPadding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        top: 10,
                        bottom: 10),
                    lastListTargetSize: 0,
                    // MediaQuery.of(context).size.width * 0.01,
                    axis: Axis.horizontal,
                    listDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[300]),
                    itemDraggingWidth: Get.width * 0.7,
                    itemDecorationWhileDragging: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(() => Container(
                      // height: 20,
                      padding: EdgeInsets.all(20.0),
                      width: Get.width,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(
                              controller.listDragAndDropContent.length,
                              (index) => Container(
                                    width: 10,
                                    height: 10,
                                    margin: EdgeInsets.only(right: 5),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            controller.tabsIndex.value == index
                                                ? Colors.white
                                                : Colors.grey.withOpacity(0.5)),
                                  ))),
                    ))
              ],
            );
          }),
    );
  }
}
