import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Functions {
  Future removeBookmark(String title) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;
    CollectionReference _collectionref =
        FirebaseFirestore.instance.collection("bookmarks");
    String id = "";

    await _collectionref
        .doc(currentUser!.email)
        .collection("news")
        .where("title", isEqualTo: title)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((DocumentSnapshot doc) {
        id = doc.id;
        print(doc.id);
      });
    }).catchError((error) => print("Failed to delete bookmark: $error"));

    return _collectionref
        .doc(currentUser.email)
        .collection("news")
        .doc(id)
        .delete()
        .then((value) => print("Bookmark Deleted"))
        .catchError((error) => print("Failed to delete bookmark: $error"));
  }

  Future removeAllBookmark() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;
    CollectionReference _collectionref = FirebaseFirestore.instance
        .collection("bookmarks")
        .doc(currentUser!.email)
        .collection("news");
    var snapshots = await _collectionref.get();

    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  Future<bool> checkIsBookmarked(String title) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;
    CollectionReference _collectionref =
        FirebaseFirestore.instance.collection("bookmarks");
    bool exists = false;

    try {
      await _collectionref
          .doc(currentUser!.email)
          .collection("news")
          .where("title", isEqualTo: title)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((DocumentSnapshot doc) {
          exists = doc.exists;

          print(doc.id);
          print(doc.exists);
        });
      }).catchError((error) => print("Failed to delete bookmark: $error"));
      print(exists);
      if (exists == false) {
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      print("e: $exists");
      return false;
    }
  }

  Future jsonnews(String title) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;
    CollectionReference _collectionref =
        FirebaseFirestore.instance.collection("bookmarks");
    String id = "";

    await _collectionref
        .doc(currentUser!.email)
        .collection("news")
        // .where("title", isEqualTo: title)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((DocumentSnapshot doc) {
        id = doc.id;
        print(doc.data());
      });
    }).catchError((error) => print("Failed to delete bookmark: $error"));
  }
}
