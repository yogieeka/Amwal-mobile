import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../domain/services/zakat_calculator_service.dart';

/// Zakat Penghasilan (Income) Calculator Page
class ZakatPenghasilanCalculatorPage extends ConsumerStatefulWidget {
  const ZakatPenghasilanCalculatorPage({super.key});

  @override
  ConsumerState<ZakatPenghasilanCalculatorPage> createState() =>
      _ZakatPenghasilanCalculatorPageState();
}

class _ZakatPenghasilanCalculatorPageState
    extends ConsumerState<ZakatPenghasilanCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _monthlyIncomeController = TextEditingController();
  final _monthlyExpensesController = TextEditingController();
  final _goldPriceController = TextEditingController();

  ZakatPenghasilanResult? _result;
  bool _isLoading = false;
  bool _useNetIncome = false;

  @override
  void initState() {
    super.initState();
    _loadGoldPrice();
  }

  Future<void> _loadGoldPrice() async {
    try {
      final goldPrice =
          await ZakatCalculatorService.instance.getCurrentGoldPrice();
      _goldPriceController.text = goldPrice.toStringAsFixed(0);
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  void dispose() {
    _monthlyIncomeController.dispose();
    _monthlyExpensesController.dispose();
    _goldPriceController.dispose();
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
      final result = ZakatCalculatorService.instance.calculateZakatPenghasilan(
        monthlyIncome: _parseValue(_monthlyIncomeController.text),
        monthlyExpenses: _parseValue(_monthlyExpensesController.text),
        goldPricePerGram: _parseValue(_goldPriceController.text),
        useNetIncome: _useNetIncome,
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
        title: const Text('Kalkulator Zakat Penghasilan'),
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

            // Monthly Income
            Text(
              'Penghasilan Bulanan',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            CustomTextField(
              label: 'Gaji / Penghasilan per Bulan',
              hint: 'Masukkan penghasilan bulanan',
              controller: _monthlyIncomeController,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.account_balance_wallet),
              validator: Validators.validatePositiveNumber,
            ),
            const SizedBox(height: 16),

            // Net Income Toggle
            SwitchListTile(
              title: const Text('Gunakan Penghasilan Bersih'),
              subtitle: const Text('Penghasilan - Pengeluaran Pokok'),
              value: _useNetIncome,
              onChanged: (value) {
                setState(() {
                  _useNetIncome = value;
                });
              },
              activeColor: AppColors.primaryGreen,
            ),

            if (_useNetIncome) ...[
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Pengeluaran Pokok Bulanan',
                hint: 'Biaya hidup, sewa, dll',
                controller: _monthlyExpensesController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.shopping_cart),
                validator: Validators.validatePositiveNumber,
              ),
            ],

            const SizedBox(height: 24),

            // Gold Price
            Text(
              'Harga Emas (untuk Nisab)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            CustomTextField(
              label: 'Harga Emas per Gram',
              controller: _goldPriceController,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.diamond),
              validator: Validators.validatePositiveNumber,
            ),

            const SizedBox(height: 32),

            // Calculate Button
            CustomButton(
              text: 'Hitung Zakat',
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

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.islamicGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info, color: AppColors.white),
              SizedBox(width: 8),
              Text(
                'Tentang Zakat Penghasilan',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Zakat penghasilan adalah zakat yang dikenakan atas penghasilan dari pekerjaan/profesi yang dilakukan setiap bulan.',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nisab: 1/12 dari 85 gram emas\nKadar: ${ZakatCalculatorService.zakatPercentage}%',
            style: const TextStyle(
              color: AppColors.white,
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
                Icon(
                  _result!.isWajib ? Icons.check_circle : Icons.info,
                  color: _result!.isWajib ? AppColors.success : AppColors.warning,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _result!.isWajib
                        ? 'Zakat Wajib Dibayarkan'
                        : 'Belum Mencapai Nisab',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: _result!.isWajib
                              ? AppColors.success
                              : AppColors.warning,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),

            _buildResultRow('Penghasilan Bulanan', _result!.monthlyIncome),
            const SizedBox(height: 12),
            _buildResultRow('Nisab per Bulan', _result!.nisabPerMonth, isHighlight: true),
            const SizedBox(height: 12),
            _buildResultRow(
              'Selisih',
              _result!.monthlyIncome - _result!.nisabPerMonth,
              color: (_result!.monthlyIncome - _result!.nisabPerMonth) >= 0
                  ? AppColors.success
                  : AppColors.error,
            ),

            const Divider(height: 32),

            // Monthly Zakat
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryGreen),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Zakat per Bulan',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Formatters.formatCurrency(_result!.zakatAmount),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Annual Zakat
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.zakatGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Zakat per Tahun',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Formatters.formatCurrency(_result!.annualZakat),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '(${ZakatCalculatorService.zakatPercentage}% × 12 bulan)',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

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
                  Icon(Icons.lightbulb_outline, size: 20, color: AppColors.grey700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Zakat penghasilan dapat dibayarkan setiap bulan atau dikumpulkan untuk dibayar setahun sekali.',
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

  Widget _buildResultRow(String label, double amount,
      {bool isHighlight = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isHighlight ? 15 : 14,
            fontWeight: isHighlight ? FontWeight.w600 : FontWeight.normal,
            color: color ?? AppColors.grey700,
          ),
        ),
        Text(
          Formatters.formatCurrency(amount),
          style: TextStyle(
            fontSize: isHighlight ? 16 : 15,
            fontWeight: FontWeight.bold,
            color: color ?? AppColors.primaryGreen,
          ),
        ),
      ],
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informasi Zakat Penghasilan'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Zakat Penghasilan (Zakat Profesi)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Zakat yang dikenakan atas penghasilan dari pekerjaan atau profesi yang halal.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Nisab:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text('Setara 1/12 dari 85 gram emas per bulan'),
              const SizedBox(height: 16),
              const Text(
                'Kadar Zakat:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('${ZakatCalculatorService.zakatPercentage}% dari penghasilan'),
              const SizedBox(height: 16),
              const Text(
                'Metode Perhitungan:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                '1. Penghasilan Bruto: Dihitung dari total penghasilan\n'
                '2. Penghasilan Netto: Dihitung setelah dikurangi kebutuhan pokok',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 16),
              const Text(
                'Waktu Pembayaran:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                '• Setiap bulan saat menerima gaji\n'
                '• Atau dikumpulkan untuk dibayar tahunan',
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
