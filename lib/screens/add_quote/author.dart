import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:memorare/components/circle_button.dart';
import 'package:memorare/components/fade_in_x.dart';
import 'package:memorare/components/fade_in_y.dart';
import 'package:memorare/components/data_quote_inputs.dart';
import 'package:memorare/state/colors.dart';
import 'package:memorare/types/author_suggestion.dart';
import 'package:memorare/utils/search.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:supercharged/supercharged.dart';

class AddQuoteAuthor extends StatefulWidget {
  @override
  _AddQuoteAuthorState createState() => _AddQuoteAuthorState();
}

class _AddQuoteAuthorState extends State<AddQuoteAuthor> {
  bool prefilledInputs = false;
  final double beginY = 10.0;

  final affiliateUrlController = TextEditingController();
  final amazonUrlController = TextEditingController();
  final facebookUrlController = TextEditingController();
  final nameController = TextEditingController();
  final instaController = TextEditingController();
  final jobController = TextEditingController();
  final summaryController = TextEditingController();
  final twitchUrlController = TextEditingController();
  final twitterUrlController = TextEditingController();
  final websiteUrlController = TextEditingController();
  final wikiUrlController = TextEditingController();
  final youtubeUrlController = TextEditingController();

  final bornCityController = TextEditingController();
  final bornCountryController = TextEditingController();
  final deathCityController = TextEditingController();
  final deathCountryController = TextEditingController();

  final linkInputController = TextEditingController();

  final nameFocusNode = FocusNode();
  final jobFocusNode = FocusNode();
  final summaryFocusNode = FocusNode();
  final bornCityFocusNode = FocusNode();
  final bornCountryFocusNode = FocusNode();
  final deathCityFocusNode = FocusNode();
  final deathCountryFocusNode = FocusNode();

  String tapToEditStr = 'Tap to edit';
  String tempImgUrl = '';

  Timer searchTimer;
  List<AuthorSuggestion> authorsSuggestions = [];

  @override
  void initState() {
    setState(() {
      affiliateUrlController.text = AddQuoteInputs.author.urls.affiliate;
      amazonUrlController.text = AddQuoteInputs.author.urls.amazon;
      facebookUrlController.text = AddQuoteInputs.author.urls.facebook;
      nameController.text = AddQuoteInputs.author.name;
      jobController.text = AddQuoteInputs.author.job;
      instaController.text = AddQuoteInputs.author.urls.instagram;
      summaryController.text = AddQuoteInputs.author.summary;
      twitchUrlController.text = AddQuoteInputs.author.urls.twitch;
      twitterUrlController.text = AddQuoteInputs.author.urls.twitter;
      websiteUrlController.text = AddQuoteInputs.author.urls.website;
      wikiUrlController.text = AddQuoteInputs.author.urls.wikipedia;
      youtubeUrlController.text = AddQuoteInputs.author.urls.youtube;
      bornCityController.text = AddQuoteInputs.author.born.city;
      bornCountryController.text = AddQuoteInputs.author.born.country;
      deathCityController.text = AddQuoteInputs.author.death.city;
      deathCountryController.text = AddQuoteInputs.author.death.country;
    });

    super.initState();
  }

  @override
  void dispose() {
    if (searchTimer != null) {
      searchTimer.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600.0,
      child: Column(
        children: <Widget>[
          avatar(),
          nameCardInput(),
          jobCardInput(),
          clearButton(),
          bornAndDeathCards(),
          FadeInY(
            delay: 0.6,
            beginY: beginY,
            child: summaryCardInput(),
          ),
          fictionalCharacterBox(),
          FadeInY(
            delay: 0.8,
            beginY: beginY,
            child: links(),
          ),
        ],
      ),
    );
  }

  Widget avatar() {
    return Material(
      elevation: AddQuoteInputs.author.urls.image.isEmpty ? 0.0 : 4.0,
      shape: CircleBorder(),
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: AddQuoteInputs.author.urls.image.isNotEmpty
          ? Ink.image(
              image: NetworkImage(AddQuoteInputs.author.urls.image),
              fit: BoxFit.cover,
              width: 150.0,
              height: 150.0,
              child: InkWell(
                onTap: prefilledInputs
                    ? showPrefilledAlert
                    : () => showAvatarDialog(),
              ),
            )
          : Ink(
              width: 150.0,
              height: 150.0,
              child: InkWell(
                onTap: prefilledInputs
                    ? showPrefilledAlert
                    : () => showAvatarDialog(),
                child: CircleAvatar(
                  child: Icon(
                    Icons.add,
                    size: 50.0,
                    color: stateColors.primary,
                  ),
                  backgroundColor: Colors.black12,
                  radius: 60.0,
                ),
              )),
    );
  }

  Widget bornAndDeathCards() {
    final born = AddQuoteInputs.author.born;
    final death = AddQuoteInputs.author.death;

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Wrap(
        spacing: 20.0,
        runSpacing: 20.0,
        children: [
          SizedBox(
            width: 150.0,
            child: Card(
              elevation: 0.0,
              child: InkWell(
                onTap: prefilledInputs
                    ? showPrefilledAlert
                    : () async {
                        await showCupertinoModalBottomSheet(
                            context: context,
                            builder: (context, scrollController) {
                              return bornInput(
                                  scrollController: scrollController);
                            });

                        setState(() {});
                      },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Opacity(
                            opacity: 0.6,
                            child: Text(
                              'Born',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            born != null && born.date != null
                                ? born.date.toLocal().toString().split(' ')[0]
                                : tapToEditStr,
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.hourglass_full),
                  ]),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 150.0,
            child: Card(
              elevation: 0.0,
              child: InkWell(
                onTap: prefilledInputs
                    ? showPrefilledAlert
                    : () async {
                        await showCupertinoModalBottomSheet(
                            context: context,
                            builder: (context, scrollController) {
                              return deathInput();
                            });

                        setState(() {});
                      },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Opacity(
                            opacity: 0.6,
                            child: Text(
                              'Death',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            death != null && death.date != null
                                ? death.date.toLocal().toString().split(' ')[0]
                                : tapToEditStr,
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.hourglass_empty),
                  ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bornInput({ScrollController scrollController}) {
    return Scaffold(
      body: ListView(
        physics: ClampingScrollPhysics(),
        controller: scrollController,
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleButton(
                      onTap: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        size: 20.0,
                        color: stateColors.primary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Opacity(
                              opacity: 0.6,
                              child: Text(
                                "Born",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "When and where this author was born?",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                StatefulBuilder(builder: (context, childSetState) {
                  var selectedDate = AddQuoteInputs.author.born.date;

                  return Padding(
                    padding: EdgeInsets.only(top: 60.0),
                    child: Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialEntryMode: DatePickerEntryMode.input,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime(0),
                              lastDate: DateTime.now(),
                            );

                            childSetState(
                                () => AddQuoteInputs.author.born.date = picked);
                          },
                          icon: Icon(Icons.calendar_today),
                          label: Text(selectedDate != null
                              ? selectedDate.toLocal().toString().split(' ')[0]
                              : 'Select a new date'),
                        ),
                        SizedBox(
                          width: 400.0,
                          child: CheckboxListTile(
                            title: Text('Before J-C (Jesus Christ)'),
                            subtitle: Text('(e.g. year -500)'),
                            value: AddQuoteInputs.author.born.beforeJC,
                            onChanged: (newValue) {
                              childSetState(() => AddQuoteInputs
                                  .author.born.beforeJC = newValue);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: TextField(
                    controller: bornCountryController,
                    focusNode: bornCountryFocusNode,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      icon: Icon(Icons.flag_outlined),
                      labelText: "Country (e.g. Italy)",
                    ),
                    minLines: 1,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    onChanged: (newValue) {
                      AddQuoteInputs.author.born.country = newValue;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: TextField(
                    controller: bornCityController,
                    focusNode: bornCityFocusNode,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      icon: Icon(Icons.pin_drop),
                      labelText: "City (e.g. Rome)",
                    ),
                    minLines: 1,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    onChanged: (newValue) {
                      AddQuoteInputs.author.born.city = newValue;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left: 40.0,
                  ),
                  child: Wrap(
                    spacing: 20.0,
                    runSpacing: 20.0,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          AddQuoteInputs.author.born.city = '';
                          AddQuoteInputs.author.born.country = '';
                          AddQuoteInputs.author.born.date = null;

                          bornCityController.clear();
                          bornCountryController.clear();
                          bornCityFocusNode.requestFocus();
                        },
                        icon: Opacity(
                          opacity: 0.6,
                          child: Icon(Icons.delete_sweep),
                        ),
                        label: Opacity(
                          opacity: 0.8,
                          child: Text(
                            'Clear inputs',
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          primary: stateColors.foreground,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Opacity(
                          opacity: 0.6,
                          child: Icon(Icons.check),
                        ),
                        label: Opacity(
                          opacity: 0.8,
                          child: Text(
                            'Save',
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          primary: stateColors.foreground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget clearButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: FlatButton.icon(
        onPressed: () {
          AddQuoteInputs.clearAuthor();

          amazonUrlController.clear();
          facebookUrlController.clear();
          jobController.clear();
          nameController.clear();
          summaryController.clear();
          twitchUrlController.clear();
          twitterUrlController.clear();
          websiteUrlController.clear();
          wikiUrlController.clear();
          youtubeUrlController.clear();

          authorsSuggestions.clear();

          prefilledInputs = false;
          tapToEditStr = 'Tap to edit';

          setState(() {});

          nameFocusNode.requestFocus();
        },
        icon: Opacity(opacity: 0.6, child: Icon(Icons.clear)),
        label: Opacity(
          opacity: 0.6,
          child: Text(
            'Clear all inputs',
          ),
        ),
      ),
    );
  }

  Widget deathInput({ScrollController scrollController}) {
    return Scaffold(
      body: ListView(
        physics: ClampingScrollPhysics(),
        controller: scrollController,
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleButton(
                      onTap: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        size: 20.0,
                        color: stateColors.primary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Opacity(
                              opacity: 0.6,
                              child: Text(
                                "Death",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "When and where this author died?",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                StatefulBuilder(builder: (context, childSetState) {
                  final selectedDate = AddQuoteInputs.author.death.date;
                  return Padding(
                    padding: EdgeInsets.only(top: 60.0),
                    child: Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialEntryMode: DatePickerEntryMode.input,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime(0),
                              lastDate: DateTime.now(),
                            );

                            childSetState(() =>
                                AddQuoteInputs.author.death.date = picked);
                          },
                          icon: Icon(Icons.calendar_today),
                          label: Text(selectedDate != null
                              ? selectedDate.toLocal().toString().split(' ')[0]
                              : 'Select a new date'),
                        ),
                        SizedBox(
                          width: 400.0,
                          child: CheckboxListTile(
                            title: Text('Before J-C (Jesus Christ)'),
                            subtitle: Text('(e.g. year -500)'),
                            value: AddQuoteInputs.author.death.beforeJC,
                            onChanged: (newValue) {
                              childSetState(() => AddQuoteInputs
                                  .author.death.beforeJC = newValue);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: TextField(
                    controller: deathCountryController,
                    focusNode: deathCountryFocusNode,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      icon: Icon(Icons.flag_outlined),
                      labelText: "Country (e.g. Italy)",
                    ),
                    minLines: 1,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    onChanged: (newValue) {
                      AddQuoteInputs.author.death.country = newValue;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: TextField(
                    controller: deathCityController,
                    focusNode: deathCityFocusNode,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      icon: Icon(Icons.pin_drop),
                      labelText: "City (e.g. Rome)",
                    ),
                    minLines: 1,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    onChanged: (newValue) {
                      AddQuoteInputs.author.death.city = newValue;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left: 40.0,
                  ),
                  child: Wrap(
                    spacing: 20.0,
                    runSpacing: 20.0,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          AddQuoteInputs.author.death.city = '';
                          AddQuoteInputs.author.death.country = '';
                          AddQuoteInputs.author.death.date = null;

                          deathCityController.clear();
                          deathCountryController.clear();
                          deathCityFocusNode.requestFocus();
                        },
                        icon: Opacity(
                          opacity: 0.6,
                          child: Icon(Icons.delete_sweep),
                        ),
                        label: Opacity(
                          opacity: 0.8,
                          child: Text(
                            'Clear inputs',
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          primary: stateColors.foreground,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Opacity(
                          opacity: 0.6,
                          child: Icon(Icons.check),
                        ),
                        label: Opacity(
                          opacity: 0.8,
                          child: Text(
                            'Save',
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          primary: stateColors.foreground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget fictionalCharacterBox() {
    return Container(
      width: 400.0,
      padding: const EdgeInsets.only(bottom: 32.0),
      child: CheckboxListTile(
        title: Text('is fictional?'),
        subtitle: Text(
            "If true, a reference's id property will be added to this author."),
        value: AddQuoteInputs.author.isFictional,
        onChanged: prefilledInputs
            ? null
            : (newValue) {
                setState(() {
                  AddQuoteInputs.author.isFictional = newValue;
                });
              },
      ),
    );
  }

  Widget jobCardInput() {
    final job = AddQuoteInputs.author.job;

    return SizedBox(
      width: 250.0,
      child: Card(
        elevation: 2.0,
        child: InkWell(
          onTap: prefilledInputs
              ? showPrefilledAlert
              : () async {
                  await showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context, scrollController) {
                        return jobInput();
                      });

                  setState(() {});
                },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Opacity(
                      opacity: 0.6,
                      child: Text(
                        'Job',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      job != null && job.isNotEmpty ? job : tapToEditStr,
                    ),
                  ],
                ),
              ),
              Icon(Icons.work),
            ]),
          ),
        ),
      ),
    );
  }

  Widget jobInput({ScrollController scrollController}) {
    return Scaffold(
      body: ListView(
        physics: ClampingScrollPhysics(),
        controller: scrollController,
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CircleButton(
                    onTap: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      size: 20.0,
                      color: stateColors.primary,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Opacity(
                            opacity: 0.6,
                            child: Text(
                              "Job",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "This author job or role in real life or in the artistic material (film, book, ...).",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 60.0),
                child: TextField(
                  autofocus: true,
                  controller: jobController,
                  focusNode: jobFocusNode,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    icon: Icon(Icons.work),
                    labelText: "e.g. Housekeeper, Lawyer, Student, Teacher",
                    alignLabelWithHint: true,
                  ),
                  minLines: 1,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                  onChanged: (newValue) {
                    AddQuoteInputs.author.job = newValue;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  left: 40.0,
                ),
                child: Wrap(
                  spacing: 20.0,
                  runSpacing: 20.0,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        AddQuoteInputs.author.job = '';
                        jobController.clear();
                        jobFocusNode.requestFocus();
                      },
                      icon: Opacity(
                        opacity: 0.6,
                        child: Icon(Icons.clear),
                      ),
                      label: Opacity(
                        opacity: 0.6,
                        child: Text(
                          'Clear input',
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        primary: stateColors.foreground,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Opacity(
                        opacity: 0.6,
                        child: Icon(Icons.check),
                      ),
                      label: Opacity(
                        opacity: 0.6,
                        child: Text(
                          'Save',
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        primary: stateColors.foreground,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget links() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80.0),
      child: Wrap(
        spacing: 20.0,
        runSpacing: 20.0,
        children: <Widget>[
          linkCircleButton(
            delay: 1.0,
            name: 'Website',
            active: AddQuoteInputs.author.urls.website.isNotEmpty,
            imageUrl: 'assets/images/world-globe.png',
            onTap: () {
              showLinkInputSheet(
                  labelText: 'Website',
                  initialValue: AddQuoteInputs.author.urls.website,
                  onSave: (String inputUrl) {
                    setState(() {
                      AddQuoteInputs.author.urls.website = inputUrl;
                    });
                  });
            },
          ),
          Observer(
            builder: (_) {
              return linkCircleButton(
                delay: 1.2,
                name: 'Wikipedia',
                active: AddQuoteInputs.author.urls.wikipedia.isNotEmpty,
                imageUrl: 'assets/images/wikipedia-${stateColors.iconExt}.png',
                onTap: () {
                  showLinkInputSheet(
                      labelText: 'Wikipedia',
                      initialValue: AddQuoteInputs.author.urls.wikipedia,
                      onSave: (String inputUrl) {
                        setState(() {
                          AddQuoteInputs.author.urls.wikipedia = inputUrl;
                        });
                      });
                },
              );
            },
          ),
          linkCircleButton(
            delay: 1.4,
            name: 'Amazon',
            imageUrl: 'assets/images/amazon.png',
            active: AddQuoteInputs.author.urls.amazon.isNotEmpty,
            onTap: () {
              showLinkInputSheet(
                  labelText: 'Amazon',
                  initialValue: AddQuoteInputs.author.urls.amazon,
                  onSave: (String inputUrl) {
                    setState(() {
                      AddQuoteInputs.author.urls.amazon = inputUrl;
                    });
                  });
            },
          ),
          linkCircleButton(
            delay: 1.6,
            name: 'Facebook',
            imageUrl: 'assets/images/facebook.png',
            active: AddQuoteInputs.author.urls.facebook.isNotEmpty,
            onTap: () {
              showLinkInputSheet(
                  labelText: 'Facebook',
                  initialValue: AddQuoteInputs.author.urls.facebook,
                  onSave: (String inputUrl) {
                    setState(() {
                      AddQuoteInputs.author.urls.facebook = inputUrl;
                    });
                  });
            },
          ),
          linkCircleButton(
            delay: 1.7,
            name: 'Instagram',
            imageUrl: 'assets/images/instagram.png',
            active: AddQuoteInputs.author.urls.instagram.isNotEmpty,
            onTap: () {
              showLinkInputSheet(
                  labelText: 'Instagram',
                  initialValue: AddQuoteInputs.author.urls.instagram,
                  onSave: (String inputUrl) {
                    setState(() {
                      AddQuoteInputs.author.urls.instagram = inputUrl;
                    });
                  });
            },
          ),
          linkCircleButton(
            delay: 1.8,
            name: 'Netflix',
            imageUrl: 'assets/images/netflix.png',
            active: AddQuoteInputs.author.urls.netflix.isNotEmpty,
            onTap: () {
              showLinkInputSheet(
                  labelText: 'Netflix',
                  initialValue: AddQuoteInputs.author.urls.netflix,
                  onSave: (String inputUrl) {
                    setState(() {
                      AddQuoteInputs.author.urls.netflix = inputUrl;
                    });
                  });
            },
          ),
          linkCircleButton(
            delay: 2.0,
            name: 'Prime Video',
            imageUrl: 'assets/images/prime-video.png',
            active: AddQuoteInputs.author.urls.primeVideo.isNotEmpty,
            onTap: () {
              showLinkInputSheet(
                  labelText: 'Prime Video',
                  initialValue: AddQuoteInputs.author.urls.primeVideo,
                  onSave: (String inputUrl) {
                    setState(() {
                      AddQuoteInputs.author.urls.primeVideo = inputUrl;
                    });
                  });
            },
          ),
          linkCircleButton(
            delay: 2.2,
            name: 'Twitch',
            imageUrl: 'assets/images/twitch.png',
            active: AddQuoteInputs.author.urls.twitch.isNotEmpty,
            onTap: () {
              showLinkInputSheet(
                  labelText: 'Twitch',
                  initialValue: AddQuoteInputs.author.urls.twitch,
                  onSave: (String inputUrl) {
                    setState(() {
                      AddQuoteInputs.author.urls.twitch = inputUrl;
                    });
                  });
            },
          ),
          linkCircleButton(
            delay: 2.4,
            name: 'Twitter',
            imageUrl: 'assets/images/twitter.png',
            active: AddQuoteInputs.author.urls.twitter.isNotEmpty,
            onTap: () {
              showLinkInputSheet(
                  labelText: 'Twitter',
                  initialValue: AddQuoteInputs.author.urls.twitter,
                  onSave: (String inputUrl) {
                    setState(() {
                      AddQuoteInputs.author.urls.twitter = inputUrl;
                    });
                  });
            },
          ),
          linkCircleButton(
            delay: 2.6,
            name: 'YouTube',
            imageUrl: 'assets/images/youtube.png',
            active: AddQuoteInputs.author.urls.youtube.isNotEmpty,
            onTap: () {
              showLinkInputSheet(
                  labelText: 'YouTube',
                  initialValue: AddQuoteInputs.author.urls.youtube,
                  onSave: (String inputUrl) {
                    setState(() {
                      AddQuoteInputs.author.urls.youtube = inputUrl;
                    });
                  });
            },
          ),
        ],
      ),
    );
  }

  Widget linkCircleButton({
    bool active = false,
    double delay = 0.0,
    String imageUrl,
    String name,
    Function onTap,
  }) {
    return FadeInX(
      beginX: 50.0,
      delay: delay,
      child: Tooltip(
        message: name,
        child: Material(
          elevation: active ? 4.0 : 0.0,
          shape: CircleBorder(),
          clipBehavior: Clip.hardEdge,
          color: Colors.black12,
          child: InkWell(
            onTap: prefilledInputs ? null : onTap,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                imageUrl,
                width: 30.0,
                color: active ? stateColors.secondary : stateColors.foreground,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget nameCardInput() {
    final authorName = AddQuoteInputs.author.name;

    return Container(
      width: 250.0,
      padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
      child: Card(
        elevation: 2.0,
        child: InkWell(
          onTap: () async {
            await showCupertinoModalBottomSheet(
                context: context,
                builder: (context, scrollController) {
                  return nameInput();
                });

            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Opacity(
                      opacity: 0.6,
                      child: Text(
                        'Name',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      authorName != null && authorName.isNotEmpty
                          ? authorName
                          : tapToEditStr,
                    ),
                  ],
                ),
              ),
              Icon(Icons.person),
            ]),
          ),
        ),
      ),
    );
  }

  Widget nameInput({ScrollController scrollController}) {
    return Scaffold(
      body: ListView(
        physics: ClampingScrollPhysics(),
        controller: scrollController,
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleButton(
                      onTap: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        size: 20.0,
                        color: stateColors.primary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Opacity(
                              opacity: 0.6,
                              child: Text(
                                "Name",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "Suggestions will show when you'll start typing.",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                StatefulBuilder(builder: (context, childSetState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 60.0),
                        child: TextField(
                          autofocus: true,
                          controller: nameController,
                          focusNode: nameFocusNode,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            icon: Icon(Icons.person_outline),
                            labelText: "e.g. Freud, Aristote",
                            alignLabelWithHint: true,
                          ),
                          minLines: 1,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                          onChanged: (newValue) async {
                            AddQuoteInputs.author.name = newValue;
                            prefilledInputs = false;
                            tapToEditStr = 'Tap to edit';

                            if (searchTimer != null && searchTimer.isActive) {
                              searchTimer.cancel();
                            }

                            searchTimer = Timer(1.seconds, () async {
                              authorsSuggestions.clear();

                              final query =
                                  algolia.index('authors').search(newValue);

                              final snapshot = await query.getObjects();

                              if (snapshot.empty) {
                                childSetState(() {});
                                return;
                              }

                              for (final hit in snapshot.hits) {
                                final data = hit.data;
                                data['id'] = data['objectID'];

                                final authorSuggestion =
                                    AuthorSuggestion.fromJSON(data);

                                final fromReference =
                                    authorSuggestion.author.fromReference;

                                if (fromReference != null &&
                                    fromReference.id != null &&
                                    fromReference.id.isNotEmpty) {
                                  try {
                                    final ref = await Firestore.instance
                                        .collection('references')
                                        .document(fromReference.id)
                                        .get();

                                    final refData = ref.data;
                                    refData['id'] = ref.documentID;

                                    authorSuggestion
                                        .parseReferenceJSON(refData);
                                  } catch (error) {}
                                }

                                authorsSuggestions.add(authorSuggestion);
                              }

                              childSetState(() {});
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20.0,
                          left: 40.0,
                          bottom: 40.0,
                        ),
                        child: Wrap(
                          spacing: 20.0,
                          runSpacing: 20.0,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {
                                AddQuoteInputs.author.name = '';
                                nameController.clear();
                                nameFocusNode.requestFocus();
                              },
                              icon: Opacity(
                                opacity: 0.6,
                                child: Icon(Icons.clear),
                              ),
                              label: Opacity(
                                opacity: 0.8,
                                child: Text(
                                  'Clear input',
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                primary: stateColors.foreground,
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: Opacity(
                                opacity: 0.6,
                                child: Icon(Icons.check),
                              ),
                              label: Opacity(
                                opacity: 0.8,
                                child: Text(
                                  'Save',
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                primary: stateColors.foreground,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: authorsSuggestions.map((authorSuggestion) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                AddQuoteInputs.author = authorSuggestion.author;
                                prefilledInputs = true;
                                tapToEditStr = '-';
                                Navigator.of(context).pop();
                              },
                              title: Text(authorSuggestion.getTitle()),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget summaryCardInput() {
    final summary = AddQuoteInputs.author.summary;

    return Container(
      width: 300.0,
      padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
      child: Card(
        elevation: 2.0,
        child: InkWell(
          onTap: prefilledInputs
              ? showPrefilledAlert
              : () async {
                  await showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context, scrollController) {
                        return summaryInput();
                      });

                  setState(() {});
                },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Opacity(
                      opacity: 0.6,
                      child: Text(
                        'Summary',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      summary != null && summary.isNotEmpty
                          ? summary
                          : tapToEditStr,
                    ),
                  ],
                ),
              ),
              Icon(Icons.short_text),
            ]),
          ),
        ),
      ),
    );
  }

  Widget summaryInput({ScrollController scrollController}) {
    return Scaffold(
      body: ListView(
        physics: ClampingScrollPhysics(),
        controller: scrollController,
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleButton(
                      onTap: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        size: 20.0,
                        color: stateColors.primary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Opacity(
                              opacity: 0.6,
                              child: Text(
                                "Summary",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "Write a short summary about this author. It can be the first Wikipedia paragraph.",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 60.0),
                  child: TextField(
                    autofocus: true,
                    controller: summaryController,
                    focusNode: summaryFocusNode,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      icon: Icon(Icons.edit),
                      labelText: "Once upon a time...",
                      alignLabelWithHint: true,
                    ),
                    minLines: 1,
                    maxLines: null,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                    onChanged: (newValue) {
                      AddQuoteInputs.author.summary = newValue;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left: 40.0,
                  ),
                  child: Wrap(
                    spacing: 20.0,
                    runSpacing: 20.0,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          AddQuoteInputs.author.summary = '';
                          summaryController.clear();
                          summaryFocusNode.requestFocus();
                        },
                        icon: Opacity(
                          opacity: 0.6,
                          child: Icon(Icons.clear),
                        ),
                        label: Opacity(
                          opacity: 0.6,
                          child: Text(
                            'Clear input',
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          primary: stateColors.foreground,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Opacity(
                          opacity: 0.6,
                          child: Icon(Icons.check),
                        ),
                        label: Opacity(
                          opacity: 0.6,
                          child: Text(
                            'Save',
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          primary: stateColors.foreground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget title() {
    return Column(
      children: <Widget>[
        Text(
          'Add author',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Opacity(
          opacity: 0.6,
          child: Text(
            '3/5',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  void showAvatarDialog() {
    showMaterialModalBottomSheet(
        context: context,
        builder: (context, scrollController) {
          return Scaffold(
            body: ListView(
              physics: ClampingScrollPhysics(),
              controller: scrollController,
              children: [
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: SizedBox(
                    width: 250.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CircleButton(
                              onTap: () => Navigator.of(context).pop(),
                              icon: Icon(
                                Icons.close,
                                size: 20.0,
                                color: stateColors.primary,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: Opacity(
                                      opacity: 0.6,
                                      child: Text(
                                        "Author illustration",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "You can either provide an online link or upload a new picture.",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                        ),
                        TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText:
                                AddQuoteInputs.author.urls.image.length > 0
                                    ? AddQuoteInputs.author.urls.image
                                    : 'URL',
                          ),
                          onChanged: (newValue) {
                            tempImgUrl = newValue;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text(
                          'CANCEL',
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text(
                          'SAVE',
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            AddQuoteInputs.author.urls.image = tempImgUrl;
                          });

                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void showLinkInputSheet({
    String labelText = '',
    String initialValue = '',
    Function onSave,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        String inputUrl;
        linkInputController.text = initialValue;

        return Container(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 250.0,
                child: TextField(
                  autofocus: true,
                  controller: linkInputController,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    labelText: labelText,
                    icon: Icon(Icons.link),
                  ),
                  onChanged: (newValue) {
                    inputUrl = newValue;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 40.0,
                  right: 10.0,
                ),
                child: RaisedButton(
                  onPressed: onSave != null
                      ? () {
                          Navigator.pop(context);
                          onSave(inputUrl);
                        }
                      : null,
                  color: stateColors.primary,
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              )
            ],
          ),
        );
      },
    );
  }

  void showPrefilledAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Author's fields have been filled out for you.",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            titlePadding: const EdgeInsets.all(20.0),
          );
        });
  }
}
