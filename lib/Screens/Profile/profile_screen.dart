// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_interpolation_to_compose_strings

// import 'dart:js_interop';

import 'dart:io';
import 'dart:math';
// import 'package:flutter/widgets.dart' as w;
// import 'package:Yomcoin/models/models.dart';
// import 'package:Yomcoin/screens/login.dart';
import 'package:farm_to_dish/app_theme_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../../global_objects.dart';
import '../../global_widgets.dart';
import '../screens.dart';

// import 'common_widget.dart';
// import 'screen_data_handler/signup_handler.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FarmToDishTheme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 33.0, vertical: 20),
        child: Column(
          children: [
            _buildTopComponent(),
            _buildSecondBlock(),
            // divider
            // Divider(color: ,)
            _buildDivider(),
            SizedBox(height: 25),
            TitleMoreAndBodyWidget(
              body: Column(children: [
                _buildItem(
                    imageWidget: Image.asset(
                      "${assets}yams.png",
                    ),
                    title: "Yams and peppers",
                    subtitle: "1 day to delivery"),
                SizedBox(height: 15),
                _buildItem(
                    imageWidget: Image.asset(
                      "${assets}yams.png",
                    ),
                    title: "Yams and peppers",
                    subtitle: "1 day to delivery"),
                SizedBox(height: 15),
                _buildItem(
                    imageWidget: Image.asset(
                      "${assets}yams.png",
                    ),
                    title: "Yams and peppers",
                    subtitle: "1 day to delivery"),
              ]),
              titleWidget: _buildTitleForLists("Current Order"),
              isSeeAll: true,
            ),
            SizedBox(height: 20),
            TitleMoreAndBodyWidget(
              body: Column(children: [
                _buildItem(
                    imageWidget: Image.asset(
                      "${assets}yams.png",
                    ),
                    title: "Service packs",
                    subtitle: "1 shoe and 3 jean"),
                SizedBox(height: 15),
                _buildItem(
                    imageWidget: Image.asset(
                      "${assets}yams.png",
                    ),
                    title: "Yams and peppers",
                    subtitle: "1 day to delivery"),
                SizedBox(height: 15),
                _buildItem(
                    imageWidget: Image.asset(
                      "${assets}yams.png",
                    ),
                    title: "Yams and peppers",
                    subtitle: "1 day to delivery"),
              ]),
              titleWidget: _buildTitleForLists("History"),
              isSeeAll: true,
            )
          ],
        ),
      )),
    );
  }

  Container _buildItem({Widget? imageWidget, String? title, String? subtitle}) {
    return Container(
      height: 89,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          color: FarmToDishTheme.accentLightColor,
          boxShadow: List.filled(4, FarmToDishTheme.genericBoxShadow)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
        child: Row(children: [
          Container(
              clipBehavior: Clip.hardEdge,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: imageWidget),
          SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title.toString(),
                style: FarmToDishTheme.listMainText,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.watch_later,
                    color: FarmToDishTheme.listSubText.color,
                    size: 15,
                  ),
                  SizedBox(width: 10),
                  Text(
                    subtitle.toString(),
                    style: FarmToDishTheme.listSubText,
                  ),
                ],
              ),
            ],
          )
        ]),
      ),
    );
  }

  Container _buildTitleForLists(String title) {
    return Container(
      alignment: Alignment.center,
      height: 35,
      // width: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: FarmToDishTheme.deepGreen),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Text(
          title,
          style: TextStyle(
            color: FarmToDishTheme.scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      height: 3,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Colors.transparent,
        FarmToDishTheme.deepGreen,
        Colors.transparent
      ])),
    );
  }

  Column _buildSecondBlock() {
    return Column(
      children: [
        CircleAvatar(
          // clipBehavior: Clip.hardEdge,
          // decoration: BoxDecoration(shape: BoxShape.circle),
          radius: 100,
          backgroundImage: Image.asset("${assets}shop.png").image,
          // child: ,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO : attach live data
            Text(
              "Bisi Olatunji",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.edit_square,
                  color: FarmToDishTheme.highlightBlue,
                ))
          ],
        )
      ],
    );
  }

  Row _buildTopComponent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Visibility(
          visible: Navigator.of(context).canPop(),
          child: CircleAvatar(
            backgroundColor: FarmToDishTheme.accentLightColor,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.chevron_left),
            ),
          ),
        ),
        IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_outlined))
      ],
    );
  }
}
