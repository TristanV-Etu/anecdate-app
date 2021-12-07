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
  late BuildContext _ctx;
  late DateTime _selectedDate;
  ImagePicker _picker = ImagePicker();
  File? _imageFile;
  late String _categoryValue;
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
    _categoryValue = Globals.idsCategories.keys.first;
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
    _ctx = context;
    _size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: _unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ajouter Anec'Date"),
        ),
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
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Card(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Icon(
                      Icons.text_format_outlined,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Text("Titre de votre Anec'Date"),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade400,
                thickness: 1.5,
                indent: 40,
                endIndent: 0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 40, right: 6, bottom: 16),
                child: TextFormField(
                  maxLength: 50,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  controller: _titleCon,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez entrer un titre valide.";
                    } else if (value.length > 30) {
                      return "Veuillez mettre un titre de moins de 50 caractères.";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createDateField() {
    return SizedBox(
      width: _size.width,
      child: Padding(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Card(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Icon(
                      Icons.calendar_today_outlined,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Text("Date de votre Anec'Date"),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade400,
                thickness: 1.5,
                indent: 40,
                endIndent: 0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 40, right: 6, bottom: 16),
                child: GestureDetector(
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
              ),
            ],
          ),
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
    return SizedBox(
      width: _size.width,
      child: Padding(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Card(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Icon(
                      Icons.image_outlined,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Text("Image de votre Anec'Date"),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade400,
                thickness: 1.5,
                indent: 40,
                endIndent: 0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 40, right: 6, bottom: 16),
                child: Row(
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
                    ElevatedButton(
                      onPressed: (() => _getImage(source: ImageSource.gallery)),
                      child: Text("CHOISIR"),
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
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Card(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Icon(
                      Icons.article_outlined,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Text("Description de votre Anec'Date"),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade400,
                thickness: 1.5,
                indent: 40,
                endIndent: 0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 40, right: 6, bottom: 16),
                child: TextFormField(
                  maxLines: 5,
                  maxLength: 1000,
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
    return SizedBox(
      width: _size.width,
      child: Padding(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Card(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Icon(
                      Icons.apps_outlined,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Text("Catégories de votre Anec'Date"),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade400,
                thickness: 1.5,
                indent: 40,
                endIndent: 0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 40, right: 6, bottom: 16),
                child: DropdownButton<String>(
                  value: _categoryValue,
                  icon: const Icon(
                    Icons.expand_more_outlined,
                  ),
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
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Card(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Icon(
                      Icons.import_contacts_outlined,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Text("Sources de votre Anec'Date"),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade400,
                thickness: 1.5,
                indent: 40,
                endIndent: 0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 40, right: 6, bottom: 16),
                child: TextFormField(
                  maxLines: 5,
                  maxLength: 1000,
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
              icon: Icon(
                Icons.expand_more_outlined,
              ),
            ),
            Text(
              "(Optionnel) Mode Quizz",
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
        Visibility(
          visible: _facultatifDisplay,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 10,
                ),
                child: Text(
                    "Si vous souhaitez que l'anec'date apparaisse en mode Quizz, remplissez les champs suivants :"),
              ),
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
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Card(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Icon(
                      Icons.contact_support_outlined,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Text("Question de votre Anec'Date"),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade400,
                thickness: 1.5,
                indent: 40,
                endIndent: 0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 40, right: 6, bottom: 16),
                child: TextFormField(
                  maxLength: 50,
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
                      return "Veuillez mettre un question de moins de 50 caractères.";
                    }
                    return null;
                  },
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
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Card(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Icon(
                      Icons.done_outlined,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Text("Réponses correctes"),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade400,
                thickness: 1.5,
                indent: 40,
                endIndent: 0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 40, right: 6, bottom: 16),
                child: TextFormField(
                  maxLength: 30,
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
                      return "Veuillez mettre une réponse de moins de 30 caractères.";
                    }
                    return null;
                  },
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
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Card(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Icon(
                      Icons.close_outlined,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 8),
                    child: Text("Réponses fausses"),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade400,
                thickness: 1.5,
                indent: 40,
                endIndent: 0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 40, right: 6, bottom: 6),
                child: TextFormField(
                  maxLength: 30,
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
                      return "Veuillez mettre une réponse de moins de 30 caractères.";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 40, right: 6, bottom: 6),
                child: TextFormField(
                  maxLength: 30,
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
                      return "Veuillez mettre une réponse de moins de 30 caractères.";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 40, right: 6, bottom: 16),
                child: TextFormField(
                  maxLength: 30,
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
                      return "Veuillez mettre une réponse de moins de 30 caractères.";
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createValidateButton() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () {
          if (_imageFile == null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text("N'oubliez pas de mettre une image d'illustration.")));
          } else if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Votre aned'date est en cours d'envoi...")));

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
                _badAnswer3Con.text,
                _ctx);
          }
        },
        child: Text("ENVOYER"),
      ),
    );
  }
}
