import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gallery_api/main.dart';

import '../models/albumModel.dart';
import '../models/userModel.dart';
import '../services/api/api_services.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController textEditingController = TextEditingController();
  late List<UserModel>? _userModel = [];
  late Future<Album> _futureAlbum;
  @override
  void initState() {
    super.initState();
    _futureAlbum = fetchAlbum();
    _getData();
  }

//
  void _getData() async {
    _userModel = (await ApiService().getUsers())!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  //
  void updateUser() async {
    _userModel = (await ApiService().updateUser('title')) as List<UserModel>?;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REST API Example'),
      ),
      body: _userModel == null || _userModel!.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _userModel!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    trailing: IconButton(
                        onPressed: () {
                          showAlertDialog(context);
                        },
                        icon: Icon(Icons.edit)),
                    leading: Text(_userModel![index].id.toString()),
                    title: Text(_userModel![index].username.toString()),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'User Name: ${_userModel![index].username.toString()}'),
                        Text(_userModel![index].email.toString()),
                        Text(_userModel![index].address.toString()),
                        Text(_userModel![index].phone.toString()),
                        Text(_userModel![index].website.toString()),
                        Text(_userModel![index].company.toString()),
                      ],
                    ),

                    //  trailing: ,
                  ),
                );
                // return Card(
                //   child: Column(
                //     children: [
                //       Text(_userModel![index].id.toString()),
                //       Text(_userModel![index].username.toString()),
                //       const SizedBox(
                //         height: 20.0,
                //       ),
                //       Text(_userModel![index].email.toString()),
                //       Text(_userModel![index].website.toString()),
                //     ],
                //   ),
                // );
              },
            ),
    );
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = ElevatedButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Simple Alert"),
      content: Container(
        height: 400,
        width: 400,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: FutureBuilder<Album>(
          future: _futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(snapshot.data!.title),
                    TextField(
                      controller: textEditingController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Title',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _futureAlbum =
                              updateAlbum(textEditingController.text);
                        });
                      },
                      child: const Text('Update Data'),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
