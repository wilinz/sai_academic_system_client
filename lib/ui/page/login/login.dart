import 'dart:async';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/data/model/account/login_response.dart';
import 'package:flutter_template/data/network.dart';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/util/md5.dart';
import 'package:kt_dart/kt.dart';
import 'package:provider/provider.dart';

import '../../route.dart';
import 'login_viewmodel.dart';

class LoginPage extends StatelessWidget {
  final bool popUpAfterSuccess;

  const LoginPage({Key? key, required this.popUpAfterSuccess})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
        create: (context) => LoginViewModel(),
        child: _LoginPage(
          popUpAfterSuccess: popUpAfterSuccess,
        ));
  }
}

class _LoginPage extends StatefulWidget {
  const _LoginPage({Key? key, required this.popUpAfterSuccess})
      : super(key: key);
  final bool popUpAfterSuccess;

  @override
  State<_LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<_LoginPage> {
  final TextEditingController _usernameController =
      TextEditingController(text: "admin");
  final TextEditingController _passwordController =
      TextEditingController(text: "asdfghjkl987654321");
  final TextEditingController _vcodeController =
      TextEditingController(text: "");
  GlobalKey _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(builder: (context, vm, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("登录"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400, //宽度尽可能大
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(height: 50),
                          Text('欢迎使用 SAI 教务系统',
                              style: Theme.of(context).textTheme.titleLarge),
                          SizedBox(height: 50),
                          TextFormField(
                            controller: _usernameController,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: "用户名",
                              hintText: "您的用户名",
                              prefixIcon: Icon(Icons.person),
                              // helperText: '用户名',
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                            ),
                            validator: (v) {
                              return v!.trim().length > 0 ? null : "账号不能为空";
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              labelText: "密码",
                              hintText: "您的登录密码",
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  //根据passwordVisible状态显示不同的图标
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  //更新状态控制密码显示或隐藏
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                              // helperText: '密码',
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                            ),
                            validator: (v) {
                              return v!.trim().length > 0 ? null : "密码不能为空";
                            },
                          ),
                          Container(
                            height: 32,
                          ),
                          Consumer<LoginViewModel>(
                            builder: (context, loginViewModel, child) {
                              return ElevatedButton(
                                onPressed: loginViewModel.isLoading
                                    ? null
                                    : () => _login(loginViewModel, context,
                                        _formKey.currentState as FormState),
                                style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        const Size(double.infinity, 50)),
                                child: loginViewModel.isLoading
                                    ? Text("正在登录...")
                                    : Text("登录"),
                              );
                            },
                          ),
                          SizedBox(height: 12),
                          Row(children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, AppRoute.registerPage,
                                      arguments: {
                                        "username": _usernameController.text,
                                        "password": _passwordController.text
                                      });
                                },
                                child: Text("注册")),
                            Expanded(child: SizedBox()),
                            TextButton(onPressed: () {}, child: Text("忘记密码"))
                          ])
                        ],
                      ),
                    )),
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initAsync() async {
    LoginViewModel vm = Provider.of(context, listen: false);
    final recentUser = await vm.getRecentUser();
    recentUser?.let((it) {
      _usernameController.text = it.username;
      _passwordController.text = it.password;
    });
  }

  Future<void> _login(LoginViewModel loginViewModel, BuildContext context,
      FormState currentState) async {
    if (!currentState.validate()) {
      showSnackBar(context, "请检查输入");
      return;
    }
    final dio = await AppNetwork.getDio();

    try {
      final resp = await dio.post("/account/login",
          options: Options(responseType: ResponseType.json),
          data: {
            "username": _usernameController.text,
            "password": sha256Text(_passwordController.text)
          });
      final loginResult = LoginResponse.fromJson(resp.data);
      if (loginResult.code == 200) {
        showSnackBar(context, "登录成功");
        final isAdmin = loginResult.data?.isAdmin == true;
        if (isAdmin) {
          Navigator.pushNamed(context, AppRoute.adminHomePage);
        } else {
          Navigator.pushNamed(context, AppRoute.studentHomePage);
        }
      } else {
        showSnackBar(context, "登录失败: ${loginResult.msg}");
      }
    } catch (e) {
      showSnackBar(context, "登录失败: ${e}");
      print(e);
    }
  }
}
