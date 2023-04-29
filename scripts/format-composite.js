import { readdirSync, readFileSync, writeFileSync } from "fs";

const GENERATED_DIR = "./.generated";
const COMPOSITE_DIR = "./.generated/composite";

const format = () => {
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
