import 'package:fluence_for_influencer/category/repository/category_repository.dart';
import 'package:fluence_for_influencer/influencer/bloc/influencer_bloc.dart';
import 'package:fluence_for_influencer/influencer/repository/influencer_repository.dart';
import 'package:fluence_for_influencer/main/main_page.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/transaction/bloc/transaction_bloc.dart';
import 'package:fluence_for_influencer/transaction/repository/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewPage extends StatefulWidget {
  final String influencerId;
  final String transactionId;
  final String reviewId;
  const ReviewPage(
      {Key? key,
      required this.influencerId,
      required this.transactionId,
      this.reviewId = ""})
      : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late final TransactionBloc transactionBloc;
  final TransactionRepository transactionRepository = TransactionRepository();

  late final InfluencerBloc influencerBloc;
  final InfluencerRepository influencerRepository = InfluencerRepository();

  final CategoryRepository categoryRepository = CategoryRepository();

  final TextEditingController _reviewController = TextEditingController();
  double finalRating = 0.0;

  dynamic finalReview;

  @override
  void initState() {
    super.initState();
    transactionBloc =
        TransactionBloc(transactionRepository: transactionRepository);
    influencerBloc = InfluencerBloc(
        influencerRepository: influencerRepository,
        categoryRepository: categoryRepository);

    if (widget.reviewId.isEmpty) {
      transactionBloc.add(GetTransactionDetail(widget.transactionId));
    } else {
      influencerBloc.add(GetInfluencerReviewOnCurrentTransaction(
          widget.influencerId, widget.reviewId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => transactionBloc),
          BlocProvider(create: (context) => influencerBloc),
        ],
        child: Scaffold(
          appBar: AppBar(title: const Text("Review")),
          body: MultiBlocListener(
            listeners: [
              BlocListener<TransactionBloc, TransactionState>(
                listener: (context, state) {
                  if (state is TransactionProcessSuccess) {
                    navigateAsFirstScreen(context, const MainPage(index: 0));
                  }
                },
              ),
              BlocListener<InfluencerBloc, InfluencerState>(
                listener: (context, state) {
                  if (state is GetInfluencerReviewOnCurrentTransactionSuccess) {
                    finalReview = state.review;
                    transactionBloc
                        .add(GetTransactionDetail(widget.transactionId));
                  }
                },
              )
            ],
            child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is TransactionLoaded) {
                  _reviewController.text =
                      widget.reviewId.isNotEmpty ? finalReview['review'] : "";
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Rating"),
                        const SizedBox(height: 8),
                        widget.reviewId.isNotEmpty
                            ? RatingBarIndicator(
                                rating: finalReview['rating'],
                                itemBuilder: (context, index) =>
                                    const Icon(Icons.star, color: Colors.red),
                              )
                            : RatingBar(
                                initialRating: 0,
                                minRating: 0,
                                maxRating: 5,
                                allowHalfRating: true,
                                itemSize: 30.0,
                                ratingWidget: RatingWidget(
                                  full: const Icon(Icons.star,
                                      color: Constants.primaryColor),
                                  half: const Icon(Icons.star_half,
                                      color: Constants.primaryColor),
                                  empty: const Icon(Icons.star_border,
                                      color: Constants.primaryColor),
                                ),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    finalRating = rating;
                                  });
                                },
                              ),
                        const SizedBox(height: 16),
                        const Text("Review"),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _reviewController,
                          maxLines: null,
                        )
                      ],
                    ),
                  );
                }
                if (state is ReviewedTransactionLoaded) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Rating"),
                        const SizedBox(height: 8),
                        RatingBar(
                          initialRating: 0,
                          minRating: 0,
                          maxRating: 5,
                          allowHalfRating: true,
                          itemSize: 30.0,
                          ratingWidget: RatingWidget(
                            full: const Icon(Icons.star,
                                color: Constants.primaryColor),
                            half: const Icon(Icons.star_half,
                                color: Constants.primaryColor),
                            empty: const Icon(Icons.star_border,
                                color: Constants.primaryColor),
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              finalRating = rating;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text("Review"),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _reviewController,
                          maxLines: null,
                        )
                      ],
                    ),
                  );
                }
                return Text(state.toString());
              },
            ),
          ),
          bottomNavigationBar: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
            if (state is TransactionLoaded) {
              return widget.reviewId.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                          onPressed: () {
                            if (finalRating >= 0) {
                              // influencerBloc.add(CreateNewReview(
                              //     state.transaction.influencerId,
                              //     Constants.firebaseAuth.currentUser!.uid,
                              //     widget.transactionId,
                              //     finalRating,
                              //     _reviewController.text));
                            }
                          },
                          child: const Text("Submit")),
                    )
                  : const Padding(padding: EdgeInsets.zero);
            }
            return const Padding(padding: EdgeInsets.zero);
          }),
        ));
  }
}
