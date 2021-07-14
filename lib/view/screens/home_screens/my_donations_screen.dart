import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rofqaa_elganna/cubits/my_donations_cubit/my_donations_cubit.dart';
import 'package:rofqaa_elganna/view/widgets/app_widgets/donation_item.dart';

class MyDonationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var myDonation = MyDonationsCubit.get(context);
    myDonation.getMyDonations();
    return BlocConsumer<MyDonationsCubit, MyDonationsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is MyDonationsLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MyDonationsSucceeded) {
          return RefreshIndicator(
            onRefresh: () async => myDonation.getMyDonations(),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return DonationItem(donationModel: myDonation.myDonationList[index]);
              },
              itemCount: myDonation.myDonationList.length,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
