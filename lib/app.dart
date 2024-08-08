import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banner de Consentimiento',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //cambiar el tipo
  bool _adStorage = true;
  bool _adUserData = true;
  bool _analyticsStorage = true;
  bool _adPersonalizationSignals = true;

  @override
  void initState() {
    super.initState();
    _loadToggleValues();
  }

  void _loadToggleValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _adStorage = prefs.getBool('adStorage') ?? false;
      _adUserData = prefs.getBool('adUserData') ?? false;
      _analyticsStorage = prefs.getBool('analyticsStorage') ?? false;
      _adPersonalizationSignals =
          prefs.getBool('adPersonalizationSignals') ?? false;
    });
    _setPreviousConsent();
  }

  void _saveToggleValue(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  void _setPreviousConsent() {
    FirebaseAnalytics.instance.setConsent(adStorageConsentGranted: _adStorage);
    FirebaseAnalytics.instance
        .setConsent(adUserDataConsentGranted: _adUserData);
    FirebaseAnalytics.instance
        .setConsent(analyticsStorageConsentGranted: _analyticsStorage);
    FirebaseAnalytics.instance.setConsent(
        adPersonalizationSignalsConsentGranted: _adPersonalizationSignals);
  }

  void rechazarTodos() {
    _adStorage = false;
    _adUserData = false;
    _analyticsStorage = false;
    _adPersonalizationSignals = false;
    _saveToggleValue('adStorage', _adStorage);
    _saveToggleValue('adUserData', _adUserData);
    _saveToggleValue('analyticsStorage', _analyticsStorage);
    _saveToggleValue('adPersonalizationSignals', _adPersonalizationSignals);
  }

  void _showConsentBanner(BuildContext context) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.symmetric(vertical: 200, horizontal: 30),
      borderRadius: BorderRadius.circular(10),
      backgroundColor: Colors.blueGrey,
      titleText: const Text(
        "Consentimiento",
        style: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      messageText: StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Switch(
                      value: _adStorage,
                      onChanged: (value) {
                        setState(() {
                          _adStorage = value;
                          _saveToggleValue('adStorage', value);
                        });
                      },
                    ),
                    const Text('Ad Storage',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
                Row(
                  children: [
                    Switch(
                      value: _adUserData,
                      onChanged: (value) {
                        setState(() {
                          _adUserData = value;
                          _saveToggleValue('adUserData', value);
                        });
                      },
                    ),
                    const Text('Ad User Data',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
                Row(
                  children: [
                    Switch(
                      value: _analyticsStorage,
                      onChanged: (value) {
                        setState(() {
                          _analyticsStorage = value;
                          _saveToggleValue('analyticsStorage', value);
                        });
                      },
                    ),
                    const Text('Analytics Storage',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
                Row(
                  children: [
                    Switch(
                      value: _adPersonalizationSignals,
                      onChanged: (value) {
                        setState(() {
                          _adPersonalizationSignals = value;
                          _saveToggleValue('adPersonalizationSignals', value);
                        });
                      },
                    ),
                    const Text('Ad Personalization Signals',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Acción para el primer botón
                        print('Botón Aceptar presionado');
                        rechazarTodos();
                        FirebaseAnalytics.instance.logEvent(
                            name: "click",
                            parameters: {"click_detail": "Aceptar Todos"});
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Rechazar Todo',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Acción para el segundo botón
                        print('Aceptar selección');
                        FirebaseAnalytics.instance.logEvent(
                            name: "click",
                            parameters: {"click_detail": "Aceptar seleccion"});
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Aceptar Seleccion',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      duration: const Duration(seconds: 10),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banner de Consentimiento'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => [
            _showConsentBanner(context),
            FirebaseAnalytics.instance.logEvent(name: 'click', parameters: {
              "click_detail": "mostrar banner de consentimiento"
            })
          ],
          child: const Text('Mostrar Banner de Consentimiento'),
        ),
      ),
    );
  }
}
