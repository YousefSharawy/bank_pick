import 'package:bank_pick/core/models/user_model.dart';
import 'package:bank_pick/core/resources/assets_manager.dart';
import 'package:bank_pick/core/resources/color_manager.dart';
import 'package:bank_pick/core/resources/font_manager.dart';
import 'package:bank_pick/core/shared/custom_transaction_section.dart';
import 'package:bank_pick/core/widgets/card.dart';
import 'package:bank_pick/feature/home/view/CustomHomeIconButton.dart';
import 'package:bank_pick/feature/home/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeViewModel homeProvider;
  @override
  void initState() {
    super.initState();
    homeProvider = context.read<HomeViewModel>();
    Future.delayed(Duration.zero, () async {
      await homeProvider.getUsers();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    homeProvider = context.read<HomeViewModel>();

    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(AssetsManager.background),
        ),
      ),
      child: Scaffold(
        backgroundColor: ColorManager.transparent,
        body: Column(
          children: [
            SizedBox(height: 54),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  CircleAvatar(
                    foregroundImage: AssetImage(AssetsManager.avatar),
                    minRadius: 28,
                    backgroundColor: ColorManager.offWhite,
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome back,",
                        style: TextStyle(
                          fontSize: FontSizeManager.s12,
                          color: ColorManager.gray,
                        ),
                      ),
                      SizedBox(height: 8),

                      Text(
                        homeProvider.currUser?.name ?? "",
                        style: TextStyle(
                          fontSize: FontSizeManager.s18,

                          color: ColorManager.dark,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 115),
                  Container(
                    decoration: BoxDecoration(
                      color: ColorManager.offWhite,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.search_sharp, size: 30),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 31),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: CustomCard(),
            ),
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomHomeIconButton(cutsomIcon: Icons.arrow_upward_outlined,label: "Send",),
                CustomHomeIconButton(cutsomIcon: Icons.arrow_downward_outlined,label: "Recieve",),
                CustomHomeIconButton(customImage: Image.asset(AssetsManager.loanIcon),label:"Loan"),
                CustomHomeIconButton(customImage: Image.asset(AssetsManager.TopUpIcon),label:"TopUp"),
              ],
            ),
            SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Transactions",style: TextStyle(fontSize: FontSizeManager.s18,fontWeight: FontWeightManager.medium)),
                  TextButton(onPressed: (){}, child: Text("See All",style: TextStyle(color: ColorManager.navyBlue,))),
                ],
              ),
            ),
            SizedBox(height: 25),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomTransactionSection(label: "Apple Store" ,labelType: "Entertainment",price: "5,99",imagepath: AssetsManager.appleIcon ,),
                      CustomTransactionSection(label: "Spotify" ,labelType: "Music",price: "12,99",imagepath: AssetsManager.spotifyIcon ,),
                      CustomTransactionSection(label: "Money" ,labelType: "Transaction",price: "300",imagepath: AssetsManager.moneyTransferIcon ,),
                      CustomTransactionSection(label: "Grocery" ,labelType: "Shopping",price: "88",imagepath: AssetsManager.shopIcon ,),
                    ],
                  ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
