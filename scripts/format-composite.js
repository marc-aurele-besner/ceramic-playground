import { readdirSync, readFileSync, writeFileSync } from "fs";

const format = () => {
  if (!process.env.COMPOSITE_DIR)
    throw new Error("COMPOSITE_DIR env variable is required");

  const { COMPOSITE_DIR } = process.env;

  // List all file from directory
  const files = readdirSync(COMPOSITE_DIR);

  // Loop through all files
  for (const file of files) {
    // Read file content
    const content = readFileSync(`${COMPOSITE_DIR}/${file}`, "utf8");

    // Save file content with formatted JSON
    writeFileSync(
      `${COMPOSITE_DIR}/${file}`,
      JSON.stringify(JSON.parse(content), null, 2)
    );
  }
};

format();
