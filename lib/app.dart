// ignore_for_file: library_private_types_in_public_api

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
  bool _adStorage = true;
  bool _adUserData = true;
  bool _analyticsStorage = true;
  bool _adPersonalizationSignals = true;

  @override
  void initState() {
    super.initState();
    _loadToggleValues();
  }

  // Cargar seleccion del usuario (persistencia en dispositivo)
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

  // Guardar consentimiento
  void _saveToggleValue(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  // Implementar consentimiento como funcion de Firebase
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


//incorporado evento de login - Success
  void declararLoginExitoso() async {
    await FirebaseAnalytics.instance.logEvent(
        name: "login",
        parameters: {"method": "AppJubilados", "login": "successful"});
  }

// incorporando evento de login - Denied
  void declararLoginFallido() {
    FirebaseAnalytics.instance.logEvent(
        name: "login",
        parameters: {
          "method": "AppJubilados", 
          "login": "denied"
          });
  }

// incorportando logScreen
void logScreen (){
  FirebaseAnalytics.instance.logScreenView(
    screenClass: "LOGIN", 
    screenName: "LOGIN_bio"
  );
}


  void _showConsentBanner(BuildContext context) {
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      margin: const EdgeInsets.all(10.0),
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
                        FirebaseAnalytics.instance.logEvent(
                            name: "click",
                            parameters: {"click_detail": "Aceptar Seleccion"});
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Aceptar Selección',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        rechazarTodos();
                        FirebaseAnalytics.instance.logEvent(
                            name: "click",
                            parameters: {"click_detail": "Rechazar Todos"});
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Rechazar Todo',
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
        title: const Text('Hola Emmanuel!'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            'https://imgs.search.brave.com/KCaHGF__tKutnV_Gs_YQYg_m0sDfryFuGMCmKJD9vto/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly91cGxv/YWQud2lraW1lZGlh/Lm9yZy93aWtpcGVk/aWEvY29tbW9ucy9i/L2IyL1N1cGVydmll/bGxlX2xvZ28xNC5w/bmc', // URL de la imagen
            fit: BoxFit.contain, // Ajusta la imagen al tamaño disponible
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              children: [
                Image.network(
                  'https://content-us-7.content-cms.com/8ba19f21-9a97-4525-8886-f54d823a5cea/dxresources/ddec/ddecff1a-f799-4bf8-9cde-7fd74a48efae.png?resize=411px%3A229px&crop=411%3A216%3B0%2C7',
                  fit: BoxFit.cover,
                ),
                Image.network(
                  'https://content-us-7.content-cms.com/8ba19f21-9a97-4525-8886-f54d823a5cea/dxresources/9717/9717cd29-928d-4d33-bd99-d27286d7ae5d.jpg?resize=411px%3A229px&crop=411%3A216%3B0%2C7',
                  fit: BoxFit.cover,
                ),
                Image.network(
                  'https://content-us-7.content-cms.com/8ba19f21-9a97-4525-8886-f54d823a5cea/dxresources/d562/d5625fdb-08d6-4760-b745-f66bd4310ba5.gif',
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
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
        ],
      ),
    );
  }
}
