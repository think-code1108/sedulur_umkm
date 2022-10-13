import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:umkm_application/Const/const_color.dart';
import 'package:umkm_application/Model/data.dart';
import 'package:umkm_application/Model/store.dart';
import 'package:umkm_application/widget/category_tab.dart';
import 'package:umkm_application/widget/store_list.dart';
import '../../widget/title.dart';


class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference stores = FirebaseFirestore.instance.collection('stores');
  List<String> categorySelected = ["makanan", "pakaian", "kesenian"];
  TextEditingController searchController = TextEditingController(text: "");
  String searchQuery = "";

  Widget _search() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Color(0xffE1E2E4),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextField(
                onChanged: (search) {
                  setState(() {
                    searchQuery = search.toUpperCase();
                  });
                },
                controller: searchController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Cari UMKM yang diinginkan",
                    hintStyle:
                        TextStyle(fontSize: 12, color: ConstColor.textDatalab),
                    contentPadding: EdgeInsets.only(
                        left: 10, right: 10, bottom: 0, top: 10),
                    prefixIcon:
                        Icon(Icons.search, color: ConstColor.textDatalab)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3),
      width: MediaQuery.of(context).size.width,
      height: 70,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: AppData.categoryList
            .map(
              (category) => CategoryTab(
                model: category,
                onSelected: (model) {
                  setState(() {
                    AppData.categoryList.forEach((item) {
                      item.isSelected = false;
                    });

                    categorySelected = [];
                    if (model.name.toLowerCase() == "semua") {
                      categorySelected = ["makanan", "pakaian", "kesenian"];
                    } else {
                      categorySelected.add(model.name.toLowerCase());
                    }
                    model.isSelected = true;
                  });
                },
              ),
            )
            .toList(),
      ),
    );
  }

  Stream<QuerySnapshot> homeStream() {
    return searchQuery != ""
        ? stores
            .where(
              "umkm_name",
              isGreaterThanOrEqualTo: searchQuery,
              isLessThan: searchQuery.substring(0, searchQuery.length - 1) +
                  String.fromCharCode(
                      searchQuery.codeUnitAt(searchQuery.length - 1) + 1),
            )
            .where("tag", arrayContainsAny: categorySelected)
            .snapshots()
        : stores.where("tag", arrayContainsAny: categorySelected).snapshots();
  }

  Widget _storeCard() {
    return StreamBuilder<QuerySnapshot>(
      stream: homeStream(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: ConstColor.darkDatalab,
          ));
        }
        if (!snapshot.hasData) {
          return Center(
            child: Text('No Data'),
          );
        }
        return Expanded(
            child: ListView(
          scrollDirection: Axis.vertical,
          children: snapshot.data!.docs.map((e) {
            var mapStore = e.data() as Map<String, dynamic>;
            Store store = Store(
              id: e.id,
              name: mapStore['umkm_name'] ?? '',
              image: mapStore['image'] ?? '',
              city: mapStore['city'] ?? '',
              province: mapStore['province'] ?? '',
              tags: List.from(mapStore['tag']),
            );
            return StoreList(
              id: e.id,
              store: store,
            );
          }).toList(),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColor.lightgreyBG,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  ConstColor.backgroundDatalab,
                  ConstColor.backgroundDatalab
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    titleApp('Daftar Anggota UMKM'),
                    _search(),
                    _categoryWidget(),
                    _storeCard(),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
