import 'package:flutter/material.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  bool _showUnreadOnly = false;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> chats = [
      {
        'name': 'M Sahel Fadillah',
        'lastMessage': 'Gc mau beli kaga nih, lagi diskon!!',
        'time': '10.30 PM',
        'avatarUrl': 'https://i.pravatar.cc/100?img=1',
        'isRead': 'false',
      },
      {
        'name': 'Justin Bieber',
        'lastMessage': 'Gc mau beli kaga nih, lagi diskon!!',
        'time': '10.30 PM',
        'avatarUrl': 'https://i.pravatar.cc/100?img=2',
        'isRead': 'false',
      },
      {
        'name': 'Jefri Nichol',
        'lastMessage': 'Gc mau beli kaga nih, lagi diskon!!',
        'time': '10.30 PM',
        'avatarUrl': 'https://i.pravatar.cc/100?img=3',
        'isRead': 'false',
      },
      {
        'name': 'Myraa',
        'lastMessage': 'Gc mau beli kaga nih, lagi diskon!!',
        'time': '10.30 PM',
        'avatarUrl': 'https://i.pravatar.cc/100?img=4',
        'isRead': 'false',
      },
      {
        'name': 'Jennifer',
        'lastMessage': 'Gc mau beli kaga nih, lagi diskon!!',
        'time': '10.30 PM',
        'avatarUrl': 'https://i.pravatar.cc/100?img=5',
        'isRead': 'false',
      },
    ];

    final visibledChats = _showUnreadOnly
        ? chats.where((chat) => chat['isRead'] == false).toList()
        : chats;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat List',
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              // Implement search functionality here
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('Semua'),
                  selected: !_showUnreadOnly,
                  onSelected: (_) => setState(() => _showUnreadOnly = false),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Belum Dibaca'),
                  selected: _showUnreadOnly,
                  onSelected: (_) => setState(() {
                    _showUnreadOnly = true;
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: visibledChats.length,
              itemBuilder: (context, index) {
                final chat = visibledChats[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(chat['avatarUrl'] as String),
                  ),
                  title: Text(
                    chat['name'] as String,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(chat['lastMessage'] as String),
                  trailing: Text(
                    chat['time'] as String,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detail_chat',
                      arguments: {'contactName': chat['name'] as String},
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
