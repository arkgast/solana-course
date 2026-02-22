use anchor_lang::prelude::*;

declare_id!("2SmsGsCi6NmAVppHjXHsewEi5uGx5fvaPvcahPYpstAp");

#[program]
pub mod day_4 {
    use super::*;

    pub fn limit_range(_ctx: Context<LimitRange>, a: u64) -> Result<()> {
        require!(a >= 10, MyError::ParamIsToSmall);
        require!(a <= 100, MyError::ParamIsToBig);
        msg!("Result: {}", a);
        Ok(())
    }

    pub fn limit_range_v2(_ctx: Context<LimitRange>, a: u64) -> Result<()> {
        if a < 10 {
            return err!(MyError::ParamIsToSmall);
        }
        if a > 100 {
            return err!(MyError::ParamIsToBig);
        }
        msg!("Result = {}", a);
        Ok(())
    }

    pub fn always_errors(_ctx: Context<LimitRange>) -> Result<()> {
        // The next message won't log cause this fn returns an error
        msg!("Fn that always errors");
        return err!(MyError::AlwaysErrors);
    }
}

#[derive(Accounts)]
pub struct LimitRange {}

#[error_code]
pub enum MyError {
    #[msg("param is too big")]
    ParamIsToBig,
    #[msg("param is too small")]
    ParamIsToSmall,
    #[msg("always errors")]
    AlwaysErrors,
}
