import * as anchor from "@coral-xyz/anchor";
import { Program } from "@coral-xyz/anchor";
import { type Day6 } from "../target/types/day_6";

describe("Day 6", () => {
  anchor.setProvider(anchor.AnchorProvider.env());

  const program = anchor.workspace.day6 as Program<Day6>;

  // Note: review day_6 code. Macros were implemented and used
  it("Is initialized!", async () => {
    const tx = await program.methods.initialize().rpc();
    console.log("Your transaction signature", tx);
  });
});
