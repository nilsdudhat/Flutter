import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies_tmdb/constants/color_constants.dart';
import 'package:movies_tmdb/constants/image_constants.dart';
import 'package:movies_tmdb/constants/string_constants.dart';
import 'package:movies_tmdb/providers/home_page_provider.dart';
import 'package:movies_tmdb/utils/progress_utils.dart';
import 'package:movies_tmdb/widgets/custom_container.dart';
import 'package:movies_tmdb/widgets/custom_text.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../models/polpular_movies_data.dart';
import 'movie_detail_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  ValueNotifier<List<Movie>> moviesListNotifier = ValueNotifier([]);
  ValueNotifier<bool> isGridNotifier = ValueNotifier(true);
  ValueNotifier<bool> isLoadingNotifier = ValueNotifier(true);

  int totalPages = 0;
  int lastLoadedPage = 0;

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      ProgressUtils.show(context);
      getMovies(pageNumber: 1);
    });
  }

  void getMovies({required int pageNumber}) {
    ref
        .read(homePageProvider)
        .getPopularMoviesData(
          pageNumber: pageNumber,
          onError: (String error) {
            getMovies(pageNumber: pageNumber);
          },
        )
        .then((value) {
      isLoadingNotifier.value = false;

      if (value == null || value.results == null) {
        return;
      }
      if (value.totalPages != null) {
        totalPages = value.totalPages!;
      }
      moviesListNotifier.value = List.from(moviesListNotifier.value)
        ..addAll(value.results!);
      lastLoadedPage = pageNumber;

      ProgressUtils.hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: CustomText(
          text: StringConstants.homePageTitle,
          textColor: ColorConstants.blackColor,
          customFontSize: CustomFontSize.largeExtra,
          customFontWeight: CustomFontWeight.semiBold,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8, top: 16, bottom: 16),
            child: InkWell(
              onTap: () {
                isGridNotifier.value = false;
              },
              customBorder: const CircleBorder(),
              child: SizedBox.square(
                child: Image.asset(ImageConstants.linearList),
              ),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 8, top: 16, bottom: 16, right: 16),
            child: InkWell(
              onTap: () {
                isGridNotifier.value = true;
              },
              customBorder: const CircleBorder(),
              child: SizedBox.square(
                child: SvgPicture.asset(ImageConstants.gridList),
              ),
            ),
          ),
        ],
      ),
      body: SizedBox.expand(
        child: ValueListenableBuilder(
          valueListenable: moviesListNotifier,
          builder: (context, value, child) {
            log("--notifier-- ${moviesListNotifier.value.length}");

            return ValueListenableBuilder(
                valueListenable: isGridNotifier,
                builder: (context, isGrid, child) {
                  return isGrid
                      ? GridView.builder(
                          itemCount: value.length,
                          padding: const EdgeInsets.only(bottom: 16),
                          clipBehavior: Clip.antiAlias,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                          ),
                          itemBuilder: (context, index) {
                            if ((index == (value.length - 1)) &&
                                lastLoadedPage < totalPages) {
                              getMovies(pageNumber: lastLoadedPage + 1);
                            }

                            final movie = value[index];
                            log("--notifier-- ${movie.toJson()}");

                            return InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return MovieDetailPage(movie: movie);
                                  },
                                ));
                              },
                              radius: 12,
                              child: CustomContainer(
                                width: double.infinity,
                                backgroundColor:
                                    ColorConstants.blackColor.withOpacity(0.10),
                                containerMargin: EdgeInsets.only(
                                  top: 16,
                                  right: ((index % 2) == 0) ? 8 : 16,
                                  left: ((index % 2) != 0) ? 8 : 16,
                                ),
                                containerPadding: EdgeInsets.zero,
                                borderWidth: 0,
                                containerChild: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: Hero(
                                        tag: "poster${movie.id}",
                                        child: Image.network(
                                          "https://image.tmdb.org/t/p/w500${movie.posterPath}",
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
                                                child: CircularProgressIndicator(
                                                    color: ColorConstants
                                                        .blackColor),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: CustomText(
                                        text: movie.title!,
                                        textOverflow: TextOverflow.ellipsis,
                                        textColor: ColorConstants.blackColor,
                                        maxLines: 1,
                                        customFontWeight:
                                            CustomFontWeight.semiBold,
                                        customFontSize: CustomFontSize.large,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 4),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: CustomText(
                                        text: movie.voteAverage!.toString(),
                                        textColor: ColorConstants.blackColor,
                                        customFontWeight: CustomFontWeight.normal,
                                        customFontSize: CustomFontSize.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: value.length,
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.only(bottom: 16),
                          clipBehavior: Clip.antiAlias,
                          itemBuilder: (context, index) {
                            if ((index == (value.length - 1)) &&
                                lastLoadedPage < totalPages) {
                              getMovies(pageNumber: lastLoadedPage + 1);
                            }

                            final movie = value[index];
                            log("--notifier-- ${movie.toJson()}");

                            return InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return MovieDetailPage(movie: movie);
                                  },
                                ));
                              },
                              radius: 12,
                              child: CustomContainer(
                                backgroundColor:
                                    ColorConstants.blackColor.withOpacity(0.10),
                                borderWidth: 0,
                                containerMargin: const EdgeInsets.only(
                                    top: 16, left: 16, right: 16),
                                containerChild: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox.square(
                                      dimension: 12.w,
                                      child: ClipOval(
                                        child: Hero(
                                          tag: "poster${movie.id}",
                                          child: Image.network(
                                            "https://image.tmdb.org/t/p/w500${movie.posterPath}",
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
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: ColorConstants
                                                              .blackColor),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text: movie.title!,
                                            textOverflow: TextOverflow.ellipsis,
                                            textColor:
                                                ColorConstants.blackColor,
                                            customFontWeight:
                                                CustomFontWeight.semiBold,
                                            customFontSize:
                                                CustomFontSize.large,
                                          ),
                                          CustomText(
                                            text: movie.voteAverage!.toString(),
                                            textColor:
                                                ColorConstants.blackColor,
                                            customFontWeight:
                                                CustomFontWeight.normal,
                                            customFontSize:
                                                CustomFontSize.normal,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                });
          },
        ),
      ),
    );
  }
}
