//=============================================================================
// LadderDM
//=============================================================================
class APLadderDM extends LadderDM;

defaultproperties
{
     Matches=16
     MapPrefix="DM-"
     Maps(0)="Tutorial.unr"
     Maps(1)="Oblivion.unr"
     Maps(2)="Stalwart.unr"
     Maps(3)="Fractal.unr"
     Maps(4)="Turbine.unr"
     Maps(5)="Codex.unr"
     Maps(6)="Pressure.unr"
     Maps(7)="ArcaneTemple.unr"
     Maps(8)="Grinder.unr"
     Maps(9)="Malevolence.unr"
     Maps(10)="Kgalleon.unr"
     Maps(11)="Tempest.unr"
     Maps(12)="Shrapnel][.unr"
     Maps(13)="Liandri.unr"
     Maps(14)="Conveyor.unr"
     Maps(15)="Peak.unr"
     MapAuthors(0)="Cliff Bleszinski"
     MapAuthors(1)="Juan Pancho Eekels"
     MapAuthors(2)="Alan Willard 'Talsiman'"
     MapAuthors(3)="Dave Ewing"
     MapAuthors(4)="Cliff Bleszinski"
     MapAuthors(5)="Cliff Bleszinski"
     MapAuthors(6)="Pancho Eekels"
     MapAuthors(7)="Shane Caudle"
     MapAuthors(8)="Myscha the Sleddog"
     MapAuthors(9)="Rich Eastwood"
     MapAuthors(10)="Juan Pancho Eekels"
     MapAuthors(11)="Cliff Bleszinski"
     MapAuthors(12)="Cliff Bleszinski"
     MapAuthors(13)="Alan Willard 'Talisman'"
     MapAuthors(14)="Shane Caudle"
     MapAuthors(15)="Juan Pancho Eekels"
     MapTitle(0)="DM Tutorial"
     MapTitle(1)="Oblivion"
     MapTitle(2)="Stalwart"
     MapTitle(3)="Fractal"
     MapTitle(4)="Turbine"
     MapTitle(5)="Codex"
     MapTitle(6)="Pressure"
     MapTitle(7)="Arcane"
     MapTitle(8)="Grinder"
     MapTitle(9)="Malevolence"
     MapTitle(10)="Galleon"
     MapTitle(11)="Tempest"
     MapTitle(12)="Shrapnel"
     MapTitle(13)="Liandri"
     MapTitle(14)="Conveyor"
     MapTitle(15)="Peak"
     MapDescription(0)="Learn the basic rules of Deathmatch in this special training environment. Test your skills against an untrained enemy before entering the tournament proper."
     MapDescription(1)="The ITV Oblivion is one of Liandri's armored transport ships. It transports new contestants via hyperspace jump from the Initiation Chambers to their first events on Earth. Little do most fighters know, however, that the ship itself is a battle arena."
     MapDescription(2)="Jerl Liandri purchased this old mechanic's garage as a possible tax dump for his fledgling company, Liandri Mining. Now, Liandri Corp. has converted it into a battle arena. While not very complex, it still manages to claim more lives than the slums of the city in which it lies."
     MapDescription(3)="LMC public polls have found that the majority of Tournament viewers enjoy fights in 'Real Life' locations. This converted plasma reactor is one such venue. Fighters should take care, as the plasma energy beams will become accessible through the 'Fractal Portal' if any of the yellow LED triggers on the floor are shot."
     MapDescription(4)="A decaying water-treatment facility that has been purchased for use in the Tourney, the Turbine Facility offers an extremely tight and fast arena for combatants which ensures that there is no running, and no hiding, from certain death."
     MapDescription(5)="The Codex of Wisdom was to be a fantastic resource for knowledge seeking beings all across the galaxy. It was to be the last place in known space where one could access rare books in their original printed form. However, when the construction crew accidentally tapped into a magma flow, the project was aborted and sold to Liandri at a bargain price for combat purposes."
     MapDescription(6)="The booby trap is a time honored tradition and a favorite among Tournament viewers. Many Liandri mining facilities offer such 'interactive' hazards."
     MapDescription(7)="The Nali, an ancient race of four armed aliens, constructed this hidden temple to worship their Gods in secrecy when they were oppressed by the vicious Skaarj aliens.  Unfortunately for the Nali, the Skaarj eventually located the temple and systematically slaughtered every inhabitant."
     MapDescription(8)="A former Liandri smelting facility, this complex has proven to be one of the bloodiest arenas for tournament participants. Lovingly called the Heavy Metal Grinder, those who enter can expect nothing less than brutal seek and destroy action."
     MapDescription(9)="This small facility is well suited for testing rising tournament favorites in one-on-one combat."
     MapDescription(10)="The indigenous people of Koos World are waterborne and find there to be no more fitting an arena than this ancient transport galleon."
     MapDescription(11)="The Tempest Facility was built specifically for the Tournament. It was designed strictly for arena combat, with multi-layered areas and tiny hiding spots. It is a personal training arena of Xan Kriegor and sits high above the sprawling Reconstructed New York City."
     MapDescription(12)="Tournament coordinators love burnt out factories, foundries, and warehouses because of the natural height and architectural hazards they provide.  With the original name of this burnt-out facility long forgotten, the contestants have morbidly nicknamed this place "
     MapDescription(13)="A textbook Liandri ore processing facility located at Earth's Mohorovicic discontinuity roughly below Mexico. Phased ion shields hold back the intense heat and pressure characteristic of deep lithosphere mining."
     MapDescription(14)="This refinery makes for a particularly well balanced arena. A multilevel central chamber keeps fighters on their toes while the nearby smelting tub keeps them toasty."
     MapDescription(15)="Originally built by the Nipi Monks in Nepal to escape moral degradation, this serene and beautiful place once called for meditation; until Liandri acquired it for perfect tournament conditions."
     RankedGame(0)=1
     RankedGame(1)=1
     RankedGame(2)=2
     RankedGame(3)=2
     RankedGame(4)=2
     RankedGame(5)=3
     RankedGame(6)=3
     RankedGame(7)=3
     RankedGame(8)=3
     RankedGame(9)=3
     RankedGame(10)=4
     RankedGame(11)=4
     RankedGame(12)=4
     RankedGame(13)=5
     RankedGame(14)=5
     RankedGame(15)=6
     FragLimits(0)=3
     FragLimits(1)=10
     FragLimits(2)=10
     FragLimits(3)=15
     FragLimits(4)=15
     FragLimits(5)=20
     FragLimits(6)=20
     FragLimits(7)=25
     FragLimits(8)=20
     FragLimits(9)=20
     FragLimits(11)=25
     FragLimits(12)=25
     FragLimits(14)=30
     FragLimits(15)=30
     MatchInfo(0)="Archipelago.APRatedMatchDMTUT"
     MatchInfo(1)="Archipelago.APRatedMatchDM1"
     MatchInfo(2)="Archipelago.APRatedMatchDM2"
     MatchInfo(3)="Archipelago.APRatedMatchDM4"
     MatchInfo(4)="Archipelago.APRatedMatchDM3"
     MatchInfo(5)="Archipelago.APRatedMatchDM5"
     MatchInfo(6)="Archipelago.APRatedMatchDM6"
     MatchInfo(7)="Archipelago.APRatedMatchDM7G"
     MatchInfo(8)="Archipelago.APRatedMatchDM7"
     MatchInfo(9)="Archipelago.APRatedMatchDM9G"
     MatchInfo(10)="Archipelago.APRatedMatchDM11"
     MatchInfo(11)="Archipelago.APRatedMatchDM8"
     MatchInfo(12)="Archipelago.APRatedMatchDM9"
     MatchInfo(13)="Archipelago.APRatedMatchDM10"
     MatchInfo(14)="Archipelago.APRatedMatchDM12"
     MatchInfo(15)="Archipelago.APRatedMatchDM13"
}
