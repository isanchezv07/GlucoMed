import 'package:flutter/material.dart';
import 'package:flutter_login/theme.dart';
import 'package:flutter_login/widgets.dart';
import 'package:glucomed/constants.dart';
import 'package:glucomed/dashboard_screen.dart'; // Importa la pantalla del dashboard
import 'package:glucomed/transition_route_observer.dart';
import 'package:glucomed/widgets/fade_in.dart';
import 'package:glucomed/widgets/round_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Clinicas extends StatefulWidget {
  static const routeName = '/dashboard';

  const Clinicas({Key? key}) : super(key: key);

  @override
  State<Clinicas> createState() => _Clinicas();
}

class _Clinicas extends State<Clinicas>
    with SingleTickerProviderStateMixin, TransitionRouteAware {
  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == await LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentPosition() async {
    Position position = await determinePosition();
    print(position.latitude);
    print(position.longitude);
  }

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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Hero(
              tag: Constants.logoTag,
              child: Image.asset(
                'assets/images/ecorp.png',
                filterQuality: FilterQuality.high,
                height: 30,
              ),
            ),
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
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                getCurrentPosition();
              },
              child: const Text('Mi Botón'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        final hasPopped = await _goToLogin(context);
        return hasPopped;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(theme),
          body: SingleChildScrollView( // Agregar SingleChildScrollView
            child: Container(
              width: double.infinity,
              color: theme.primaryColor.withOpacity(.1),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 40),
                  _buildHeader(theme),
                  GridView.builder(
                    shrinkWrap: true, // Importante: Para que la rejilla se ajuste al contenido
                    physics: NeverScrollableScrollPhysics(), // Para deshabilitar el desplazamiento de la cuadrícula
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: 6, // Cambiar este valor según la cantidad de cuadrados que desees
                    itemBuilder: (context, index) {
                      return _buildClinicCard(index);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClinicCard(int index) {
    // Aquí puedes personalizar los datos de cada clínica
    // Por ahora, se generan datos ficticios
    final clinicImage = Image.asset(
      'assets/images/ecorp.png',
      fit: BoxFit.cover,
    );

    final clinicName = Text(
      'Clinica $index',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );

    final clinicFeatures = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dirección: Dirección $index'),
        Text('Teléfono: Teléfono $index'),
        Text('Horario: Horario $index'),
      ],
    );

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 100,
            child: clinicImage,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                clinicName,
                SizedBox(height: 8),
                clinicFeatures,
              ],
            ),
          ),
        ],
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
              title: Text('Option 1'),
              onTap: () {
                // Handle Option 1
              },
            ),
            ListTile(
              title: Text('Opcion 3'),
              onTap: () {
                // Handle Option 3
              },
            ),
            ListTile(
              title: Text('Option 3'),
              onTap: () {
                // Handle Option 1
              },
            ),
            ListTile(
              title: Text('Regresar'),
              onTap: () {
                // Navegar al dashboard
                Navigator.pushNamed(context, DashboardScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}