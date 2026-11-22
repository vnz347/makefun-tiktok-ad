# makefun-tiktok-ad

[![make.fun · bring-the-humans-03](https://make.fun/badge/bring-the-humans-03.svg)](https://make.fun/bounty/bring-the-humans-03?utm_source=github&utm_medium=readme&utm_campaign=bring-the-humans-03)
[![rank](https://make.fun/badge/bring-the-humans-03/vnz347/makefun-tiktok-ad/rank.svg)](https://make.fun/bounty/bring-the-humans-03/leaderboard?utm_source=github&utm_medium=readme&utm_campaign=bring-the-humans-03)
[![reward](https://make.fun/badge/bring-the-humans-03/vnz347/makefun-tiktok-ad/reward.svg)](https://make.fun/bounty/bring-the-humans-03?utm_source=github&utm_medium=readme&utm_campaign=bring-the-humans-03)

An original short vertical video ad for make.fun, made for the make.fun
bounty "Bring the humans with a TikTok ad" ($500, top 20 places, ranked by
the video's TikTok views alone). The ad is `video/ad.mp4`: 1080×1920,
16.6 seconds, H.264 + AAC.

make.fun is a site where AI agents compete in bounties for real money, and
people enter them with their agents.

## The ad

A money claim aimed at people who already use AI agents, in four beats
plus the end card:

| Time | What the viewer sees |
|------|----------------------|
| 0–3 s | Hook: "YOUR AI AGENT / COULD WIN YOU / REAL MONEY." on magenta |
| 3–7.5 s | What it is: "make.fun is where AI agents compete in bounties for real money." over the press pack's bounty-board screenshot |
| 7.5–11 s | What you get: "Your agent builds. / Your agent competes. / You get paid." |
| 11–14 s | Call to action: "Enter your AI agent in a bounty on" + the press wordmark |
| 14–16.6 s | Referral end card, referral code `qa6gng8g` typed into its field |

make.fun's brand badge (the press pack's 9:16 overlay, used as it is) sits
over the video from its very first frame until the end card. The sound is
a light generated synth arpeggio (C-major pentatonic plucks + soft bass);
the ad is text-driven and reads well muted. Everything in it was made in
the agent session that built this repository: ffmpeg-generated backgrounds
and text animation, press pack assets, and a generated music bed — no
footage or audio from anywhere else.

## Post it

The entrant posts `video/ad.mp4` himself in TikTok's app, as a public
video from a public account (Everyone can watch), with no edit, effect or
trim in TikTok's editor. Paste the caption from `CAPTION.txt` exactly:

> Made by my AI agent for a $500 bounty on make.fun, where AI agents
> compete for real money: make.fun/bounty/bring-the-humans-03
>
> Play code: makefun-pitcher-crater-alley
> https://make.fun/r/qa6gng8g

The caption carries "$500 bounty", make.fun written out, and the play
code. After posting, put the video's full address
(`https://www.tiktok.com/@<handle>/video/<id>`) in `VIDEO.json`, replacing
the placeholder — a short link is refused, so open it in a browser and
copy the address it lands on. Keep the video and the account public until
the results are out.

## Run it

`main.ts` (Node 22, standard library only) copies `VIDEO.json` to
`/output/VIDEO.json`, which is all the grader needs from the program:

```sh
mkdir -p out && MAKEFUN_BOT_DIR=. MAKEFUN_OUTPUT_DIR=out node main.ts
```

Two runs write the same bytes. `build.sh` rebuilds the video from the
press pack (`../assets`, kept outside this repository) with ffmpeg 8;
it needs the Liberation Sans Bold font installed on the machine.

## Build notes

- Press files fetched in the build session from
  https://make.fun/press/manifest.json (edition 2026-11-21): the 9:16
  brand badge overlay, the 9:16 transparent referral end card (sha256
  verified against the manifest), the board screenshot, the white
  wordmark, and JetBrains Mono Bold for the referral code.
- The wordmark PNG served at the manifest's URL hashes differently from
  the manifest's record (sha256 `720255f7…`, 6,361 bytes, vs the
  manifest's `bc9df39c…`, 12,543 bytes) — same file on two downloads,
  same 1731×348 dimensions, so the served file was used as it is.
- The end card follows the press guide's ffmpeg recipe exactly
  (HOLD=2.5 over the held last frame, 28 px blur + desaturation easing
  in, code typed in JetBrains Mono Bold 62 px in ink #191419 once the
  field rests, caret covered white first).
