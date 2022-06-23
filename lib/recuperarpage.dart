import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RecuperarPage extends StatefulWidget {
  final String title = 'Recuperar contraseña';

  State<StatefulWidget> createState() => RecuperarPageState();
}

class RecuperarPageState extends State<RecuperarPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passswordController = TextEditingController();
  bool _success;
  String _userEmail;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo'),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Ingresa tu correo electronico';
                }
              },
            ),
            FlatButton(
                child: Text('Verificar'),
                color: Color.fromARGB(255, 36, 1, 233),
                textColor: Colors.white,
                onPressed: () {
                  _register();
                }),
            Container(
              alignment: Alignment.center,
              child: Text(_success == null
                  ? ''
                  : (_success
                      ? 'Por favor confirma en tu correo electronico tu cuenta' +
                          _userEmail
                      : 'El correo no existe')),
            )
          ],
        ),
      ),
    );
  }

  void dispose() {
    _emailController.dispose();
    _passswordController.dispose();
    super.dispose();
  }

  void _register() async {
    final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passswordController.text,
    );
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
      });
    } else {
      _success = false;
    }
  }
}
