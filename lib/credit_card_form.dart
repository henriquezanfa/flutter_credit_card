import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import 'credit_card_model.dart';

class CreditCardForm extends StatefulWidget {
  const CreditCardForm({
    Key key,
    this.cardNumber,
    this.expiryDate,
    this.cardHolderName,
    this.cvvCode,
    @required this.onCreditCardModelChange,
    this.themeColor,
    this.textColor = Colors.black,
    this.cursorColor,
  }) : super(key: key);

  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final void Function(CreditCardModel) onCreditCardModelChange;
  final Color themeColor;
  final Color textColor;
  final Color cursorColor;

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  String cardNumber;
  String expiryDate;
  String cardHolderName;
  String cvvCode;
  bool isCvvFocused = false;
  Color themeColor;

  void Function(CreditCardModel) onCreditCardModelChange;
  CreditCardModel creditCardModel;

  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _cvvCodeController =
      MaskedTextController(mask: '000');

  FocusNode cvvFocusNode = FocusNode();

  void textFieldFocusDidChange() {
    creditCardModel.isCvvFocused = cvvFocusNode.hasFocus;
    onCreditCardModelChange(creditCardModel);
  }

  void createCreditCardModel() {
    cardNumber = widget.cardNumber ?? '';
    expiryDate = widget.expiryDate ?? '';
    cardHolderName = widget.cardHolderName ?? '';
    cvvCode = widget.cvvCode ?? '';

    creditCardModel = CreditCardModel(
        cardNumber, expiryDate, cardHolderName, cvvCode, isCvvFocused);
  }

  void setInitialText() {
    _cardNumberController.text = creditCardModel.cardNumber ?? "";
    _expiryDateController.text = creditCardModel.expiryDate ?? "";
    _cardHolderNameController.text = creditCardModel.cardHolderName ?? "";
    _cvvCodeController.text = creditCardModel.cvvCode ?? "";
  }

  @override
  void initState() {
    super.initState();

    createCreditCardModel();
    setInitialText();

    onCreditCardModelChange = widget.onCreditCardModelChange;

    cvvFocusNode.addListener(textFieldFocusDidChange);

    _cardNumberController.addListener(() {
      setState(() {
        cardNumber = _cardNumberController.text;
        creditCardModel.cardNumber = cardNumber;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _expiryDateController.addListener(() {
      setState(() {
        expiryDate = _expiryDateController.text;
        creditCardModel.expiryDate = expiryDate;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cardHolderNameController.addListener(() {
      setState(() {
        cardHolderName = _cardHolderNameController.text;
        creditCardModel.cardHolderName = cardHolderName;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cvvCodeController.addListener(() {
      setState(() {
        cvvCode = _cvvCodeController.text;
        creditCardModel.cvvCode = cvvCode;
        onCreditCardModelChange(creditCardModel);
      });
    });
  }

  @override
  void didChangeDependencies() {
    themeColor = widget.themeColor ?? Theme.of(context).primaryColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: themeColor.withOpacity(0.8),
        primaryColorDark: themeColor,
      ),
      child: Form(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(4),
              child: TextFormField(
                maxLength: 19,
                controller: _cardNumberController,
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                  labelText: 'Número do cartão',
                  hintText: 'xxxx xxxx xxxx xxxx',
                  counterText: "",
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            Row(children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: TextFormField(
                    maxLength: 5,
                    controller: _expiryDateController,
                    cursorColor: widget.cursorColor ?? themeColor,
                    style: TextStyle(
                      color: widget.textColor,
                    ),
                    decoration: InputDecoration(
                      // border: OutlineInputBorder(),
                      labelText: 'Data de expiração',
                      hintText: 'MM/AA',
                      counterText: "",
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: TextField(
                    maxLength: 3,
                    focusNode: cvvFocusNode,
                    controller: _cvvCodeController,
                    cursorColor: widget.cursorColor ?? themeColor,
                    style: TextStyle(
                      color: widget.textColor,
                    ),
                    decoration: InputDecoration(
                      // border: OutlineInputBorder(),
                      labelText: 'CVV',
                      hintText: 'XXX',
                      counterText: "",
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onChanged: (String text) {
                      setState(() {
                        cvvCode = text;
                      });
                    },
                  ),
                ),
              ),
            ]),
            Container(
              padding: const EdgeInsets.all(4),
              child: TextFormField(
                controller: _cardHolderNameController,
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                  labelText: 'Nome',
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
