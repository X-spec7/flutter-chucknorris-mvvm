import 'package:chuck_norris_io/core/injection/injection_container.dart';
import 'package:chuck_norris_io/features/random/domain/entities/entities/random_entitie.dart';
import 'package:chuck_norris_io/features/random/presentation/viewmodel/bloc/random_bloc.dart';
import 'package:chuck_norris_io/features/random/presentation/widgets/category.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RandomChuckNorrisScreen extends StatefulWidget {
  static const routeName = '/';

  const RandomChuckNorrisScreen({Key? key}) : super(key: key);

  @override
  State<RandomChuckNorrisScreen> createState() =>
      _RandomChuckNorrisScreenState();
}

class _RandomChuckNorrisScreenState extends State<RandomChuckNorrisScreen> {
  RandomEntity randomEntity = RandomEntity.empty();

  final randomBloc = getIt<RandomViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider<RandomViewModel>(
        create: (context) {
          randomBloc.add(const GetRandomEvent());
          return randomBloc;
        },
        child: BlocConsumer<RandomViewModel, RandomState>(
          listener: (context, state) {
            if (state is SuccessGetRandomState) {
              setState(() {
                randomEntity = state.randomEntity;
              });
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: _principalBody(state),
            );
          },
        ),
      ),
    );
  }

  Widget _principalBody(RandomState state) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      children: [
        SizedBox(
          height: 5.h,
        ),
        Image.network(
          "https://avatars.githubusercontent.com/u/17794049?s=280&v=4",
          width: 20.w,
          height: 20.h,
        ),
        SizedBox(
          height: 5.h,
        ),
        Visibility(
          visible: state is LoadingGetRandomState,
          child: _loading(),
        ),
        Visibility(
          visible: state is! LoadingGetRandomState,
          child: _contentBody(),
        ),
      ],
    );
  }

  Widget _contentBody() {
    return Column(
      children: [
        Visibility(
          visible: randomEntity.categories.isNotEmpty,
          child: _categories(),
        ),
        Text(
          randomEntity.value,
          textAlign: TextAlign.justify,
          style: GoogleFonts.jost(
            fontWeight: FontWeight.w800,
            fontSize: 0.1.dp,
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        _buttonRandom(),
      ],
    );
  }

  Widget _categories() {
    return Column(
      children: [
        Text(
          "Categories",
          style: GoogleFonts.jost(
            fontWeight: FontWeight.w800,
            fontSize: 0.2.dp,
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        Row(
          children: List.generate(
            randomEntity.categories.length,
            (index) {
              String category = randomEntity.categories[index];
              return RandomCategory(category: category);
            },
          ),
        ),
        Divider(
          color: Colors.black45,
          height: 5.h,
        ),
      ],
    );
  }

  Widget _buttonRandom() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      child: OutlinedButton(
        onPressed: () {
          randomBloc.add(const GetRandomEvent());
        },
        child: const Text('Try again'),
      ),
    );
  }

  Widget _loading() {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }
}
