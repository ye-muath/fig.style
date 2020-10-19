import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:memorare/components/fade_in_y.dart';
import 'package:memorare/screens/add_quote/author.dart';
import 'package:memorare/data/add_quote_inputs.dart';
import 'package:memorare/state/colors.dart';
import 'package:memorare/state/topics_colors.dart';

class AddQuoteTopics extends StatefulWidget {
  @override
  _AddQuoteTopicsState createState() => _AddQuoteTopicsState();
}

class _AddQuoteTopicsState extends State<AddQuoteTopics> {
  FocusNode keyboardFocusNode;

  @override
  void initState() {
    super.initState();
    keyboardFocusNode = FocusNode();
  }

  @override
  void dispose() {
    if (keyboardFocusNode != null) {
      keyboardFocusNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: keyboardFocusNode,
      onKey: keyHandler,
      child: topics(),
    );
  }

  Widget clearButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: FlatButton.icon(
          onPressed: () {
            setState(() => AddQuoteInputs.clearTopics());
          },
          icon: Opacity(
            opacity: 0.6,
            child: Icon(Icons.clear),
          ),
          label: Opacity(
            opacity: 0.6,
            child: Text(
              'Clear all selected',
            ),
          )),
    );
  }

  Widget topics() {
    return Column(
      children: <Widget>[
        FadeInY(
          beginY: 10.0,
          delay: 0,
          child: Opacity(
            opacity: .6,
            child: Text(
              'Select some of the available topics to categorize the quote.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
        ),
        FadeInY(
          beginY: 10.0,
          delay: 0.5,
          child: clearButton(),
        ),
        Observer(builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 60.0),
            child: Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: appTopicsColors.topicsColors.map<Widget>((topicColor) {
                final name = topicColor.name;
                final selected =
                    AddQuoteInputs.quote.topics.contains(topicColor.name);

                return ChoiceChip(
                  label: Text(
                    name,
                    style: TextStyle(
                      color: selected ? Colors.white : stateColors.foreground,
                    ),
                  ),
                  selectedColor: Color(topicColor.decimal),
                  selected: selected,
                  onSelected: (bool selected) {
                    setState(() {
                      selected
                          ? AddQuoteInputs.quote.topics.add(topicColor.name)
                          : AddQuoteInputs.quote.topics.remove(topicColor.name);
                    });
                  },
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

  void keyHandler(RawKeyEvent keyEvent) {
    if (keyEvent.runtimeType.toString() == 'RawKeyDownEvent') {
      return;
    }

    if (keyEvent.logicalKey.keyId == LogicalKeyboardKey.enter.keyId) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => AddQuoteAuthor()));
      return;
    }
  }
}
