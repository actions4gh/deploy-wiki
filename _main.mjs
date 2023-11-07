import { spawn } from "node:child_process";
import { once } from "node:events";
import { join, dirname } from "node:path";
const file = join(dirname(process.argv[1]), "main.ts"); // 👈 CHANGE ME!
const subprocess = spawn("bash", [file], { stdio: "inherit" });
await once(subprocess, "spawn");
subprocess.on("exit", (x) => process.exit(x));
