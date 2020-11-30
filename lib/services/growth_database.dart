import 'package:cloud_firestore/cloud_firestore.dart';

class GrowthDatabaseService {
  final String uid;
  GrowthDatabaseService({this.uid});

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference internshipCollection =
      FirebaseFirestore.instance.collection('Internships');
  final CollectionReference quickfixCollection =
      FirebaseFirestore.instance.collection('QuickFixes');
  final CollectionReference projectCollection =
      FirebaseFirestore.instance.collection('Projects');

  Future addResumeDetails(Map i) async {
    print(uid);
    print(i);
    DocumentReference documentReference =
        usersCollection.doc(uid).collection('Resume').doc(uid);
    await documentReference.set(i);
  }

  Future<void> createResume() async {}
  Future<bool> checkIfUserCreatedResume() async {
    QuerySnapshot snapshot =
        await usersCollection.doc(uid).collection('Resume').get();
    if (snapshot.docs.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<QuerySnapshot> getInternships() {
    return internshipCollection
        .orderBy('timeOfCreation', descending: true)
        .get();
  }

  Future sendResumeDetailsToRecruiterForinternship(
      Map i, String internshipId) async {
    await internshipCollection
        .doc(internshipId)
        .collection('Applicants')
        .doc(uid)
        .set(i);
    await internshipCollection
        .doc(internshipId)
        .collection('Applicants')
        .doc(uid)
        .update({'sentOn': Timestamp.now(), 'isSelected': false});
  }

  Future sendResumeDetailsToRecruiterForQuickFix(
      Map i, String quickfixId) async {
    await quickfixCollection
        .doc(quickfixId)
        .collection('Applicants')
        .doc(uid)
        .set(i);
    await quickfixCollection
        .doc(quickfixId)
        .collection('Applicants')
        .doc(uid)
        .update({'sentOn': Timestamp.now(), 'isSelected': false});
  }

  Future sendResumeDetailsToRecruiterForProject(Map i, String projectId) async {
    await projectCollection
        .doc(projectId)
        .collection('Applicants')
        .doc(uid)
        .set(i);
    await projectCollection
        .doc(projectId)
        .collection('Applicants')
        .doc(uid)
        .update({'sentOn': Timestamp.now(), 'isSelected': false});
  }

  Future<bool> checkIfUserAppliedforThisInternship(String internshipId) async {
    bool exists = false;
    try {
      await internshipCollection
          .doc(internshipId)
          .collection('Applicants')
          .doc(uid)
          .get()
          .then((doc) {
        doc.exists ? exists = true : exists = false;
      });
      return exists;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> checkIfUserAppliedforThisQuickFix(String quickfixId) async {
    bool exists = false;
    try {
      await quickfixCollection
          .doc(quickfixId)
          .collection('Applicants')
          .doc(uid)
          .get()
          .then((doc) {
        doc.exists ? exists = true : exists = false;
      });
      return exists;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> checkIfUserAppliedforThisProject(String projectId) async {
    bool exists = false;
    try {
      await projectCollection
          .doc(projectId)
          .collection('Applicants')
          .doc(uid)
          .get()
          .then((doc) {
        doc.exists ? exists = true : exists = false;
      });
      return exists;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<QuerySnapshot> getQuickFixes() {
    return quickfixCollection.orderBy('timeOfCreation', descending: true).get();
  }

  Future<QuerySnapshot> getProjects() {
    return projectCollection.orderBy('timeOfCreation', descending: true).get();
  }
}
