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
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
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
                    decoration: const InputDecoration(
                      labelText: "Title",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
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
                    decoration: const InputDecoration(
                      labelText: "Message",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
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
                  InkWell(
                    onTap: _submitForm,
                    child: Ink(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 1, 46, 76),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Make Announcement",
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Current Announcement(s)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: announcements.length,
                itemBuilder: (context, index) {
                  final announcement = announcements[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          announcement.title,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(announcement.message),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          onPressed: () async {
                            await ref
                                .read(rtAnnouncementNotifier.notifier)
                                .deleteAnnouncement(
                                  announcementId: announcement.announcementId,
                                );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final String title = _titleController.text;
      final String message = _messageController.text;

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
