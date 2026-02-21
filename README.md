# Solana Course - RareSkills

## Commands

### Init project and programs

    $ anchor init solana-course
    $ anchor new day_1
    $ anchor build

### Run solana local (test) node instance

    $ solana-test-validator
    $ solana-test-validator --reset

### Sync keys

    $ anchor keys sync

### Tests

    $ anchor test --skip-local-validator // use (local) test node instance

### Logs

    $ solana logs
    $ ls .anchor/program-logs/

### Wallet

    $ solana address
    $ solana balance
    $ solana airdrop <amount> <address>

## Concepts

Solana uses u64 as the "standard" integer size.

### Arithmetic overflow

If the key overflow-checks is set to true in the Cargo.toml file, then Rust will add overflow checks
at the compiler level. See the screenshot of Cargo.toml next:

### Compute units

By default, a transaction is limited to 200,000 compute units. If more than 200,000 compute units are consumed, the transaction reverts.

- With overflow protection disabled a math operation consumes 824 compute units
- With overflow protection enabled in consumes 872 compute units.
