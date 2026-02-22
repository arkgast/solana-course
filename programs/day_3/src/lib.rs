use anchor_lang::prelude::*;

declare_id!("7aVVoCgRAmdqTkEHoVUegndGgG6Kc5nNNFmkdXkXTJgs");

#[program]
pub mod day_3 {
    use super::*;

    pub fn non_empty_accounts_example(_ctx: Context<NonEmptyAccountsExample>) -> Result<()> {
        Ok(())
    }

    pub fn empty_accounts_example(
        _ctx: Context<EmptyAccountsExample>,
        uniq_arg: String,
    ) -> Result<()> {
        Ok(())
    }
}

#[derive(Accounts)]
pub struct NonEmptyAccountsExample<'info> {
    signer: Signer<'info>,
    another_signer: Signer<'info>,
}

#[derive(Accounts)]
pub struct EmptyAccountsExample {}
