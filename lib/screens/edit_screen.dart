import 'package:bin_reminder/extensions/material_colors.dart';
import 'package:flutter/material.dart';
import 'package:bin_reminder/models/bin.dart';
import 'package:bin_reminder/constants/custom_styles.dart';
import 'package:bin_reminder/services/database_service.dart';
import 'package:bin_reminder/widgets/bin_type_selector.dart';
import 'package:bin_reminder/widgets/collection_frequency_selector.dart';
import 'package:bin_reminder/widgets/bin_color_selector.dart';
import 'package:bin_reminder/helpers/date_helper.dart';

class EditScreen extends StatefulWidget {
  // If editing, this is the bin we are editing.  If adding new this will be null
  final Bin? bin;

  const EditScreen({super.key, this.bin});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController nameController = TextEditingController();
  BinType? _binType;
  BinColor? _binColor;
  DateTime? _collectionDate;
  TextEditingController collectionDateController = TextEditingController();
  CollectionFrequency? _collectionFrequency;
  bool? _isPaused;

  String? _binTypeValidationError;
  String? _binColorValidationError;
  String? _collectionFrequencyValidationError;

  bool _unsavedChanges = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.bin != null) {
      nameController.text = widget.bin!.name;
      _binType = widget.bin!.binType;
      _binColor = widget.bin!.binColor;
      _collectionDate = widget.bin!.collectionDate;
      collectionDateController.text =
          DateHelper.getFormattedNextCollectionDate(widget.bin!.collectionDate);
      _collectionFrequency = widget.bin!.collectionFrequency;
      _isPaused = widget.bin!.isPaused;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.bin == null ? 'Add new bin' : 'Edit bin'),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: context.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                child: Text('Save',
                    style: TextStyle(
                      backgroundColor: context.primary,
                      color: context.onPrimary,
                    )),
                onPressed: () async {
                  if (_validate()) {
                    if (!await _saveData()) {
                      // an error occurred and we cannot save?
                      // TODO Log and report error
                      return;
                    }

                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  }
                },
              ),
            ]),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Form(
            canPop: !_unsavedChanges,
            onPopInvoked: (bool didPop) {
              if (didPop) {
                return;
              }
              _showSaveChangesDialog();
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(labelText: "Bin Description"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter some text";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      _unsavedChanges = true;
                    },
                  ),
                  const SizedBox(height: 20),
                  BinTypeSelector(
                      binType: _binType,
                      errorText: _binTypeValidationError,
                      edgeInsets: EdgeInsets.zero,
                      onSelectionChanged: (value) {
                        setState(() {
                          _unsavedChanges = true;
                          _binType = value;
                          _validate(field: 'BinType');
                        });
                      }),
                  const SizedBox(height: 20),
                  BinColorSelector(
                    binColor: _binColor,
                    errorText: _binColorValidationError,
                    edgeInsets: EdgeInsets.zero,
                    onSelectionChanged: (value) {
                      setState(() {
                        _unsavedChanges = true;
                        _binColor = value;
                        _validate(field: 'BinColor');
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  CollectionFrequencySelector(
                      collectionFrequency: _collectionFrequency,
                      errorText: _collectionFrequencyValidationError,
                      edgeInsets: EdgeInsets.zero,
                      onSelectionChanged: (value) {
                        setState(() {
                          _unsavedChanges = true;
                          _collectionFrequency = value;
                          _validate(field: 'CollectionFrequency');
                        });
                      }),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: collectionDateController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today), //icon of text field
                        labelText: "Next Collection Due"),
                    readOnly: true, // when true user cannot edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _collectionDate, //get today's date
                          firstDate: DateTime
                              .now(), //DateTime.now() - not to allow to choose before today.
                          lastDate:
                              DateTime.now().add(const Duration(days: 60)));

                      if (pickedDate != null) {
                        _collectionDate = pickedDate;
                        setState(() {
                          _unsavedChanges = true;
                          collectionDateController.text =
                              DateHelper.getFormattedNextCollectionDate(
                                  pickedDate);
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select a date";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Paused?',
                          style: CustomStyles.inputTitleTextStyle),
                      Switch(
                          value: _isPaused ?? false,
                          onChanged: (value) {
                            setState(() {
                              _isPaused = value;
                            });
                          })
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future<bool> _saveData() async {
    Bin b = Bin(
        id: widget.bin?.id,
        name: nameController.text,
        binType: _binType!,
        binColor: _binColor!,
        collectionDate: _collectionDate!,
        collectionFrequency: _collectionFrequency!,
        isPaused: _isPaused ?? false);

    DatabaseService db = DatabaseService();
    if (widget.bin == null) {
      await db.insertBin(b);
    } else {
      await db.updateBin(b);
    }

    return true;
  }

  /// validate the form.  Needed as the DropDownMenu controls
  /// currently do not support Form validation
  ///
  /// [field] can specify the field to validate, or null to validate all fields
  bool _validate({String? field}) {
    bool isValid = true;

    if (field == null && !_formKey.currentState!.validate()) {
      isValid = false;
    }
    if (field == null || field == 'BinType') {
      if (_binType == null) {
        setState(() {
          _binTypeValidationError = 'Please select a valid bin type';
        });
        isValid = false;
      } else {
        setState(() {
          _binTypeValidationError = null;
        });
      }
    }
    if (field == null || field == 'BinColor') {
      if (_binColor == null) {
        setState(() {
          _binColorValidationError = 'Please select a valid bin color';
        });
        isValid = false;
      } else {
        setState(() {
          _binColorValidationError = null;
        });
      }
    }
    if (field == null || field == 'CollectionFrequency') {
      if (_collectionFrequency == null) {
        setState(() {
          _collectionFrequencyValidationError =
              'Please select a valid collection frequency';
        });
        isValid = false;
      } else {
        setState(() {
          _collectionFrequencyValidationError = null;
        });
      }
    }
    return isValid;
  }

  Future<void> _showSaveChangesDialog() async {
    final bool? shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Any unsaved changes will be lost!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes, discard my changes'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: const Text('No, continue editing'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );

    if (shouldDiscard ?? false) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
    }
  }
}
