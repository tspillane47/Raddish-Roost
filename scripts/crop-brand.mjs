/**
 * One-time crop of the brand sheet into a hero and three property logos.
 *
 * Source: public/images/brand-original.png
 *   Top: Vermont scene with the onion, shallot, and raddish characters.
 *   Bottom: Onion Ranch, Shallot Chalet, and Raddish Roost lockups on a cream field.
 *
 * Output (public/images/brand/):
 *   hero.webp
 *   logo-onion-ranch.webp
 *   logo-shallot-chalet.webp
 *   logo-raddish-roost.webp
 *
 * Usage: npm run crop:brand
 */
import { mkdir, stat } from "node:fs/promises";
import path from "node:path";
import sharp from "sharp";

const root = path.resolve(import.meta.dirname, "..");
const inputPath = path.join(root, "public/images/brand-original.png");
const outDir = path.join(root, "public/images/brand");

const LOGO_NAMES = [
  "logo-onion-ranch.webp",
  "logo-shallot-chalet.webp",
  "logo-raddish-roost.webp",
];

/** Pixels within this distance of the sampled cream field count as background. */
const PAPER_DISTANCE = 26;
/** Keep a little cream around each lockup so the circles are not flush to the edge. */
const LOGO_PADDING = 18;

function colorDistance(a, b) {
  const dr = a[0] - b[0];
  const dg = a[1] - b[1];
  const db = a[2] - b[2];
  return Math.sqrt(dr * dr + dg * dg + db * db);
}

function createReader(data, width, channels) {
  return (x, y) => {
    const i = (y * width + x) * channels;
    return [data[i], data[i + 1], data[i + 2]];
  };
}

/**
 * The logo panel begins at the first full-width cream row under the scene.
 * Snow in the scene is cooler and never fills a whole row, so a near-solid
 * cream row is the cut.
 */
function findHeroSplit(at, width, height, paper) {
  const start = Math.floor(height * 0.25);
  for (let y = start; y < height; y++) {
    let paperPixels = 0;
    let samples = 0;
    for (let x = 0; x < width; x += 2) {
      samples++;
      if (colorDistance(at(x, y), paper) <= PAPER_DISTANCE) paperPixels++;
    }
    if (paperPixels / samples > 0.985) return y;
  }
  throw new Error("Could not find the split between the hero scene and the logo panel.");
}

function samplePaperColor(at, width, height) {
  const totals = [0, 0, 0];
  let count = 0;
  const y0 = height - 12;
  for (let y = y0; y < height; y++) {
    for (let x = 0; x < width; x += 3) {
      const pixel = at(x, y);
      const max = Math.max(...pixel);
      const min = Math.min(...pixel);
      if (max > 225 && max - min < 30) {
        totals[0] += pixel[0];
        totals[1] += pixel[1];
        totals[2] += pixel[2];
        count++;
      }
    }
  }
  if (count < 20) {
    throw new Error("Could not sample the cream background along the bottom edge.");
  }
  return totals.map((value) => Math.round(value / count));
}

function findLogoSpans(at, width, height, top, paper) {
  const columnHits = new Array(width).fill(0);
  for (let y = top; y < height; y++) {
    for (let x = 0; x < width; x++) {
      if (colorDistance(at(x, y), paper) > PAPER_DISTANCE) columnHits[x]++;
    }
  }

  const spans = [];
  let spanStart = -1;
  for (let x = 0; x <= width; x++) {
    const hit = x < width && columnHits[x] > 4;
    if (hit && spanStart < 0) spanStart = x;
    if (!hit && spanStart >= 0) {
      spans.push([spanStart, x - 1]);
      spanStart = -1;
    }
  }

  const merged = [];
  for (const span of spans) {
    const previous = merged[merged.length - 1];
    if (previous && span[0] - previous[1] < 24) {
      previous[1] = span[1];
    } else {
      merged.push([...span]);
    }
  }

  const substantial = merged.filter(([start, end]) => end - start > 40);
  if (substantial.length !== 3) {
    throw new Error(
      `Expected 3 logo lockups, found ${substantial.length}: ${JSON.stringify(substantial)}`,
    );
  }
  return substantial;
}

function boundsForSpan(at, width, height, top, paper, x0, x1) {
  let minX = width;
  let minY = height;
  let maxX = 0;
  let maxY = 0;
  for (let y = top; y < height; y++) {
    for (let x = x0; x <= x1; x++) {
      if (colorDistance(at(x, y), paper) <= PAPER_DISTANCE) continue;
      if (x < minX) minX = x;
      if (y < minY) minY = y;
      if (x > maxX) maxX = x;
      if (y > maxY) maxY = y;
    }
  }
  return { minX, minY, maxX, maxY };
}

function paddedRect(bounds, limit, neighborLeft, neighborRight) {
  const gapLeft = neighborLeft == null ? LOGO_PADDING : Math.floor((bounds.minX - neighborLeft) / 2);
  const gapRight = neighborRight == null ? LOGO_PADDING : Math.floor((neighborRight - bounds.maxX) / 2);
  const padLeft = Math.min(LOGO_PADDING, Math.max(0, gapLeft));
  const padRight = Math.min(LOGO_PADDING, Math.max(0, gapRight));
  const left = Math.max(0, bounds.minX - padLeft);
  const right = Math.min(limit.width - 1, bounds.maxX + padRight);
  const top = Math.max(limit.top, bounds.minY - LOGO_PADDING);
  const bottom = Math.min(limit.height - 1, bounds.maxY + LOGO_PADDING);
  return {
    left,
    top,
    width: right - left + 1,
    height: bottom - top + 1,
  };
}

async function writeWebp(source, rect, outputPath, quality) {
  await sharp(source)
    .extract(rect)
    .webp({ quality, effort: 6, smartSubsample: true })
    .toFile(outputPath);
  const file = await stat(outputPath);
  return file.size;
}

function kb(bytes) {
  return `${(bytes / 1024).toFixed(1)} KB`;
}

async function main() {
  const { data, info } = await sharp(inputPath)
    .ensureAlpha()
    .raw()
    .toBuffer({ resolveWithObject: true });
  const { width, height, channels } = info;
  const at = createReader(data, width, channels);
  const paper = samplePaperColor(at, width, height);
  const split = findHeroSplit(at, width, height, paper);
  const hero = { left: 0, top: 0, width, height: split };

  const spans = findLogoSpans(at, width, height, split, paper);
  const bounds = spans.map(([x0, x1]) => boundsForSpan(at, width, height, split, paper, x0, x1));
  const logos = bounds.map((box, index) =>
    paddedRect(box, { top: split, width, height }, bounds[index - 1]?.maxX, bounds[index + 1]?.minX),
  );

  await mkdir(outDir, { recursive: true });

  const heroPath = path.join(outDir, "hero.webp");
  const heroBytes = await writeWebp(inputPath, hero, heroPath, 74);

  console.log(`source ${width}x${height}`);
  console.log(`paper rgb(${paper.join(", ")})`);
  console.log(`hero ${hero.width}x${hero.height} @ (${hero.left}, ${hero.top}) -> ${kb(heroBytes)}`);

  for (let index = 0; index < logos.length; index++) {
    const rect = logos[index];
    const name = LOGO_NAMES[index];
    const bytes = await writeWebp(inputPath, rect, path.join(outDir, name), 86);
    console.log(
      `${name} ${rect.width}x${rect.height} @ (${rect.left}, ${rect.top}) -> ${kb(bytes)}`,
    );
  }
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
