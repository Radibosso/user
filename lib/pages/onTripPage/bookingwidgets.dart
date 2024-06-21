import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_user/functions/functions.dart';
import 'package:flutter_user/pages/onTripPage/booking_confirmation.dart';
import 'package:flutter_user/pages/onTripPage/map_page.dart';
import 'package:flutter_user/styles/styles.dart';
import 'package:flutter_user/translations/translation.dart';
import 'package:flutter_user/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class ApplyCouponsContainer extends StatefulWidget {
  final dynamic type;
  const ApplyCouponsContainer({super.key, this.type});

  @override
  State<ApplyCouponsContainer> createState() => _ApplyCouponsContainerState();
}

class _ApplyCouponsContainerState extends State<ApplyCouponsContainer> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Container(
      padding: MediaQuery.of(context).viewInsets,
      decoration: BoxDecoration(
          color: page,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(media.width * 0.05),
              topRight: Radius.circular(media.width * 0.05))),
      // padding:
      //     EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
      child: Container(
        padding: EdgeInsets.all(media.width * 0.05),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyText(
                textAlign: TextAlign.center,
                text: (languages[choosenLanguage]['text_apply'] +
                    ' ' +
                    languages[choosenLanguage]['text_coupons']),
                size: media.width * sixteen,
                fontweight: FontWeight.w600,
                color: textColor,
              ),
            ),
            SizedBox(
              height: media.width * 0.06,
            ),
            Container(
              width: media.width * 0.8,
              height: media.width * 0.12,
              padding: EdgeInsets.all(media.width * 0.01),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  border: Border.all(color: textColor.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(media.width * 0.02)),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: promoKey,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: languages[choosenLanguage]['text_enterpromo'],
                        hintStyle: GoogleFonts.notoSans(
                            color: hintColor, fontSize: media.width * fourteen),
                      ),
                      style: GoogleFonts.notoSans(color: textColor),
                      onChanged: (val) {
                        setState(() {
                          promoCode = val;
                          couponerror = false;
                        });
                      },
                    ),
                  ),
                  (promoStatus == 1)
                      ? MyText(
                          text: languages[choosenLanguage]
                              ['text_promoaccepted'],
                          size: media.width * twelve,
                          color: online,
                        )
                      : Container(),
                ],
              ),
            ),
            SizedBox(
              height: media.width * 0.04,
            ),
            SizedBox(
              // width: media.width * 0.8,
              // height: media.width * 0.1,
              child: Button(
                text: (promoStatus == 1)
                    ? languages[choosenLanguage]['text_remove']
                    : languages[choosenLanguage]['text_apply'],
                fontweight: FontWeight.w500,
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    isLoading = true;
                  });

                  // promoStatus = null;)
                  if (promoStatus != 1 && promoCode != '') {
                    setState(() {
                      promoStatus = null;
                    });
                    if (widget.type != 1 && promoCode != '') {
                      await etaRequestWithPromo();
                    } else if (widget.type == 1 && promoCode != '') {
                      await rentalRequestWithPromo();
                    }
                  } else {
                    if (promoKey.text != '') {
                      if (promoStatus != 2) {
                        if (widget.type != 1) {
                          await etaRequest();
                        } else if (widget.type == 1) {
                          await rentalEta();
                        }
                        promoKey.text = '';
                        promoCode = '';
                      }
                      if (promoStatus == 1) {
                        // promoKey.text = '';
                        promoStatus = null;
                        // if (widget.type != 1) {
                        //   await etaRequest();
                        // } else if (widget.type == 1) {
                        //   await rentalEta();
                        // }
                      }
                    }
                  }
                  setState(() {
                    isLoading = false;
                  });
                },
                color: (promoKey.text == '')
                    ? Colors.grey
                    : (isDarkTheme)
                        ? Colors.white
                        : Colors.black,
                textcolor: (!isDarkTheme) ? Colors.white : Colors.black,
                borderRadius: 12.0,
              ),
            ),
            if (promoStatus != null && promoStatus == 2 && couponerror == true)
              Container(
                width: media.width * 0.9,
                padding: EdgeInsets.only(top: media.width * 0.025),
                child: MyText(
                  text: languages[choosenLanguage]['text_promorejected'],
                  size: media.width * twelve,
                  color: Colors.red,
                ),
              ),
            (choosenVehicle != null)
                ? SizedBox(
                    height: media.width * 0.025,
                  )
                : Container(),
            SizedBox(
              height: media.width * 0.04,
            ),
            InkWell(
                onTap: () {
                  if (widget.type == 1
                      ? (rentalOption[choosenVehicle]['has_discount'] == true)
                      : etaDetails[choosenVehicle]['has_discount'] == true) {
                    setState(() {
                      promoStatus = 1;
                      addCoupon = false;
                      // promoKey.clear();
                    });
                  } else {
                    setState(() {
                      promoStatus = null;
                      addCoupon = false;
                      promoKey.clear();
                    });
                  }
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  // width: media.width * 0.8,
                  child: MyText(
                    text: languages[choosenLanguage]['text_cancel'],
                    size: media.width * sixteen,
                    color: verifyDeclined,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

int choosenInPopUp = 0;

class ChoosePaymentMethodContainer extends StatefulWidget {
  final dynamic type;
  final dynamic onTap;
  const ChoosePaymentMethodContainer(
      {super.key, this.type, required this.onTap});

  @override
  State<ChoosePaymentMethodContainer> createState() =>
      _ChoosePaymentMethodContainerState();
}

class _ChoosePaymentMethodContainerState
    extends State<ChoosePaymentMethodContainer> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Container(
      height: media.width * 0.7,
      width: media.width * 1,
      padding: EdgeInsets.all(media.width * 0.05),
      decoration: BoxDecoration(
          color: page,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(media.width * 0.05),
              topRight: Radius.circular(media.width * 0.05))),
      child: Column(
        children: [
          MyText(
            text: languages[choosenLanguage]['text_choose_payment'],
            size: media.width * sixteen,
            fontweight: FontWeight.bold,
          ),
          SizedBox(
            height: media.width * 0.03,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: (choosenVehicle != null && widget.type != 1)
                  ? Column(
                      children: etaDetails[choosenVehicle]['payment_type']
                          .toString()
                          .split(',')
                          .toList()
                          .asMap()
                          .map((i, value) {
                            return MapEntry(
                                i,
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      choosenInPopUp = i;
                                    });
                                  },
                                  child: SizedBox(
                                    height: media.width * 0.106,
                                    width: media.width * 0.9,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: (etaDetails[choosenVehicle]
                                                          ['payment_type']
                                                      .toString()
                                                      .split(',')
                                                      .toList()[i] ==
                                                  'cash')
                                              ? Image.asset(
                                                  'assets/images/cash.png',
                                                  width: media.width * 0.05,
                                                  height: media.width * 0.05,
                                                  fit: BoxFit.contain,
                                                )
                                              : (etaDetails[choosenVehicle]
                                                              ['payment_type']
                                                          .toString()
                                                          .split(',')
                                                          .toList()[i] ==
                                                      'wallet')
                                                  ? Image.asset(
                                                      'assets/images/wallet.png',
                                                      width: media.width * 0.1,
                                                      height: media.width * 0.1,
                                                      fit: BoxFit.contain,
                                                    )
                                                  : (etaDetails[choosenVehicle][
                                                                  'payment_type']
                                                              .toString()
                                                              .split(',')
                                                              .toList()[i] ==
                                                          'card')
                                                      ? Image.asset(
                                                          'assets/images/card.png',
                                                          width:
                                                              media.width * 0.1,
                                                          height:
                                                              media.width * 0.1,
                                                          fit: BoxFit.contain,
                                                        )
                                                      : (etaDetails[choosenVehicle]
                                                                      [
                                                                      'payment_type']
                                                                  .toString()
                                                                  .split(',')
                                                                  .toList()[i] ==
                                                              'upi')
                                                          ? Image.asset(
                                                              'assets/images/upi.png',
                                                              width:
                                                                  media.width *
                                                                      0.1,
                                                              height:
                                                                  media.width *
                                                                      0.1,
                                                              fit: BoxFit
                                                                  .contain,
                                                            )
                                                          : Container(),
                                        ),
                                        SizedBox(
                                          width: media.width * 0.02,
                                        ),
                                        Expanded(
                                          flex: 6,
                                          child: MyText(
                                            text: etaDetails[choosenVehicle]
                                                    ['payment_type']
                                                .toString()
                                                .split(',')
                                                .toList()[i],
                                            size: media.width * fourteen,
                                            color: (choosenInPopUp == i)
                                                ? const Color(0xffFF0000)
                                                : (isDarkTheme == true)
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                        ),
                                        Expanded(
                                            child: Container(
                                          height: media.width * 0.05,
                                          width: media.width * 0.05,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(),
                                              shape: BoxShape.circle),
                                          child: Container(
                                            height: media.width * 0.03,
                                            width: media.width * 0.03,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: (choosenInPopUp == i)
                                                    ? const Color(0xffFF0000)
                                                    : page),
                                          ),
                                        ))
                                      ],
                                    ),
                                  ),
                                ));
                          })
                          .values
                          .toList(),
                    )
                  : Column(
                      children: rentalOption[choosenVehicle]['payment_type']
                          .toString()
                          .split(',')
                          .toList()
                          .asMap()
                          .map((i, value) {
                            return MapEntry(
                                i,
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      choosenInPopUp = i;
                                    });
                                  },
                                  child: SizedBox(
                                    height: media.width * 0.106,
                                    width: media.width * 0.9,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: (rentalOption[choosenVehicle]
                                                          ['payment_type']
                                                      .toString()
                                                      .split(',')
                                                      .toList()[i] ==
                                                  'cash')
                                              ? Image.asset(
                                                  'assets/images/cash.png',
                                                  width: media.width * 0.05,
                                                  height: media.width * 0.05,
                                                  fit: BoxFit.contain,
                                                )
                                              : (rentalOption[choosenVehicle]
                                                              ['payment_type']
                                                          .toString()
                                                          .split(',')
                                                          .toList()[i] ==
                                                      'wallet')
                                                  ? Image.asset(
                                                      'assets/images/wallet.png',
                                                      width: media.width * 0.1,
                                                      height: media.width * 0.1,
                                                      fit: BoxFit.contain,
                                                    )
                                                  : (rentalOption[choosenVehicle]
                                                                  [
                                                                  'payment_type']
                                                              .toString()
                                                              .split(',')
                                                              .toList()[i] ==
                                                          'card')
                                                      ? Image.asset(
                                                          'assets/images/card.png',
                                                          width:
                                                              media.width * 0.1,
                                                          height:
                                                              media.width * 0.1,
                                                          fit: BoxFit.contain,
                                                        )
                                                      : (rentalOption[choosenVehicle]
                                                                      [
                                                                      'payment_type']
                                                                  .toString()
                                                                  .split(',')
                                                                  .toList()[i] ==
                                                              'upi')
                                                          ? Image.asset(
                                                              'assets/images/upi.png',
                                                              width:
                                                                  media.width *
                                                                      0.1,
                                                              height:
                                                                  media.width *
                                                                      0.1,
                                                              fit: BoxFit
                                                                  .contain,
                                                            )
                                                          : Container(),
                                        ),
                                        SizedBox(
                                          width: media.width * 0.02,
                                        ),
                                        Expanded(
                                          flex: 6,
                                          child: MyText(
                                            text: rentalOption[choosenVehicle]
                                                    ['payment_type']
                                                .toString()
                                                .split(',')
                                                .toList()[i],
                                            size: media.width * fourteen,
                                            color: (choosenInPopUp == i)
                                                ? const Color(0xffFF0000)
                                                : (isDarkTheme == true)
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                        ),
                                        Expanded(
                                            child: Container(
                                          height: media.width * 0.05,
                                          width: media.width * 0.05,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(),
                                              shape: BoxShape.circle),
                                          child: Container(
                                            height: media.width * 0.03,
                                            width: media.width * 0.03,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: (choosenInPopUp == i)
                                                    ? const Color(0xffFF0000)
                                                    : page),
                                          ),
                                        ))
                                      ],
                                    ),
                                  ),
                                ));
                          })
                          .values
                          .toList(),
                    ),
            ),
          ),
          Button(
              onTap: widget.onTap,
              text: languages[choosenLanguage]['text_confirm'])
        ],
      ),
    );
  }
}

bool confirmRideLater = false;
bool rideLaterSuccess = false;

class RideLaterBottomSheet extends StatefulWidget {
  final dynamic type;
  const RideLaterBottomSheet({super.key, this.type});

  @override
  State<RideLaterBottomSheet> createState() => _RideLaterBottomSheetState();
}

class _RideLaterBottomSheetState extends State<RideLaterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Container(
      height: media.width * 1,
      width: media.width * 1,
      padding: EdgeInsets.all(media.width * 0.03),
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
          color: page,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(media.width * 0.05),
              topRight: Radius.circular(media.width * 0.05))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              MyText(
                text: languages[choosenLanguage]['text_choose_date'],
                size: media.width * eighteen,
                fontweight: FontWeight.w600,
              ),
              (confirmRideLater)
                  ? Row(
                      children: [
                        InkWell(
                          onTap: () {
                            confirmRideLater = false;
                            choosenDateTime = null;
                            Navigator.pop(context);
                            valueNotifierBook.incrementNotifier();
                          },
                          child: MyText(
                            text: 'Reset To Now',
                            size: media.width * fourteen,
                            color: Colors.blue,
                          ),
                        )
                      ],
                    )
                  : Container(),
              Container(
                height: media.width * 0.5,
                width: media.width * 0.9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12), color: topBar),
                child: CupertinoDatePicker(
                    minimumDate: DateTime.now().add(Duration(
                        minutes: int.parse(userDetails[
                            'user_can_make_a_ride_after_x_miniutes']))),
                    initialDateTime: DateTime.now().add(Duration(
                        minutes: int.parse(userDetails[
                            'user_can_make_a_ride_after_x_miniutes']))),
                    maximumDate: DateTime.now().add(const Duration(days: 4)),
                    onDateTimeChanged: (val) {
                      // setState(() {
                      choosenDateTime = val;
                      // });
                    }),
              ),
            ],
          ),
          Container(
              padding: EdgeInsets.all(media.width * 0.05),
              child: Button(
                  onTap: () async {
                    // setState(() {
                    confirmRideLater = true;
                    // });
                    Navigator.pop(context);
                    valueNotifierBook.incrementNotifier();
                  },
                  text: languages[choosenLanguage]['text_confirm'])),
          if (!confirmRideLater && !rideLaterSuccess)
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: SizedBox(
                height: media.width * 0.06,
                width: media.width * 0.9,
                child: MyText(
                  textAlign: TextAlign.center,
                  text: languages[choosenLanguage]['text_cancel'],
                  size: media.width * fourteen,
                  color: verifyDeclined,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class SuccessPopUp extends StatefulWidget {
  const SuccessPopUp({super.key});

  @override
  State<SuccessPopUp> createState() => _SuccessPopUpState();
}

class _SuccessPopUpState extends State<SuccessPopUp> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Container(
        height: media.width * 0.4,
        width: media.width * 1,
        padding: EdgeInsets.all(media.width * 0.05),
        decoration: BoxDecoration(
            color: page,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(media.width * 0.05),
                topRight: Radius.circular(media.width * 0.05))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
                text: languages[choosenLanguage]['text_rideLaterSuccess'],
                size: media.width * sixteen),
            Button(
                onTap: () {
                  addressList.clear();
                  confirmRideLater = false;
                  ismulitipleride = false;
                  etaDetails.clear();
                  userRequestData.clear();

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Maps()),
                      (route) => false);
                },
                text: languages[choosenLanguage]['text_confirm'])
          ],
        ));
  }
}
