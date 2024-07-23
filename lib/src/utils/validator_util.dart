import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';

var duration = const Duration(milliseconds: 300);

bool emailValid(String email) {
  final RegExp regex = RegExp(r"^(([^<>()[\]\\.,;:\s@\']+(\.[^<>()[\]\\.,;:\s@\']+)*)|(\'.+\'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$");
  return regex.hasMatch(email);
}

class EasyCompValid {
  static StringValidationCallback cpf([String? message = "CPF inválido"]) => ValidatorUtil().cpf(message).build();
  static StringValidationCallback cnpj([String? message = "CNPJ inválido"]) => ValidatorUtil().cnpj(message).build();
  static StringValidationCallback cpfOuCnpj([String? message = "Documento inválido"]) => ValidatorUtil().cpfOuCnpj(message).build();
  static StringValidationCallback email([String? message = "E-mail inválido"]) => ValidatorUtil().email(message).build();
  static StringValidationCallback required([String? message = "Campo requerido"]) => ValidatorUtil().required(message).build();
  static StringValidationCallback minLength(int minLength, [String? message = "Tamanho inválido"]) => ValidatorUtil().minLength(minLength, message).build();
  static StringValidationCallback maxLength(int maxLength, [String? message = "Tamanho inválido"]) => ValidatorUtil().maxLength(maxLength, message).build();
  static StringValidationCallback compareController(TextEditingController to, TextEditingController compareTo, [String? message = "Campo divergente"]) => ValidatorUtil()
      .compareController(
        to,
        compareTo,
        message,
      )
      .build();
  static StringValidationCallback compareString(String to, String compareTo, [String? message = "Campo divergente"]) => ValidatorUtil()
      .compareString(
        to,
        compareTo,
        message,
      )
      .build();
  static StringValidationCallback custom({
    bool Function(String?)? valide,
    String? message = "Inválido",
  }) =>
      ValidatorUtil()
          .custom(
            valide: valide,
            message: message,
          )
          .build();

  static StringValidationCallback multiples(List<StringValidationCallback> validations) {
    return (v) {
      for (var validate in validations) {
        final result = validate(v);
        if (result != null) {
          return result;
        }
      }
      return null;
    };
  }
}

class ValidatorUtil {
  ValidatorUtil({
    this.optional = false,
    this.isFuture = false,
  });

  final List<StringValidationCallback> validations = [];
  final List<StringValidationCallbackFuture> validationsF = [];
  final bool optional;
  final bool isFuture;

  /// Adds new item to [validations] list, returns this instance
  ValidatorUtil _add(StringValidationCallback validator) {
    validations.add(validator);
    return this;
  }

  ValidatorUtil _addF(StringValidationCallbackFuture validator) {
    validationsF.add(validator);
    return this;
  }

  /// Tests [value] against defined [validations]
  String? _test(String? value) {
    for (var validate in validations) {
      if (optional && (value == null || value.isEmpty)) {
        return null;
      }
      final result = validate(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  Future<String?> _testF(String? value) async {
    for (var validate in validationsF) {
      if (optional && (value == null || value.isEmpty)) {
        return Future.value(null);
      }
      final result = await validate(value);
      if (result != null) {
        return Future.value(result);
      }
    }
    return Future.value(null);
  }

  /// Returns a validator function for FormInput
  StringValidationCallback build() => _test;

  StringValidationCallbackFuture buildFuture() => _testF;

  /// Value must not be null or empty
  ValidatorUtil required([String? message = "Campo requerido"]) =>
      isFuture ? _addF((v) => Future.delayed(duration, () => (v == null || v.isEmpty)).then((value) => value ? message : null)) : _add((v) => (v == null || v.isEmpty) ? message : null);

  /// Value length must be greater than or equal to [minLength]
  ValidatorUtil minLength(int minLength, [String? message = "Tamanho inválido"]) =>
      isFuture ? _addF((v) => Future.delayed(duration, () => v!.length < minLength).then((value) => value ? message : null)) : _add((v) => v!.length < minLength ? message : null);

  /// Value length must be less than or equal to [maxLength]
  ValidatorUtil maxLength(int maxLength, [String? message = "Tamanho inválido"]) =>
      isFuture ? _addF((v) => Future.delayed(duration, () => v!.length > maxLength).then((value) => value ? message : null)) : _add((v) => v!.length > maxLength ? message : null);

  ValidatorUtil email([String? message = "E-mail inválido"]) {
    return isFuture ? _addF((v) => Future.delayed(duration, () => !emailValid(v!)).then((value) => value ? message : null)) : _add((v) => !emailValid(v!) ? message : null);
  }

  ValidatorUtil compareController(TextEditingController to, TextEditingController compareTo, [String? message = "Campo divergente"]) {
    return isFuture ? _addF((v) => Future.delayed(duration, () => (to.text != compareTo.text)).then((value) => value ? message : null)) : _add((v) => (to.text != compareTo.text) ? message : null);
  }

  ValidatorUtil compareString(String to, String compareTo, [String? message = "Campo divergente"]) {
    return isFuture ? _addF((v) => Future.delayed(duration, () => (to != compareTo)).then((value) => value ? message : null)) : _add((v) => (to != compareTo) ? message : null);
  }

  ValidatorUtil cpf([String? message = "CPF inválido"]) =>
      isFuture ? _addF((v) => Future.delayed(duration, () => !CPFValidator.isValid(v)).then((value) => value ? message : null)) : _add((v) => !CPFValidator.isValid(v) ? message : null);

  ValidatorUtil cnpj([String? message = "CNPJ inválido"]) =>
      isFuture ? _addF((v) => Future.delayed(duration, () => !CNPJValidator.isValid(v)).then((value) => value ? message : null)) : _add((v) => !CNPJValidator.isValid(v) ? message : null);

  ValidatorUtil cpfOuCnpj([String? message = "Documento inválido"]) => isFuture ? _addF((v) => /*Future.delayed(duration, () => valideCpfOuCnpj(v!))*/
      Future.value(valideCpfOuCnpj(v!)).then((value) => value ? message : null)) : _add((v) => valideCpfOuCnpj(v!) ? message : null);

  ValidatorUtil custom({
    Future<bool> Function(String?)? future,
    bool Function(String?)? valide,
    String? message = "Inválido",
  }) =>
      isFuture
          ? _addF((v) => future == null ? Future.delayed(const Duration(milliseconds: 500), () => null) : future(v).then((value) => value ? message : null))
          : _add((v) => valide == null
              ? null
              : valide(v)
                  ? message
                  : null);
}

bool valideCpfOuCnpj(String value) {
  var v = value.replaceAll(".", "").replaceAll("-", "").replaceAll("/", "");
  if (v.length <= 11) {
    return !CPFValidator.isValid(v);
  } else {
    return !CNPJValidator.isValid(v);
  }
}

typedef StringValidationCallback = String? Function(String? value);
typedef StringValidationCallbackFuture = Future<String?> Function(String? value);
