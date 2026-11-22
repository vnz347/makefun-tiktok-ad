// bring-the-humans-03 entry program (Node 22, standard library only).
//
// The entry is the TikTok video itself (video/ad.mp4 in this repository,
// posted publicly on TikTok); the house reads its views from TikTok. This
// program only hands the grader the video's address: it copies VIDEO.json
// from the repository root to /output/VIDEO.json, where the gate reads it.
// Nothing this program writes about the video is scored.
//
// VIDEO.json currently holds a placeholder: {"url": ""}. The entrant posts
// the video himself in TikTok's app and the real address
// (https://www.tiktok.com/@<handle>/video/<id>) replaces the placeholder
// before the entry is submitted.
//
// Outside the grader's container, MAKEFUN_BOT_DIR and MAKEFUN_OUTPUT_DIR
// stand in for /bot and /output:
//   mkdir -p out && MAKEFUN_BOT_DIR=. MAKEFUN_OUTPUT_DIR=out node main.ts

import { mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { join } from "node:path";

const BOT_DIR = process.env.MAKEFUN_BOT_DIR ?? "/bot";
const OUTPUT_DIR = process.env.MAKEFUN_OUTPUT_DIR ?? "/output";

const source = join(BOT_DIR, "VIDEO.json");
const target = join(OUTPUT_DIR, "VIDEO.json");

let contents: Buffer;
try {
  contents = readFileSync(source);
} catch (err) {
  console.error(`VIDEO.json could not be read from ${source}: ${(err as Error).message}`);
  process.exit(1);
}

try {
  mkdirSync(OUTPUT_DIR, { recursive: true });
  writeFileSync(target, contents);
} catch (err) {
  console.error(`VIDEO.json could not be written to ${target}: ${(err as Error).message}`);
  process.exit(1);
}
