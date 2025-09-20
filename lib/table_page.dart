import 'package:flutter/material.dart';
import 'booking_bottom_sheet.dart';
import 'cart_page.dart';
import 'models/table_model.dart';
import 'services/api_service.dart';
import 'utils/localization_helper.dart';
import 'extensions/table_model_extensions.dart';
import 'config/app_config.dart';

class TablePage extends StatefulWidget {
  const TablePage({super.key});

  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> with LocalizationMixin {
  String searchText = '';
  String selectedFilter = 'All';
  List<TableModel> allTables = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTables();
  }

  Future<void> _loadTables() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final tables = await ApiService.getTables();
      setState(() {
        allTables = tables;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  List<TableModel> get filteredTables {
    return allTables.where((table) {
      final matchesSearch = table
          .getLocalizedName()
          .toLowerCase()
          .contains(searchText.toLowerCase());
      final matchesFilter = selectedFilter == 'All' ||
          table.type.toLowerCase() == selectedFilter.toLowerCase();
      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return withDirectionality(
      Scaffold(
        appBar: createLocalizedAppBar(
          titleKey: 'tables',
          actions: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartPage(),
                      ));
                },
                icon: const Icon(Icons.shopping_cart,
                    color: Colors.black, size: 26),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Search bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: getText('search_table'),
                    border: InputBorder.none,
                    icon: const Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Filter buttons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    filterButton('All', getText('all')),
                    filterButton('Single', getText('single')),
                    filterButton('Double', getText('double')),
                    filterButton('Family', getText('family')),
                    filterButton('Special', getText('special')),
                    filterButton('Custom', getText('custom')),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Table list
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error,
                                    size: 64, color: Colors.red),
                                const SizedBox(height: 16),
                                Text(
                                  getText('error_loading_tables'),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _loadTables,
                                  child: Text(getText('retry')),
                                ),
                              ],
                            ),
                          )
                        : filteredTables.isEmpty
                            ? Center(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    const SizedBox(height: 10),
                                    Text(
                                      getText('no_tables_found'),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedFilter = 'All';
                                          searchText = '';
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFF008C8C),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        width: 371,
                                        height: 45,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            getText('find_other_table'),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: _loadTables,
                                child: ListView.builder(
                                  itemCount: filteredTables.length,
                                  itemBuilder: (context, index) {
                                    final table = filteredTables[index];
                                    return tableCard(table: table);
                                  },
                                ),
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget filterButton(String value, String displayText) {
    final isSelected = selectedFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = value;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : const Color(0xFFF3F1F1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          displayText,
          style: TextStyle(
              fontSize: 15, color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget tableCard({required TableModel table}) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          builder: (context) => BookingBottomSheet(table: table),
        );
      },
      child: Container(
        height: 240,
        width: 215,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                    '${table.image}',
                    fit: BoxFit.cover),
              ),
              Positioned.fill(
                child: Container(color: Colors.black.withOpacity(0.3)),
              ),
              Positioned(
                left: 16,
                bottom: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      table.getLocalizedName(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      table.getLocalizedDescription(),
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    Text(
                      '${table.capacity} ${getText('chairs')}',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
