---
title: "Background"
date: 2021-08-09T10:49:43+02:00
---

Of course I used Winamp to play my handful of MP3s. Sometimes I stared at the
mesmerizing, colorful, friendly and uplifting visuals that double-clicking on the bouncy
bars would get you: **AVS**, the "_Advanced Visualization Studio_".

But ever since accidentally right-clicking on the AVS window to discover the **builtin
editor** sometime in 2004 or 2005 or so, I've been enamored with the amount of fun that
I could have, and the ways I could express myself, in that particular rabbit hole.

{{<figure
    src="avs-editor-menu.png"
    alt="Winamp AVS window with context menu open, with embellished menu entry \"AVS Editor\""
    caption="The moment I found out about the editor. I was probably watching _mig_'s _\"Velvet Ice\"_ at the time. The menu entry might or might not have had a halo and a choir that day."
>}}

There's a whole bucket of easily-accessible effects that could be just added in, with
simple sliders, checkboxes and color choosers that would immediately change what would
happen next. Your personal little pixel aquarium with a very fancy stick to stir and
whip its contents into so many shapes. It invited you to just play or to realize a
vision, a toy and a tool at the same time.  And always it allowed both, to play with the
vision as it emerged, in your mind and on-screen. After that, learning AVS's builtin
scripting language allowed you to go almost arbitrarily far—and many people did. With or
without code, AVS allowed you to develop a personal style and as a result whole
sub-genres and taxonomies of flavors emerged over time.

Around 2006 (a.k.a. six years too late) I found an online community of like-minded
people on the [Winamp Forums][forums], DeviantArt and on IRC. I also met quite a few
people in person over the years, first _toniq_, whom I mistook for _Tonic_, in my
hometown. Later I visited [_Yathosho_][visbot], [_micro.D_][microd], and even met
[framesofreality][frames] for about 30 minutes. Before that, in the final throes of
school, there I met Lukas, a.k.a [_HuRriC4nE_][hurricane] back then, or
[_exo-cortex_][exocortex] these days. Together, as [_Effekthasch_][ehorg], we did some
of both our [best work][ehpack], performed an ever-evolving greatest hits playlist of
AVS from many artists in clubs in Berlin for over a year around 2013, and to that end
even designed our own [VJ mixing software][avsmixer] enabling us to play presets much
like a DJ plays their records.

AVS's quirky _EEL_ scripting language was my second introduction to programming (after a
stint with Flash some years before). While I was getting better at creating code-heavy
presets, the community was already fading around me. The AVS scene had felt stagnant
for quite a while. Reasons included the lack of development of AVS itself, the parent
Winamp losing popularity and many AVS creators moving on to greener pastures, as screen
sizes doubled and doubled again (while AVS's speed did not) and more exciting tools
became available.

But still AVS held a special place in the hearts of all of us, as a potent catalyst for
creative expression, learning tool and favorite toy. Seeing it dwindle filled many with
nostalgia. When the source code to AVS was released in 2005, it gave rise to a
[forum thread of hope][oss-avs-thread], and the same in 2010, when original author
Justin Frankel released [a new version][chavs-thread] with a few new language features.
But each time the optimism subsided again when no significant updates emerged.

Over all this time, one thing did grow: The feeling that if AVS were not somehow dragged
into the present and possibly the future, then all the fantastic works done by many
great artists would be forever locked in a legacy plugin for a legacy media player, and
barely hinted at by blurry videos that failed to capture most of the great
side-offerings of AVS:

* Visuals created with _your_ music, live in real time,
* Sharp & colorful images, endlessly new, and
* Completely open presets, giving rise to a remixing community rarely equaled.

Quite a suprising amount of rewrites where attempted in the 2010s: There's a
[C rewrite][c99avs] aiming at portability and cleanliness, a [DirecX11 version][dxavs]
leveraging GPUs to achieve (for AVS) ungodly resolutions at the cost of completeness,
and a [Javascript+WebGL port][webvs] which promised to bring AVS to the (now
web-captured) masses once again. All of these fell somewhat silent before reaching a
satisfactory level of compatibility.

[The version I started][vis_avs] aims at completeness and compatibility first. The
initial motivator was making accessible what we created in the past to a future
audience. To that end, AVS's source code must first be put in better shape to be more
portable across compilers, and in the future even operating systems. This is _not_ a
rewrite, but a proper fork and hopefully an actual continuation of development.

There's no saying this attempt will fare any better than others, but at least I tried to
avoid the trope of starting-fresh-then-falling-short by never straying far from 100%.
Starting from the old code and iteratively cleaning up instead of a big-swoop rewrite,
has so far resulted in an AVS that is highly compatible while laying the ground work
for future development and ports.

I start this blog and write this post after having already done a lot of cleanup and at
a time when AVS already compiles with GCC. But it is also the first day of a whole year
off for me. No regular work, no other projects in the way. Just a list of exciting
projects with AVS at the top of the list.

Here's to hoping I can make good use of it.


[forums]: http://forums.winamp.com/forumdisplay.php?f=85 "Winamp's AVS Forums"
[visbot]: https://visbot.net
[microd]: https://www.mcro.de/
[frames]: https://www.deviantart.com/framesofreality/
[hurricane]: https://thehurric4ne.deviantart.com/
[exocortex]: https://exo-cortex.github.io/
[ehorg]: https://effekthasch.org
[ehpack]: https://www.deviantart.com/grandchild/art/Effekthasch-204391561
[avsmixer]: https://github.com/grandchild/AVS-Mixer/
[avs-unconed]: https://acko.net/blog/avs/
[avs-frames]: https://www.deviantart.com/framesofreality/journal/long-time-no-see-contemporary-art-questions-345306886
[oss-avs-thread]: http://forums.winamp.com/showthread.php?s=&threadid=216394
[chavs-thread]: http://forums.winamp.com/showthread.php?t=321482
[c99avs]: https://gitlab.com/J_Darnley/Advanced-Visualization-Studio
[dxavs]: https://github.com/Const-me/vis_avs_dx
[webvs]: https://github.com/azeem/webvs/
[vis_avs]: https://github.com/grandchild/vis_avs