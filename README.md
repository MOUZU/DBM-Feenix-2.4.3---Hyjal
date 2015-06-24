#DBM Feenix 2.4.3 - Mount Hyjal
I worked on adjusting the DBM Timers for Feenix 2.4.3 Archangel Server in my Time playing on there, since I've stopped doing so there will most likely be not that much of a progress from now on but feel free to keep working on my code or at least report Issues feature here on GitHub (if you support enough Material for me to fix things without playing myself I might do that).

#Changelist
For people who aren't into coding and doesn't want to check the Changes in Detail I'll list here the major changes made prior to this first GitHub upload:

- replaced wave timers with values from BigWigs because they were more accurate

Rage Winterchill:
- changed the Combat Trigger from his yell to actual combat entering
- changed the Timer for Next Death & Decay from 21s to 20s

Anetheron:
- changed the Combat Trigger from his yell to actual combat entering
- changed the value for Infernal from 51.5 to 64s (this will never be 100% accurate, but 64s is the best value from my research)
- infernal timer will now correctly restart itself in case mages are using iceblock to avoid it and causes him to cast another inferno cast too early
- reintroduced Carrion Swarm Timer and changed its value to 17s

Kazrogal: (untested)
- added a Timer for the Stun (14s after combat, every 20s)
- added a Timer for the next Mark (those values are kinda fcked up but here is what I got: after 45s combat then 41s,36s,32s,27s,22s,19s,13s,10s,10s,5s,6s,9s,10s,11s,9s,11s,10s repeat)

Azgalor: (untested)
- added a Timer for the next Doom (every 45s)

Archimonde: (untested)
- lowered the Fear Timer from 41s to 36s, lowered the first fear from 41s to 21s
- on entering the last phase all timers will be canceled and instead of that a "FINISH HIM" Timer with the duration of 60s will appear
- added a Timer for the first Air Burst (30s after combat)
- added a Timer for the next Grip(~22s after combat, every 10s)
