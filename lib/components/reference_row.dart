import 'package:flutter/material.dart';
import 'package:memorare/state/colors.dart';
import 'package:memorare/types/reference.dart';

import '../screens/reference_page.dart';

class ReferenceRow extends StatefulWidget {
  final Reference reference;

  final Function itemBuilder;
  final Function onSelected;

  ReferenceRow({
    this.reference,
    this.itemBuilder,
    this.onSelected,
  });

  @override
  _ReferenceRowState createState() => _ReferenceRowState();
}

class _ReferenceRowState extends State<ReferenceRow> {
  double elevation = 0.0;
  Color iconColor;
  Color iconHoverColor;

  @override
  initState() {
    super.initState();

    setState(() {
      iconHoverColor = stateColors.primary;
    });
  }

  @override
  Widget build(BuildContext context) {
    final reference = widget.reference;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 70.0,
        vertical: 30.0,
      ),
      child: Card(
        elevation: elevation,
        color: stateColors.appBackground,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => ReferencePage(id: reference.id)),
            );
          },
          onHover: (isHover) {
            elevation = isHover ? 2.0 : 0.0;

            iconColor = isHover ? iconHoverColor : null;

            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                avatar(reference),
                title(reference),
                actions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget actions() {
    return SizedBox(
      width: 50.0,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PopupMenuButton<String>(
            icon: Opacity(
              opacity: .6,
              child: iconColor != null
                  ? Icon(
                      Icons.more_vert,
                      color: iconColor,
                    )
                  : Icon(Icons.more_vert),
            ),
            onSelected: widget.onSelected,
            itemBuilder: widget.itemBuilder,
          ),
        ],
      ),
    );
  }

  Widget avatar(Reference reference) {
    final isImageOk = reference.urls.image?.isNotEmpty;

    if (!isImageOk) {
      return Padding(padding: EdgeInsets.zero);
    }

    return Padding(
        padding: const EdgeInsets.only(right: 40.0),
        child: Card(
          elevation: 4.0,
          child: Opacity(
            opacity: elevation > 0.0 ? 1.0 : 0.5,
            child: Image.network(
              reference.urls.image,
              width: 80.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
          ),
        ));
  }

  Widget title(Reference reference) {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            reference.name,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          Padding(padding: const EdgeInsets.only(top: 10.0)),
          if (reference.type?.primary?.isNotEmpty)
            FlatButton.icon(
              onPressed: () {},
              icon: Icon(Icons.filter_1),
              label: Text(
                reference.type.primary,
              ),
            ),
        ],
      ),
    );
  }
}
