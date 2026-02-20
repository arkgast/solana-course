use anchor_lang::prelude::*;

declare_id!("5dUwkHQDurqJFEky2sHpnVJ4Xob7W9GAMr3XWThCMmCc");

#[program]
pub mod day_1 {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        msg!("Greetings from: {:?}", ctx.program_id);
        Ok(())
    }
}

#[derive(Accounts)]
pub struct Initialize {}
