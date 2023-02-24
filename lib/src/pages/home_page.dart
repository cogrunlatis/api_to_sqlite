// ignore_for_file: unnecessary_const, unnecessary_new

import 'package:api_to_sqlite/src/models/information_model.dart';
import 'package:api_to_sqlite/src/providers/db_provider.dart';
import 'package:api_to_sqlite/src/providers/information_api_provider.dart';
import 'package:flutter/material.dart';
import 'package:api_to_sqlite/src/dao/todo_dao.dart';

final informationDao = InformationDao();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text('API to SQLite'),
          centerTitle: true,
          actions: <Widget>[
            Container(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: const Icon(Icons.settings_input_antenna),
                onPressed: () async {
                  await _loadFromApi();
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await _deleteData();
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  _showTodoSearchSheet(context);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: const Icon(Icons.delete_sweep),
                onPressed: () {},
              ),
            )
          ],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _buildInformationListView(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: FloatingActionButton(
            elevation: 5.0,
            onPressed: () {
              _showAddTodoSheet(context);
            },
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.add,
              size: 32,
              color: Colors.deepPurple,
            ),
          ),
        ));
  }

  void _showAddTodoSheet(BuildContext context) {
    final _nameController = TextEditingController();
    final _avatarController = TextEditingController();

    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: new Container(
              color: Colors.transparent,
              child: new Container(
                height: 230,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 25.0, right: 15, bottom: 30),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _nameController,
                                  textInputAction: TextInputAction.newline,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w400),
                                  autofocus: true,
                                  decoration: const InputDecoration(
                                      hintText: 'name',
                                      labelText: 'Name',
                                      labelStyle: TextStyle(
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.w500)),
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'The name can not be empty!';
                                    }
                                    return value.contains('')
                                        ? 'Do not use the @ char.'
                                        : null;
                                  },
                                ),
                                TextFormField(
                                  controller: _avatarController,
                                  textInputAction: TextInputAction.newline,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w400),
                                  autofocus: true,
                                  decoration: const InputDecoration(
                                      hintText: 'avatar',
                                      labelText: 'Avatar',
                                      labelStyle: TextStyle(
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.w500)),
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'The avatar can not be empty!';
                                    }
                                    return value.contains('')
                                        ? 'Do not use the @ char.'
                                        : null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, top: 15),
                            child: CircleAvatar(
                              backgroundColor: Colors.deepPurple,
                              radius: 18,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.save,
                                  size: 22,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  final newInformation = Information(
                                      name: _nameController.value.text,
                                      avatar: _avatarController.value.text);
                                  if (newInformation.name != null) {
                                    informationDao
                                        .createInformation(newInformation);
                                    //dismisses the bottomsheet
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _showTodoSearchSheet(BuildContext context) {
    final _nameController = TextEditingController();
    final _avatarController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: new Container(
              color: Colors.transparent,
              child: new Container(
                height: 230,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 25.0, right: 15, bottom: 30),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: _nameController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 4,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: 'Search...',
                                labelText: 'Search *',
                                labelStyle: TextStyle(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.w500),
                              ),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Empty description!';
                                }
                                return value.contains('')
                                    ? 'Do not use the @ char.'
                                    : null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, top: 15),
                            child: CircleAvatar(
                              backgroundColor: Colors.deepPurple,
                              radius: 18,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.search,
                                  size: 22,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  final newInformation = Information(
                                    name: _nameController.text,
                                    avatar: _avatarController.text,
                                  );
                                  if (newInformation.name != null) {
                                    informationDao
                                        .createInformation(newInformation);
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'name',
                          labelText: 'Name',
                          labelStyle: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      TextField(
                        controller: _avatarController,
                        decoration: const InputDecoration(
                          hintText: 'avatar',
                          labelText: 'Avatar',
                          labelStyle: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = InformationApiProvider();
    await apiProvider.getAllInformation();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  _deleteData() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllInformation();

    // wait for 1 second to simulate loading of data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    // ignore: avoid_print
    print('All information deleted');
  }

  _buildInformationListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllInformation(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              color: Colors.black12,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Image.network('${snapshot.data[index].avatar}'),
                title: Text("Name: ${snapshot.data[index].name}"),
              );
            },
          );
        }
      },
    );
  }
}
