import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticeo/mentoring/helper/color.dart';
import 'package:ticeo/mentoring/helper/constants.dart';
import 'package:ticeo/mentoring/model/mentor_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, this.model}) : super(key: key);
  final MentorModel? model;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isStarred = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _appBar(context),
                _cards(context),
                SizedBox(height: 20.h),
                _description(),
                SizedBox(height: 20.h),
                _achivment(),
                _button(),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar(context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Icon(Icons.arrow_back, size: 24.sp),
          ),
        ),
        Spacer(),
        IconButton(
          icon: Icon(
            _isStarred ? Icons.star : Icons.star_border,
            color: _isStarred ? Colors.blue : Colors.grey,
            size: 24.sp,
          ),
          onPressed: () {
            setState(() {
              _isStarred = !_isStarred;
            });
          },
        ),
      ],
    );
  }

  Widget _cards(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePage(model: widget.model)));
        },
        child: Row(
          children: <Widget>[
            Container(
              height: 85.h,
              width: 85.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                image: DecorationImage(
                  image: widget.model?.image != null
                      ? AssetImage(widget.model!.image)
                      : AssetImage("assets/images/deffault_profil.jpg"),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    blurRadius: 10.r,
                    color: Colors.grey.shade400,
                    offset: Offset(4.w, 4.h),
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                decoration: BoxDecoration(
                  border: Border.all(color: MColor.grey.withOpacity(.5)),
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.star_outline_rounded,
                            color: MColor.yellow, size: 15.sp),
                        SizedBox(height: 5.h),
                        Text("${widget.model?.ratings}/hr",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w300,
                              fontSize: 10.sp,
                            )),
                      ],
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text("Reviews",
                            style: GoogleFonts.inter(fontSize: 8.sp)),
                        SizedBox(height: 8.h),
                        Text("1500",
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w300,
                                fontSize: 10.sp,
                                color: Colors.black54)),
                      ],
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget _description() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.model?.name ?? "Nom non disponible",
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                        fontFamily: "Jersey"),
                  ),
                  Text(widget.model?.type ?? "Type non disponible",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w300,
                          fontSize: 10.sp,
                          color: Colors.black54)),
                ],
              ),
              Spacer(),
              Text("\Ar ${widget.model?.price ?? '00.0'}",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: Color.fromARGB(255, 17, 169, 224))),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            'A propos de ${widget.model?.name.split(" ")[0] ?? 'Mentor'}',
            style: TextStyle(
                fontSize: 25.sp,
                fontWeight: FontWeight.w500,
                height: 1.3,
                fontFamily: "Jersey"),
          ),
          SizedBox(height: 5.h),
          Text("${Constants.description.substring(0, 350)}",
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w300,
                  fontSize: 12.sp,
                  height: 1.4,
                  color: Colors.black54)),
        ]);
  }

  Widget _achivment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Accomplissements',
          style: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.w500,
              height: 1.3,
              fontFamily: "Jersey"),
        ),
        SizedBox(height: 16.h),
        _achivmentCard(),
        SizedBox(height: 16.h),
        _achivmentCard(),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _achivmentCard() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: MColor.grey.withOpacity(.1),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
            width: 40.w,
            alignment: Alignment.center,
            child: Icon(Icons.star_outline_rounded,
                color: MColor.yellow, size: 20.sp)),
        title: Text("Supported 100+ startups",
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w600, fontSize: 15.sp)),
        subtitle: Text(Constants.description.substring(0, 90),
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w400, fontSize: 12.sp)),
      ),
    );
  }

  Widget _button() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 30, 126, 205),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
      onPressed: () {},
      child: Container(
        height: 40.h,
        alignment: Alignment.center,
        child: Text(
          "Demander Mentoring",
          style: GoogleFonts.inter(
            color: const Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
