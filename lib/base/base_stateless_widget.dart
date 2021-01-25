import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:my_investment/base/base_cubit.dart';
import 'package:my_investment/custom_widget/custom_widget.dart';
import 'package:my_investment/custom_widget/streambuilder/custom_streambuilder.dart';
import 'package:my_investment/interface/main_body.dart';

// ignore: must_be_immutable
abstract class BaseStatelessWidget<T extends BaseCubit> extends StatelessWidget
    with IMainBody {
  final String title;
  BuildContext currentContext;

  BaseStatelessWidget(this.title);

  T getCubit();
  @override
  buildContext(BuildContext context) {
    currentContext = context;
  }

  @override
  Widget build(BuildContext context) {
    print("build");

    return CubitProvider(
        create: (_) {
          print("CubitProvider");
          return getCubit();
        },
        child: getMainBody(context));
  }

  Widget getMainBody(BuildContext context) {
    return MainBodyPage<T>(iMainBody: this);
  }

  Widget getBackButton(BuildContext context) {
    return BackButton(
      onPressed: () {
        handleBackButton(context);
      },
    );
  }

  handleBackButton(BuildContext context) {
    print("Back nè");
  }

  String getUriImage() {
    return "assets/images/bg_toolbar.png";
  }

  @override
  initState() {}

  @override
  dispose() {}

  @override
  FloatingActionButton getFloatButton(BuildContext context) {
    return null;
  }

  @override
  PreferredSize getAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size(0, kToolbarHeight),
      child: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: getBackButton(context),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: defaultAppbarGradient),
          child: Row(
            children: [
              Image.asset(
                getUriImage(),
                width: MediaQuery.of(context).size.width / 2,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        title: Text(title ?? ""),
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                // handleBackButton(context);
              }),
        ],
      ),
    );
  }
}

class MainBodyPage<T extends BaseCubit> extends StatefulWidget {
  final IMainBody iMainBody;

  MainBodyPage({Key key, this.iMainBody}) : super(key: key);

  @override
  _MainBodyState createState() => _MainBodyState<T>();
}

class _MainBodyState<T extends BaseCubit> extends State<MainBodyPage> {
  @override
  void initState() {
    super.initState();
    widget.iMainBody.buildContext(context);
    widget.iMainBody.initState();
  }

  @override
  void dispose() {
    super.dispose();
    widget.iMainBody.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("_MainBodyState");

    return Stack(
      children: [
        Scaffold(
          floatingActionButton: widget.iMainBody.getFloatButton(context),
          primary: true,
          body: widget.iMainBody.getBody(context),
          appBar: widget.iMainBody.getAppBar(context),
        ),
        MyStreamBuilder<bool>(
            stream: context.cubit<T>().bsLoading.stream,
            initialData: false,
            builder: (context, snapshot) {
              return loadingWidget(context, snapshot.data);
            }),
      ],
    );
  }
}

const LinearGradient defaultAppbarGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xff0077B6), Color(0xFF007CB9), Color(0xff00B4D8)]);
