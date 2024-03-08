import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/providers/rt_announcement_provider.dart';
import 'package:hostel_pass_management/widgets/rt/rt_drawer.dart';

class AnnouncementPage extends ConsumerStatefulWidget {
  const AnnouncementPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AnnouncementPage> createState() {
    return _AnnouncementPageState();
  }
}

class _AnnouncementPageState extends ConsumerState<AnnouncementPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    final announcements = ref.watch(rtAnnouncementNotifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Announcements"),
        centerTitle: true,
      ),
      drawer: RtDrawer(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    maxLength: 20,
                    decoration: const InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _messageController,
                    maxLength: 200,
                    decoration: const InputDecoration(
                      labelText: "Message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the message';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _submitForm();
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      "Current Announcement",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    ...announcements.map(
                      (announcement) => ExpansionTile(
                        childrenPadding:
                            const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        title: Text(announcement.title),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colorScheme.primaryContainer,
                          ),
                          child: Icon(
                            Icons.announcement,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        subtitle: Text(announcement.message),
                        children: [
                          ListTile(
                            title: Text('Delete'),
                            onTap: () async {
                              await ref
                                  .read(rtAnnouncementNotifier.notifier)
                                  .deleteAnnouncement(
                                      announcementId:
                                          announcement.announcementId);
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Form is valid, perform desired actions here
      final String title = _titleController.text;
      final String message = _messageController.text;

      // Print or use the title and message
      print("Title: $title");
      print("Message: $message");
      try {
        await ref
            .read(rtAnnouncementNotifier.notifier)
            .makeAnnouncement(title: title, message: message);
        if (!mounted) {
          return;
        }
        _titleController.clear();
        _messageController.clear();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Announcement Made")));
      } catch (error) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.toString(),
            ),
          ),
        );
      }
    }
  }
}
