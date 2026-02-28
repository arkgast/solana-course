# Solana Course (Anchor + Rust)

Hands-on Solana learning repo with small daily programs (`day_1` to `day_X`) and TypeScript tests.

This README is written for learning: each section explains what to run and why it matters.

## 1. What You Will Learn

- How to write Anchor programs in Rust.
- How to call instructions from TypeScript tests.
- How account validation works (`Context<...>` and `#[derive(Accounts)]`).
- How errors and `require!` behave in Solana programs.
- How IDL files connect on-chain Rust code to off-chain clients.
- How to build, deploy, and test each program on localnet.

## 2. Project Layout

```text
programs/
  day_1 ... day_X/       # Solana programs (Rust + Anchor)
tests/
  day_1.ts ... day_5.ts  # Client-side tests (TypeScript + Anchor)
Anchor.toml              # Program IDs, localnet config, test script
Makefile                 # Day-specific deploy/test shortcuts
```

## 3. Prerequisites

Install and verify:

- Rust (toolchain in this repo is pinned in `rust-toolchain.toml`).
- Solana CLI (`solana --version`).
- Anchor CLI (`anchor --version`).
- Node.js + Yarn (`node -v`, `yarn -v`).

If your wallet is not set up yet:

```bash
solana-keygen new
solana config set --url http://127.0.0.1:8899
```

## 4. Quick Start

Install JavaScript dependencies:

```bash
yarn install
```

Build all programs:

```bash
anchor build
```

Start local validator (terminal 1):

```bash
solana-test-validator --reset
```

Run tests against that validator (terminal 2):

```bash
anchor test --skip-local-validator
```

## 5. Day-by-Day Learning Path

### Day 1: First instruction

- File: `programs/day_1/src/lib.rs`
- Test: `tests/day_1.ts`
- Goal: call a basic instruction (`initialize`) and confirm your local setup works.

### Day 2: Types, vectors, and safe arithmetic

- File: `programs/day_2/src/lib.rs`
- Test: `tests/day_2.ts`
- Goal: pass `u64`, `String`, and `Vec<u64>` from TypeScript into Rust.
- Practice safe math with `checked_add`, `checked_sub`, `checked_mul`, `checked_div`, and `checked_pow`.

### Day 3: Accounts context patterns

- File: `programs/day_3/src/lib.rs`
- Test: `tests/day_3.ts`
- Goal: compare an instruction with required signer accounts vs an instruction with empty accounts.

### Day 4: Custom errors and validation

- File: `programs/day_4/src/lib.rs`
- Test: `tests/day_4.ts`
- Goal: use `require!` and custom `#[error_code]` enums, then assert those errors in tests.

### Day 5: IDL and manual client creation

- File: `programs/day_5/src/lib.rs`
- Test: `tests/day_5.ts`
- Goal: instantiate an Anchor `Program` client manually from `target/idl/day_5.json`.

### Day 6: Scaffold for next lessons

- File: `programs/day_6/src/lib.rs`
- Goal: starter module ready for extending with new topics.

## 6. Useful Commands

### Local validator

```bash
solana-test-validator
solana-test-validator --reset
```

### Build and key sync

```bash
anchor build
anchor keys sync
```

### Run specific day with Makefile

```bash
make test DAY=day_2
# or shortcut:
make test-day_2
```

### Run all tests (with existing local validator)

```bash
anchor test --skip-local-validator
```

### Wallet and airdrop

```bash
solana address
solana balance
solana airdrop 2
```

### Logs and program logs

```bash
solana logs
ls .anchor/program-logs/
```

## 7. Core Concepts (Practical)

### `u64` in Solana programs

Many examples use `u64` because it is a common integer type for balances, counters, and amounts.
In TypeScript tests, pass large integers using `BN` (`bn.js`) to avoid JavaScript number limits.

### Overflow and safe math

Rust can panic on overflow depending on build settings, but in on-chain code you should prefer explicit safe math:

- `checked_*` returns `Option<T>`.
- Handle `None` and return a program error when needed.

This repo shows safe math patterns in `day_2`.

### Compute units

Each transaction has a compute budget. If your instruction uses too much compute, the transaction fails.
Small code choices can change compute usage, so test and measure while optimizing.

### IDL (Interface Definition Language)

Anchor generates IDL JSON files under `target/idl/`.
IDL describes instruction names, arguments, and account requirements so clients can call your program safely.

Equivalent mental model for Solidity developers: IDL is similar to ABI metadata.

Note: Rust `snake_case` instruction names become `camelCase` in TypeScript clients.

### Errors and `require!`

Use `require!(condition, CustomError)` for guard checks.
If a condition fails, your instruction returns an error and the transaction is reverted.
`day_4` demonstrates both success and failure test cases.

Reference: https://www.anchor-lang.com/docs/features/errors

### Deployment and upgrades

Anchor deploys upgradeable programs by default (upgrade authority exists).
You can upgrade while authority is active; removing authority makes the program immutable.
For tests, `--skip-deploy` or `--skip-local-validator` helps target an already running environment.

## 8. Common Learning Workflow

1. Start validator: `solana-test-validator --reset`
2. Build programs: `anchor build`
3. Run one lesson: `make test DAY=day_4`
4. Inspect logs: `solana logs`
5. Modify program logic and rerun the same day

Repeat this loop until you can explain both the Rust instruction and the TypeScript call path.

## 9. Troubleshooting

- `AccountNotFound` or signer errors:
  verify account constraints in the instruction `Context`.
- Program ID mismatch:
  run `anchor keys sync` and rebuild.
- Wallet has no SOL:
  run `solana airdrop 2`.
- Tests target wrong RPC:
  ensure provider points to localnet (`http://127.0.0.1:8899`).
