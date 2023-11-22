import 'package:flutter/material.dart';
import 'package:sdeng/model/team.dart';
import 'package:sdeng/ui/team_details/view/team_details.dart';

/// ListTile specific for teams, with team icon in the leading
/// and forwarding arrow in the trailing.
/// This tile is Slide-To-Delete
class TeamTileWidget extends StatelessWidget {
  const TeamTileWidget({
    Key? key,
    required this.team
  }) : super(key: key);

  final Team team;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.people_alt_rounded, color: Color(0xff4D46B2),
      ),
      title: Text(
        team.name,
        style: const TextStyle(
          color: Color(0xff4D46B2)
        ),
      ),
      subtitle: Text(
          ' ${team.athletesId.length} Players ',
        style: const TextStyle(
          color: Color(0xff4D46B2),
          fontSize: 12
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded,
          color: Color(0xff4D46B2)
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TeamDetails(team),
          ),
        );
      },
    );
  }
}