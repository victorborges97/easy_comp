import 'dart:async';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EasyCompInput extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final String? formatter;
  final Function(String)? onChange;
  final Function()? onInFocus;
  final Function()? onOutFocus;
  final EasyCompInputType? typeInput;
  final bool withValidation;

  // Future
  final Future<String?> Function(String)? validatorFuture;
  final String? Function(String)? validator;
  final Duration? validationDebounce;
  final TextEditingController? controller;
  final String isValidatingMessage;
  final String valueIsEmptyMessage;
  final String? valueIsInvalidMessage;

  //
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function()? onTap;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final List<TextInputFormatter>? inputFormatters;
  final Color? bgColor;
  final bool? readOnly;
  final bool? autofocus;
  final bool? disable;
  final bool? isPassword;
  final String? value;
  final AutovalidateMode? autovalidateMode;
  final Widget? icon;

  const EasyCompInput(
      {super.key,
      this.labelText,
      this.hintText,
      this.formatter,
      this.onChange,
      this.typeInput,
      // Future
      this.validator,
      this.validationDebounce,
      this.controller,
      this.isValidatingMessage = "Validando...",
      this.valueIsEmptyMessage = 'Por favor preencha algum valor',
      this.valueIsInvalidMessage = 'Por favor, insira um valor válido',
      //teste
      this.value,
      this.onTap,
      this.inputFormatters,
      this.onEditingComplete,
      this.onSaved,
      this.onFieldSubmitted,
      this.textInputAction,
      this.keyboardType,
      this.isPassword = false,
      this.autofocus = false,
      this.disable = false,
      this.withValidation = false,
      this.readOnly,
      this.bgColor,
      this.focusNode,
      this.autovalidateMode,
      this.icon,
      this.onInFocus,
      this.onOutFocus})
      : validatorFuture = null;

  const EasyCompInput.future(
      {super.key,
      this.labelText,
      this.hintText,
      this.formatter,
      this.onChange,
      this.typeInput,
      // Future
      Future<String?> Function(String)? validator,
      this.validationDebounce,
      this.controller,
      this.isValidatingMessage = "Validando...",
      this.valueIsEmptyMessage = 'Por favor preencha algum valor',
      this.valueIsInvalidMessage = 'Por favor, insira um valor válido',
      //teste
      this.value,
      this.onTap,
      this.onEditingComplete,
      this.onSaved,
      this.onFieldSubmitted,
      this.textInputAction,
      this.keyboardType,
      this.isPassword = false,
      this.autofocus = false,
      this.disable = false,
      this.withValidation = false,
      this.readOnly,
      this.bgColor,
      this.focusNode,
      this.inputFormatters,
      this.autovalidateMode,
      this.icon,
      this.onInFocus,
      this.onOutFocus})
      : validatorFuture = validator,
        validator = null;

  @override
  State<EasyCompInput> createState() => _EasyCompInputState();
}

class _EasyCompInputState extends State<EasyCompInput> {
  final GlobalKey _textFieldKey = GlobalKey();
  List<TextInputFormatter>? inputFormatters;
  EasyCompInputType? typeInput;
  TextInputType? keyboardType;
  String? hintText;
  Timer? _debounce;
  var isValidating = false;
  var isValid = false;
  var isDirty = false;
  var isWaiting = false;
  bool view = true;
  String? messageError = "";

  @override
  void initState() {
    messageError = widget.valueIsInvalidMessage;
    super.initState();

    keyboardType = widget.keyboardType;
    inputFormatters = widget.inputFormatters;
    typeInput = widget.typeInput;
    hintText = widget.hintText;

    if (typeInput != null) {
      if (typeInput == EasyCompInputType.cpf) {
        inputFormatters = [
          FilteringTextInputFormatter.digitsOnly,
          CpfInputFormatter(),
        ];
        keyboardType = TextInputType.number;
        hintText ??= "000.000.000-00";
      } else if (typeInput == EasyCompInputType.cpfOrCnpj) {
        inputFormatters = [
          FilteringTextInputFormatter.digitsOnly,
          CpfOuCnpjFormatter(),
        ];
        keyboardType = TextInputType.number;
        hintText ??= "000.000.000-00";
      } else if (typeInput == EasyCompInputType.cep) {
        inputFormatters = [
          FilteringTextInputFormatter.digitsOnly,
          CepInputFormatter(),
        ];
        keyboardType = TextInputType.number;
        hintText ??= "00.000-000";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sizeIcon = widget.isPassword != null && widget.isPassword == true ? 18.0 : 15.0;
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: widget.labelText != null ? 8.0 : 0),
              child: Focus(
                onFocusChange: (widget.onInFocus != null || widget.onOutFocus != null)
                    ? (foco) {
                        if (foco) {
                          widget.onInFocus!();
                        } else {
                          widget.onOutFocus!();
                        }
                      }
                    : null,
                child: TextFormField(
                  autovalidateMode: !widget.withValidation ? null : widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    dynamic res;
                    if (!widget.withValidation) return null;

                    if (isValidating) {
                      // res = widget.isValidatingMessage;
                    } else if (value?.isEmpty ?? false) {
                      res = widget.valueIsEmptyMessage;
                    } else if (!isValid && isDirty) {
                      res = messageError;
                    } else {
                      res = null;
                    }

                    return res;
                  },
                  key: _textFieldKey,
                  controller: widget.controller,
                  decoration: InputDecoration(
                    floatingLabelBehavior: widget.labelText != null ? FloatingLabelBehavior.always : null,
                    labelText: widget.labelText,
                    hintText: hintText,
                    prefixIcon: widget.icon,
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 30,
                    ),
                    suffixIcon: SizedBox(
                      height: sizeIcon,
                      width: sizeIcon,
                      child: _getSuffixIcon(),
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 30,
                    ),
                    fillColor: (widget.disable ?? false) ? Colors.grey.shade300 : widget.bgColor,
                  ),
                  onChanged: (text) async {
                    if (widget.withValidation) {
                      isDirty = true;
                      if (text.isEmpty) {
                        setState(() {
                          isValid = false;
                        });
                        cancelTimer();
                        widget.onChange!(text);
                        return;
                      }
                      isWaiting = true;
                      cancelTimer();
                      _debounce = Timer(
                        (widget.validationDebounce ?? const Duration(milliseconds: 500)),
                        () async {
                          isValid = await validate(text);
                          debugPrint("é valido($isValid)");
                          debugPrint("é valido(${!isValid && isDirty})");
                          isWaiting = false;

                          setState(() {});
                          isValidating = false;

                          if (isValid) {
                            widget.onChange!(text);
                          }
                        },
                      );
                    }
                    //
                    else {
                      widget.onChange!(text);
                    }
                  },
                  readOnly: widget.readOnly ?? false,
                  initialValue: widget.value,
                  obscureText: (widget.isPassword ?? false) ? view : false,
                  textInputAction: isValidating ? TextInputAction.none : widget.textInputAction,
                  keyboardType: keyboardType,
                  autofocus: widget.autofocus ?? false,
                  inputFormatters: inputFormatters,
                  onEditingComplete: widget.onEditingComplete,
                  onSaved: widget.onSaved,
                  onFieldSubmitted: widget.onFieldSubmitted,
                  onTap: widget.onTap,
                  enabled: !(widget.disable ?? false),
                  focusNode: widget.focusNode,
                ),
              ),
            ),
            if (widget.withValidation && isValidating)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                child: Row(
                  children: [
                    Text(
                      widget.isValidatingMessage,
                      style: TextStyle(
                        color: Theme.of(context).inputDecorationTheme.focusColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void cancelTimer() {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
  }

  Future<bool> validate(String text) async {
    try {
      setState(() {
        isValidating = true;
      });
      String? isValid;

      if (widget.validatorFuture != null && widget.validator == null) {
        isValid = await widget.validatorFuture!(text);
      } else if (widget.validator != null && widget.validatorFuture == null) {
        isValid = widget.validator!(text);
      }

      debugPrint("widget.validator($isValid)");

      if (isValid != null) {
        messageError = isValid;
      }
      debugPrint("messageError($messageError)");

      isValidating = false;
      return isValid == null;
    } catch (e) {
      if (isValidating) {
        isValidating = false;
      }

      if (e.toString().isNotEmpty) {
        messageError = e.toString();
      }
      debugPrint("messageError($messageError)");
      return false;
    }
  }

  Widget? _getSuffixIcon() {
    if (widget.isPassword != null && widget.isPassword == true) {
      return InkWell(
        onTap: () => setState(() {
          view = !view;
        }),
        child: Icon(
          view ? Icons.visibility_off : Icons.visibility,
          size: 15,
          color: Colors.grey,
        ),
      );
    }

    if (!widget.withValidation) {
      return null;
    }

    if (isValidating) {
      return const CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation(Colors.blue),
      );
    } else {
      if (!isValid && isDirty) {
        return const Icon(
          Icons.cancel,
          color: Colors.red,
          size: 13,
        );
      } else if (isValid) {
        return const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 13,
        );
      } else {
        return Container();
      }
    }
  }
}

enum EasyCompInputType {
  cpf,
  cpfOrCnpj,
  cep,
}
