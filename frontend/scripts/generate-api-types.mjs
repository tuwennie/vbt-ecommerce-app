import { execFileSync } from "node:child_process";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, "..");

const source =
  process.env.API_SCHEMA_URL || path.join(root, "openapi", "schema.yaml");

const outFile = path.join(root, "src", "types", "api.generated.ts");

console.log(`OpenAPI kaynagi: ${source}`);
console.log(`Cikti: ${outFile}`);

execFileSync(
  "npx",
  ["openapi-typescript", source, "-o", outFile],
  { stdio: "inherit", cwd: root, shell: true }
);