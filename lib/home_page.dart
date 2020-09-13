import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_chopper/single_post_page.dart';
import 'package:provider/provider.dart';
import 'data/post_api_service.dart';
//import 'single_post_page.dart';


class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog'),
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          print('response body');
          final response = await Provider.of<PostApiService>(context, listen: false)
              .postPost({'key': 'value', 'key1': 'value1'});
          //print the response
          if(response.isSuccessful) {
            print('response successful');
            print(response.body);
          }else {
            print('response is not successful');
          }

        },
      ),
    );
  }

  FutureBuilder<Response> _buildBody(BuildContext context) {
    return FutureBuilder<Response>(
      future: Provider.of<PostApiService>(context).getPosts(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done) {
          final List posts = jsonDecode(snapshot.data.bodyString);
          return _buildPosts(context, posts);
        }else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
  

  ListView _buildPosts(BuildContext context, List posts) {
    return ListView.builder(
      itemCount: posts.length,
      padding: EdgeInsets.all(16),
      itemBuilder: (context, index){
        return Card(
          elevation: 4,
          child: ListTile(
            title: Text(
              posts[index]['title'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(posts[index]['body']),
            onTap: () => _navigateToPost(context, posts[index]['id']),
          ),
        );
      },
    );
  }

  void _navigateToPost(BuildContext context, int id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => new SinglePostPage(postId: id),
      ),
    );
  }
  
  

}











