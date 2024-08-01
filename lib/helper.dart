import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp_group9/apiKey.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:social_share/social_share.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:newsapp_group9/bookmarks.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Functions func = Functions();

class NewsTile extends StatelessWidget {
  final String imageUrl,
      title,
      desc,
      content,
      posturl,
      author,
      url,
      description;

  NewsTile(
      {required this.imageUrl,
      required this.desc,
      required this.title,
      required this.content,
      required this.posturl,
      required this.author,
      required this.url,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArticlePage(
                      title: title,
                      author: author,
                      url: url,
                      description: description,
                      imageUrl: imageUrl,
                    )));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 6,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(children: [
          SizedBox(
            height: 4,
          ),
          ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                height: 220,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              )),
          Container(
            padding: EdgeInsets.all(6.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Text(
              "Author: $author",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            title,
            maxLines: 2,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ]),
      ),
    );
  }
}

class ArticlePage extends StatefulWidget {
  final String title, imageUrl, author, description, url;

  ArticlePage(
      {required this.title,
      required this.imageUrl,
      required this.author,
      required this.url,
      required this.description});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  // FirebaseAuth auth = FirebaseAuth.instance;
  bool exists = false;

  // exists = func.checknews(title);
  Future addBookmark() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;
    CollectionReference _collectionref =
        FirebaseFirestore.instance.collection("bookmarks");
    return _collectionref
        .doc(currentUser!.email)
        .collection("news")
        .doc()
        .set({
          "title": widget.title,
          "author": widget.author,
          "url": widget.url,
          "description": widget.description,
          "imageUrl": widget.imageUrl,
        })
        .then((value) => print("Bookmark Added"))
        .catchError((error) => print("Failed to add bookmark: $error"));
  }

  @override
  void initState() {
    super.initState();

    func.checkIsBookmarked(widget.title).then((value) {
      print(value);

      setState(() {
        exists = value;
      });
    });
    //Use  func.checkIsBookmarked to check weather the news is bookmarked or not if yes then set bookmarked to true

    // exists = func.checknews(widget.title);
  }

  test() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          // if (FirebaseAuth.instance.currentUser != null)
          //   if (func.checknews(title) == true)
          //     IconButton(
          //       icon: Icon(Icons.bookmark),
          //       onPressed: () {
          //         func.removeBookmark(title);
          //       },
          //     )
          //   else
          //     IconButton(
          //       icon: Icon(Icons.bookmark_border),
          //       onPressed: () {
          //         addBookmark();
          //         // removeBookmark(title);
          //       },
          //     ),
          // IconButton(
          //   icon: Icon(Icons.bookmark),
          //   onPressed: () {
          //     func.checknews(title);
          //   },
          // ),
          IconButton(
            onPressed: () async {
              await SocialShare.shareOptions(widget.url);
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200.0,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.imageUrl), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              padding: EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(
                "Author: ${widget.author}",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              widget.description,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(
              height: 150.0,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                child: Text("Learn More"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewsPage(
                                url: widget.url,
                              )));
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: exists
          ? FloatingActionButton(
              child: const Icon(Icons.bookmark_add),
              onPressed: () {
                addBookmark();
                Navigator.pop(context);
              },
            )
          : FloatingActionButton(
              child: Icon(Icons.bookmark_remove),
              onPressed: () {
                func.removeBookmark(widget.title);
                Navigator.pop(context);
              },
            ),

      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.bookmark_add),
      //   onPressed: () {
      //     // if (func.checknews(title) == false) {
      //     addBookmark();
      //     // }
      //     // addBookmark();
      //   },
      // ),
    );
  }
}

class NewsPage extends StatefulWidget {
  final String url;
  NewsPage({required this.url});

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Group 9",
              style:
                  TextStyle(color: Colors.yellow, fontWeight: FontWeight.w600),
            ),
            Text(
              " Flutter News",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            )
            // Text(widget.url),
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await SocialShare.shareOptions(widget.url);
            },
            icon: const Icon(Icons.share),
          ),
        ],
        elevation: 0.0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: WebView(
          initialUrl: widget.url,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}

class CategoriesPage extends StatefulWidget {
  final String newsCategory;

  CategoriesPage({required this.newsCategory});

  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoriesPage> {
  var newslist;
  bool _loading = true;

  @override
  void initState() {
    _loading = true;
    getNews();
  }

  getNews() async {
    NewsForCategorie news = NewsForCategorie();
    await news.getNewsForCategory(widget.newsCategory);
    newslist = news.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Group 9",
              style:
                  TextStyle(color: Colors.yellow, fontWeight: FontWeight.w600),
            ),
            Text(
              " Flutter News",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            )
          ],
        ),
        actions: <Widget>[
          Opacity(
            opacity: 0,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.share,
                )),
          )
        ],
        elevation: 0.0,
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                child: Container(
                  margin: EdgeInsets.only(top: 16),
                  child: ListView.builder(
                      itemCount: newslist.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return NewsTile(
                          imageUrl: newslist[index].urlToImage,
                          title: newslist[index].title,
                          desc: newslist[index].description,
                          content: newslist[index].content,
                          posturl: newslist[index].articleUrl,
                          author: newslist[index].author,
                          url: newslist[index].articleUrl,
                          description: newslist[index].description,
                        );
                      }),
                ),
              ),
            ),
    );
  }
}

class News {
  List<Article> news = [];
  Future<void> getNews() async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey";
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);
    if (jsonData['status'] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null &&
            element['description'] != null &&
            element['author'] != null &&
            element['content'] != null) {
          Article article = Article(
            title: element['title'],
            author: element['author'],
            description: element['description'],
            urlToImage: element['urlToImage'],
            publshedAt: DateTime.parse(element['publishedAt']),
            content: element["content"],
            articleUrl: element["url"],
          );
          news.add(article);
        }
      });
    }
  }
}

class NewsForCategorie {
  List<Article> news = [];
  Future<void> getNewsForCategory(String category) async {
    String url =
        "http://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=${apiKey}";

    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null &&
            element['description'] != null &&
            element['author'] != null &&
            element['content'] != null) {
          Article article = Article(
            title: element['title'],
            author: element['author'],
            description: element['description'],
            urlToImage: element['urlToImage'],
            publshedAt: DateTime.parse(element['publishedAt']),
            content: element["content"],
            articleUrl: element["url"],
          );
          news.add(article);
        }
      });
    }
  }
}

class Article {
  String title;
  String author;
  String description;
  String urlToImage;
  DateTime publshedAt;
  String content;
  String articleUrl;

  Article(
      {required this.title,
      required this.description,
      required this.author,
      required this.content,
      required this.publshedAt,
      required this.urlToImage,
      required this.articleUrl});
}

class DropDownList extends StatelessWidget {
  const DropDownList({super.key, required this.name, required this.call});
  final String name;
  final Function call;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ListTile(title: Text(name)),
      onTap: () => call(),
    );
  }
}

class AuthService {
  handleAuthState() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return HomePage(); //successful login
        } else {
          //return Center(child: Text('Something went wrong'));
          return const LoginPage(); //unsuccessful login
        }
      },
    );
  }

  signInWithGoogle() async {
    //Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn(); //google sign in

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication; //google authentication

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    //Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  //sign out
  signOut() async {
    await GoogleSignIn().disconnect();

    FirebaseAuth.instance.signOut();
  }
}

class bookmarkPage extends StatefulWidget {
  @override
  _bookmarkPageState createState() => _bookmarkPageState();
}

class _bookmarkPageState extends State<bookmarkPage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Bookmarks'),
          elevation: 0.0,
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("bookmarks")
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection("news")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    // leading: Icon(Icons.person),
                    onTap: () {
                      // AuthService().signOut();
                      // Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewsPage(
                                    url: snapshot.data!.docs[index].get('url'),
                                  )));
                    },
                    title: Text(
                      "-> " + snapshot.data!.docs[index].get('title'),
                      maxLines: 2,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              );
            }
            if (snapshot.hasError) {
              return const Text('Error');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.delete),
          onPressed: () {
            func.removeAllBookmark();
          },
        ),
      );
}
