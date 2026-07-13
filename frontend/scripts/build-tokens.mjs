import { readFileSync, writeFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import path from "node:path";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const tokensPath = path.join(__dirname, "..", "tokens", "design-tokens.json");
const outPath = path.join(__dirname, "..", "src", "app", "tokens.generated.css");

const tokens = JSON.parse(readFileSync(tokensPath, "utf-8"));

const NAMESPACE_MAP = {
  color: "color",
  font: "font",
  fontSize: "text",
  spacing: "spacing",
  radius: "radius",
};

const lines = [];
for (const [group, cssPrefix] of Object.entries(NAMESPACE_MAP)) {
  const entries = tokens[group];
  if (!entries) continue;
  for (const [key, token] of Object.entries(entries)) {
    lines.push(`  --${cssPrefix}-${key}: ${token.value};`);
  }
}

const css = `/* OTOMATIK URETILDI - ELLE DUZENLEME. Kaynak: tokens/design-tokens.json */
@theme {
${lines.join("\n")}
}
`;

writeFileSync(outPath, css, "utf-8");
console.log(`${lines.length} token yazildi -> ${outPath}`);