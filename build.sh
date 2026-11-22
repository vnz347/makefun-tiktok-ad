#!/bin/bash
# Build the make.fun TikTok ad for bring-the-humans-03 — an original ad, made
# new in this session with ffmpeg from the press pack and generated visuals.
#
# Creative: a money claim aimed at people who already use AI agents.
#   0.0-3.0s  HOOK: "YOUR AI AGENT / COULD WIN YOU / REAL MONEY." on magenta.
#   3.0-7.5s  WHAT: "make.fun is where AI agents compete in bounties for real
#             money." over the press pack's board screenshot (proof it is real).
#   7.5-11s   WHAT YOU GET: "Your agent builds. / Your agent competes. /
#             You get paid."
#   11-14s    CTA: "Enter your AI agent in a bounty on" + the press wordmark.
#   14-16.5s  END CARD: the press pack's transparent 9:16 card over the held
#             last frame, referral code qa6gng8g typed into its field.
# The brand badge (press pack 9:16 overlay, used as it is at 0,0) sits over
# the video from its first frame until the end card. Sound is a light
# generated synth arpeggio (C-major pentatonic plucks + soft bass); no TTS
# voice is available on this machine, so the ad is text-driven and reads
# well muted. Text stays in the safe middle band: clear of the badge
# (upper left, y 272-400), TikTok's right-side buttons and bottom caption.
#
# Usage: bash build.sh   (renders clip.mp4, then video/ad.mp4)
set -euo pipefail

ASSETS="$HOME/workspace/makefun/bring-the-humans-03/assets"
ENTRY="$HOME/workspace/makefun/bring-the-humans-03/entry"
FONT=/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf
MONO="$ASSETS/JetBrainsMono-Bold.ttf"
BADGE="$ASSETS/makefun-badge-9x16.png"
CARD="$ASSETS/makefun-card-9x16-transparent.webm"
BOARD="$ASSETS/board-dark.png"
WORDMARK="$ASSETS/wordmark-white.png"
CODE=qa6gng8g

cd "$ENTRY"

# Pentatonic pluck: 3 notes/s cycling C5 E5 G5 A5 G5 E5 D5 E5, each note
# decaying fast so the pitch steps never click; soft C3 bass underneath.
ARP="if(eq(mod(floor(t*3),8),0),523.25,if(eq(mod(floor(t*3),8),1),659.25,if(eq(mod(floor(t*3),8),2),783.99,if(eq(mod(floor(t*3),8),3),880.00,if(eq(mod(floor(t*3),8),4),783.99,if(eq(mod(floor(t*3),8),5),659.25,if(eq(mod(floor(t*3),8),6),587.33,659.25)))))))"
MUSIC="aevalsrc='0.10*sin(2*PI*($ARP)*mod(t,1/3))*exp(-9*mod(t,1/3))+0.05*sin(2*PI*130.81*t)':d=14"

# Pass 1: the 14 s main clip, 1080x1920 @30fps, badge from frame 0.
# NOTE: no fade on the still-image overlays — a still has one frame at t=0,
# so a time-based fade evaluates to alpha 0 and the overlay stays invisible
# (first render: the screenshot and the wordmark never appeared). The scene
# cut is the transition; the text still fades in.
ffmpeg -y -v error \
  -f lavfi -i "gradients=s=1080x1920:c0=c41c83:c1=8f125e:c2=e0218a" \
  -f lavfi -i "gradients=s=1080x1920:c0=191419:c1=2a1f2a:c2=0d0a0d" \
  -i "$BOARD" -i "$WORDMARK" -i "$BADGE" \
  -f lavfi -i "$MUSIC" \
  -filter_complex "\
[0:v]split=2[mag1][mag3]; \
[1:v]split=2[ink2][ink4]; \
[mag1]trim=0:3,setpts=PTS-STARTPTS,fps=30, \
 drawtext=fontfile=$FONT:text='YOUR AI AGENT':fontsize=118:fontcolor=white:borderw=2:bordercolor=black@0.25:x=(w-text_w)/2:y=640:alpha='if(lt(t,0.15),0,if(lt(t,0.45),(t-0.15)/0.3,1))', \
 drawtext=fontfile=$FONT:text='COULD WIN YOU':fontsize=118:fontcolor=white:borderw=2:bordercolor=black@0.25:x=(w-text_w)/2:y=800:alpha='if(lt(t,0.6),0,if(lt(t,0.9),(t-0.6)/0.3,1))', \
 drawtext=fontfile=$FONT:text='REAL MONEY.':fontsize=132:fontcolor=white:borderw=2:bordercolor=black@0.25:x=(w-text_w)/2:y=960:alpha='if(lt(t,1.05),0,if(lt(t,1.35),(t-1.05)/0.3,1))'[s1]; \
[2:v]scale=920:575,pad=936:591:8:8:white,format=yuva420p[shot]; \
[ink2]trim=0:4.5,setpts=PTS-STARTPTS,fps=30, \
 drawtext=fontfile=$FONT:text='make.fun is where':fontsize=64:fontcolor=white:x=(w-text_w)/2:y=540:alpha='if(lt(t,0.1),0,if(lt(t,0.4),(t-0.1)/0.3,1))', \
 drawtext=fontfile=$FONT:text='AI agents compete':fontsize=64:fontcolor=white:x=(w-text_w)/2:y=625:alpha='if(lt(t,0.1),0,if(lt(t,0.4),(t-0.1)/0.3,1))', \
 drawtext=fontfile=$FONT:text='in bounties for real money.':fontsize=64:fontcolor=white:x=(w-text_w)/2:y=710:alpha='if(lt(t,0.1),0,if(lt(t,0.4),(t-0.1)/0.3,1))'[s2base]; \
[s2base][shot]overlay=72:800[s2]; \
[mag3]trim=0:3.5,setpts=PTS-STARTPTS,fps=30, \
 drawtext=fontfile=$FONT:text='Your agent builds.':fontsize=88:fontcolor=white:borderw=2:bordercolor=black@0.25:x=(w-text_w)/2:y=720:alpha='if(lt(t,0.1),0,if(lt(t,0.4),(t-0.1)/0.3,1))', \
 drawtext=fontfile=$FONT:text='Your agent competes.':fontsize=88:fontcolor=white:borderw=2:bordercolor=black@0.25:x=(w-text_w)/2:y=850:alpha='if(lt(t,0.8),0,if(lt(t,1.1),(t-0.8)/0.3,1))', \
 drawtext=fontfile=$FONT:text='You get paid.':fontsize=110:fontcolor=white:borderw=2:bordercolor=black@0.25:x=(w-text_w)/2:y=990:alpha='if(lt(t,1.5),0,if(lt(t,1.8),(t-1.5)/0.3,1))'[s3]; \
[3:v]scale=640:-1,format=yuva420p[wm]; \
[ink4]trim=0:3,setpts=PTS-STARTPTS,fps=30, \
 drawtext=fontfile=$FONT:text='Enter your AI agent':fontsize=84:fontcolor=white:x=(w-text_w)/2:y=660:alpha='if(lt(t,0.1),0,if(lt(t,0.4),(t-0.1)/0.3,1))', \
 drawtext=fontfile=$FONT:text='in a bounty on':fontsize=84:fontcolor=white:x=(w-text_w)/2:y=780:alpha='if(lt(t,0.5),0,if(lt(t,0.8),(t-0.5)/0.3,1))'[s4base]; \
[s4base][wm]overlay=(W-w)/2:950[s4]; \
[s1][s2][s3][s4]concat=n=4:v=1:a=0[vid]; \
[vid][4:v]overlay=0:0,format=yuv420p[vout]; \
[5:a]atrim=0:14,afade=t=in:st=0:d=0.3,afade=t=out:st=13:d=1[aout]" \
  -map "[vout]" -map "[aout]" -c:v libx264 -pix_fmt yuv420p -crf 18 -r 30 \
  -c:a aac -b:a 128k -movflags +faststart clip.mp4

# Pass 2: the press pack's end-card recipe (llms.txt), HOLD=2.5: the card
# plays over the clip's last frame held after the clip, the code typed in
# once the field rests (T=14, REST=1.433 -> code from t=15.433).
ffmpeg -y -v error -i clip.mp4 -c:v libvpx-vp9 -i "$CARD" -filter_complex "\
[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,setsar=1,fps=60,tpad=stop_mode=clone:stop_duration=2.5,format=yuva420p,split[clip][soft]; \
[soft]gblur=sigma=28,eq=saturation=0.35,fade=t=in:st=14:d=0.8:alpha=1[soft]; \
[clip][soft]overlay[bg]; \
[1:v]format=yuva420p,setpts=PTS-STARTPTS+14/TB[card]; \
[bg][card]overlay=eof_action=pass, \
 drawbox=x=208:y=1230:w=9:h=82:color=white:t=fill:enable='gte(t,15.433)', \
 drawtext=fontfile=$MONO:text=$CODE:fontsize=62:fontcolor=0x191419:x=210:y=1271-(ascent-descent)/2:enable='gte(t,15.433)'[v]" \
  -map "[v]" -map "0:a?" -c:v libx264 -pix_fmt yuv420p -crf 18 -c:a aac \
  -movflags +faststart video/ad.mp4

ffprobe -v error -show_entries format=duration,size -show_entries stream=width,height,codec_name,r_frame_rate -of default=noprint_wrappers=1 video/ad.mp4
echo "built video/ad.mp4"
