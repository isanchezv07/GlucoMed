// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_login/theme.dart';
import 'package:flutter_login/widgets.dart';
import 'package:glucomed/about_us.dart';
import 'package:glucomed/clinicas.dart';
import 'package:glucomed/configuracion.dart';
import 'package:glucomed/constants.dart';
import 'package:glucomed/dashboard_screen.dart'; // Importa la pantalla del dashboard
import 'package:glucomed/planes.dart';
import 'package:glucomed/transition_route_observer.dart';
import 'package:glucomed/user_conf.dart';
import 'package:glucomed/widgets/fade_in.dart';
import 'package:glucomed/widgets/round_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  ];

  bool _isMenuOpen = false; // Estado del menú
  late Animation<double> _menuAnimation;

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

    _menuAnimation = Tween<double>(
      begin: -200.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _loadingController,
        curve: Curves.easeInOut,
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
    return AppBar(
      leading: IconButton(
        // Cambia el icono y el onPressed para abrir/cerrar el menú
        color: theme.colorScheme.secondary,
        icon: _isMenuOpen ? Icon(Icons.close) : Icon(FontAwesomeIcons.bars),
        onPressed: () {
          setState(() {
            _isMenuOpen = !_isMenuOpen;
          });
        },
      ),
      title: Center(
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
      ),
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
    required String imagePath,
    required String label,
    required Interval interval,
    required int itemIndex,
    double size = 100.0,
    double imageSize = 100.0, // Nuevo parámetro para el tamaño de la imagen
  }) {
    return RoundButton(
      icon: Image.asset(
        imagePath,
        width: imageSize, // Utiliza el nuevo parámetro para el tamaño de la imagen
        height: imageSize, // Utiliza el nuevo parámetro para el tamaño de la imagen
        fit: BoxFit.cover,
      ),
      label: label,
      loadingController: _loadingController,
      interval: Interval(
        interval.begin,
        interval.end,
        curve: const ElasticOutCurve(0.42),
      ),
      size: size,
      onPressed: () {
        if (itemIndex == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Configuracion(),
            ),
          );
        } else if (itemIndex == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  User_conf(),
            ),
          );
        } else if (itemIndex == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Planes(),
            ),
          );
        } else if (itemIndex == 4) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Clinicas(),
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

    // Definir rutas de imagen para cada botón
    final List<String> buttonImages = [
      'assets/images/Configuracion-image.png',
      'assets/images/User-image.png',
      'assets/images/Planes-image.png',
      'assets/images/Clinicas-image.png',
    ];

    return WillPopScope(
      onWillPop: () async {
        await _goToLogin(context);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(theme),
          body: Stack(
            children: [
              // Contenido principal de la pantalla
              GridView.count(
                crossAxisCount: 2,
                children: List.generate(buttonTitles.length, (index) {
                  int itemIndex = index + 1;
                  return _buildButton(
                    imagePath: buttonImages[index], // Ruta de imagen correspondiente al índice actual
                    label: buttonTitles[index],
                    interval: Interval(0.0, 0.5),
                    itemIndex: itemIndex,
                    size: 150.0,
                    imageSize: 120.0, // Tamaño de la imagen personalizado
                  );
                }),
              ),
              // Menú desplegable animado
              AnimatedPositioned(
                duration: Duration(milliseconds: 250),
                top: 0,
                left: _isMenuOpen ? 0 : -200, // Oculta el menú fuera de la pantalla
                child: Container(
                  width: 200, // Ancho del menú
                  height: MediaQuery.of(context).size.height, // Altura igual al alto de la pantalla
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Contenido del menú
                      ListTile(
                        title: Text('Configuración'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Configuracion()),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('User'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => User_conf()),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Planes'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Planes()),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Clínicas'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Clinicas()),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('About Us'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AboutUs()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}