import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tracker/utils/database.dart';
import 'package:tracker/utils/data_structure.dart';

class CollectionCheckbox extends StatefulWidget {
  SingleMovie movie;
  CollectionCheckbox(
      {super.key, required this.movie});

  @override
  _CollectionCheckboxState createState() => _CollectionCheckboxState();
}

class _CollectionCheckboxState extends State<CollectionCheckbox> {
  List<Map<int, String>> myCollections = [];
  List<Map<int, String>> selectedItems = [];

  void initState() {
    super.initState();
    refreshMovie();
    refreshCollections();
  }

  // 根据tmdbId获取电影id
  Future<void> refreshMovie() async {
    String query = "select id from myTable where tmdbId='${widget.movie.tmdbId}'";
    List<dynamic> res=await ProjectDatabase().sudoQuery(query);

    setState(() {
      widget.movie.id=int.parse(res[0]["id"].toString());
      initSelectedItems(widget.movie.id);
    });
  }

  // 根据myCollection中的内容预选好多选框
  Future<void> initSelectedItems(int? movieId) async {
    String query = """select myCollectionTable.id,collectionName from (myCollectionTable join
myCollections on myCollectionTable.id=myCollections.myCollectionId)
where myMediaId='${movieId}'
""";
    List<Map<dynamic, dynamic>> res = await ProjectDatabase().sudoQuery(query);
    setState(() {
      // 将res中的值赋值给myCollections
      selectedItems=[];
      for (int i = 0; i < res.length; i++) {
        Map<int, String> tmp={};
        tmp[int.parse(res[i].values.first.toString())]=res[i].values.last.toString();
        selectedItems.add(tmp);
      }
      print(selectedItems);
    });
  }

  Future<void> refreshCollections() async {
    String query = "select id,collectionName from myCollectionTable";
    List<Map<dynamic, dynamic>> res = await ProjectDatabase().sudoQuery(query);

    setState(() {
      // 将res中的值赋值给myCollections
      myCollections = [];
      for (int i = 0; i < res.length; i++) {
        Map<int, String> tmp = {};
        tmp[int.parse(res[i].values.first.toString())] =
            res[i].values.last.toString();
        myCollections.add(tmp);
      }
    });
  }

  Future<void> addNewCollection(String name) async {
    String query = """
INSERT INTO myCollectionTable (collectionName)
VALUES ('$name')
    """;
    ProjectDatabase().sudoQuery(query);
    refreshCollections();
  }

  Future<void> addMovieToCollections() async {
    // 先把所有删掉、再添加新的
    String deleteQuery =
        "DELETE FROM myCollections WHERE myMediaId=${widget.movie.id};";
    ProjectDatabase().sudoQuery(deleteQuery);
    for (int i = 0; i < selectedItems.length; i++) {
      String addQuery =
          "INSERT INTO myCollections (myCollectionId,myMediaId) VALUES (${selectedItems[i].keys.first},${widget.movie.id});";
      ProjectDatabase().sudoQuery(addQuery);
    }
  }

  Future<void> deleteCollections() async {
    // 先把myCollections里面内容删光，再删myCollectionTable
    for (int i = 0; i < selectedItems.length; i++) {
      String deleteQuery =
        "DELETE FROM myCollections WHERE myCollectionId=${selectedItems[i].keys.first};";
      ProjectDatabase().sudoQuery(deleteQuery);
    }
    for (int i = 0; i < selectedItems.length; i++) {
      String deleteQuery =
        "DELETE FROM myCollectionTable WHERE id=${selectedItems[i].keys.first};";
      ProjectDatabase().sudoQuery(deleteQuery);
    }
  }

  void _toggleCheckbox(Map<int, String> item) {
    setState(() {
      if (_isContain(item)) {
        selectedItems
            .removeWhere((element) => element.keys.first == item.keys.first);
      } else {
        selectedItems.add(item);
      }
      print(selectedItems);
    });
  }

  bool _isContain(Map<int, String> item) {
    return selectedItems
        .map((e) => e.keys.first)
        .contains(item.keys.first);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          for (Map<int, String> item in myCollections) // 你的选项列表
            CheckboxListTile(
              title: Text(item.values.first),
              value: _isContain(item),
              onChanged: (value) {
                _toggleCheckbox(item);
              },
            ),
          addNewCollectionButton(),
          const SizedBox(height: 10),
          confirmButton(),
          const SizedBox(height: 10),
          deleteButton(),
        ],
      ),
    );
  }

  Widget addNewCollectionButton() {
    return ElevatedButton.icon(
      icon: Icon(
        Icons.add_box,
        color: Colors.purple, // 图标颜色
      ),
      label: const Text('新建合集'),
      onPressed: () async {
        Get.bottomSheet(addNewCollectionDialog(),
            backgroundColor: Colors.white);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // 按钮颜色
        foregroundColor: Colors.deepPurple, // 文本颜色
        shadowColor: Colors.deepPurple, // 阴影颜色
        minimumSize: Size(140, 50), // 按钮大小
      ),
    );
  }

  Widget confirmButton() {
    return ElevatedButton.icon(
      icon: Icon(
        Icons.check,
        color: Colors.white, // 图标颜色
      ),
      label: const Text('确定'),
      onPressed: () async {
        addMovieToCollections();
        Get.back();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple, // 按钮颜色
        foregroundColor: Colors.white, // 文本颜色
        shadowColor: Colors.deepPurple, // 阴影颜色
        minimumSize: Size(140, 50), // 按钮大小
      ),
    );
  }

  Widget deleteButton() {
    return ElevatedButton.icon(
      icon: Icon(
        Icons.delete,
        color: Colors.white, // 图标颜色
      ),
      label: const Text('删除'),
      onPressed: () async {
        deleteCollections();
        refreshCollections();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red, // 按钮颜色
        foregroundColor: Colors.white, // 文本颜色
        shadowColor: Colors.deepOrange, // 阴影颜色
        minimumSize: Size(140, 50), // 按钮大小
      ),
    );
  }

  Widget addNewCollectionDialog() {
    TextEditingController _controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(children: [
        TextField(
            autofocus: true,
            controller: _controller,
            decoration: InputDecoration(
              labelText: "请输入合集名称",
              hintText: "合集名称不能为空",
              prefixIcon: Icon(Icons.collections_bookmark),
            )),
        const SizedBox(height: 10),
        ElevatedButton(
            onPressed: () {
              addNewCollection(_controller.text);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple, // 按钮颜色
              foregroundColor: Colors.white, // 文本颜色
              shadowColor: Colors.deepPurple, // 阴影颜色
              minimumSize: Size(140, 50), // 按钮大小
            ),
            child: Text("确定"))
      ]),
    );
  }
}
