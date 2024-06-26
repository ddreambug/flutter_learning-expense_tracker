import 'package:flutter/material.dart';
import 'package:expense_tracker/model/expense_model.dart';

class NewExpenses extends StatefulWidget {
  const NewExpenses({super.key, required this.onAddExpense});

  final void Function(ExpenseModel expense) onAddExpense;

  @override
  State<NewExpenses> createState() {
    return _NewExpensesState();
  }
}

class _NewExpensesState extends State<NewExpenses> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _dateSelected;
  Category category = Category.food;

  void _showDatePicker() async {
    final now = DateTime.now();
    final minusYear = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: minusYear,
        lastDate: now);

    setState(() {
      _dateSelected = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount < 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _dateSelected == null) {
      showDialog(
          //showerrormessage
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Invalid Input"),
                content: const Text(
                    "Please Make Sure You Input All Required Values"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text("Okay"))
                ],
              ));
      return;
    }
    widget.onAddExpense(ExpenseModel(
        title: _titleController.text,
        amount: enteredAmount,
        date: _dateSelected!,
        category: category));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context)
        .viewInsets
        .bottom; //untuk membaca berapa px ui yang tertindih

    return LayoutBuilder(builder: (context, constraints) {
      print(constraints.minWidth);
      final screenWidth = constraints.maxWidth; //640

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if (screenWidth >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength: 50,
                          decoration:
                              const InputDecoration(label: Text('Title')),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          decoration: const InputDecoration(
                              label: Text('Amount'), prefixText: '\$'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(label: Text('Title')),
                  ),
                if (screenWidth >= 600)
                  Row(
                    children: [
                      DropdownButton(
                          value: category,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              category = value!;
                            });
                          }),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_dateSelected == null
                                ? 'No Date Selected'
                                : formatter.format(_dateSelected!)),
                            IconButton(
                                onPressed: _showDatePicker,
                                icon: const Icon(Icons.date_range_outlined))
                          ],
                        ),
                      )
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          decoration: const InputDecoration(
                              label: Text('Amount'), prefixText: '\$'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_dateSelected == null
                                ? 'No Date Selected'
                                : formatter.format(_dateSelected!)),
                            IconButton(
                                onPressed: _showDatePicker,
                                icon: const Icon(Icons.date_range_outlined))
                          ],
                        ),
                      )
                    ],
                  ),
                const SizedBox(height: 20),
                if (screenWidth >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('Save Input'),
                      )
                    ],
                  )
                else
                  Row(
                    children: [
                      DropdownButton(
                          value: category,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              category = value!;
                            });
                          }),
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('Save Input'),
                      )
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}
