
import 'package:complaints_project/Widgets/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';



class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  Container slideContiner(IconData icon, Color color, String txt) {
    return Container(
      height: 90,
      margin: EdgeInsets.only(right: 5),
      decoration:
      BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          Text(
            txt,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorForDesign().lightblue,
        body: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, int index) {
              return Slidable(
                actionPane: SlidableDrawerActionPane(),
                secondaryActions: <Widget>[
                  InkWell(
                    onTap: () {
                    },
                    child: slideContiner(
                        Icons.delete, Colors.red, "Delete"),
                  )
                ],
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    decoration: BoxDecoration(
                        color: ColorForDesign().blue,
                        borderRadius: BorderRadiusDirectional.circular(8)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage('assets/images/image.jpg'),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "title",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorForDesign().white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "body",
                            style: TextStyle(
                                color: ColorForDesign().white,
                                fontSize: 15),
                          ),
                          Text(
                            "19/2/2022",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black45,
                                fontSize: 10),
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                        });
                      },
                    )),
              );
          },
        )
    );
  }
}
