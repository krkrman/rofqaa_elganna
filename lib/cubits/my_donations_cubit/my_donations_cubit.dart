import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:rofqaa_elganna/helper/constants.dart';
import 'package:rofqaa_elganna/helper/utility.dart';
import 'package:rofqaa_elganna/models/donation_model.dart';
import 'package:rofqaa_elganna/models/user_model.dart';

part 'my_donations_state.dart';

class MyDonationsCubit extends Cubit<MyDonationsState> {
  MyDonationsCubit() : super(MyDonationsInitial());

  static MyDonationsCubit get(context) => BlocProvider.of(context);
  List<DonationModel> myDonationList = [];
  CollectionReference donationsCollection =
      FirebaseFirestore.instance.collection(Constants.DONATION_COLLECTION);

  void getMyDonations() {
    emit(MyDonationsLoading());
    myDonationList = [];
    UserModel userModel = UserModel.fromMap(
        Map<String, dynamic>.from(Utility.box.get(Constants.USER)));
    donationsCollection
        .doc(userModel.phone)
        .collection('MyDonations')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        DonationModel donationModel =
            DonationModel.fromMap(doc.data() as Map<String, dynamic>);
        myDonationList.add(donationModel);
      });
      emit(MyDonationsSucceeded());
    }).catchError((error) {
      print(error.toString());
      emit(MyDonationsFailed());
    });
  }
}
