import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../domain/services/zakat_calculator_service.dart';

/// Zakat Fitrah Calculator Page
class ZakatFitrahCalculatorPage extends ConsumerStatefulWidget {
  const ZakatFitrahCalculatorPage({super.key});

  @override
  ConsumerState<ZakatFitrahCalculatorPage> createState() =>
      _ZakatFitrahCalculatorPageState();
}

class _ZakatFitrahCalculatorPageState
    extends ConsumerState<ZakatFitrahCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _numberOfPeopleController = TextEditingController(text: '1');
  final _ricePriceController = TextEditingController();
  final _kgPerPersonController = TextEditingController(text: '2.5');

  ZakatFitrahResult? _result;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRicePrice();
  }

  Future<void> _loadRicePrice() async {
    try {
      final ricePrice =
          await ZakatCalculatorService.instance.getCurrentRicePrice();
      _ricePriceController.text = ricePrice.toStringAsFixed(0);
      // Auto-calculate on init
      _calculate();
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  void dispose() {
    _numberOfPeopleController.dispose();
    _ricePriceController.dispose();
    _kgPerPersonController.dispose();
    super.dispose();
  }

  double _parseValue(String value) {
    if (value.trim().isEmpty) return 0.0;
    return double.tryParse(value.replaceAll(',', '').replaceAll('.', '')) ?? 0.0;
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = ZakatCalculatorService.instance.calculateZakatFitrah(
        numberOfPeople: _parseValue(_numberOfPeopleController.text).toInt(),
        pricePerKg: _parseValue(_ricePriceController.text),
        kgPerPerson: _parseValue(_kgPerPersonController.text),
      );

      setState(() {
        _result = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.error,
        ),
      );
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
        title: const Text('Kalkulator Zakat Fitrah'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Info Card
            _buildInfoCard(),
            const SizedBox(height: 24),

            // Number of People
            Text(
              'Jumlah Jiwa',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                IconButton.filled(
                  onPressed: () {
                    final current = int.tryParse(_numberOfPeopleController.text) ?? 1;
                    if (current > 1) {
                      _numberOfPeopleController.text = (current - 1).toString();
                      _calculate();
                    }
                  },
                  icon: const Icon(Icons.remove),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                  ),
                ),
                Expanded(
                  child: CustomTextField(
                    label: 'Jumlah Orang',
                    controller: _numberOfPeopleController,
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(Icons.people),
                    validator: (value) => Validators.validatePositiveNumber(value, 'Jumlah orang'),
                    onChanged: (_) => _calculate(),
                  ),
                ),
                IconButton.filled(
                  onPressed: () {
                    final current = int.tryParse(_numberOfPeopleController.text) ?? 1;
                    _numberOfPeopleController.text = (current + 1).toString();
                    _calculate();
                  },
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Staple Food Type
            Text(
              'Jenis Makanan Pokok',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            CustomTextField(
              label: 'Kilogram per Orang',
              controller: _kgPerPersonController,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.scale),
              validator: (value) => Validators.validatePositiveNumber(value, 'Kilogram'),
              onChanged: (_) => _calculate(),
            ),

            const SizedBox(height: 16),

            CustomTextField(
              label: 'Harga per Kilogram (Rp)',
              controller: _ricePriceController,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.attach_money),
              validator: (value) => Validators.validatePositiveNumber(value, 'Harga'),
              onChanged: (_) => _calculate(),
            ),

            const SizedBox(height: 12),

            // Quick select buttons for common staples
            Wrap(
              spacing: 8,
              children: [
                _buildQuickSelectChip('Beras', 15000),
                _buildQuickSelectChip('Gandum', 20000),
                _buildQuickSelectChip('Kurma', 80000),
              ],
            ),

            const SizedBox(height: 32),

            // Calculate Button
            CustomButton(
              text: 'Hitung Zakat Fitrah',
              onPressed: _calculate,
              isLoading: _isLoading,
              icon: Icons.calculate,
            ),

            // Result Section
            if (_result != null) ...[
              const SizedBox(height: 32),
              _buildResultCard(),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSelectChip(String label, double price) {
    return ChoiceChip(
      label: Text('$label (${Formatters.formatCompactCurrency(price)})'),
      selected: _parseValue(_ricePriceController.text) == price,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _ricePriceController.text = price.toString();
          });
          _calculate();
        }
      },
      selectedColor: AppColors.primaryGreen,
      labelStyle: TextStyle(
        color: _parseValue(_ricePriceController.text) == price
            ? AppColors.white
            : AppColors.grey700,
        fontSize: 12,
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accentPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accentPurple.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.mosque, color: AppColors.accentPurple),
              const SizedBox(width: 8),
              const Text(
                'Tentang Zakat Fitrah',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Zakat fitrah adalah zakat yang wajib dikeluarkan oleh setiap muslim menjelang Idul Fitri.',
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 8),
          const Text(
            'Jumlah: 2.5-3 kg makanan pokok atau nilai uangnya',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    if (_result == null) return const SizedBox.shrink();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Ringkasan Zakat Fitrah',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),

            // Details
            _buildResultRow('Jumlah Jiwa', '${_result!.numberOfPeople} orang', isText: true),
            const SizedBox(height: 12),
            _buildResultRow('Per Orang', '${_result!.kgPerPerson} kg', isText: true),
            const SizedBox(height: 12),
            _buildResultRow('Harga per Kg', _result!.pricePerKg),

            const Divider(height: 32),

            // Total in KG
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondaryGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.secondaryGold),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Beras/Makanan Pokok',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${_result!.totalKg} kg',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryGold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Total Amount
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.accentPurple, AppColors.accentPurple.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Pembayaran Zakat Fitrah',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Formatters.formatCurrency(_result!.totalAmount),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Untuk ${_result!.numberOfPeople} orang',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Payment Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Navigate to payment
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur pembayaran akan segera hadir'),
                    ),
                  );
                },
                icon: const Icon(Icons.payment),
                label: const Text('Bayar Zakat Fitrah'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Notes
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.calendar_today, size: 20, color: AppColors.grey700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Waktu pembayaran: Sejak awal Ramadan sampai sebelum sholat Idul Fitri. Lebih utama dibayar sebelum sholat Ied.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.grey700,
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

  Widget _buildResultRow(String label, dynamic value, {bool isText = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.grey700,
          ),
        ),
        Text(
          isText ? value : Formatters.formatCurrency(value),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
      ],
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informasi Zakat Fitrah'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Zakat Fitrah',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Zakat fitrah adalah zakat yang wajib dikeluarkan oleh setiap muslim yang mampu pada bulan Ramadan.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Jumlah:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text('2.5 - 3 kg makanan pokok atau nilai uangnya per jiwa'),
              const SizedBox(height: 16),
              const Text(
                'Jenis Makanan Pokok:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                '• Beras (untuk Indonesia)\n'
                '• Gandum\n'
                '• Kurma\n'
                '• Atau makanan pokok setempat',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 16),
              const Text(
                'Waktu Pembayaran:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                '• Paling lambat: Sebelum shalat Idul Fitri\n'
                '• Paling utama: Pagi sebelum berangkat shalat Ied\n'
                '• Diperbolehkan: Sejak awal Ramadan',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 16),
              const Text(
                'Yang Wajib Membayar:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                'Setiap muslim yang memiliki kelebihan makanan untuk diri dan keluarganya pada malam dan hari raya Idul Fitri.',
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
