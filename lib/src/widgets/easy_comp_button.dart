import 'package:flutter/material.dart';

class EasyCompButton extends StatefulWidget {
  const EasyCompButton({
    super.key,
    this.onPressed,
    this.text,
    this.child,
    this.loadingColor = Colors.white,
    this.style,
    this.padding,
    this.contentPadding,
    this.primary,
    this.loading,
    this.width,
    this.height,
    this.bgColor,
    this.side,
    this.isRounded = true,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.clipBehavior = Clip.none,
    this.autofocus = false,
  });

  const EasyCompButton.grid({
    super.key,
    this.onPressed,
    this.text,
    this.child,
    this.loadingColor = Colors.white,
    this.style,
    this.padding = EdgeInsets.zero,
    this.contentPadding = const EdgeInsets.all(5),
    this.primary,
    this.loading,
    this.width = double.infinity,
    this.height = double.infinity,
    this.bgColor,
    this.side = BorderSide.none,
    this.isRounded = false,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.clipBehavior = Clip.none,
    this.autofocus = false,
  });

  final void Function()? onLongPress;
  final void Function(bool)? onHover;
  final void Function()? onPressed;
  final void Function(bool)? onFocusChange;
  final Clip clipBehavior;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? text;
  final Widget? child;
  final TextStyle? style;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;
  final Color? primary;
  final bool? loading;
  final Color loadingColor;
  final Color? bgColor;
  final double? width;
  final double? height;
  final BorderSide? side;
  final bool isRounded;

  @override
  State<EasyCompButton> createState() => _EasyCompButtonState();
}

class _EasyCompButtonState extends State<EasyCompButton> {
  bool confirmLoading() {
    if (widget.loading != null && widget.loading == true) {
      return true;
    } else {
      setState(() => isAnimated = false);
      return false;
    }
  }

  bool isAnimated = false;

  Widget buildButton() => InkWell(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: widget.loading == null ? Colors.black38 : null,
            backgroundColor: widget.primary ?? Theme.of(context).primaryColor,
            shape: widget.isRounded
                ? const StadiumBorder()
                : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
            padding: widget.contentPadding,
            side: widget.side,
          ),
          onPressed: widget.onPressed,
          onLongPress: widget.onLongPress,
          onHover: widget.onHover,
          onFocusChange: widget.onFocusChange,
          clipBehavior: widget.clipBehavior,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          child: widget.text != null
              ? FittedBox(
                  child: Text(
                    widget.text!,
                    style: widget.style ?? const TextStyle(fontSize: 18),
                  ),
                )
              : widget.child != null
                  ? widget.child!
                  : Container(),
        ),
      );

  Widget buildSmallButton() => Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: widget.primary ?? Theme.of(context).primaryColor),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(widget.loadingColor),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    double? widthContainer = widget.width ?? MediaQuery.of(context).size.width;

    Widget buildButtonNotLoading() => Container(
          alignment: Alignment.center,
          padding: widget.padding ?? const EdgeInsets.all(10),
          child: SizedBox(
            height: widget.height ?? 45,
            width: widthContainer,
            child: buildButton(),
          ),
        );

    Widget buildButtonLoading(BuildContext context, double? widthContainer) => Container(
          alignment: Alignment.center,
          // padding: const EdgeInsets.all(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            onEnd: () => setState(() => isAnimated = !isAnimated),
            height: widget.height ?? 45,
            width: confirmLoading() ? 45 : widthContainer!,
            child: isAnimated ? buildSmallButton() : buildButton(),
          ),
        );
    if (widget.loading == null) {
      return buildButtonNotLoading();
    } else {
      return buildButtonLoading(context, widthContainer);
    }
  }
}
