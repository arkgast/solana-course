import * as anchor from "@coral-xyz/anchor";
import { Program } from "@coral-xyz/anchor";
import { BN } from "bn.js";
import { type Day3 } from "../target/types/solana_course";

describe("Day 3", () => {
  anchor.setProvider(anchor.AnchorProvider.env());

  const program = anchor.workspace.day3 as Program<Day3>;

  it("Call non_empty_accounts_example", async () => {
    const tx = await program.methods.nonEmptyAccountsExample().rpc();
    console.log("Tx signature: ", tx);
  });

  it("Call empty_accounts_example", async () => {
    const tx = await program.methods.emptyAccountsExample("Hi!").rpc();
    console.log("Tx signature: ", tx);
  });
});
