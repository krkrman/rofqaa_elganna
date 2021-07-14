import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:rofqaa_elganna/helper/constants.dart';
import 'package:rofqaa_elganna/helper/utility.dart';
import 'package:rofqaa_elganna/models/user_model.dart';

part 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  PhoneAuthCubit() : super(PhoneAuthInitial());
  FirebaseAuth auth = FirebaseAuth.instance;

  static PhoneAuthCubit get(context) => BlocProvider.of(context);

  void firebasePhoneAuth(UserModel userModel) async {
    emit(PhoneAuthLoading());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: userModel.phone!,
      verificationCompleted: (PhoneAuthCredential credential) async {
        /*await auth.signInWithCredential(credential);
        Utility.box.put(Constants.USER, userModel.toMap());
        emit(PhoneAuthVerificationCompleted());*/
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          emit(PhoneAuthInvalidPhoneNumber());
          print('The provided phone number is not valid.');
        } else {
          emit(PhoneAuthVerificationFailed(error: e.message));
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        emit(PhoneAuthCodeSent(verificationId: verificationId));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        emit(PhoneAuthCodeAutoRetrievalTimeout());
      },
    );
  }

  void signInWithPhoneCredential(
      String verificationCode, String pinCode, UserModel userModel) async {
    try {
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: verificationCode, smsCode: pinCode))
          .then((value) async {
        if (value.user != null) {
          Utility.box.put(Constants.USER, userModel.toMap());
          emit(PhoneAuthVerificationCompleted());
        }
      });
    } catch (e) {
      emit(PhoneAuthVerificationFailed(error: e.toString()));
    }
  }

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection(Constants.USERs_COLLECTION);

  void createUser(UserModel userModel) {
    usersCollection
        .doc(userModel.phone)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (!documentSnapshot.exists) {
        usersCollection
            .doc(userModel.phone)
            .set(userModel.toMap())
            .then((value) => emit(PhoneAuthEmailCreatedSuccessfully()))
            .catchError(
                (error) => emit(PhoneAuthVerificationFailed(error: error)));
      } else {
        emit(PhoneAuthEmailCreatedSuccessfully());
      }
    });
  }
}
