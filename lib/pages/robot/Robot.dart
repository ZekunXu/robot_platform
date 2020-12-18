import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:robot_platform/widgets/common_card.dart';

class RobotPage extends StatefulWidget {
  RobotPage({Key key}) : super(key: key);

  @override
  _RobotPageState createState() => _RobotPageState();
}

class _RobotPageState extends State<RobotPage> {
  final List<dynamic> gridItems = [
    {"text": "IFS外围小黑", "height": 100.0},
    {"text": "IFS七楼小黑", "height": 150.0},
    {"text": "IFS五楼大白", "height": 170.0},
    {"text": "IFS四楼大白", "height": 220.0},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 30, 15, 30),
          child: StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            itemCount: gridItems.length,
            itemBuilder: (context, index) {
              return Container(
                height: gridItems[index]["height"],
                child: MyCard(
                  child: Center(
                    child: Text(gridItems[index]["text"]),
                  ),
                ),
              );
            },
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            staggeredTileBuilder: (index) {
              return StaggeredTile.fit(1);
            },
          ),
        ),
      ),
    );
  }
}
