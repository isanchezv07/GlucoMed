// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_login/theme.dart';
import 'package:flutter_login/widgets.dart';
import 'package:glucomed/clinicas.dart';
import 'package:glucomed/configuracion.dart';
import 'package:glucomed/constants.dart';
import 'package:glucomed/dashboard_screen.dart'; // Importa la pantalla del dashboard
import 'package:glucomed/transition_route_observer.dart';
import 'package:glucomed/widgets/fade_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glucomed/user_conf.dart';

class Planes extends StatefulWidget {
  static const routeName = '/dashboard';

  const Planes({Key? key}) : super(key: key);

  @override
  State<Planes> createState() => _PlanesState();
}

class _PlanesState extends State<Planes>
    with SingleTickerProviderStateMixin, TransitionRouteAware {
  Future<bool> _goToLogin(BuildContext context) {
    return Navigator.of(context)
        .pushReplacementNamed('/auth')
        .then((_) => false);
  }

  final routeObserver = TransitionRouteObserver<PageRoute?>();
  static const headerAniInterval = Interval(.1, .3, curve: Curves.easeOut);
  late Animation<double> _headerScaleAnimation;
  AnimationController? _loadingController;

  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    );

    _headerScaleAnimation = Tween<double>(begin: .6, end: 1).animate(
      CurvedAnimation(
        parent: _loadingController!,
        curve: headerAniInterval,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(
      this,
      ModalRoute.of(context) as PageRoute<dynamic>?,
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _loadingController!.dispose();
    super.dispose();
  }

  @override
  void didPushAfterTransition() => _loadingController!.forward();

  AppBar _buildAppBar(ThemeData theme) {
    final menuBtn = IconButton(
      color: theme.colorScheme.secondary,
      icon: const Icon(FontAwesomeIcons.bars),
      onPressed: () {
        setState(() {
          _isMenuOpen = !_isMenuOpen;
        });
      },
    );
    final signOutBtn = IconButton(
      icon: const Icon(FontAwesomeIcons.rightFromBracket),
      color: theme.colorScheme.secondary,
      onPressed: () => _goToLogin(context),
    );
    final title = Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          HeroText(
            Constants.appName,
            tag: Constants.titleTag,
            viewState: ViewState.shrunk,
            style: LoginThemeHelper.loginTextStyle,
          ),
          const SizedBox(width: 20),
        ],
      ),
    );

    return AppBar(
      leading: FadeIn(
        controller: _loadingController,
        offset: .3,
        curve: headerAniInterval,
        child: menuBtn,
      ),
      actions: <Widget>[
        FadeIn(
          controller: _loadingController,
          offset: .3,
          curve: headerAniInterval,
          fadeDirection: FadeDirection.endToStart,
          child: signOutBtn,
        ),
      ],
      title: title,
      backgroundColor: theme.primaryColor.withOpacity(.1),
      elevation: 0,
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final primaryColor =
        Colors.primaries.where((c) => c == theme.primaryColor).first;
    final accentColor =
        Colors.primaries.where((c) => c == theme.colorScheme.secondary).first;
    final linearGradient = LinearGradient(
      colors: [
        primaryColor.shade800,
        primaryColor.shade200,
      ],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 418.0, 78.0));

    return ScaleTransition(
      scale: _headerScaleAnimation,
      child: FadeIn(
        controller: _loadingController,
        curve: headerAniInterval,
        fadeDirection: FadeDirection.bottomToTop,
        offset: .5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      onPopInvoked: (hasPopped) => hasPopped ? _goToLogin(context) : null,
      child: SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(theme),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: theme.primaryColor.withOpacity(.1),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(height: 40),
                    Expanded(
                      flex: 2,
                      child: _buildHeader(theme),
                    ),
                    Expanded(
                      flex: 8,
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              Colors.deepPurpleAccent.shade100,
                              Colors.deepPurple.shade100,
                              Colors.deepPurple.shade100,
                              Colors.deepPurple.shade100,
                            ],
                          ).createShader(bounds);
                        },
                      ),
                    ),
                  ],
                ),
                _buildMenu(theme),
                _buildImageAndText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenu(ThemeData theme) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      left: _isMenuOpen ? 0 : -200,
      top: 0,
      bottom: 0,
      width: 200,
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text('Configuracion'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Configuracion()));
              },
            ),
            ListTile(
              title: Text('User'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => User_conf()));
              },
            ),
            ListTile(
              title: Text('Clinicas'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Clinicas()));
              },
            ),
            ListTile(
              title: Text('Regresar'),
              onTap: () {
                Navigator.pushNamed(context, DashboardScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageAndText() {
    return Positioned(
      left: 20,
      top: MediaQuery.of(context).size.height * 0.3, // Adjust this value as needed
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildPhotoAndText(),
          SizedBox(height: 20),
          _buildPhotoAndText(),
          SizedBox(height: 20),
          _buildPhotoAndText(),
        ],
      ),
    );
  }

  Widget _buildPhotoAndText() {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/images/sample_image.jpg'), // Replace with your image asset
        ),
        SizedBox(width: 20),
        Text(
          'Some Text', // Replace with your text
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}