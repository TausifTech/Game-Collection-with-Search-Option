// ignore_for_file: file_names
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController controller = TextEditingController();

  // Get json result and convert it to model.
  Future<void> getUserDetails() async {
    final response = await http.get(Uri.parse(url));
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map user in responseJson) {
        _userDetails.add(UserDetails.fromJson(user));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        //For Smooth Scrollable Screen

        slivers: <Widget>[
          const SliverAppBar(
            //SliverAppBar Used
            backgroundColor: Colors.teal,
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Tausif's Games",
                style: TextStyle(
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 26, 58, 45),
                    ),
                    Shadow(
                      offset: Offset(3.0, 3.0),
                      blurRadius: 8.0,
                      color: Color.fromARGB(255, 36, 100, 83),
                    ),
                  ],
                ),
              ),
              background: Image(
                image: AssetImage("assets/banner2.jpg"),
                fit: BoxFit.cover,
              ),

            ),
          ),
          SliverPadding(
              padding: const EdgeInsets.all(4.0),
              sliver: SliverFillRemaining(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          child: ListTile(
                            leading: const Icon(Icons.search),
                            title: TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                  hintText: 'Search', border: InputBorder.none),
                              onChanged: onSearchTextChanged,
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () {
                                controller.clear();
                                onSearchTextChanged('');
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _searchResult.length != 0 ||
                              controller.text.isNotEmpty
                          ? ListView.builder(
                              itemCount: _searchResult.length,
                              itemBuilder: (context, i) {
                                return Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        _searchResult[i].imagePath,
                                      ),
                                    ),
                                    title: Text(_searchResult[i].firstName),
                                  ),
                                  margin: const EdgeInsets.all(2.0),
                                );
                              },
                            )
                          : GridView.builder(
                              itemCount: _userDetails.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Image.network(
                                          _userDetails[index].imagePath,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Container(
                                          height: 48,
                                          width: double.infinity,
                                          color: Colors.grey[900],
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Favorites(),
                                              Expanded(
                                                child: Text(
                                                  ' ' +
                                                      _userDetails[index]
                                                          .firstName,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 17,
                                              )
                                            ],
                                          )),
                                    ],
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 5,
                                  margin: const EdgeInsets.all(10),
                                );
                              },
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5.0,
                                mainAxisSpacing: 5.0,
                              ),
                            ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    text.toLowerCase();

    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
      if (userDetail.firstName.toLowerCase().contains(text))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }
}

List<UserDetails> _searchResult = [];
List<UserDetails> _userDetails = [];

const String url = 'https://www.freetogame.com/api/games?category=shooter';

class UserDetails {
  final int id;
  final String firstName, imagePath;

  UserDetails({
    required this.id,
    required this.firstName,
    required this.imagePath,
  });

  factory UserDetails.fromJson(Map<dynamic, dynamic> json) {
    return UserDetails(
      id: json['id'],
      firstName: json['title'],
      imagePath: json['thumbnail'],
    );
  }
}

//favourites stateful widget
class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.favorite_outlined,
          color: isActive ? Colors.white : Colors.red),
      iconSize: 18,
      onPressed: () {
        setState(() {
          // use setState
          if (isActive == true) {
            isActive = false;
          } else
            isActive = true;
        });
      },
    );
  }
}
