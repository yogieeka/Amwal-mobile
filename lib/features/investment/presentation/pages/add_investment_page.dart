import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../data/models/investment_model.dart';
import '../providers/investment_provider.dart';

/// Add/Edit Investment Page
class AddInvestmentPage extends ConsumerStatefulWidget {
  final InvestmentModel? investment;

  const AddInvestmentPage({super.key, this.investment});

  @override
  ConsumerState<AddInvestmentPage> createState() => _AddInvestmentPageState();
}

class _AddInvestmentPageState extends ConsumerState<AddInvestmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _initialAmountController = TextEditingController();
  final _currentValueController = TextEditingController();
  final _expectedReturnController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();

  InvestmentType _selectedType = InvestmentType.sahamSyariah;
  DateTime _startDate = DateTime.now();
  bool _isActive = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.investment != null) {
      _loadInvestmentData();
    }
  }

  void _loadInvestmentData() {
    final inv = widget.investment!;
    _nameController.text = inv.name;
    _initialAmountController.text = inv.initialAmount.toStringAsFixed(0);
    _currentValueController.text = inv.currentValue.toStringAsFixed(0);
    _expectedReturnController.text = inv.expectedReturn.toStringAsFixed(2);
    _descriptionController.text = inv.description;
    _notesController.text = inv.notes;
    _selectedType = inv.type;
    _startDate = inv.startDate;
    _isActive = inv.isActive;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _initialAmountController.dispose();
    _currentValueController.dispose();
    _expectedReturnController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  double _parseValue(String value) {
    if (value.trim().isEmpty) return 0.0;
    return double.tryParse(value.replaceAll(',', '').replaceAll('.', '')) ?? 0.0;
  }

  Future<void> _saveInvestment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final investment = InvestmentModel(
        id: widget.investment?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        type: _selectedType,
        initialAmount: _parseValue(_initialAmountController.text),
        currentValue: _parseValue(_currentValueController.text),
        startDate: _startDate,
        expectedReturn: _parseValue(_expectedReturnController.text),
        description: _descriptionController.text.trim(),
        notes: _notesController.text.trim(),
        isActive: _isActive,
      );

      if (widget.investment == null) {
        await ref.read(investmentsProvider.notifier).addInvestment(investment);
      } else {
        await ref.read(investmentsProvider.notifier).updateInvestment(investment);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.investment == null
                  ? 'Investasi berhasil ditambahkan'
                  : 'Investasi berhasil diupdate',
            ),
          ),
        );
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.investment == null ? 'Tambah Investasi' : 'Edit Investasi',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Investment Type
            Text(
              'Jenis Investasi',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<InvestmentType>(
              value: _selectedType,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: InvestmentType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 24),

            // Name
            Text(
              'Nama Investasi',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Nama',
              hint: 'Contoh: Saham BBCA, Sukuk Ritel',
              controller: _nameController,
              prefixIcon: const Icon(Icons.label),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama investasi harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Amounts
            Text(
              'Nilai Investasi',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Modal Awal (Rp)',
              hint: 'Jumlah modal yang diinvestasikan',
              controller: _initialAmountController,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.account_balance_wallet),
              validator: Validators.validatePositiveNumber,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Nilai Saat Ini (Rp)',
              hint: 'Nilai investasi saat ini',
              controller: _currentValueController,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.trending_up),
              validator: Validators.validatePositiveNumber,
            ),
            const SizedBox(height: 24),

            // Expected Return
            Text(
              'Return Ekspektasi',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Return per Tahun (%)',
              hint: 'Estimasi return tahunan',
              controller: _expectedReturnController,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.percent),
            ),
            const SizedBox(height: 24),

            // Start Date
            Text(
              'Tanggal Mulai',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _startDate = date;
                  });
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Status
            SwitchListTile(
              title: const Text('Status Investasi'),
              subtitle: Text(_isActive ? 'Aktif' : 'Tidak Aktif'),
              value: _isActive,
              onChanged: (value) {
                setState(() {
                  _isActive = value;
                });
              },
              activeColor: AppColors.primaryGreen,
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              'Deskripsi (Opsional)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Deskripsi singkat tentang investasi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Notes
            Text(
              'Catatan (Opsional)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Catatan pribadi tentang investasi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),

            // Save Button
            CustomButton(
              text: widget.investment == null
                  ? 'Simpan Investasi'
                  : 'Update Investasi',
              onPressed: _saveInvestment,
              isLoading: _isLoading,
              icon: Icons.save,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
