import 'package:easy_comp/src/widgets/easy_comp_input.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class EasyCompInputCalendar extends StatefulWidget {
  final bool multiplos;
  final String? labelText;
  final String? formatter;
  final Function(DateTime)? onChange1;
  final Function(DateTime, DateTime)? onChange2;

  const EasyCompInputCalendar({super.key, this.labelText, this.formatter, required Function(DateTime) onChange})
      : multiplos = false,
        onChange1 = onChange,
        onChange2 = null;

  const EasyCompInputCalendar.multiplos({super.key, this.labelText, this.formatter, required Function(DateTime, DateTime) onChange})
      : multiplos = true,
        onChange1 = null,
        onChange2 = onChange;
  @override
  State<EasyCompInputCalendar> createState() => _EasyCompInputCalendarState();
}

class _EasyCompInputCalendarState extends State<EasyCompInputCalendar> {
  final _textEditingController = TextEditingController();
  final GlobalKey _textFieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  late final FocusNode _focusTextField;
  late final FocusNode _focusCalendar;

  @override
  void initState() {
    super.initState();
    _focusTextField = FocusNode();
    _focusCalendar = FocusNode();

    _focusTextField.addListener(() {
      if (!_focusTextField.hasFocus) {
        if (_overlayEntry != null) {
          hideOverlay();
        }
      }
    });
    // Adiciona um listener ao teclado para esconder o overlay quando o teclado estiver aberto
    // KeyboardVisibilityController().onChange.listen((bool visible) {
    //   if (visible) {
    //     hideOverlay();
    //   }
    // });
  }

  @override
  void dispose() {
    hideOverlay();
    _focusTextField.dispose();
    super.dispose();
  }

  void showOverlay() {
    // Cria o widget do calendário

    int ano = 2023;
    String mes = 'Maio';
    String errorMessage = '';

    String diaSelecionado1 = "";
    String diaSelecionado2 = "";
    String diaSelecionado3 = "";

    final PageController controllerPageView = PageController(initialPage: CalendarGen.month_names.toList().indexOf(mes));

    Widget calendar = Material(
      child: StatefulBuilder(
        builder: (context, set) {
          return Container(
            width: 300,
            height: 400,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 1,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 30,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_left),
                        splashRadius: 5,
                        onPressed: () {
                          print(controllerPageView.page!);
                          if (controllerPageView.page! <= 0) {
                            set(() {
                              ano--;
                            });
                            controllerPageView.animateToPage(12, duration: const Duration(milliseconds: 50), curve: Curves.fastOutSlowIn);
                          } else {
                            controllerPageView.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                          }
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: PageView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: controllerPageView,
                            onPageChanged: (int) {
                              set(() {
                                mes = CalendarGen.month_names.toList()[int];
                              });
                            },
                            pageSnapping: false,
                            scrollDirection: Axis.horizontal,
                            children: [
                              ...CalendarGen.month_names
                                  .map(
                                    (e) => Center(
                                      child: Text(
                                        "$e ${ano}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_right),
                        splashRadius: 5,
                        onPressed: () {
                          if (controllerPageView.page! >= 11) {
                            set(() {
                              ano++;
                            });
                            controllerPageView.animateToPage(0, duration: const Duration(milliseconds: 50), curve: Curves.fastOutSlowIn);
                          } else {
                            controllerPageView.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ...CalendarGen.semanaNames.map((e) => Center(child: Text(e))).toList(),
                      ...CalendarGen.tratarDiasEmpty(
                        CalendarGen.getDaysOfMonthByYear(CalendarGen.month_data[mes], ano),
                        CalendarGen.month_data[mes],
                        ano,
                      )
                          .map(
                            (e) => InkWell(
                              onTap: () {
                                if (e.dayMonthOld) {
                                  controllerPageView.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                                  return;
                                }
                                // 2 data
                                if (widget.multiplos) {
                                  if (diaSelecionado1.isEmpty && diaSelecionado2.isEmpty) {
                                    set(() {
                                      diaSelecionado1 = e.dia;
                                    });
                                  }
                                  //
                                  else if (diaSelecionado1.isNotEmpty && diaSelecionado2.isEmpty && diaSelecionado3.isEmpty) {
                                    set(() {
                                      diaSelecionado2 = e.dia;
                                    });

                                    final data1 = DateTime(ano, int.parse(CalendarGen.month_data[mes].toString()), int.parse(diaSelecionado1));
                                    final data2 = DateTime(ano, int.parse(CalendarGen.month_data[mes].toString()), int.parse(diaSelecionado2));
                                    _textEditingController.text = "${data1.day}/${data1.month}/${data1.year} - ${data2.day}/${data2.month}/${data2.year}";
                                    widget.onChange2!(data1, data2);

                                    diaSelecionado3 = "-";
                                  }
                                  //
                                  else if (diaSelecionado1.isNotEmpty && diaSelecionado2.isNotEmpty && diaSelecionado3.isNotEmpty) {
                                    set(() {
                                      diaSelecionado1 = e.dia;
                                      diaSelecionado2 = "";
                                      diaSelecionado3 = "";
                                    });
                                  }
                                }
                                // 1 data
                                else {
                                  if (diaSelecionado1 != e.dia) {
                                    set(() {
                                      diaSelecionado1 = e.dia;
                                    });
                                    final data = DateTime(ano, int.parse(CalendarGen.month_data[mes].toString()), int.parse(diaSelecionado1));
                                    _textEditingController.text = "${data.day}/${data.month}/${data.year}";
                                    if (diaSelecionado1.isNotEmpty) widget.onChange1!(data);
                                  }

                                  if (errorMessage.isNotEmpty) {
                                    set(() {
                                      errorMessage = "";
                                    });
                                  }
                                }
                              },
                              child: Builder(builder: (context) {
                                return Container(
                                  decoration: dbox(diaSelecionado1, diaSelecionado2, e, ano, CalendarGen.month_data[mes]!),
                                  child: Center(
                                    child: Text(
                                      e.dia,
                                      style: stext(diaSelecionado1, diaSelecionado2, e, ano, CalendarGen.month_data[mes]!),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
                Visibility(
                  visible: errorMessage.isNotEmpty,
                  child: Text(
                    errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (widget.multiplos) {
                          if (diaSelecionado1.isEmpty && diaSelecionado2.isEmpty) {
                            set(() {
                              errorMessage = "Selecione duas datas.";
                            });
                            Future.delayed(
                                const Duration(seconds: 2),
                                () => set(() {
                                      errorMessage = "";
                                    }));
                            return;
                          } else if (diaSelecionado1.isNotEmpty && diaSelecionado2.isEmpty) {
                            set(() {
                              errorMessage = "Selecione a 2º data.";
                            });
                            Future.delayed(
                                const Duration(seconds: 2),
                                () => set(() {
                                      errorMessage = "";
                                    }));
                            return;
                          } else if (diaSelecionado2.isNotEmpty && diaSelecionado1.isEmpty) {
                            set(() {
                              errorMessage = "Selecione a 1º data.";
                            });
                            Future.delayed(
                                const Duration(seconds: 2),
                                () => set(() {
                                      errorMessage = "";
                                    }));
                            return;
                          }
                        }
                        //
                        else {
                          if (diaSelecionado1.isEmpty) {
                            set(() {
                              errorMessage = "Selecione um data.";
                            });
                            Future.delayed(
                                const Duration(seconds: 2),
                                () => set(() {
                                      errorMessage = "";
                                    }));
                            return;
                          }
                        }

                        hideOverlay();
                      },
                      child: const Text("Confirmar"),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );

    // Cria o OverlayEntry
    _overlayEntry = OverlayEntry(builder: (context) {
      // Calcula a posição do OverlayEntry
      final RenderBox textFieldBox = _textFieldKey.currentContext!.findRenderObject() as RenderBox;
      final textFieldOffset = textFieldBox.localToGlobal(Offset.zero);
      final textFieldSize = textFieldBox.size;
      const double overlayWidth = 300;
      const double overlayHeight = 360;
      final double x = textFieldOffset.dx + textFieldSize.width - overlayWidth;
      final double y = textFieldOffset.dy + textFieldSize.height;

      // Cria o widget do OverlayEntry
      return Positioned(
        left: x,
        top: y + 8,
        width: overlayWidth,
        height: overlayHeight,
        child: calendar,
      );
    });

    // Adiciona o OverlayEntry ao Overlay do contexto
    Overlay.of(context).insert(_overlayEntry!);
  }

  void hideOverlay() {
    // Remove o OverlayEntry
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  BoxDecoration dbox(String diaSelecionado1, String diaSelecionado2, DiaData e, int anoSelecionado, int mes) {
    if (e.dia.trim().isEmpty) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      );
    }
    bool anoEmesOk = e.ano == anoSelecionado && e.month == mes;
    if (widget.multiplos) {
      bool valoresOk = diaSelecionado1.isNotEmpty && diaSelecionado2.isNotEmpty;

      return BoxDecoration(
        color: valoresOk && anoEmesOk && isValueInRange(int.parse(e.dia), int.parse(diaSelecionado1), int.parse(diaSelecionado2))
            ? Theme.of(context).primaryColor.withOpacity(0.8)
            : (diaSelecionado1 == e.dia && anoEmesOk)
                ? Theme.of(context).primaryColor.withOpacity(0.8)
                : e.isToday
                    ? Theme.of(context).primaryColor
                    : null,
        borderRadius: BorderRadius.circular(5),
      );
    } else {
      return BoxDecoration(
        color: (diaSelecionado1 == e.dia && anoEmesOk)
            ? Theme.of(context).primaryColor.withOpacity(0.8)
            : e.isToday
                ? Theme.of(context).primaryColor
                : null,
        borderRadius: BorderRadius.circular(5),
      );
    }
  }

  TextStyle stext(String diaSelecionado1, String diaSelecionado2, DiaData e, int anoSelecionado, int mes) {
    if (e.dia.trim().isEmpty) {
      return const TextStyle();
    }

    if (widget.multiplos) {
      bool valoresOk = diaSelecionado1.isNotEmpty && diaSelecionado2.isNotEmpty;
      bool anoEmesOk = e.ano == anoSelecionado && e.month == mes;

      return TextStyle(
        color: e.isToday || (valoresOk && anoEmesOk && isValueInRange(int.parse(e.dia), int.parse(diaSelecionado1), int.parse(diaSelecionado2)))
            ? Colors.white
            : e.dayMonthOld
                ? Colors.grey.shade600.withOpacity(0.8)
                : null,
      );
    } else {
      bool anoEmesOk = e.ano == anoSelecionado && e.month == mes;
      return TextStyle(
        color: e.isToday || (diaSelecionado1 == e.dia && anoEmesOk) ? Colors.white : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: EasyCompInput(
            focusNode: _focusTextField,
            key: _textFieldKey,
            controller: _textEditingController,
            labelText: widget.labelText ?? 'Data',
            icon: const Icon(Icons.calendar_month),
            // decoration: InputDecoration(
            //   labelText: widget.labelText ?? 'Data',
            //   suffixIcon: IconButton(
            //     onPressed: true
            //         ? null
            //         : () {
            //             if (_overlayEntry != null) {
            //               hideOverlay();
            //             } else {
            //               showOverlay();
            //             }
            //           },
            //     icon: const Icon(Icons.calendar_month),
            //   ),
            // ),
            onTap: () {
              if (_overlayEntry != null) {
                hideOverlay();
              } else {
                showOverlay();
              }
            },
          ),
        ),
      ],
    );
  }
}

class CalendarGen {
  static bool isLeapYear(num year) {
    return ((year % 4 == 0 && year % 100 != 0 && year % 400 != 0) || (year % 100 == 0 && year % 400 == 0));
  }

  static num getFebDays(num year) {
    return isLeapYear(year) ? 29 : 28;
  }

  static final month_names = month_data.keys;
  static final month_data = {
    'Janeiro': 1,
    'Fevereiro': 2,
    'Março': 3,
    'Abril': 4,
    'Maio': 5,
    'Junho': 6,
    'Julho': 7,
    'Agosto': 8,
    'Setembro': 9,
    'Outubro': 10,
    'Novembro': 11,
    'Dezembro': 12,
  };
  static List<dynamic> semanaNames = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab'];

  static List<DiaData> getDaysOfMonthByYear(month, year) {
    var monthIndex = month - 1;
    var daysOfMonth = [31, getFebDays(year), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    var currentDate = DateTime.now();
    var firstDay = DateTime(year, month);
    List<DiaData> mesDays = [];

    for (var i = 0; i <= (daysOfMonth[monthIndex] + (firstDay.weekday - 1)); i++) {
      var day = "  ";

      if (i >= firstDay.weekday) {
        var dia = i - firstDay.weekday + 1;
        day = dia.toString().padLeft(2, "0");
        if (dia == currentDate.day && year == currentDate.year && month == currentDate.month) {
          day = "${day.padLeft(2, "0")}+";
        }
      }

      if (firstDay.weekday == 7 && day == "  ") {
        print("first_day.weekday == 7 && day == " "");
      } else {
        mesDays.add(
          DiaData(
            dia: day.replaceAll("+", ""),
            ano: year,
            month: month,
            isToday: day.contains("+") ? true : false,
          ),
        );
      }
    }
    return mesDays;
  }

  static List<DiaData> tratarDiasEmpty(List<DiaData> mesDays, month, year) {
    final diasSemNada = mesDays.where((element) => element.dia.trim().isEmpty);

    //
    if (diasSemNada.isNotEmpty) {
      final diasDoMes = getDaysOfMonthByYear(month == 1 ? 12 : month - 1, year);

      final diasDoMesReversed = diasDoMes.reversed.toList().getRange(0, (diasSemNada.length)).toList();

      final diasDoMesAnterior = diasDoMesReversed.reversed.toList();

      if (diasDoMesAnterior.isNotEmpty) {
        for (var i = 0; i < mesDays.length; i++) {
          var dia = mesDays[i];
          if (dia.dia.trim().isEmpty) {
            mesDays[i] = dia.copyWith(
              dayMonthOld: true,
              dia: diasDoMesAnterior[i].dia,
              month: month == 1 ? 12 : month - 1,
              ano: year,
            );
          }
        }
      }
    }
    return mesDays;
  }

  static void printCalendar(List<dynamic> dias) {
    List<List<dynamic>> mes = [
      ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab']
    ];

    int i = 0;
    while (i < dias.length) {
      int finalIndex = i + 7 < dias.length ? i + 7 : dias.length;
      List<dynamic> subLista = dias.sublist(i, finalIndex);
      mes.add(subLista);
      i += 7;
    }
  }
}

class DiaData {
  String dia;
  int ano;
  int month;
  bool isToday;
  bool dayMonthOld;
  String id;

  DiaData({required this.dia, required this.ano, required this.month, this.isToday = false, this.dayMonthOld = false, String? id}) : id = id ?? const Uuid().v4();

  DiaData copyWith({
    String? dia,
    bool? isToday,
    bool? dayMonthOld,
    String? id,
    int? ano,
    int? month,
  }) {
    return DiaData(
      dia: dia ?? this.dia,
      ano: ano ?? this.ano,
      month: month ?? this.month,
      dayMonthOld: dayMonthOld ?? this.dayMonthOld,
      isToday: isToday ?? this.isToday,
      id: id ?? this.id,
    );
  }

  @override
  String toString() {
    return 'DiaData{ano: $ano, month: $month, dia: $dia, isToday: $isToday}';
  }
}

bool isValueInRange(int value, int minValue, int maxValue) {
  return value >= minValue && value <= maxValue;
}
