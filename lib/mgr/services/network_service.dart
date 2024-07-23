import 'dart:async';import 'package:connectivity_plus/connectivity_plus.dart';import 'package:flutter/material.dart';import 'package:flutter/services.dart';import 'dart:async';import 'package:connectivity_plus/connectivity_plus.dart';class NetworkService {  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];  final Connectivity _connectivity = Connectivity();  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;  final _networkStatusController = StreamController<bool>.broadcast();  Stream<bool> get networkStatusStream => _networkStatusController.stream;  NetworkService() {    initConnectivity();    _connectivitySubscription =        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);  }  Future<void> initConnectivity() async {    late List<ConnectivityResult> result;    try {      result = await _connectivity.checkConnectivity();    } on PlatformException catch (e) {      print('Couldn\'t check connectivity status');      return;    }    return _updateConnectionStatus(result);  }  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {    _connectionStatus = result;    bool isConnected = _connectionStatus.contains(ConnectivityResult.mobile) ||        _connectionStatus.contains(ConnectivityResult.wifi);    print('Connectivity changed: $_connectionStatus');    _networkStatusController.sink.add(isConnected);  }  void dispose() {    _connectivitySubscription.cancel();    _networkStatusController.close();  }}class NetworkAwareWidget extends StatelessWidget {  final NetworkService networkService;  final Widget child;  const NetworkAwareWidget(      {super.key, required this.networkService, required this.child});  @override  Widget build(BuildContext context) {    return StreamBuilder<bool>(      stream: networkService.networkStatusStream,      initialData: true,      builder: (context, snapshot) {        if (snapshot.data == false) {          return const Scaffold(            body: Center(              child: Column(                mainAxisAlignment: MainAxisAlignment.center,                children: [                  Icon(                    Icons.wifi_off,                    size: 100,                    color: Colors.grey,                  ),                  SizedBox(height: 20),                  Text(                    'No internet connection',                    style: TextStyle(                      fontSize: 20,                      color: Colors.grey,                    ),                  ),                ],              ),            ),          );        }        return child;      },    );  }}