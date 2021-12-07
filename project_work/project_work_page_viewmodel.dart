import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro4umanager/packages/drag_and_drop_lists-0.2.10/drag_and_drop_item.dart';
import 'package:pro4umanager/packages/drag_and_drop_lists-0.2.10/drag_and_drop_list.dart';
import 'package:pro4umanager/src/app/core/baseViewModel.dart';
import 'package:pro4umanager/src/app/theme/theme_primary.dart';

class ProjectModelDemo {
  final String title;
  final List<String> task;
  ProjectModelDemo({this.title, this.task});

  static List<String> listHeader = [
    "Cần làm",
    "Đang làm",
    "Đã xong",
    "Đang kiểm tra",
    "Hoàn tất"
  ];
}

class ProjectWorkPageController extends ViewModelBase {
  ProjectWorkPageController();
  RxInt tabsIndex = 0.obs;

  //Drag and drop UI
  // ScrollController scrollController;
  List<DragAndDropList> listDragAndDropContent = [];
  String keyDragAndDropContent = "dragDropListUpdate";


  //Search task

  @override
  void onInit() {
    super.onInit();

    // scrollController = ScrollController();

    listDragAndDropContent = getListDragAndDropContent();

    // scrollController.addListener(() async {
    //   // Size Offset max của list
    //   double maxWidh =
    //       Get.size.width * 0.9 * (listDragAndDropContent.length - 1) -
    //           Get.size.width * 0.05;
    //   // Tỉ lệ
    //   double ratio = scrollController.position.pixels == 0
    //       ? 0
    //       : scrollController.position.pixels / maxWidh;
    //   int _index = (ratio * 5).toInt();
    //   if (_index == listDragAndDropContent.length) _index = _index - 1;
    //   tabsIndex.value = _index;
    //   print("tabsIndex = $tabsIndex");

      // scrollController.position.isScrollingNotifier.addListener(() async {
      //   if (!scrollController.position.isScrollingNotifier.value) {
      //     print('scroll is stopped');
      //     await scrollController.animateTo(lastOffset,
      //         duration: Duration(milliseconds: 50), curve: Curves.easeInOut);
      //   } else {
      //     print('scroll is started');
      //   }
      // });
    // });
  }

  @override
  void dispose() {
    // scrollController?.dispose();
    super.dispose();
  }

  /*---------------------- Tạo UI cho list Drag&Drop ---------------------- */

  /// Header
  Widget dragAndDropHeaderItem(String headerName) {
    return Container(
      padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
      child: Center(
        child: Text(
          '$headerName',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  /// Footer
  Widget dragAndDropFooterItem(String headerName) {
    return InkWell(
      onTap: () {
        onTapNewItem(headerName);
      },
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.white),
        child: Center(
          child: Text(
            '+ Thêm thẻ mới',
            style: ThemePrimary.styleHeardLine16
                .copyWith(color: ThemePrimary.primaryColor),
          ),
        ),
      ),
    );
  }

  // Empty
  Widget dragAndDropEmpty() {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(5), color: Colors.white),
      child: Center(
        child: Text("Không có thông tin"),
      ),
    );
  }

  /// Item Task DragAndDropItem

  List<DragAndDropItem> getListDragAndDropItem(String headerName) {
    return List.generate(
        15,
        (index) => DragAndDropItem(
              keyStr: '$headerName',
              child: Container(
                padding: EdgeInsets.all(10),
                width: Get.width,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white),
                child: Text(
                  '$headerName $index',
                  style: ThemePrimary.styleHeardLine16,
                ),
              ),
            ));
  }

  // ListDragAndDropList UI hiển thị
  List<DragAndDropList> getListDragAndDropContent() {
    List<DragAndDropList> result = [];
    result = ProjectModelDemo.listHeader
        .map(
          (e) => DragAndDropList(
              keyAddress: e,
              enableAddNew: false,
              canDrag: false,
              contentsWhenEmpty: dragAndDropEmpty(),
              header: dragAndDropHeaderItem(e),
              footer: dragAndDropFooterItem(e),
              children: getListDragAndDropItem(e),
              index: ProjectModelDemo.listHeader.indexOf(e)),
        )
        .toList();
    return result;
  }

  /*----------------------  Drag&Drop Logic ---------------------- */

  /// Tạo mới item trong header
  onTapNewItem(String headerName) {
    int _index = listDragAndDropContent.indexOf(listDragAndDropContent
        .firstWhere((element) => element.keyAddress == headerName));
    listDragAndDropContent[_index].enableAddNew = true;
    listDragAndDropContent[_index].children.add(DragAndDropItem(
          child: Container(
            padding: EdgeInsets.all(10),
            width: Get.width,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.white),
            child: Text(
              '$headerName ${listDragAndDropContent[_index].children.length}',
              style: ThemePrimary.styleHeardLine16,
            ),
          ),
        ));
    print("onTap + Task $headerName");
    this.update([keyDragAndDropContent]);
  }

  onItemAdd(DragAndDropItem newItem, int listIndex, int itemIndex) {
    // DragAndDropItem item = DragAndDropItem(
    //   child: Container(
    //     padding: EdgeInsets.all(10),
    //     width: Get.width,
    //     margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    //     decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(5), color: Colors.white),
    //     child: Text(
    //       '$headerName Yêu cầu ${listDragAndDropContent[_index].children.length}',
    //       style: ThemePrimary.styleHeardLine16,
    //     ),
    //   ),
    // );

    // if (itemIndex == -1)
    //   _contents[listIndex].children.add(newItem);
    // else
    //   _contents[listIndex].children.insert(itemIndex, newItem);
  }

  onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    var movedItem =
        listDragAndDropContent[oldListIndex].children.removeAt(oldItemIndex);
    listDragAndDropContent[newListIndex]
        .children
        .insert(newItemIndex, movedItem);
    this.update([keyDragAndDropContent]);
  }

  onListReorder(int oldListIndex, int newListIndex) {
    var movedList = listDragAndDropContent.removeAt(oldListIndex);
    listDragAndDropContent.insert(newListIndex, movedList);
    this.update([keyDragAndDropContent]);
  }
}
