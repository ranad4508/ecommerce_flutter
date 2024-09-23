import 'package:money_formatter/money_formatter.dart';

class CurrencyFormatter{
   converter(double amount) {
    MoneyFormatter fmf = MoneyFormatter(amount: amount);

    MoneyFormatterOutput fo = fmf.output;
    return fo.withoutFractionDigits;
  }
}