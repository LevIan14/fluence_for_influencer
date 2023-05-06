import 'package:fluence_for_influencer/category/repository/category_repository.dart';
import 'package:fluence_for_influencer/models/review.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/umkm/bloc/umkm_bloc.dart';
import 'package:fluence_for_influencer/umkm/repository/umkm_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

class InfluencerReview extends StatefulWidget {
  const InfluencerReview({super.key, required this.review});

  final Review review;

  @override
  State<InfluencerReview> createState() => _InfluencerReviewState();
}

class _InfluencerReviewState extends State<InfluencerReview> {
  late final UmkmBloc umkmBloc;
  final UmkmRepository umkmRepository = UmkmRepository();
  final CategoryRepository categoryRepository = CategoryRepository();

  @override
  void initState() {
    super.initState();
    umkmBloc = UmkmBloc(
        umkmRepository: umkmRepository, categoryRepository: categoryRepository);
    umkmBloc.add(GetUmkmDetail(widget.review.umkmId!));
  }

  @override
  Widget build(BuildContext context) {
    double margin = 10.0;
    // bloc listener umkm
    return BlocProvider(
      create: (context) => umkmBloc,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: Constants.defaultBorderRadiusButton,
            color: Colors.white,
          ),
          // width: maxWidth,
          padding: EdgeInsets.symmetric(
              vertical: margin * 2.5, horizontal: margin * 2.5),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<UmkmBloc, UmkmState>(
                builder: (context, state) {
                  if (state is UmkmLoaded) {
                    return Container(
                        margin: EdgeInsets.only(bottom: margin),
                        child: Text(state.umkm.fullname,
                            style: const TextStyle(
                                color: Constants.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 17.0)));
                  }
                  return Container();
                },
              ),
              buildStar(),
              Container(
                child: Text(widget.review.review ?? " ",
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        color: Constants.primaryColor, fontSize: 14.0)),
              )
            ],
          )),
    );
  }

  Widget buildStar() {
    double margin = 10.0;
    return Container(
        margin: EdgeInsets.only(bottom: margin),
        child: Row(
          children: [
            for (num i = 0; i < widget.review.rating; i++)
              const Padding(
                  padding: EdgeInsets.only(right: 2.0),
                  child: Icon(Ionicons.star, color: Colors.yellow)),
            for (num i = widget.review.rating; i < 5; i++)
              const Padding(
                  padding: EdgeInsets.only(right: 2.0),
                  child: Icon(Ionicons.star_outline, color: Colors.yellow)),
          ],
        ));
  }
}
