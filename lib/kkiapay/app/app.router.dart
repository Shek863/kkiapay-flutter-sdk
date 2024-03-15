// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i3;
import 'package:flutter/material.dart';
import 'package:kkiapay_flutter_sdk/kkiapay/view/widget_builder_view.dart'
    as _i2;
import 'package:kkiapay_flutter_sdk/utils/kkiapayConf.sample.dart' as _i4;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i5;

class Routes {
  static const kKiaPay = '/k-kia-pay';

  static const all = <String>{kKiaPay};
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.kKiaPay,
      page: _i2.KKiaPay,
    )
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.KKiaPay: (data) {
      final args = data.getArgs<KKiaPayArguments>(nullOk: false);
      return _i3.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.KKiaPay(
            key: args.key,
            amount: args.amount,
            phone: args.phone,
            data: args.data,
            paymentMethod: args.paymentMethod,
            sandbox: args.sandbox,
            apikey: args.apikey,
            callback: args.callback,
            theme: args.theme,
            name: args.name,
            email: args.email),
        settings: data,
      );
    }
  };

  @override
  List<_i1.RouteDef> get routes => _routes;
  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class KKiaPayArguments {
  const KKiaPayArguments({
    this.key,
    required this.amount,
    this.phone,
    this.data,
    this.paymentMethod,
    this.sandbox,
    required this.apikey,
    required this.callback,
    this.theme,
    this.name,
    this.email,
  });

  final _i3.Key? key;

  final int amount;

  final String? phone;

  final String? data;

  final _i4.PaymentMethod? paymentMethod;

  final bool? sandbox;

  final String? apikey;

  final dynamic Function(
    Map<String, dynamic>,
    _i3.BuildContext,
  ) callback;

  final String? theme;

  final String? name;

  final String? email;

  @override
  String toString() {
    return '{"key": "$key", "amount": "$amount", "phone": "$phone", "data": "$data", "paymentMethod": "$paymentMethod", "sandbox": "$sandbox", "apikey": "$apikey", "callback": "$callback", "theme": "$theme", "name": "$name", "email": "$email"}';
  }

  @override
  bool operator ==(covariant KKiaPayArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.amount == amount &&
        other.phone == phone &&
        other.data == data &&
        other.paymentMethod == paymentMethod &&
        other.sandbox == sandbox &&
        other.apikey == apikey &&
        other.callback == callback &&
        other.theme == theme &&
        other.name == name &&
        other.email == email;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        amount.hashCode ^
        phone.hashCode ^
        data.hashCode ^
        paymentMethod.hashCode ^
        sandbox.hashCode ^
        apikey.hashCode ^
        callback.hashCode ^
        theme.hashCode ^
        name.hashCode ^
        email.hashCode;
  }
}

extension NavigatorStateExtension on _i5.NavigationService {
  Future<dynamic> navigateToKKiaPay({
    _i3.Key? key,
    required int amount,
    String? phone,
    String? data,
    _i4.PaymentMethod? paymentMethod,
    bool? sandbox,
    required String? apikey,
    required dynamic Function(
      Map<String, dynamic>,
      _i3.BuildContext,
    ) callback,
    String? theme,
    String? name,
    String? email,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.kKiaPay,
        arguments: KKiaPayArguments(
            key: key,
            amount: amount,
            phone: phone,
            data: data,
            paymentMethod: paymentMethod,
            sandbox: sandbox,
            apikey: apikey,
            callback: callback,
            theme: theme,
            name: name,
            email: email),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithKKiaPay({
    _i3.Key? key,
    required int amount,
    String? phone,
    String? data,
    _i4.PaymentMethod? paymentMethod,
    bool? sandbox,
    required String? apikey,
    required dynamic Function(
      Map<String, dynamic>,
      _i3.BuildContext,
    ) callback,
    String? theme,
    String? name,
    String? email,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.kKiaPay,
        arguments: KKiaPayArguments(
            key: key,
            amount: amount,
            phone: phone,
            data: data,
            paymentMethod: paymentMethod,
            sandbox: sandbox,
            apikey: apikey,
            callback: callback,
            theme: theme,
            name: name,
            email: email),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
