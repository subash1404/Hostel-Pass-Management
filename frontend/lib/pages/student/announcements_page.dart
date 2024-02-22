import 'package:flutter/material.dart';
import 'package:hostel_pass_management/widgets/student/custom_drawer.dart';

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
      ),
      drawer: const StudentDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionTile(
              childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              title: const Text("Announcement Title"),
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
              subtitle: const Text("Lorem Ipsum"),
              children: const [
                Text(
                  "lknsofnvon osln ldj flo flso fndoinosdfn losd fnosdnfi ndifon oldinf ion olind f nid fnldn f; pdnf pkdnf ikpn dfk ndfkn ;dfk ndpi fn",
                ),
                Text(
                  "lknsofnvon osln ldj flo flso fndoinosdfn losd fnosdnfi ndifon oldinf ion olind f nid fnldn f; pdnf pkdnf ikpn dfk ndfkn ;dfk ndpi fn",
                ),
                Text(
                  "lknsofnvon osln ldj flo flso fndoinosdfn losd fnosdnfi ndifon oldinf ion olind f nid fnldn f; pdnf pkdnf ikpn dfk ndfkn ;dfk ndpi fn",
                ),
              ],
            ),
            ExpansionTile(
              childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              title: const Text("Announcement Title"),
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
              subtitle: const Text("Lorem Ipsum"),
              children: const [
                Text(
                  "lknsofnvon osln ldj flo flso fndoinosdfn losd fnosdnfi ndifon oldinf ion olind f nid fnldn f; pdnf pkdnf ikpn dfk ndfkn ;dfk ndpi fn",
                ),
                Text(
                  "lknsofnvon osln ldj flo flso fndoinosdfn losd fnosdnfi ndifon oldinf ion olind f nid fnldn f; pdnf pkdnf ikpn dfk ndfkn ;dfk ndpi fn",
                ),
                Text(
                  "lknsofnvon osln ldj flo flso fndoinosdfn losd fnosdnfi ndifon oldinf ion olind f nid fnldn f; pdnf pkdnf ikpn dfk ndfkn ;dfk ndpi fn",
                ),
              ],
            ),
            ExpansionTile(
              childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              title: const Text("Announcement Title"),
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
              subtitle: const Text("Lorem Ipsum"),
              children: const [
                Text(
                  "lknsofnvon osln ldj flo flso fndoinosdfn losd fnosdnfi ndifon oldinf ion olind f nid fnldn f; pdnf pkdnf ikpn dfk ndfkn ;dfk ndpi fn",
                ),
                Text(
                  "lknsofnvon osln ldj flo flso fndoinosdfn losd fnosdnfi ndifon oldinf ion olind f nid fnldn f; pdnf pkdnf ikpn dfk ndfkn ;dfk ndpi fn",
                ),
                Text(
                  "lknsofnvon osln ldj flo flso fndoinosdfn losd fnosdnfi ndifon oldinf ion olind f nid fnldn f; pdnf pkdnf ikpn dfk ndfkn ;dfk ndpi fn",
                ),
              ],
            ),
            ExpansionTile(
              childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              title: const Text("Announcement Title"),
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
              subtitle: const Text("Lorem Ipsum"),
              children: const [
                Text(
                  "lknsofnvon osln ldj flo flso fndoinosdfn losd fnosdnfi ndifon oldinf ion olind f nid fnldn f; pdnf pkdnf ikpn dfk ndfkn ;dfk ndpi fn",
                ),
                Text(
                  "lknsofnvon osln ldj flo flso fndoinosdfn losd fnosdnfi ndifon oldinf ion olind f nid fnldn f; pdnf pkdnf ikpn dfk ndfkn ;dfk ndpi fn",
                ),
                Text(
                  "lknsofnvon osln ldj flo flso fndoinosdfn losd fnosdnfi ndifon oldinf ion olind f nid fnldn f; pdnf pkdnf ikpn dfk ndfkn ;dfk ndpi fn",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
