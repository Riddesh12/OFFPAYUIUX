import 'package:flutter/material.dart';
import 'package:offpay/query/fileHandling.dart';
import 'package:offpay/query/phone.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    // Fetch transactions when the page loads
    sync();
  }

  Future<void> sync() async {
    try {
      final fetchedTransactions = await FileHandle().readTransactions();
      setState(() {
        transactions = fetchedTransactions;
      });
      PhoneAuth().transSync(transactions);
    } catch (e) {
      print('Error reading transactions: $e');
      // Optionally handle the error (e.g., show a Snackbar)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          transactions.isEmpty
              ? const Center(child: Text('No transactions found'))
              : Expanded(
                  // Ensure ListView.builder has a bounded height
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      // Access the transaction at the current index
                      var transaction = transactions[index];
                      return ListTile(
                        title: Text(
                            'Pay To: ${transaction['payto'] ?? 'Unknown'}'),
                        subtitle:
                            Text('Amount: ${transaction['amount'] ?? 'N/A'}'),
                        trailing: Text(
                            'Date: ${transaction['date'] ?? DateTime.now().toLocal().toString().split(' ')[0]}'),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
