import * as anchor from "@coral-xyz/anchor";
import { Program } from "@coral-xyz/anchor";
import { BN } from "bn.js";
import { type Day2 } from "../target/types/solana_course";

describe("Day 2", () => {
  anchor.setProvider(anchor.AnchorProvider.env());

  const program = anchor.workspace.day2 as Program<Day2>;

  it("Is initialized!", async () => {
    const a = new BN(555);
    const b = new BN(666);
    const message = "Hi!";

    const tx = await program.methods.initialize(a, b, message).rpc();
    console.log("Your transaction signature", tx);
  });

  it("Array test", async () => {
    const arr = [
      new BN(555),
      new BN(666),
      new BN(777),
    ];
    const tx = await program.methods.array(arr).rpc();
    console.log("Array tx signature", tx);
  });

  it("Add test", async () => {
    const a = new BN(1);
    const b = new BN("18446744073709551615"); // u64::MAX
    const tx = await program.methods.add(a, b).rpc();
    console.log("Add tx signature", tx);
  });

  it("Sub test", async () => {
    const a = new BN(10);
    const b = new BN(1);
    const tx = await program.methods.sub(a, b).rpc();
    console.log("Sub tx signature", tx);
  });

  it("Mult test", async () => {
    const a = new BN(4);
    const b = new BN(4);
    const tx = await program.methods.mult(a, b).rpc();
    console.log("Mult tx signature", tx);
  });

  it("Div test", async () => {
    const a = new BN(4);
    const b = new BN(4);
    const tx = await program.methods.div(a, b).rpc();
    console.log("Div tx signature", tx);
  });

  it("Pow test", async () => {
    const a = new BN(2);
    const b = new BN(2);
    const tx = await program.methods.pow(a, b).rpc();
    console.log("Pow tx signature", tx);
  });

  it("Log test", async () => {
    const a = new BN(100);
    const tx = await program.methods.log(a).rpc();
    console.log("Log tx signature", tx);
  });
});
