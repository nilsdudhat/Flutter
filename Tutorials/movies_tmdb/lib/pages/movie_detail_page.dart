import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_tmdb/constants/image_constants.dart';
import 'package:movies_tmdb/models/polpular_movies_data.dart';
import 'package:movies_tmdb/providers/movie_details_provider.dart';
import 'package:movies_tmdb/utils/progress_utils.dart';
import 'package:movies_tmdb/widgets/custom_container.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constants/color_constants.dart';
import '../models/movie_details.dart';
import '../widgets/custom_text.dart';

class MovieDetailPage extends ConsumerStatefulWidget {
  const MovieDetailPage({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  ConsumerState<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends ConsumerState<MovieDetailPage> {
  ValueNotifier<MovieDetails?> movieDetailsNotifier = ValueNotifier(null);
  ValueNotifier<bool> isLoadingNotifier = ValueNotifier(true);

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      ProgressUtils.show(context);

      getMovieDetails();
    });
  }

  void getMovieDetails() {
    ref
        .read(movieDetailsProvider)
        .getMovieDetails(
          movieID: widget.movie.id!,
          onError: (exception) {
            ProgressUtils.hide();
            getMovieDetails();
          },
        )
        .then((value) {
      log("--details-- ${value?.toJson().toString()}");
      ProgressUtils.hide();
      isLoadingNotifier.value = false;

      movieDetailsNotifier.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: CustomText(
          text: widget.movie.title!,
          textOverflow: TextOverflow.ellipsis,
          textColor: ColorConstants.blackColor,
          customFontSize: CustomFontSize.large,
          customFontWeight: CustomFontWeight.semiBold,
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: isLoadingNotifier,
        builder: (context, isLoading, child) {
          return isLoading
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AspectRatio(
                      aspectRatio: 1.77,
                      child: SizedBox.expand(),
                    ),
                    CustomContainer(
                      width: 30.w,
                      containerMargin: const EdgeInsets.all(16),
                      containerPadding: EdgeInsets.zero,
                      borderWidth: 0,
                      containerChild: Hero(
                        tag: "poster${widget.movie.id}",
                        child: Image.network(
                          "https://image.tmdb.org/t/p/w500${widget.movie.posterPath}",
                          fit: BoxFit.cover,
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) {
                            if ((frame != null)) {
                              return AnimatedOpacity(
                                opacity: 1,
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeOut,
                                child: child,
                              );
                            } else {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(
                                      color: ColorConstants.blackColor),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                )
              : ValueListenableBuilder(
                  valueListenable: movieDetailsNotifier,
                  builder: (context, value, child) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 1.75,
                            child: (value == null)
                                ? const SizedBox.expand()
                                : Image.network(
                                    "https://image.tmdb.org/t/p/w500${value.backdropPath}",
                                    fit: BoxFit.cover,
                                    frameBuilder: (context, child, frame,
                                        wasSynchronouslyLoaded) {
                                      if ((frame != null)) {
                                        return AnimatedOpacity(
                                          opacity: 1,
                                          duration: const Duration(seconds: 1),
                                          curve: Curves.easeOut,
                                          child: child,
                                        );
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                              color: ColorConstants.blackColor),
                                        );
                                      }
                                    },
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomContainer(
                                      width: 30.w,
                                      containerPadding: EdgeInsets.zero,
                                      borderWidth: 0,
                                      containerChild: Hero(
                                        tag: "poster${widget.movie.id}",
                                        child: Image.network(
                                          "https://image.tmdb.org/t/p/w500${widget.movie.posterPath}",
                                          fit: BoxFit.cover,
                                          frameBuilder: (context, child, frame,
                                              wasSynchronouslyLoaded) {
                                            if ((frame != null)) {
                                              return AnimatedOpacity(
                                                opacity: 1,
                                                duration:
                                                    const Duration(seconds: 1),
                                                curve: Curves.easeOut,
                                                child: child,
                                              );
                                            } else {
                                              return Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(16.0),
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: ColorConstants
                                                              .blackColor),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    if (value != null) ...[
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            if ((value.adult != null) &&
                                                value.adult!)
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: SizedBox.square(
                                                  dimension: math.min(16.w, 16.h),
                                                  child: Image.asset(
                                                      ImageConstants.adult),
                                                ),
                                              ),
                                            CustomText(
                                              text:
                                                  "Popularity: ${value.popularity?.toStringAsFixed(2)}",
                                              textColor:
                                                  ColorConstants.blackColor,
                                            ),
                                            CustomText(
                                              text:
                                                  "Rating: ${value.voteAverage?.toStringAsFixed(2)}",
                                              textColor:
                                                  ColorConstants.blackColor,
                                            ),
                                            CustomText(
                                              text:
                                                  "Release Date: ${value.releaseDate}",
                                              textColor:
                                                  ColorConstants.blackColor,
                                            ),
                                          ],
                                        ),
                                      )
                                    ]
                                  ],
                                ),
                                const SizedBox(height: 16),
                                if (value != null) ...[
                                  if (value.genres != null) ...[
                                    Builder(builder: (context) {
                                      String genres = "";

                                      for (var element in value.genres!) {
                                        genres = genres.isEmpty
                                            ? element.name!
                                            : "$genres, ${element.name}";
                                      }
                                      return CustomText(
                                        text: genres,
                                        textColor: ColorConstants.blackColor,
                                        customFontWeight:
                                            CustomFontWeight.semiBold,
                                        customFontSize: CustomFontSize.medium,
                                      );
                                    }),
                                    const SizedBox(height: 8)
                                  ],
                                  if (value.spokenLanguages != null) ...[
                                    Builder(builder: (context) {
                                      String languages = "";

                                      for (var element
                                          in value.spokenLanguages!) {
                                        languages = languages.isEmpty
                                            ? element.name!
                                            : "$languages, ${element.name}";
                                      }
                                      return CustomText(
                                        text: languages,
                                        textColor: ColorConstants.blackColor,
                                        customFontWeight:
                                            CustomFontWeight.semiBold,
                                        customFontSize: CustomFontSize.medium,
                                      );
                                    }),
                                    const SizedBox(height: 8)
                                  ],
                                  if (value.overview != null)
                                    CustomText(
                                      text: value.overview!,
                                      textColor: ColorConstants.blackColor,
                                    ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
