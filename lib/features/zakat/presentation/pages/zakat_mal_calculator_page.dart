import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../domain/services/zakat_calculator_service.dart';

/// Zakat Mal (Wealth) Calculator Page
class ZakatMalCalculatorPage extends ConsumerStatefulWidget {
  const ZakatMalCalculatorPage({super.key});

  @override
  ConsumerState<ZakatMalCalculatorPage> createState() =>
      _ZakatMalCalculatorPageState();
}

class _ZakatMalCalculatorPageState
    extends ConsumerState<ZakatMalCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _cashController = TextEditingController();
  final _savingsController = TextEditingController();
  final _goldController = TextEditingController();
  final _silverController = TextEditingController();
  final _investmentsController = TextEditingController();
  final _receivablesController = TextEditingController();
  final _debtController = TextEditingController();
  final _goldPriceController = TextEditingController();

  ZakatMalResult? _result;
  bool _isLoading = false;
  bool _isLoadingGoldPrice = false;

  @override
  void initState() {
    super.initState();
    _loadGoldPrice();
  }

  Future<void> _loadGoldPrice() async {
    setState(() {
      _isLoadingGoldPrice = true;
    });

    try {
      final goldPrice =
          await ZakatCalculatorService.instance.getCurrentGoldPrice();
      _goldPriceController.text = goldPrice.toStringAsFixed(0);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat harga emas: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoadingGoldPrice = false;
      });
    }
  }

  @override
  void dispose() {
    _cashController.dispose();
    _savingsController.dispose();
    _goldController.dispose();
    _silverController.dispose();
    _investmentsController.dispose();
    _receivablesController.dispose();
    _debtController.dispose();
    _goldPriceController.dispose();
    super.dispose();
  }

  double _parseValue(String value) {
    if (value.trim().isEmpty) return 0.0;
    return double.tryParse(value.replaceAll(',', '').replaceAll('.', '')) ??
        0.0;
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = ZakatCalculatorService.instance.calculateZakatMal(
        cash: _parseValue(_cashController.text),
        savings: _parseValue(_savingsController.text),
        gold: _parseValue(_goldController.text),
        silver: _parseValue(_silverController.text),
        investments: _parseValue(_investmentsController.text),
        receivables: _parseValue(_receivablesController.text),
        debt: _parseValue(_debtController.text),
        goldPricePerGram: _parseValue(_goldPriceController.text),
      );

      setState(() {
        _result = result;
      });

      // Scroll to result
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 300),
          );
        }
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

  void _reset() {
    _formKey.currentState?.reset();
    _cashController.clear();
    _savingsController.clear();
    _goldController.clear();
    _silverController.clear();
    _investmentsController.clear();
    _receivablesController.clear();
    _debtController.clear();
    setState(() {
      _result = null;
    });
    _loadGoldPrice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Zakat Mal'),
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

            // Gold Price
            Text(
              'Harga Emas Saat Ini',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'Harga per Gram',
                    controller: _goldPriceController,
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(Icons.diamond),
                    validator: Validators.validatePositiveNumber,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: _isLoadingGoldPrice
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                  onPressed: _isLoadingGoldPrice ? null : _loadGoldPrice,
                  tooltip: 'Refresh harga emas',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Assets Section
            Text(
              'Harta yang Dimiliki',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            CustomTextField(
              label: 'Uang Tunai',
              hint: 'Cash on hand',
              controller: _cashController,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.money),
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Tabungan',
              hint: 'Savings in bank',
              controller: _savingsController,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.savings),
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Nilai Emas (Rp)',
              hint: 'Total value of gold owned',
              controller: _goldController,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.diamond_outlined),
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Nilai Perak (Rp)',
              hint: 'Total value of silver owned',
              controller: _silverController,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.circle_outlined),
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Investasi',
              hint: 'Stocks, mutual funds, etc.',
              controller: _investmentsController,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.trending_up),
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Piutang',
              hint: 'Receivables from others',
              controller: _receivablesController,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.request_quote),
            ),
            const SizedBox(height: 24),

            // Liabilities Section
            Text(
              'Kewajiban',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            CustomTextField(
              label: 'Hutang',
              hint: 'Current debts and liabilities',
              controller: _debtController,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.credit_card),
            ),
            const SizedBox(height: 32),

            // Calculate Button
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Hitung Zakat',
                    onPressed: _calculate,
                    isLoading: _isLoading,
                    icon: Icons.calculate,
                  ),
                ),
                const SizedBox(width: 12),
                CustomOutlinedButton(
                  text: 'Reset',
                  onPressed: _reset,
                  icon: Icons.refresh,
                ),
              ],
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
        gradient: AppColors.zakatGradient,
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
                'Tentang Zakat Mal',
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
            'Zakat Mal adalah zakat yang dikenakan atas harta yang dimiliki oleh individu atau lembaga. Nisab zakat mal setara dengan 85 gram emas.',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Kadar zakat: ${ZakatCalculatorService.zakatPercentage}%',
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

            _buildResultRow('Total Harta', _result!.totalWealth),
            const SizedBox(height: 12),
            _buildResultRow('Nisab (85g emas)', _result!.nisab, isHighlight: true),
            const SizedBox(height: 12),
            _buildResultRow(
              'Selisih',
              _result!.totalWealth - _result!.nisab,
              color: (_result!.totalWealth - _result!.nisab) >= 0
                  ? AppColors.success
                  : AppColors.error,
            ),

            const Divider(height: 32),

            // Zakat Amount
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: _result!.isWajib
                    ? AppColors.zakatGradient
                    : LinearGradient(
                        colors: [AppColors.grey300, AppColors.grey400],
                      ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Jumlah Zakat yang Harus Dibayar',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Formatters.formatCurrency(_result!.zakatAmount),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '(${ZakatCalculatorService.zakatPercentage}% dari total harta)',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            if (_result!.isWajib) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to payment/save page
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fitur pembayaran akan segera hadir'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.payment),
                  label: const Text('Bayar Zakat'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],

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
                  Icon(Icons.lightbulb_outline, size: 20, color: AppColors.grey700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _result!.isWajib
                          ? 'Harta wajib dimiliki selama 1 tahun Hijriyah (haul) untuk wajib zakat.'
                          : 'Tingkatkan harta Anda hingga mencapai nisab untuk wajib zakat.',
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
        title: const Text('Informasi Zakat Mal'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Zakat Mal (Zakat Harta)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Zakat yang dikenakan atas harta yang dimiliki selama 1 tahun (haul) dan mencapai nisab.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Nisab:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Emas: ${ZakatCalculatorService.goldNisabGrams} gram'),
              Text('• Perak: ${ZakatCalculatorService.silverNisabGrams} gram'),
              const SizedBox(height: 16),
              const Text(
                'Kadar Zakat:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('${ZakatCalculatorService.zakatPercentage}% dari total harta'),
              const SizedBox(height: 16),
              const Text(
                'Harta yang Dizakatkan:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text('• Uang tunai dan tabungan'),
              const Text('• Emas dan perak'),
              const Text('• Investasi (saham, reksadana)'),
              const Text('• Piutang yang dapat ditagih'),
              const SizedBox(height: 16),
              const Text(
                'Catatan:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                '• Hutang dapat dikurangkan dari total harta\n'
                '• Kebutuhan pokok tidak termasuk zakat\n'
                '• Haul dihitung dari kalender Hijriyah',
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
