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
