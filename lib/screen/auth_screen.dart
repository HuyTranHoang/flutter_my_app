import 'package:flutter/material.dart';
import 'package:my_app/model/http_exception.dart';
import 'package:my_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.pinkAccent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 1],
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: AuthCard(),
              )
            ],
          ),
        ),
      ],
    ));
  }
}

enum AuthMode { signUp, login }

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<StatefulWidget> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Okay'),
          )
        ],
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    if (_authMode == AuthMode.login) {
      try {
        await context
            .read<AuthProvider>()
            .login(_authData['email']!, _authData['password']!);
      } on HttpException catch (error) {
        _showErrorDialog(error.toString());
      } catch (error) {
        _showErrorDialog(error.toString());
      }
    } else {
      await context
          .read<AuthProvider>()
          .signup(_authData['email']!, _authData['password']!);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-Mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Invalid email!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['email'] = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty || value.length < 5) {
                    return 'Password is too short!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['password'] = value!;
                },
              ),
              if (_authMode == AuthMode.signUp)
                TextFormField(
                  enabled: _authMode == AuthMode.signUp,
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: _authMode == AuthMode.signUp
                      ? (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match!';
                          }
                          return null;
                        }
                      : null,
                ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit,
                  child:
                      Text(_authMode == AuthMode.login ? 'LOGIN' : 'SIGN UP'),
                ),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(
                  '${_authMode == AuthMode.login ? 'SIGN UP' : 'LOGIN'} INSTEAD',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
