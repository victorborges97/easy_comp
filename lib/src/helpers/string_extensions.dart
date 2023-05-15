extension StringExtension on String {
  String get capitalize {
    var str = this;
    return "${str[0].toUpperCase()}${str.substring(1)}";
  }

  String replaceWhiteSpaces(String replace) {
    String comAcentos = "ÄÅÁÂÀÃäáâàãÉÊËÈéêëèÍÎÏÌíîïìÖÓÔÒÕöóôòõÜÚÛüúûùÇç";
    String semAcentos = "AAAAAAaaaaaEEEEeeeeIIIIiiiiOOOOOoooooUUUuuuuCc";
    var s = this;
    String r = s.toLowerCase();
    for (int i = 0; i < comAcentos.length; i++) {
      r = r.replaceAll(comAcentos[i].toString(), semAcentos[i].toString());
    }
    return r.replaceAll(' ', replace);
  }

  String get replaceAcentos {
    String comAcentos = "ÄÅÁÂÀÃäáâàãÉÊËÈéêëèÍÎÏÌíîïìÖÓÔÒÕöóôòõÜÚÛüúûùÇç";
    String semAcentos = "AAAAAAaaaaaEEEEeeeeIIIIiiiiOOOOOoooooUUUuuuuCc";
    var s = this;
    String r = s.toLowerCase();
    for (int i = 0; i < comAcentos.length; i++) {
      r = r.replaceAll(comAcentos[i].toString(), semAcentos[i].toString());
    }
    return r;
  }

  //
}
