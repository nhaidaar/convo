import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/src/features/call/domain/models/call_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CallService {
  final _firestore = FirebaseFirestore.instance;
  final _user = FirebaseAuth.instance.currentUser;

  Future<void> postCallData(CallModel callModel) async {
    try {
      await _firestore.collection('calls').doc(callModel.callId).set(callModel.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> callAccepted(String callId) async {
    await _firestore.collection('calls').doc(callId).update({
      'isAccepted': true,
    });
  }

  Future<void> callDeclined(String callId) async {
    await _firestore.collection('calls').doc(callId).update({
      'isDeclined': true,
    });
  }

  Stream<List<CallModel>> streamCallList() {
    return FirebaseFirestore.instance
        .collection('calls')
        .where('participant', arrayContains: _user!.uid)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) => CallModel.fromMap(doc.data())).toList();
    });
  }
}
