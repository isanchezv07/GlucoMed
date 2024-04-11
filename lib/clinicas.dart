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

// Define la clase para representar una clínica
class Clinic {
  final String name;
  final String address;
  final String phone;
  final String schedule;

  Clinic({
    required this.name,
    required this.address,
    required this.phone,
    required this.schedule,
  });
}

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

  // Define una lista de clínicas con información específica
  final List<Clinic> clinics = [
    Clinic(
      name: 'Medica Sur',
      address: 'Tlalpan',
      phone: '55 5424 6805',
      schedule: '24/7',
    ),
    Clinic(
      name: 'Centro Médico ABC Camp. Observatorio',
      address: 'Álvaro Obregón',
      phone: '55 5230 8000',
      schedule: '24/7',
    ),
    Clinic(
      name: 'Centro Médico ABC Camp. Santa Fe',
      address: 'Cuajimalpa de Morelos',
      phone: '55 1103 1600',
      schedule: '24/7',
    ),
    Clinic(
      name: 'Hospital Español',
      address: 'Miguel Hidalgo',
      phone: '55 5255 9600',
      schedule: '24/7',
    ),
    Clinic(
      name: 'Christus Muguerza Hospital Alta Especialidad',
      address: 'Monterrey',
      phone: '+52 81 8399 3477',
      schedule: '24/7',
    ),
    Clinic(
      name: 'Hospital Zambrano Hellion TecSalud',
      address: 'San Pedro Garza García',
      phone: 'Teléfono 6',
      schedule: '24/7',
    ),
    // Agrega más clínicas según sea necesario
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
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              color: theme.primaryColor.withOpacity(.1),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 40),
                  _buildHeader(theme),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: clinics.length, // Usa la cantidad de clínicas
                    itemBuilder: (context, index) {
                      return _buildClinicCard(index);
                    },
                  ),
                ],
              ),
            ),
          ),
          drawer: _buildMenu(theme), // Agrega el drawer aquí
        ),
      ),
    );
  }

  Widget _buildClinicCard(int index) {
    final Clinic clinic = clinics[index]; // Obtiene la clínica actual

    final clinicName = Text(
      clinic.name,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );

    final clinicFeatures = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dirección: ${clinic.address}'),
        Text('Teléfono: ${clinic.phone}'),
        Text('Horario: ${clinic.schedule}'),
      ],
    );

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: theme.primaryColor,
            ),
          ),
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
              Navigator.pushNamed(context, DashboardScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}