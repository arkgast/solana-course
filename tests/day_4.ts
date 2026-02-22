import * as anchor from "@coral-xyz/anchor";
import { AnchorError, Program } from "@coral-xyz/anchor";
import { BN } from "bn.js";
import { assert } from "chai";
import { type Day4 } from "../target/types/day_4.ts";

describe("Day 4", () => {
  // Configure the client to use the local cluster.
  anchor.setProvider(anchor.AnchorProvider.env());

  const program = anchor.workspace.day4 as Program<Day4>;

  it("should not throw", async () => {
    const num = new BN("50");
    const tx = await program.methods.limitRange(num).rpc();
    console.log("Tx signature: ", tx);
  });

  it("should throw if input is below lower limit", async () => {
    try {
      const num = new BN("5");
      const tx = await program.methods.limitRange(num).rpc();
      console.log("Tx signature", tx);
    } catch (_err) {
      assert.isTrue(_err instanceof AnchorError);
      const err: AnchorError = _err;
      const errMsg = "param is too small";
      assert.strictEqual(err.error.errorMessage, errMsg);
      console.log("Anchor error: ", err.error);
    }
  });

  it("should throw if input is above higher limit", async () => {
    try {
      const num = new BN("150");
      const tx = await program.methods.limitRange(num).rpc();
      console.log("Tx signature", tx);
    } catch (_err) {
      assert.isTrue(_err instanceof AnchorError);
      const err: AnchorError = _err;
      const errMsg = "param is too big";
      assert.strictEqual(err.error.errorMessage, errMsg);
      console.log("Anchor error: ", err.error);
    }
  });

  it("should throw", async () => {
    try {
      await program.methods.alwaysErrors().rpc();
      assert.fail("Tx executed successfully when it should fail");
    } catch (_err) {
      assert.isTrue(_err instanceof AnchorError);
      const err: AnchorError = _err;
      const errMsg = "always errors";
      assert.strictEqual(err.error.errorMessage, errMsg);
      console.log("Anchor error: ", err.error);
    }
  });
});
