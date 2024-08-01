import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapp_group9/helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Group 9 Flutter News',
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        brightness: Brightness.dark,
      ),
      home: AuthService().handleAuthState(),
    );
  }
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // bool isSwitched = false;
  bool _loading = true;
  dynamic cName;
  dynamic country;
  dynamic category;
  dynamic findNews;

  List<Article> articles = [];

  @override
  void initState() {
    _loading = true;
    // TODO: implement initState
    super.initState();
    getNews();
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      FirebaseAuth.instance.currentUser!.displayName!,
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Logout'),
              onTap: () {
                AuthService().signOut();
                Navigator.pop(context);
              },
            ),
            // ListTile(
            //   title: Text('Bookmark',
            //       style: TextStyle(fontWeight: FontWeight.bold)),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => bookmarkPage(),
            //       ),
            //     );
            //   },
            // ),
            ListTile(
              title: Text('Science'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoriesPage(
                      newsCategory: 'science',
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Business'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoriesPage(
                              newsCategory: 'business',
                            )));
              },
            ),
            ListTile(
              title: Text('Technology'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoriesPage(
                              newsCategory: 'technology',
                            )));
              },
            ),
            ListTile(
              title: Text('Sports'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoriesPage(
                              newsCategory: 'sports',
                            )));
              },
            ),
            ListTile(
              title: Text('Health'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoriesPage(
                              newsCategory: 'health',
                            )));
              },
            ),
            ListTile(
              title: Text('General'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoriesPage(
                              newsCategory: 'general',
                            )));
              },
            ),
            ListTile(
              title: Text('Entertainment'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoriesPage(
                              newsCategory: 'entertainment',
                            )));
              },
            ),
          ],
        ),
        //   ],
        // ),
      ),
      appBar: AppBar(
        title: Row(
          children: const <Widget>[
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

          // ListTile(
          //   title: Text('Bookmark',
          //       style: TextStyle(fontWeight: FontWeight.bold)),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => bookmarkPage(),
          //       ),
          //     );
          //   },
          // ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => bookmarkPage(),
                ),
              );
            },
            icon: const Icon(Icons.bookmarks),
          ),
        ],
        elevation: 0.0,
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(Colors.blue),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                  itemCount: articles.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return NewsTile(
                      imageUrl: articles[index].urlToImage,
                      title: articles[index].title,
                      desc: articles[index].description,
                      content: articles[index].content,
                      posturl: articles[index].articleUrl,
                      author: articles[index].author,
                      url: articles[index].articleUrl,
                      description: articles[index].description,
                    );
                  }),
            ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // bool isSwitched = false;
  bool _loading = true;
  dynamic cName;
  dynamic country;
  dynamic category;
  dynamic findNews;

  List<Article> articles = [];

  @override
  void initState() {
    _loading = true;
    // TODO: implement initState
    super.initState();
    getNews();
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Please Login",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Login'),
              onTap: () {
                AuthService().signInWithGoogle();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Science'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoriesPage(
                      newsCategory: 'science',
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Business'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoriesPage(
                              newsCategory: 'business',
                            )));
              },
            ),
            ListTile(
              title: Text('Technology'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoriesPage(
                              newsCategory: 'technology',
                            )));
              },
            ),
            ListTile(
              title: Text('Sports'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoriesPage(
                              newsCategory: 'sports',
                            )));
              },
            ),
            ListTile(
              title: Text('Health'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoriesPage(
                              newsCategory: 'health',
                            )));
              },
            ),
            ListTile(
              title: Text('General'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoriesPage(
                              newsCategory: 'general',
                            )));
              },
            ),
            ListTile(
              title: Text('Entertainment'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoriesPage(
                              newsCategory: 'entertainment',
                            )));
              },
            ),
          ],
        ),
        //   ],
        // ),
      ),
      appBar: AppBar(
        title: Row(
          children: const <Widget>[
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
        elevation: 0.0,
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(Colors.blue),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                  itemCount: articles.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return NewsTile(
                      imageUrl: articles[index].urlToImage,
                      title: articles[index].title,
                      desc: articles[index].description,
                      content: articles[index].content,
                      posturl: articles[index].articleUrl,
                      author: articles[index].author,
                      url: articles[index].articleUrl,
                      description: articles[index].description,
                    );
                  }),
            ),
    );
  }
}
