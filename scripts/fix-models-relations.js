import { readdirSync, readFileSync, writeFileSync, unlinkSync } from "fs";

const fix = () => {};

const run = () => {
  if (!process.env.GENERATED_DIR)
    throw new Error("GENERATED_DIR env variable is required");
  if (!process.env.MODELS_DIR)
    throw new Error("MODELS_DIR env variable is required");

  const { GENERATED_DIR } = process.env;

  const remainingRelations = 0;

  const rawModelsList = readFileSync(
    `${GENERATED_DIR}/models-list.json`,
    "utf8"
  );
  const models = JSON.parse(rawModelsList);

  // List all file from directory
  const files = readdirSync(`${GENERATED_DIR}/models`);

  const modelsMissing = files.length - (models.length - 1);
  console.log(
    "\x1b[36m%s\x1b[0m",
    `Models missing: ${modelsMissing}`,
    "\x1b[0m"
  );

  // Loop through all files
  for (const file of files) {
    // Read file content
    const content = readFileSync(`${GENERATED_DIR}/models/${file}`, "utf8");
    let newContent = "";

    // Verify if file has relations to fix
    const hasRelations = content.includes("[modelName:");
    if (hasRelations) {
      // Get model name
      const relations = content.match(/\[modelName:(.*?)\]/g);
      for (const relation of relations) {
        const content = readFileSync(`${GENERATED_DIR}/models/${file}`, "utf8");
        const relationName = relation
          .replace("[modelName:", "")
          .replace("]", "");

        const relationPossible = models.find(
          (model) => model.modelName === relationName
        );
        if (relationPossible) {
          newContent = content.replace(
            `[modelName:${relationName}]`,
            relationPossible.modelId
          );
          console.log(
            "\x1b[36m%s\x1b[0m",
            `Relation [modelName:${relationName}] fixed in ${GENERATED_DIR}/models/${file}`,
            "\x1b[0m"
          );
          // Save models fixed
          writeFileSync(`${GENERATED_DIR}/models/${file}`, newContent);
        } else remainingRelations++;
      }
    }
  }

  if (remainingRelations > 0 || modelsMissing > 0) {
    console.log(
      `There are ${remainingRelations} relations that could not be fixed`
    );
    console.log(
      `There are ${modelsMissing} models missing in models-list.json`
    );
    writeFileSync(
      `${GENERATED_DIR}/pending-relations.txt`,
      (remainingRelations + modelsMissing).toString()
    );
  } else {
    console.log("All relations fixed");
    // Delete pending relations file
    unlinkSync(`${GENERATED_DIR}/pending-relations.txt`);
  }
};

run();
