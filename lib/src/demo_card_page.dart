import 'package:flutter/material.dart';
import 'package:fluttertrellocard/packages/drag_and_drop_lists-0.2.10/drag_and_drop_lists.dart';
import 'package:get/get.dart';
import 'demo_card_controller.dart';

class CardDemoPage extends StatelessWidget {
  static const routeName = "/projectWorkPage";
  final CardDemoController controller = Get.put(CardDemoController());
  CardDemoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.withOpacity(0.5),
      appBar: AppBar(
        title: const Text("Card Trello Clone"),
        backgroundColor: Colors.teal.withOpacity(0.5),
      ),
      body: GetBuilder<CardDemoController>(builder: (controller) {
        return Column(
          children: [
            if (controller.listDragAndDropContent.length > 0)
              Expanded(
                child: DragAndDropLists(
                  scrollAreaSize: Get.width * 0.2,
                  listWidth: MediaQuery.of(context).size.width * 0.9,
                  children: controller.listDragAndDropContent,
                  onItemReorder: controller.onItemReorder,
                  tabIndexCallBack: (vt) => controller.tabsIndex.value = vt,
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
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
            if (controller.listDragAndDropContent.length > 0)
              Obx(() => SafeArea(
                child: Container(
                      // height: 20,
                      padding: const EdgeInsets.all(8.0),
                      width: Get.width,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(
                              controller.listDragAndDropContent.length,
                              (index) => Container(
                                    width: 10,
                                    height: 10,
                                    margin: const EdgeInsets.only(right: 5),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: controller.tabsIndex.value == index
                                            ? Colors.white
                                            : Colors.grey.withOpacity(0.5)),
                                  ))),
                    ),
              ))
          ],
        );
      }),
    );
  }
}
