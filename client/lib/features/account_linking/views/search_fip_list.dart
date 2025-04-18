import 'package:collection/collection.dart';
import 'package:finvu_flutter_sdk/common/models/fi_type_category.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_fip_icon.dart';
import 'package:finvu_flutter_sdk/features/account_linking/bloc/account_linking_bloc.dart';
import 'package:finvu_flutter_sdk/finvu_ui_manager.dart';
import 'package:finvu_flutter_sdk_core/finvu_fip_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class SearchFipList extends StatefulWidget {
  const SearchFipList({super.key, this.fiTypeCategory});

  final FiTypeCategory? fiTypeCategory;

  @override
  State<SearchFipList> createState() => _SearchFipListState();
}

class _SearchFipListState extends State<SearchFipList> {
  final TextEditingController editingController = TextEditingController();
  FinvuFIPInfo? _selectedFip;

  List<FinvuFIPInfo> _allFips = [];
  List<FinvuFIPInfo>? _filteredFips;
  int _selectedFiTypeCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.fiTypeCategory != null) {
      _selectedFiTypeCategoryIndex = FiTypeCategory.values
          .indexWhere((element) => element == widget.fiTypeCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiConfig = FinvuUIManager().uiConfig;

    return BlocConsumer<AccountLinkingBloc, AccountLinkingState>(
      listener: (context, state) {
        if (state.status == AccountLinkingStatus.initializingComplete) {
          if (_allFips.isEmpty) {
            setState(() {
              _allFips = state.fipInfoList;
            });
          }
        }

        if (state.selectedFipInfo?.fipId != _selectedFip?.fipId) {
          final selectedFip = state.fipInfoList.firstWhereOrNull(
              (element) => state.selectedFipInfo?.fipId == element.fipId);
          setState(() {
            _selectedFip = selectedFip;
          });
        }
      },
      builder: (context, state) {
        if (state.status == AccountLinkingStatus.isInitializing ||
            state.status == AccountLinkingStatus.unknown) {
          return const SizedBox.shrink();
        }

        final List<FinvuFIPInfo> items =
            _filteredFips ?? _getSelectedFiTypeCategoryFips();
        return Column(children: [
          _buildSearchBankHeader(context),
          const Padding(padding: EdgeInsets.only(top: 15)),
          _buildInstitutionTypeSelectionWidget(context),
          const Padding(padding: EdgeInsets.only(top: 20)),
          _buildSearchBarWidget(context),
          const Padding(padding: EdgeInsets.only(top: 20)),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) =>
                _buildRadioButtonWidget(context, items[index]),
          ),
        ]);
      },
    );
  }

  Widget _buildSearchBankHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        AppLocalizations.of(context)!.searchInstitution,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildSearchBarWidget(BuildContext context) {
    final theme = Theme.of(context);
    final uiConfig = FinvuUIManager().uiConfig;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 1,
        child: TextField(
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          onChanged: _filterSearchResults,
          controller: editingController,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white.withAlpha(1),
            labelText: AppLocalizations.of(context)!.searchInstitution,
            hintText: AppLocalizations.of(context)!.searchInstitution,
            suffixIcon: Icon(Icons.search, color: uiConfig?.primaryColor),
            enabledBorder: uiConfig?.inputDecorationTheme?.enabledBorder ??
                theme.inputDecorationTheme.enabledBorder,
            focusedBorder: uiConfig?.inputDecorationTheme?.focusedBorder ??
                theme.inputDecorationTheme.focusedBorder,
            border: uiConfig?.inputDecorationTheme?.border ??
                theme.inputDecorationTheme.border,
            labelStyle: uiConfig?.inputDecorationTheme?.labelStyle ??
                theme.inputDecorationTheme.labelStyle,
            hintStyle: uiConfig?.inputDecorationTheme?.hintStyle ??
                theme.inputDecorationTheme.hintStyle,
            contentPadding: uiConfig?.inputDecorationTheme?.contentPadding ??
                theme.inputDecorationTheme.contentPadding,
          ),
        ),
      ),
    );
  }

  Widget _buildRadioButtonWidget(BuildContext context, FinvuFIPInfo fip) {
    final theme = Theme.of(context);
    final uiConfig = FinvuUIManager().uiConfig;

    return Card(
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: InkWell(
        onTap: () => _handleRadioButtonChanged(context, fip),
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: FinvuFipIcon(
                    iconUri: fip.productIconUri,
                    size: 22,
                  ),
                ),
                Expanded(
                  child: Text(
                    fip.productName ?? "",
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.left,
                  ),
                ),
                Radio<FinvuFIPInfo>(
                  value: fip,
                  groupValue: _selectedFip,
                  onChanged: (value) => _handleRadioButtonChanged(context, fip),
                  activeColor: uiConfig?.primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleRadioButtonChanged(BuildContext context, FinvuFIPInfo fipInfo) {
    context.read<AccountLinkingBloc>().add(AccountLinkingFipSelected(fipInfo));
    setState(() {
      _selectedFip = fipInfo;
    });
  }

  void _filterSearchResults(final String query) {
    final filteredItems = _getSelectedFiTypeCategoryFips()
        .where((element) => element.productName
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredFips = filteredItems;
    });
  }

  List<FinvuFIPInfo> _getSelectedFiTypeCategoryFips() {
    final List<String> applicableFiTypes = FiTypeCategory
        .values[_selectedFiTypeCategoryIndex].fiTypes
        .map((fiType) => fiType.value)
        .toList();

    if (applicableFiTypes.isEmpty) {
      return _allFips;
    }

    return _allFips.where((fip) {
      for (final fiType in fip.fipFitypes) {
        if (applicableFiTypes.contains(fiType)) {
          return true;
        }
      }

      return false;
    }).toList();
  }

  Widget _buildInstitutionTypeSelectionWidget(BuildContext context) {
    final uiConfig = FinvuUIManager().uiConfig;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: FiTypeCategory.values
            .mapIndexed(
              (index, fiTypeCategory) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () => setState(() {
                    _selectedFiTypeCategoryIndex = index;
                  }),
                  child: Chip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: _selectedFiTypeCategoryIndex == index
                            ? uiConfig?.primaryColor ?? FinvuColors.blue
                            : FinvuColors.greyD8E1EE,
                      ),
                    ),
                    backgroundColor: _selectedFiTypeCategoryIndex == index
                        ? uiConfig?.primaryColor
                        : null,
                    label: Text(
                      fiTypeCategory.getLocalizedTitle(context),
                      style: TextStyle(
                        color: _selectedFiTypeCategoryIndex == index
                            ? Colors.white
                            : null,
                        fontFamily: uiConfig?.fontFamily,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
