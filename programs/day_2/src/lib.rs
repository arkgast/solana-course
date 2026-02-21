use anchor_lang::prelude::*;

declare_id!("5PgNrb46oPVRQR1pm711prm9NDcRHB2HWtqLeL8ogjpG");

#[program]
pub mod day_2 {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>, a: u64, b: u64, message: String) -> Result<()> {
        msg!("Message s: {}", message);
        msg!("Numbers are {} and {}", a, b);
        msg!("Greetings from: {:?}", ctx.program_id);
        Ok(())
    }

    pub fn array(_ctx: Context<Initialize>, v: Vec<u64>) -> Result<()> {
        msg!("Vector values are: {:?}", v);
        Ok(())
    }

    pub fn add(_ctx: Context<Initialize>, a: u64, b: u64) -> Result<()> {
        // Overflow protection
        // Plain +
        // Enabled: it consumes 1711 units
        // Disabled: it consumes 277 units
        // .checked_add
        // Enabled: it consumes 776 units
        // Disabled: it consumes 760 units
        let res = match a.checked_add(b) {
            Some(r) => r,
            None => {
                msg!("Overflow error");
                0
            }
        };
        msg!("Add: {}", res);
        Ok(())
    }

    pub fn sub(_ctx: Context<Initialize>, a: u64, b: u64) -> Result<()> {
        let res = a.checked_sub(b).expect("Sub error");
        msg!("Sub: {}", res);
        Ok(())
    }

    pub fn mult(_ctx: Context<Initialize>, a: u64, b: u64) -> Result<()> {
        let res = a.checked_mul(b).expect("Mult error");
        msg!("Mult: {}", res);
        Ok(())
    }

    pub fn div(_ctx: Context<Initialize>, a: u64, b: u64) -> Result<()> {
        let res = a.checked_div(b).expect("Div error");
        msg!("Div: {}", res);
        Ok(())
    }

    pub fn pow(_ctx: Context<Initialize>, a: u64, b: u64) -> Result<()> {
        let b: u32 = b.try_into()?;
        let res: u64 = a.checked_pow(b).expect("Pow error");
        msg!("Pow: {}", res);
        Ok(())
    }

    pub fn log(_ctx: Context<Initialize>, a: u64) -> Result<()> {
        let res = a.checked_ilog10().expect("Error on log fn");
        msg!("Log: {}", res);
        Ok(())
    }
}

#[derive(Accounts)]
pub struct Initialize {}
