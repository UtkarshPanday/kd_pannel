import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:kd_pannel/app_theme.dart';
import 'package:kd_pannel/core/responsive/responsive.dart';
import 'package:kd_pannel/core/services/dashboard_service.dart';
import 'package:kd_pannel/features/shared/widgets/stat_card_widget.dart';
import 'package:kd_pannel/util/dealers.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DealerManagementPage extends StatefulWidget {
  const DealerManagementPage({super.key});

  @override
  State<DealerManagementPage> createState() => _DealerManagementPageState();
}

class _DealerManagementPageState extends State<DealerManagementPage> {
  String selectedTimeframe = 'This Week';
  PickerDateRange? _selectedRange;
  int currentPage = 1;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter states
  String selectedAgent = 'All Sales Agents';
  String selectedState = 'All States';
  bool showHighValueOnly = false;
  bool showInactiveOnly = false;

  final List<String> timeframeOptions = [
    'Today',
    'Yesterday',
    'This Week',
    'Last Week',
    'This Month',
    'Last Month',
    'Custom Range',
  ];

  final List<String> agentOptions = [
    'All Sales Agents',
    'Rajesh Kumar',
    'Suresh Patil',
    'Amit Shah',
    'Vijay Deshmukh',
  ];

  final List<String> stateOptions = [
    'All States',
    'Maharashtra',
    'Gujarat',
    'Madhya Pradesh',
  ];

  List<Dealer> get filteredDealers {
    return allDealers.where((dealer) {
      final query = _searchController.text.toLowerCase();
      bool matchesSearch =
          dealer.name.toLowerCase().contains(query) ||
          dealer.phone.toLowerCase().contains(query) ||
          dealer.city.toLowerCase().contains(query) ||
          dealer.agent.toLowerCase().contains(query);
      bool matchesAgent =
          selectedAgent == 'All Sales Agents' || dealer.agent == selectedAgent;
      bool matchesState =
          selectedState == 'All States' || dealer.state == selectedState;
      bool matchesHighValue = !showHighValueOnly || dealer.isHighValue;
      bool matchesInactive = !showInactiveOnly || dealer.isInactive;
      return matchesSearch &&
          matchesAgent &&
          matchesState &&
          matchesHighValue &&
          matchesInactive;
    }).toList();
  }

  void _showDatePicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        content: SizedBox(
          height: 400,
          width: 350,
          child: SfDateRangePicker(
            backgroundColor: Colors.white,
            selectionMode: DateRangePickerSelectionMode.range,
            showActionButtons: true,
            confirmText: 'Apply',
            cancelText: 'Cancel',
            selectionShape: DateRangePickerSelectionShape.rectangle,
            rangeSelectionColor: AppTheme.primaryColor.withOpacity(0.12),
            startRangeSelectionColor: AppTheme.primaryColor,
            endRangeSelectionColor: AppTheme.primaryColor,
            initialSelectedRange: _selectedRange,
            onSubmit: (Object? val) {
              if (val is PickerDateRange &&
                  val.startDate != null &&
                  val.endDate != null) {
                setState(() {
                  _selectedRange = val;
                  selectedTimeframe = 'Custom Range';
                });
                Navigator.pop(context);
              }
            },
            onCancel: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isMobile = Responsive.isMobile(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 24 : 16,
        vertical: isDesktop ? 16 : 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isMobile),
          const SizedBox(height: 16),
          _buildStatsCards(context),
          const SizedBox(height: 20),
          _buildFiltersRow(isMobile, isDesktop),
          const SizedBox(height: 16),
          _buildDealerTable(isMobile),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    final isDesktop = Responsive.isDesktop(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isMobile ? 'Dealers' : 'Dealer Management',
          style: TextStyle(
            fontSize: isDesktop ? 20 : 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        _buildTimeframeFilter(isMobile),
      ],
    );
  }

  Widget _buildTimeframeFilter(bool isMobile) {
    return Container(
      height: isMobile ? 40 : 48,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 10 : 14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: InkWell(
              onTap: _showDatePicker,
              child: Icon(
                Icons.calendar_month_outlined,
                size: isMobile ? 18 : 20,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
          VerticalDivider(
            indent: isMobile ? 10 : 12,
            endIndent: isMobile ? 10 : 12,
            width: isMobile ? 16 : 24,
            color: const Color(0xFFE5E7EB),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: timeframeOptions.contains(selectedTimeframe)
                  ? selectedTimeframe
                  : null,
              hint: Text(
                'Timeframe',
                style: TextStyle(
                  fontSize: isMobile ? 12 : 13,
                  color: const Color(0xFF4B5563),
                  fontWeight: FontWeight.w500,
                ),
              ),
              icon: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: isMobile ? 16 : 18,
                  color: const Color(0xFF6B7280),
                ),
              ),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedTimeframe = newValue;
                    if (newValue != 'Custom Range') {
                      _selectedRange = null;
                    } else {
                      _showDatePicker();
                    }
                  });
                }
              },
              items: timeframeOptions
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: isMobile ? 12 : 13),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final service = DashboardService();

    return LayoutBuilder(
      builder: (context, constraints) {
        final double spacing = AppTheme.spacingSmall;
        final int columns = isDesktop ? 4 : 2;

        final double width =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            FutureBuilder<String>(
              future: service.getDealerTotalDealers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return StatCardShimmer(isCompact: true, width: width);
                }
                return StatCardWidget(
                  width: width,
                  title: 'Total Dealers',
                  value: snapshot.data ?? '0',
                  imagePath: 'assets/images/Total dealer.png',
                  color: AppTheme.primaryColor,
                  isCompact: true,
                );
              },
            ),
            FutureBuilder<String>(
              future: service.getDealerActiveDealers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return StatCardShimmer(isCompact: true, width: width);
                }
                return StatCardWidget(
                  width: width,
                  title: 'Active Dealers',
                  value: snapshot.data ?? '0',
                  imagePath: 'assets/images/Active dealer .png',
                  color: AppTheme.success,
                  isCompact: true,
                );
              },
            ),
            FutureBuilder<String>(
              future: service.getDealerHighValueDealers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return StatCardShimmer(isCompact: true, width: width);
                }
                return StatCardWidget(
                  width: width,
                  title: 'High Value Dealers',
                  value: snapshot.data ?? '0',
                  imagePath: 'assets/images/sales perfrom.png',
                  color: AppTheme.warning,
                  isCompact: true,
                );
              },
            ),
            FutureBuilder<String>(
              future: service.getDealerInactiveDealers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return StatCardShimmer(isCompact: true, width: width);
                }
                return StatCardWidget(
                  width: width,
                  title: 'Inactive Dealers',
                  value: snapshot.data ?? '0',
                  imagePath: 'assets/images/New leads.png',
                  color: AppTheme.error,
                  isCompact: true,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildFiltersRow(bool isMobile, bool isDesktop) {
    if (!isMobile) {
      return Row(
        children: [
          _buildSearchField(300),
          const SizedBox(width: 12),
          _buildFilterDropdown(
            'All Sales Agents',
            180,
            agentOptions,
            selectedAgent,
            (val) => setState(() => selectedAgent = val!),
          ),
          const SizedBox(width: 12),
          _buildFilterDropdown(
            'All States',
            150,
            stateOptions,
            selectedState,
            (val) => setState(() => selectedState = val!),
          ),
          const Spacer(),
          _buildToggleFilter(
            'High Value',
            showHighValueOnly,
            (val) => setState(() => showHighValueOnly = val),
          ),
          const SizedBox(width: 12),
          _buildToggleFilter(
            'Inactive',
            showInactiveOnly,
            (val) => setState(() => showInactiveOnly = val),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          _buildSearchField(double.infinity),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown(
                  'Sales Agents',
                  null,
                  agentOptions,
                  selectedAgent,
                  (val) => setState(() => selectedAgent = val!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterDropdown(
                  'States',
                  null,
                  stateOptions,
                  selectedState,
                  (val) => setState(() => selectedState = val!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildToggleFilter(
                  'High Value',
                  showHighValueOnly,
                  (val) => setState(() => showHighValueOnly = val),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildToggleFilter(
                  'Inactive',
                  showInactiveOnly,
                  (val) => setState(() => showInactiveOnly = val),
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildSearchField(double? width) {
    return Container(
      width: width,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => setState(() {}),
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(fontSize: 13, color: Color(0xFF1F2937)),
        decoration: const InputDecoration(
          hintText: 'Search dealers...',
          hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
          prefixIcon: Icon(Icons.search, size: 18, color: Color(0xFF9CA3AF)),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildFilterDropdown(
    String hint,
    double? width,
    List<String> options,
    String currentValue,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      height: 38,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: options.contains(currentValue) ? currentValue : null,
          hint: Text(
            hint,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: Color(0xFF9CA3AF),
          ),
          onChanged: onChanged,
          items: options
              .map<DropdownMenuItem<String>>(
                (String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textBody,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildToggleFilter(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          FlutterSwitch(
            width: 36.0,
            height: 18.0,
            toggleSize: 12.0,
            value: value,
            borderRadius: 20.0,
            padding: 3.0,
            activeColor: AppTheme.primaryColor,
            inactiveColor: const Color(0xFFE5E7EB),
            onToggle: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDealerTable(bool isMobile) {
    final dealersToShow = filteredDealers;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        children: [
          _buildTableHeader(isMobile),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          if (dealersToShow.isEmpty)
            Container(
              padding: const EdgeInsets.all(40),
              child: const Center(
                child: Text(
                  'No dealers found matching your criteria',
                  style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                ),
              ),
            )
          else
            ...dealersToShow.asMap().entries.map(
              (entry) =>
                  _buildDealerRow(entry.value, entry.key % 2 == 1, isMobile),
            ),
          _buildTableFooter(isMobile),
        ],
      ),
    );
  }

  Widget _buildTableHeader(bool isMobile) {
    final header = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: const Color(0xFFF9FAFB),
      child: const Row(
        children: [
          Expanded(flex: 2, child: _HeaderText('Dealer Name')),
          Expanded(flex: 2, child: _HeaderText('Phone Number')),
          Expanded(flex: 1, child: _HeaderText('City')),
          Expanded(flex: 2, child: _HeaderText('Assigned Sales Agent')),
          Expanded(flex: 1, child: Center(child: _HeaderText('GST Status'))),
          Expanded(flex: 1, child: Center(child: _HeaderText('Total Orders'))),
          Expanded(
            flex: 2,
            child: Center(child: _HeaderText('Total Purchase Value')),
          ),
          Expanded(flex: 1, child: Center(child: _HeaderText('Actions'))),
        ],
      ),
    );

    if (!isMobile) return header;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(width: 900, child: header),
    );
  }

  Widget _buildDealerRow(Dealer dealer, bool isAlternate, bool isMobile) {
    final row = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: isAlternate ? const Color(0xFFF9FAFB) : Colors.white,
        border: const Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              dealer.name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              dealer.phone,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              dealer.city,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              dealer.agent,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
          ),
          Expanded(flex: 1, child: _buildGstStatusBadge(dealer.gstStatus)),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                dealer.totalOrders.toString(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4B5563),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                dealer.purchaseValue,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
          ),
          Expanded(flex: 1, child: Center(child: _buildViewButton())),
        ],
      ),
    );

    if (!isMobile) return row;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(width: 900, child: row),
    );
  }

  Widget _buildGstStatusBadge(String status) => _StatusBadge(status: status);

  Widget _buildViewButton() => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/dealers/profile'),
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF2E7D32),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Text(
          'View',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );

  Widget _buildTableFooter(bool isMobile) {
    final footerContent = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Showing 1 to 10 of 1245 entries',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            _buildPaginationButton(Icons.chevron_left, false),
            const SizedBox(width: 8),
            _buildPaginationPage(1, true),
            _buildPaginationPage(2, false),
            _buildPaginationPage(3, false),
            if (!isMobile) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text('...', style: TextStyle(color: Color(0xFF9CA3AF))),
              ),
              _buildPaginationPage(125, false),
            ],
            const SizedBox(width: 8),
            _buildPaginationButton(Icons.chevron_right, true),
          ],
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: isMobile ? Column(children: [footerContent]) : footerContent,
    );
  }

  Widget _buildPaginationButton(IconData icon, bool isEnabled) => Container(
    width: 32,
    height: 32,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: const Color(0xFFE5E7EB)),
    ),
    child: Icon(
      icon,
      size: 18,
      color: isEnabled ? const Color(0xFF6B7280) : const Color(0xFFD1D5DB),
    ),
  );

  Widget _buildPaginationPage(int page, bool isActive) => Container(
    width: 32,
    height: 32,
    margin: const EdgeInsets.symmetric(horizontal: 2),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: isActive ? AppTheme.primaryColor : Colors.white,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(
        color: isActive ? AppTheme.primaryColor : const Color(0xFFE5E7EB),
      ),
    ),
    child: Text(
      page.toString(),
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: isActive ? Colors.white : const Color(0xFF4B5563),
      ),
    ),
  );
}

class _HeaderText extends StatelessWidget {
  final String text;

  const _HeaderText(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w800,
      color: Color(0xFF374151),
      letterSpacing: 0.2,
    ),
  );
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    switch (status) {
      case 'Verified':
      case 'Completed':
      case 'Verified ✓':
        bgColor = AppTheme.success;
        break;
      case 'Pending':
      case 'Order Pending':
        bgColor = AppTheme.warning;
        break;
      case 'Rejected':
      case 'Cancelled':
        bgColor = AppTheme.error;
        break;
      default:
        bgColor = AppTheme.info;
    }
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          status,
          style: const TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }
}
