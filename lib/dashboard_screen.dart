// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_login/theme.dart';
import 'package:flutter_login/widgets.dart';
import 'package:glucomed/clinicas.dart';
import 'package:glucomed/configuracion.dart';
import 'package:glucomed/constants.dart';
import 'package:glucomed/dev.dart';
import 'package:glucomed/planes.dart';
import 'package:glucomed/transition_route_observer.dart';
import 'package:glucomed/widgets/fade_in.dart';
import 'package:glucomed/widgets/round_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'item_2_menu.dart'; // Importa la pantalla de destino
import 'configuracion.dart';
import 'Dev.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  const DashboardScreen({Key? key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin, TransitionRouteAware {
  Future<bool> _goToLogin(BuildContext context) {
    return Navigator.of(context)
        .pushReplacementNamed('/auth')
        // we dont want to pop the screen, just replace it completely
        .then((_) => false);
  }

  final routeObserver = TransitionRouteObserver<PageRoute?>();
  static const headerAniInterval = Interval(.1, .3, curve: Curves.easeOut);
  late Animation<double> _headerScaleAnimation;
  late AnimationController _loadingController;

  final List<String> buttonTitles = [
    'Configuracion',
    'User',
    'Planes',
    'Clinicas',
    'Title 5',
    'Title 6',
    'Title 7',
    'Title 8',
  ];

  @override
  void initState() {
    super.initState();

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    );

    _headerScaleAnimation = Tween<double>(begin: .6, end: 1).animate(
      CurvedAnimation(
        parent: _loadingController,
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
    _loadingController.dispose();
    super.dispose();
  }

  @override
  void didPushAfterTransition() => _loadingController.forward();

  AppBar _buildAppBar(ThemeData theme) {
    final menuBtn = IconButton(
      color: theme.colorScheme.secondary,
      icon: const Icon(FontAwesomeIcons.bars),
      onPressed: () {},
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
          ),
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

  Widget _buildButton({
    Widget? icon,
    required String label,
    required Interval interval,
    required int itemIndex, // Necesitamos el índice del botón
    double size = 100.0, // Tamaño predeterminado del botón
  }) {
    return RoundButton(
      icon: icon,
      label: label,
      loadingController: _loadingController,
      interval: Interval(
        interval.begin,
        interval.end,
        curve: const ElasticOutCurve(0.42),
      ),
      size: size, // Usa el tamaño definido
      onPressed: () {
        // Verifica si el índice del botón es 2
        if (itemIndex == 1) {
          // Navega a la pantalla "item_2_menu.dart"
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Configuracion(), // Pantalla de destino
            ),
          );
        } else {
          print('Item $itemIndex');
        }
        if (itemIndex == 2) {
          // Navega a la pantalla "item_2_menu.dart"
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => item_2_menu(), // Pantalla de destino
            ),
          );
        } else {
          print('Item $itemIndex');
        }
        if (itemIndex == 3) {
          // Navega a la pantalla "item_2_menu.dart"
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Planes(), // Pantalla de destino
            ),
          );
        } else {
          print('Item $itemIndex');
        }
        if (itemIndex == 4) {
          // Navega a la pantalla "item_2_menu.dart"
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Clinicas(), // Pantalla de destino
            ),
          );
        } else {
          print('Item $itemIndex');
        }
        if (itemIndex == 5) {
          // Navega a la pantalla "item_2_menu.dart"
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dev(), // Pantalla de destino
            ),
          );
        } else {
          print('Item $itemIndex');
        }
        if (itemIndex == 6) {
          // Navega a la pantalla "item_2_menu.dart"
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Clinicas(), // Pantalla de destino
            ),
          );
        } else {
          print('Item $itemIndex');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        await _goToLogin(context);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(theme),
          body: GridView.count(
            crossAxisCount: 2,
            children: List.generate(8, (index) {
              int itemIndex = index + 1;
              return _buildButton(
                icon: null,
                label: buttonTitles[index],
                interval: Interval(0.0, 0.5),
                itemIndex: itemIndex,
                size: 150.0, // Ajusta el tamaño del botón según sea necesario
              );
            }),
          ),
        ),
      ),
    );
  }
}