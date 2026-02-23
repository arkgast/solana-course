use anchor_lang::prelude::*;

declare_id!("3ZecEBnrkQu31ZX2w4bU3d4Y6aLPAHENQqLxEtq8BqET");

// Deployed program 3ZecEBnrkQu31ZX2w4bU3d4Y6aLPAHENQqLxEtq8BqET
// Upgraded program 3ZecEBnrkQu31ZX2w4bU3d4Y6aLPAHENQqLxEtq8BqET

#[program]
pub mod day_5 {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        msg!("Greetings from: {:?}", ctx.program_id);
        Ok(())
    }
}

#[derive(Accounts)]
pub struct Initialize {}
