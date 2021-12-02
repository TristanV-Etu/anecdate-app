import 'dart:io';

import 'package:anecdate_app/utils/api.dart';
import 'package:anecdate_app/utils/globals.dart';
import 'package:anecdate_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddAnecdatePage extends StatefulWidget {
  const AddAnecdatePage({Key? key}) : super(key: key);

  @override
  AddAnecdatePageState createState() => AddAnecdatePageState();
}

class AddAnecdatePageState extends State<AddAnecdatePage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCon;
  late TextEditingController _dateCon;
  late TextEditingController _descCon;
  late TextEditingController _sourcesCon;
  late TextEditingController _questionCon;
  late TextEditingController _goodAnswerCon;
  late TextEditingController _badAnswer1Con;
  late TextEditingController _badAnswer2Con;
  late TextEditingController _badAnswer3Con;
  late Size _size;
  late DateTime _selectedDate;
  ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String _categoryValue = "";
  bool _facultatifDisplay = false;
  var _currentFocus;

  void _unfocus() {
    _currentFocus = FocusScope.of(context);

    if (!_currentFocus.hasPrimaryFocus) {
      _currentFocus.unfocus();
    }
  }

  @override
  void initState() {
    super.initState();
    _titleCon = TextEditingController();
    _dateCon = TextEditingController();
    _descCon = TextEditingController();
    _sourcesCon = TextEditingController();
    _questionCon = TextEditingController();
    _goodAnswerCon = TextEditingController();
    _badAnswer1Con = TextEditingController();
    _badAnswer2Con = TextEditingController();
    _badAnswer3Con = TextEditingController();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _titleCon.dispose();
    _dateCon.dispose();
    _descCon.dispose();
    _sourcesCon.dispose();
    _questionCon.dispose();
    _goodAnswerCon.dispose();
    _badAnswer1Con.dispose();
    _badAnswer2Con.dispose();
    _badAnswer3Con.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: _unfocus,
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: _formKey,
          child: _createAddPage(),
        ),
      ),
    );
  }

  Widget _createAddPage() {
    return SingleChildScrollView(
      child: Column(children: [
        _createTitleField(),
        _createDateField(),
        _createImageField(),
        _createDescField(),
        _createCategoryField(),
        _createSourcesField(),
        _createFacultatifField(),
        _createValidateButton(),
      ]),
    );
  }

  Widget _createTitleField() {
    return SizedBox(
      width: _size.width,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Card(
          child: Row(
            children: [
              const Icon(Icons.menu),
              Expanded(
                child: Column(
                  children: [
                    Text("Titre de votre Anec'Date"),
                    Divider(),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      controller: _titleCon,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer un titre valide.";
                        } else if (value.length > 30) {
                          return "Veuillez mettre un titre de moins de 30 caractères.";
                        }
                        return null;
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createDateField() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Card(
        child: Row(
          children: [
            const Icon(Icons.menu),
            Expanded(
              child: Column(
                children: [
                  Text("Date de votre Anec'Date"),
                  Divider(),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        controller: _dateCon,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez entrer une date valide.";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(0),
        lastDate: DateTime(2040));

    if (newSelectedDate != null) {
      setState(() {
        _selectedDate = newSelectedDate;
        _dateCon
          ..text = DateFormat('yyyy-MM-dd').format(_selectedDate)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: _dateCon.text.length, affinity: TextAffinity.upstream));
      });
    }
  }

  Widget _createImageField() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Card(
        child: Row(
          children: [
            const Icon(Icons.menu),
            Expanded(
              child: Column(
                children: [
                  Text("Image de votre Anec'Date"),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 3.5,
                        child: (_imageFile == null)
                            ? Text("Aucune photo sélectionnée.")
                            : Image.file(
                                _imageFile!,
                                fit: BoxFit.cover,
                                height: _size.height * 0.1,
                                width: _size.width * 0.1,
                              ),
                      ),
                      IconButton(
                        onPressed: (() =>
                            _getImage(source: ImageSource.gallery)),
                        icon: Icon(Icons.photo_album_outlined),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _getImage({required ImageSource source}) async {
    var chosenFile = await _picker.pickImage(source: source);
    setState(() {
      if (chosenFile == null) {
        print("Aucune photo");
      } else {
        _imageFile = File(chosenFile.path);
      }
    });
  }

  Widget _createDescField() {
    return SizedBox(
      width: _size.width,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Card(
          child: Row(
            children: [
              const Icon(Icons.menu),
              Expanded(
                child: Column(
                  children: [
                    Text("Description de votre Anec'Date"),
                    Divider(),
                    TextFormField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      controller: _descCon,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer une description valide.";
                        } else if (value.length > 1000) {
                          return "Veuillez mettre une description de moins de 1000 caractères.";
                        }
                        return null;
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createCategoryField() {
    List<DropdownMenuItem<String>> items = Globals.idsCategories.keys
        .map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
    _categoryValue = items[0].value!;
    return SizedBox(
      width: _size.width,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Card(
          child: Row(
            children: [
              const Icon(Icons.menu),
              Expanded(
                child: Column(
                  children: [
                    Text("Catégorie de votre Anec'Date"),
                    Divider(),
                    DropdownButton<String>(
                      value: _categoryValue,
                      icon: const Icon(Icons.arrow_downward),
                      underline: Container(
                        height: 2,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _categoryValue = newValue!;
                        });
                      },
                      items: items,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createSourcesField() {
    return SizedBox(
      width: _size.width,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Card(
          child: Row(
            children: [
              const Icon(Icons.menu),
              Expanded(
                child: Column(
                  children: [
                    Text("Sources de votre Anec'Date"),
                    Divider(),
                    TextFormField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      controller: _sourcesCon,
                      validator: (value) {
                        if (!isAdressWebValid(value)) {
                          return "Veuillez entrer des sources valides.";
                        } else if (value!.length > 1000) {
                          return "Veuillez mettre des sources de moins de 1000 caractères.";
                        }
                        return null;
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createFacultatifField() {
    return Column(
      children: [
        Divider(),
        Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _facultatifDisplay = !_facultatifDisplay;
                });
              },
              icon: const Icon(Icons.arrow_downward),
            ),
            Text("(Optionnel) Mode Quizz"),
          ],
        ),
        Visibility(
          visible: _facultatifDisplay,
          child: Column(
            children: [
              Text(
                  "Si vous souhaitez que l'anec'date apparaisse en mode Quizz, remplissez les champs suivants :"),
              _createQuestionField(),
              _createGoodAnswerField(),
              _createBadAnswerField(),
            ],
          ),
        )
      ],
    );
  }

  Widget _createQuestionField() {
    return SizedBox(
      width: _size.width,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Card(
          child: Row(
            children: [
              const Icon(Icons.menu),
              Expanded(
                child: Column(
                  children: [
                    Text("Question de votre Anec'Date"),
                    Divider(),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      controller: _questionCon,
                      validator: (value) {
                        if ((value == null || value.isEmpty) &&
                            ((_goodAnswerCon.text != null &&
                                    _goodAnswerCon.text.isNotEmpty) ||
                                (_badAnswer2Con.text != null &&
                                    _badAnswer2Con.text.isNotEmpty) ||
                                (_badAnswer1Con.text != null &&
                                    _badAnswer1Con.text.isNotEmpty) ||
                                (_badAnswer3Con.text != null &&
                                    _badAnswer3Con.text.isNotEmpty))) {
                          return "N'oubliez pas de mettre une question.";
                        } else if (!isQuestionValid(value)) {
                          return "N'oubliez pas le point d'interrogation.";
                        } else if (value!.length > 30) {
                          return "Veuillez mettre un question de moins de 30 caractères.";
                        }
                        return null;
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createGoodAnswerField() {
    return SizedBox(
      width: _size.width,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Card(
          child: Row(
            children: [
              const Icon(Icons.menu),
              Expanded(
                child: Column(
                  children: [
                    Text("Bonne réponse"),
                    Divider(),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      controller: _goodAnswerCon,
                      validator: (value) {
                        if ((value == null || value.isEmpty) &&
                            ((_questionCon.text.isNotEmpty &&
                                    _questionCon != null) ||
                                (_badAnswer2Con.text != null &&
                                    _badAnswer2Con.text.isNotEmpty) ||
                                (_badAnswer1Con.text != null &&
                                    _badAnswer1Con.text.isNotEmpty) ||
                                (_badAnswer3Con.text != null &&
                                    _badAnswer3Con.text.isNotEmpty))) {
                          return "N'oubliez de mettre une bonne réponse.";
                        } else if (value!.length > 20) {
                          return "Veuillez mettre une réponse de moins de 20 caractères.";
                        }
                        return null;
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createBadAnswerField() {
    return SizedBox(
      width: _size.width,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Card(
          child: Row(
            children: [
              const Icon(Icons.menu),
              Expanded(
                child: Column(
                  children: [
                    Text("Mauvaises réponses"),
                    Divider(),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      controller: _badAnswer1Con,
                      validator: (value) {
                        if ((value == null || value.isEmpty) &&
                            ((_questionCon.text.isNotEmpty &&
                                    _questionCon != null) ||
                                (_goodAnswerCon.text != null &&
                                    _goodAnswerCon.text.isNotEmpty) ||
                                (_badAnswer2Con.text != null &&
                                    _badAnswer2Con.text.isNotEmpty) ||
                                (_badAnswer3Con.text != null &&
                                    _badAnswer3Con.text.isNotEmpty))) {
                          return "N'oubliez pas de mettre une mauvaise réponse.";
                        } else if (value!.length > 20) {
                          return "Veuillez mettre une réponse de moins de 20 caractères.";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      controller: _badAnswer2Con,
                      validator: (value) {
                        if ((value == null || value.isEmpty) &&
                            ((_questionCon.text.isNotEmpty &&
                                    _questionCon != null) ||
                                (_goodAnswerCon.text != null &&
                                    _goodAnswerCon.text.isNotEmpty) ||
                                (_badAnswer1Con.text != null &&
                                    _badAnswer1Con.text.isNotEmpty) ||
                                (_badAnswer3Con.text != null &&
                                    _badAnswer3Con.text.isNotEmpty))) {
                          return "N'oubliez pas de mettre une mauvaise réponse.";
                        } else if (value!.length > 20) {
                          return "Veuillez mettre une réponse de moins de 20 caractères.";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      controller: _badAnswer3Con,
                      validator: (value) {
                        if ((value == null || value.isEmpty) &&
                            ((_questionCon.text.isNotEmpty &&
                                    _questionCon != null) ||
                                (_goodAnswerCon.text != null &&
                                    _goodAnswerCon.text.isNotEmpty) ||
                                (_badAnswer2Con.text != null &&
                                    _badAnswer2Con.text.isNotEmpty) ||
                                (_badAnswer1Con.text != null &&
                                    _badAnswer1Con.text.isNotEmpty))) {
                          return "N'oubliez pas de mettre une mauvaise réponse.";
                        } else if (value!.length > 20) {
                          return "Veuillez mettre une réponse de moins de 20 caractères.";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createValidateButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          postNewAnecDate(
              _titleCon.text, 
              _dateCon.text, 
              _imageFile!,
              _categoryValue,
              _descCon.text,
              _sourcesCon.text,
              _questionCon.text,
              _goodAnswerCon.text,
              _badAnswer1Con.text,
              _badAnswer2Con.text,
              _badAnswer3Con.text
          );
        }
      },
      child: Text("Envoyer"),
    );
  }
}
