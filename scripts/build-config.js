import { existsSync, mkdirSync, rmSync, writeFileSync } from 'fs'

const GENERATED_DIR = './.generated'
const CONFIG_FILE = `${GENERATED_DIR}/ceramic-config.json`
const config = {
  "anchor": {},
  "http-api": {
    "cors-allowed-origins": [".*"],
    "admin-dids": [process.env.COMPOSEDB_ADMIN_DID]
  },
  "ipfs": {
    "mode": "bundled"
  },
  "network": {
    "name": "inmemory"
  },
  "node": {},
  "state-store": {
    "mode": "fs",
    "local-directory": ".ceramic/statestore/"
  },
  "indexing": {
    "db": "sqlite:.ceramic/indexing-inmemory.sqlite",
    "allow-queries-before-historical-sync": true,
  }
}

const build = () => {
  if (!process.env.COMPOSEDB_ADMIN_DID)
    throw new Error('COMPOSEDB_ADMIN_DID env variable is required')

  if (!existsSync(GENERATED_DIR)) mkdirSync(GENERATED_DIR)
  if (existsSync(CONFIG_FILE)) rmSync(CONFIG_FILE)

  writeFileSync(CONFIG_FILE, JSON.stringify(config, null, 2))
}

build()
