import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../data/models/transaction_model.dart';
import '../providers/transaction_provider.dart';

/// Add/Edit transaction page
class AddTransactionPage extends ConsumerStatefulWidget {
  final TransactionModel? transaction;

  const AddTransactionPage({
    super.key,
    this.transaction,
  });

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();

  TransactionType _selectedType = TransactionType.expense;
  String _selectedCategory = '';
  DateTime _selectedDate = DateTime.now();
  bool _isRecurring = false;
  String? _recurringPeriod;
  List<String> _tags = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _initializeFromTransaction(widget.transaction!);
    } else {
      _selectedCategory = AppConstants.expenseCategories.first;
    }
  }

  void _initializeFromTransaction(TransactionModel transaction) {
    _titleController.text = transaction.title;
    _amountController.text = transaction.amount.toString();
    _descriptionController.text = transaction.description ?? '';
    _notesController.text = transaction.notes ?? '';
    _selectedType = transaction.type;
    _selectedCategory = transaction.category;
    _selectedDate = transaction.date;
    _isRecurring = transaction.isRecurring;
    _recurringPeriod = transaction.recurringPeriod;
    _tags = transaction.tags;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  List<String> _getCategoriesForType() {
    switch (_selectedType) {
      case TransactionType.income:
        return AppConstants.incomeCategories;
      case TransactionType.expense:
      case TransactionType.zakat:
      case TransactionType.sedekah:
        return AppConstants.expenseCategories;
      case TransactionType.investment:
        return AppConstants.investmentTypes;
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final transaction = TransactionModel(
        id: widget.transaction?.id ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        type: _selectedType,
        category: _selectedCategory,
        date: _selectedDate,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        isRecurring: _isRecurring,
        recurringPeriod: _recurringPeriod,
        tags: _tags,
        createdAt: widget.transaction?.createdAt ?? DateTime.now(),
        updatedAt: widget.transaction != null ? DateTime.now() : null,
      );

      if (widget.transaction != null) {
        await ref.read(transactionsProvider.notifier).updateTransaction(transaction);
      } else {
        await ref.read(transactionsProvider.notifier).addTransaction(transaction);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.transaction != null
                  ? 'Transaksi berhasil diupdate'
                  : 'Transaksi berhasil ditambahkan',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = _getCategoriesForType();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.transaction != null ? 'Edit Transaksi' : 'Tambah Transaksi',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Transaction Type Selector
            Text(
              'Tipe Transaksi',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: TransactionType.values.map((type) {
                final isSelected = _selectedType == type;
                return ChoiceChip(
                  label: Text(type.displayName),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = type;
                      _selectedCategory = _getCategoriesForType().first;
                    });
                  },
                  selectedColor: AppColors.primaryGreen,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.white : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Title
            CustomTextField(
              label: 'Judul',
              hint: 'Masukkan judul transaksi',
              controller: _titleController,
              validator: (value) => Validators.validateRequired(value, 'Judul'),
              textCapitalization: TextCapitalization.words,
              prefixIcon: const Icon(Icons.title),
            ),
            const SizedBox(height: 16),

            // Amount
            CustomTextField(
              label: 'Jumlah',
              hint: 'Masukkan jumlah',
              controller: _amountController,
              keyboardType: TextInputType.number,
              validator: Validators.validateAmount,
              prefixIcon: const Icon(Icons.attach_money),
            ),
            const SizedBox(height: 16),

            // Category
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                prefixIcon: Icon(Icons.category),
              ),
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Date
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Tanggal',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Formatters.formatDateLong(_selectedDate)),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            CustomTextField(
              label: 'Deskripsi (Opsional)',
              hint: 'Tambahkan deskripsi',
              controller: _descriptionController,
              maxLines: 3,
              prefixIcon: const Icon(Icons.description),
            ),
            const SizedBox(height: 16),

            // Notes
            CustomTextField(
              label: 'Catatan (Opsional)',
              hint: 'Tambahkan catatan',
              controller: _notesController,
              maxLines: 3,
              prefixIcon: const Icon(Icons.note),
            ),
            const SizedBox(height: 16),

            // Recurring
            SwitchListTile(
              title: const Text('Transaksi Berulang'),
              subtitle: const Text('Transaksi ini akan berulang secara otomatis'),
              value: _isRecurring,
              onChanged: (value) {
                setState(() {
                  _isRecurring = value;
                });
              },
              activeColor: AppColors.primaryGreen,
            ),

            if (_isRecurring) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _recurringPeriod,
                decoration: const InputDecoration(
                  labelText: 'Periode Berulang',
                  prefixIcon: Icon(Icons.repeat),
                ),
                items: const [
                  DropdownMenuItem(value: 'daily', child: Text('Harian')),
                  DropdownMenuItem(value: 'weekly', child: Text('Mingguan')),
                  DropdownMenuItem(value: 'monthly', child: Text('Bulanan')),
                  DropdownMenuItem(value: 'yearly', child: Text('Tahunan')),
                ],
                onChanged: (value) {
                  setState(() {
                    _recurringPeriod = value;
                  });
                },
              ),
            ],

            const SizedBox(height: 32),

            // Save Button
            CustomButton(
              text: widget.transaction != null
                  ? 'Update Transaksi'
                  : 'Simpan Transaksi',
              onPressed: _saveTransaction,
              isLoading: _isLoading,
              icon: Icons.save,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
