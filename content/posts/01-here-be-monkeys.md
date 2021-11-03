---
title: "Here Be Monkeys"
date: 2021-11-01T12:12:17+01:00
---

One of the principal features of AVS that allowed it to thrive, despite itself not being
actively developed anymore, was the plugin system it provided. Dubbed "_AVS Plugin
Effect_", an _APE_ is a DLL library that extends AVS with a new effect that can alter
the image or provide other utilities to a preset.

Examples for APEs are _Color Map_ which lets you define new colors for each pixel
keyed by its previous color:

{{<figure
    src="colormap.png"
>}}


Or _Convolution Filter_, which can create vastly different effects simply by combining
nearby pixels, for blur, edge detection or more extreme pixel pattern effects:

{{<figure
    src="convofilter.png"
>}}

But there's also _AVS Trans Automation_ which doesn't affect the image itself, but the
scripting language of AVS, which allows writing much cleaner code throughout all
codeable effects within AVS. Others allowed you to limit the framerate of the preset,
or resize the editor window (which was not possible out-of-the-box).


### Usage

There are a few more APEs than these --- some more popular, some less so. Some years ago
I gathered some numbers on just _how_ popular which one is. For this I used the
[JSON converter for AVS presets][webvsc] to convert all presets I had to JSON and then
was easily able to count how often each effect (both built-in and APE) was used by a
preset.

I went over my complete collection of presets, removed duplicates and redid the
calculation just now. The distribution for only the APEs is [fairly
unsurprising][long-tail] with a few very popular ones and a long tail of rarely used
effects.(If you want, you can see the same graph for _all_ effects [here][stats-all].)

{{<figure
    src="component-stats-with-missing.png"
    alt=""
    caption="Colormap and Convolution Filter leading the pack, rightly so. Marked in red are the ones that are currently not available."
>}}


With a similar graph in hand, I prioritized which APEs to implement first --- and also
which ones to I'm going to skip completely, probably.


### The APE API

An APE can modify the framebuffer[^1] as much as it wants to. It's also given some
additional information, like of course width and height, but also current sound data,
and whether there's been a beat detected for the current frame.

The basics of the API look like this:

```
int render(
    char audio[2][2][576],
    int is_beat,
    int* framebuffer,
    int* alternate_framebuffer,
    int w,
    int h);

int ui_handler(
    HWND window,
    uint message,
    WPARAM wparam,
    LPARAM lparam);

char* get_name();
```

All an APE has to do is "fill in" these functions (the UI handler can sometimes be more
code than `render()` --- UIs are complex). The `get_name()` function is basically just
a function that returns the name of the effect, which AVS will query so it can populate
the effect menu so users can actually add the effect to presets.

Note: There are a few more functions, e.g for loading and saving, and except for the
`ui_handler`, these are actually all methods of an effect `class`, but that's not
really relevant here and the API is simpler to understand without all the C++
specifics. But the fact that it's actually C++ will become relevant (and problematic)
in the next section.

You can now select and use the effect in a preset. To render a frame AVS will call every
effect's `render()` method in turn, and give it the framebuffer as it is up to that
point. To draw something, the APE can now freely write to the framebuffer. The
`alternate_framebuffer` is useful for effects that move pixels around, where
overwriting one part of the framebuffer would alter pixels that are still needed to be
in their original state elsewhere in the frame. Think moving pixels down one row after
the other: In the second row, the pixels you'd want to move would already be
overwritten by the ones you moved from the first row. To prevent those kinds of effects
from having to allocate their own temporary framebuffer, AVS provides two framebuffers,
that it simply switches when an effect that makes use of it is done rendering.

`audio` contains waveform and spectrogram data, each for both left and right stereo
audio channels.


### The C++ ABI Problem

APE's are C++ DLLs, because AVS expects an effect _class_ that it can instantiate. And
while C has some consensus around how functions are laid out once they have been
compiled, so they can be called freely from code compiled with a different compiler,
C++ has no such single convention. This _ABI_, the "Application _Binary_ Interface"
(as opposed to the _API_, the "Application _Programming_ Interface") varies across
compilers for C++. Since all existing APEs have been compiled with Microsoft's MSVC
compiler, this is a problem for AVS compiled with GCC. GCC lays out C++ classes
differently in binary, and so AVS will not load the old APEs --- or worse, it will:

{{<figure
    src="ape-abi-error.png"
    alt="Winamp AVS editor with overlaid Windows crash error dialog saying 'winamp.exe has encountered a serious problem and needs to close'. Underneath a line from the terminal output saying '44297 segmentation fault (core dumped) winamp.exe'."
    caption="If you see this you are having a bad problem and you will not go to space today."
>}}


### APE Archaeology

The solution I chose, was probably the most expensive one, but the one with the most
long-term benefits: Incorporate the code for all popular APEs' into AVS itself. I
started working on importing APEs into the AVS codebase after receiving the source code
for _Convolution Filter_ from Tom Holden. But actually having the source code was a
rarity. Many APEs were written at a time before version control and online repository
hosting were _really_ popular, and consequently most APE authors lost the source code
to their effects over the years. Because there are (as of today) only 4 APEs' source
code available to me, I started the long march of decompiling and rewriting the rest.
There is a different approach, that I wasn't fully aware of at the time I started,
which I will talk about a bit later.

To reconstruct effects that I had no source code to, I used [Ghidra][ghidra], the open
source decompiler, to look at the APE binaries and figure out how it is that they do
their thing.

Usually, when compiling a program into an executable binary, all function and variable
names that the programmer carefully chose to concisely reflect their meaning get
completely lost. Every function now simply becomes an address, i.e. just a number, and
every variable just an index into the stack[^2]. So when you open a binary in Ghidra
and look at the decompiled C code it deduced from it, you will only see a lot of
`uVar7`, `iVar2` and `fun_37f57ac8()` and so on, all ordered in an apparently random
fashion. This is not very meaningful at first glance. The work in a binary analysis
tool like this is to help the decompiler and tell it about things _you've_ deduced.
This means labeling variables and functions, and --- more importantly --- telling the
decompiler about variable types and defining data structures, like classes.

{{<figure
    src="ghidra.png"
    alt="Ghidra (binary analysis tool & decompiler) screenshot showing both disassembly listing on the left and decompiled C code on the right. The upper third of the visible C++ code is a complex multi-line expression with various Ghidra-specific helper functions, corresponding to a portion of x86 MMX SIMD instructions. The lower two-thirds of the C++ code contain more regular control flow code with assignments, if clauses and while loops."
    caption="Not exactly production-ready C++ code. Note how many of the variables are already named meaningfully, and data structures have been defined, all by hand."
>}}

I learned a lot about the binary layout of programs through working with Ghidra, and,
with the help of the decompiled C++ code that it gave me, was able to rewrite the APEs'
code. If I can offer one advice to anyone attempting to turn a binary back into source
code, it's this: Try to figure out the data structures (`struct`s and `class`es) as
early as possible and define them in Ghidra, and set variable types. As the
(ever-evolving) definition of the data structures approaches something correct, the
decompiled C++ code will start to simplify and clarify a _lot_ from the gibberish that
it initially comes out as. I found this [tutorial for dealing with C++
classes][ghidra-tutorial-pdf] extremely helpful.

Figuring out UI handler code was thankfully a lot easier because by its nature it uses a
lot of Win32-UI API calls, which are external to the APE and are thus referenced by
their actual function names. This made the decompiled code much more readable from the
start.

The alternative approach I mentioned above, and learned about only later, would have
been to put a layer of C between the C++: The idea is that there would be a small piece
of translation code, compiled only in MSVC, that can talk to the legacy APE DLLs and on
the other side exposes a C interface towards AVS. AVS's APE interface would change to a
strict C-only interface (structs and functions). This way, AVS could be compiled with
any compiler it itself supported, the APE C++ interface code could only be compiled
with MSVC and would be provided as a binary blob. The drawbacks include: Obviously the
dependency on MSVC to create a fully capable version of AVS --- one of the exact goals
this project aimed to remedy --- and an uncertainty of what MSVC might change in the
future to break ABI with DLLs compiled with older versions of itself.

For now unfortunately, loading APEs and so extending AVS remains impossible. But it'd be
a shame to keep it that way, so the part about turning the APE interface into a C
interface might still happen in the future.


### Current Status

Currently there are about 3 to 5 APEs left to implement (depending on how much time I
want to spend on less-than-popular effects), with the difficult ones already done and
shipping. The remaining effects shouldn't take as much time as the previous bunch
(around half a year) to complete. Instead I expect them to be done inside of a month.

After that comes the big work of separating the UI, porting to Linux, and _finally_
getting some semblance of an automated testing setup installed, so that trivial
regressions don't happen quite so often. And maybe there will be some 64-bit action
sometime after that?

We'll see...


[webvsc]: https://github.com/grandchild/AVS-File-Decoder
[long-tail]: https://en.wikipedia.org/wiki/Long_tail
[stats-all]: component-stats-all.png
[ghidra]: https://ghidra-sre.org
[ghidra-tutorial-pdf]: https://ghidra.re/courses/GhidraClass/Advanced/improvingDisassemblyAndDecompilation.pdf


[^1]: The "framebuffer" is a section of memory that eventually becomes the pixels of the
screen --- what you see. It's just a section of the memory that's `width ⨉ height` in
size, and where each element corresponds to a pixel. Each pixel may be further
subdivided into red, green and blue --- but that's not a requirement. In AVS that's the
case, each pixel is a 32-bit integer, with 8 bits allocated for each of the three color
channels, and the final 8 bits unused (usually just set to 0).

[^2]: In this context, it suffices to understand the stack as a list of things that the
current context (or "scope") needs, which is usually the currently executed function.
If, for example, what a function does is swap the two parameters it's given, there will
be three items on the stack while the function is doing its thing: the first and the
second parameter, and the temporary location that is needed to hold one of the values
while the other is being copied to the first location.
