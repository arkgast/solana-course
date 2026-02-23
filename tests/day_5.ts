import fs from "fs";
import * as anchor from "@coral-xyz/anchor";
import { Program } from "@coral-xyz/anchor";
import { type Day5 } from "../target/types/day_5.ts";

const fileContent = fs.readFileSync("target/idl/day_5.json", "utf-8");
const idl = JSON.parse(fileContent);

describe("Day 5", () => {
  // Sets RPC connection + wallet from environment.
  // Does NOT deploy anything.
  anchor.setProvider(anchor.AnchorProvider.env());

  /**
   * Option 1 — anchor.workspace
   *
   * const program = anchor.workspace.day5 as Program<Day5>;
   *
   * Auto-loads IDL + program ID from Anchor.toml.
   * Creates a client wrapper only (no deployment).
   */

  /**
   * Option 2 — Manual instantiation
   *
   * In Anchor >= 0.30, the program ID is embedded in the IDL
   * under the `address` field, so it is not passed separately.
   * This only creates a client to interact with the already
   * deployed program — it does NOT deploy or upgrade it.
   */
  const program = new Program<Day5>(idl, anchor.getProvider());

  it("Is initialized!", async () => {
    // Sends an instruction to the deployed program.
    const tx = await program.methods.initialize().rpc();
    console.log("Your transaction signature", tx);
  });
});
