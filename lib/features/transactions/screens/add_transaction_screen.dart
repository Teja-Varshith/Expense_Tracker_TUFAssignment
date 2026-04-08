import 'package:expense_tracker_tuf/core/app/app_colors.dart';
import 'package:expense_tracker_tuf/core/widgets/app_snackbar.dart';
import 'package:expense_tracker_tuf/models/category_model.dart';
import 'package:expense_tracker_tuf/models/transaction_model.dart';
import 'package:expense_tracker_tuf/features/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionState();
}

class _AddTransactionState extends ConsumerState<AddTransactionScreen> {
  TransactionType _type = TransactionType.expense;
  String? _selectedCategory;
  DateTime _date = DateTime.now();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _customCatCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  List<CategoryModel> get _categories => CategoryModel.categoriesFor(_type);
  bool get _isOtherSelected => _selectedCategory == 'Other';

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    _customCatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBg : AppColors.lightBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _handle(),
              _txHeader(),
              _txBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _handle() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _txHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'ADD TRANSACTION',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              letterSpacing: 2.0,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _txBody() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              _typeChip('INCOME', TransactionType.income, AppColors.income),
              const SizedBox(width: 10),
              _typeChip('EXPENSE', TransactionType.expense, AppColors.expense),
            ]),
            const SizedBox(height: 24),

            _lbl('AMOUNT'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _amountCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))
              ],
              textInputAction: TextInputAction.next,
              decoration:
                  const InputDecoration(hintText: '0.00', prefixText: 'Rs '),
              style: GoogleFonts.dmSans(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Amount required';
                if (double.tryParse(v) == null || double.parse(v) <= 0) {
                  return 'Enter valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            _lbl('CATEGORY'),
            const SizedBox(height: 10),
            _categoryGrid(),

            if (_isOtherSelected) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _customCatCtrl,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Enter custom category name...',
                  prefixIcon: Icon(
                    Icons.label_outline_rounded,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                    size: 20,
                  ),
                ),
                style: GoogleFonts.dmSans(fontSize: 14),
                validator: (v) {
                  if (_isOtherSelected &&
                      (v == null || v.trim().isEmpty)) {
                    return 'Please enter a category name';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 20),

            _lbl('DATE'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCardAlt,
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : Colors.black.withValues(alpha: 0.06),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 18),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat.yMMMd().format(_date),
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            _lbl('NOTE (OPTIONAL)'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _noteCtrl,
              maxLines: 2,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(hintText: 'Add a note...'),
            ),
            const SizedBox(height: 28),

            _neoPopSaveButton(isDark),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _typeChip(String label, TransactionType type, Color color) {
    final selected = _type == type;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _type = type;
          _selectedCategory = null;
          _customCatCtrl.clear();
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? color.withValues(alpha: 0.15) : Colors.transparent,
            border: Border.all(
              color: selected
                  ? color
                  : isDark
                      ? AppColors.darkBorder
                      : Colors.black.withValues(alpha: 0.1),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected
                    ? color
                    : isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryGrid() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _categories.map((cat) {
        final selected = _selectedCategory == cat.name;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return GestureDetector(
          onTap: () => setState(() {
            _selectedCategory = cat.name;
            if (cat.name != 'Other') _customCatCtrl.clear();
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color:
                  selected ? cat.color.withValues(alpha: 0.2) : Colors.transparent,
              border: Border.all(
                color: selected
                    ? cat.color
                    : isDark
                        ? AppColors.darkBorder
                        : Colors.black.withValues(alpha: 0.08),
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(cat.icon, size: 16, color: cat.color),
              const SizedBox(width: 6),
              Text(
                cat.name.toUpperCase(),
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected
                      ? cat.color
                      : isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                  letterSpacing: 0.8,
                ),
              ),
            ]),
          ),
        );
      }).toList(),
    );
  }

  Widget _lbl(String t) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      t,
      style: GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _neoPopSaveButton(bool isDark) {
    final buttonColor = isDark ? Colors.white : AppColors.purple;
    final textColor = isDark ? const Color(0xFF0D0D0D) : Colors.white;
    final rightShadow = isDark
        ? Colors.white.withValues(alpha: 0.3)
        : AppColors.purple.withValues(alpha: 0.4);
    final bottomShadow = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : AppColors.purple.withValues(alpha: 0.2);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: _saving ? 0.7 : 1.0,
      child: NeoPopButton(
        color: buttonColor,
        onTapUp: _saving ? () {} : _save,
        onTapDown: () {},
        parentColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        buttonPosition: Position.center,
        depth: 4,
        rightShadowColor: rightShadow,
        bottomShadowColor: bottomShadow,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: _saving
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation(textColor),
                    ),
                  )
                : Text(
                    'SAVE TRANSACTION',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                      letterSpacing: 1.8,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      AppSnackbar.warning(
        context,
        title: 'Category required',
        message: 'Please select a category.',
      );
      return;
    }

    final categoryName = _isOtherSelected && _customCatCtrl.text.trim().isNotEmpty
        ? _customCatCtrl.text.trim()
        : _selectedCategory!;

    setState(() => _saving = true);
    await ref.read(transactionProvider.notifier).add(
          amount: double.parse(_amountCtrl.text),
          category: categoryName,
          type: _type,
          note: _noteCtrl.text.trim(),
          date: _date,
        );
    if (mounted) {
      Navigator.pop(context);
      AppSnackbar.success(
        context,
        title: 'Saved',
        message: 'Transaction added successfully.',
      );
    }
  }
}
