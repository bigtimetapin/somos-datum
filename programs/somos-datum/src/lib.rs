use anchor_lang::prelude::*;

declare_id!("2tvgaNY3tuBP552wsLWUsYRVUjSNFPQac1FQPxfaDZgc");

#[program]
pub mod somos_datum {
    use super::*;

    pub fn initialize_increment(
        _ctx: Context<InitializeIncrement>,
    ) -> Result<()> {
        Ok(())
    }

    pub fn publish_assets(
        ctx: Context<PublishAssets>,
        seed: u8,
        url: [u8; 78],
    ) -> Result<()> {
        let datum = &mut ctx.accounts.datum;
        let increment_pda = &mut ctx.accounts.increment;
        // increment
        let increment = increment_pda.increment + 1;
        // assert that datum is produced in sequence
        assert_eq!(increment, seed);
        increment_pda.increment = increment;
        // mint
        datum.mint = ctx.accounts.mint.key();
        // url
        datum.url = url;
        // authority
        datum.authority = ctx.accounts.payer.key();
        // datum pda
        datum.seed = seed;
        datum.bump = *ctx.bumps.get("datum").unwrap();
        Ok(())
    }

    pub fn initialize_authority(
        ctx: Context<InitializeAuthority>,
    ) -> Result<()> {
        let authority = &mut ctx.accounts.authority;
        let payer = &mut ctx.accounts.payer;
        // init
        authority.authority = payer.key();
        authority.fee = 0;
        Ok(())
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// DATUM ///////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#[derive(Accounts)]
pub struct InitializeIncrement<'info> {
    #[account(init,
    seeds = [mint.key().as_ref(), payer.key().as_ref()], bump,
    payer = payer,
    space = Increment::SPACE
    )]
    pub increment: Account<'info, Increment>,
    #[account()]
    /// CHECK: excluding check for spl-mint type
    /// provides run-time benefits in avoiding additional
    /// deserialization & binary dependencies
    pub mint: UncheckedAccount<'info>,
    #[account(mut)]
    pub payer: Signer<'info>,
    // system program
    pub system_program: Program<'info, System>,
}

#[derive(Accounts)]
#[instruction(seed: u8)]
pub struct PublishAssets<'info> {
    #[account(init,
    seeds = [mint.key().as_ref(), payer.key().as_ref(), & [seed]], bump,
    payer = payer,
    space = Datum::SPACE
    )]
    pub datum: Account<'info, Datum>,
    #[account(mut, seeds = [mint.key().as_ref(), payer.key().as_ref()], bump)]
    pub increment: Account<'info, Increment>,
    #[account()]
    /// CHECK: excluding check for spl-mint type
    /// provides run-time benefits in avoiding additional
    /// deserialization & binary dependencies
    pub mint: UncheckedAccount<'info>,
    #[account(mut)]
    pub payer: Signer<'info>,
    #[account(seeds = [b"authority"], bump)]
    pub authority: Account<'info, Authority>,
    // system program
    pub system_program: Program<'info, System>,
}

#[derive(Accounts)]
pub struct InitializeAuthority<'info> {
    #[account(init,
    seeds = [b"authority"], bump,
    payer = payer,
    space = Authority::SPACE
    )]
    pub authority: Account<'info, Authority>,
    #[account(mut)]
    pub payer: Signer<'info>,
    // system program
    pub system_program: Program<'info, System>,
}

#[account]
pub struct Datum {
    // target mint
    pub mint: Pubkey,
    // upload url
    pub url: [u8; 78],
    // authority
    pub authority: Pubkey,
    // pda
    pub seed: u8,
    pub bump: u8,
}

impl Datum {
    const SPACE: usize = 8 + 32 + 78 + 32 + 1 + 1;
}

#[account]
pub struct Increment {
    pub increment: u8,
}

impl Increment {
    const SPACE: usize = 8 + 8; // TODO;
}

#[account]
pub struct Authority {
    pub authority: Pubkey,
    pub fee: u64,
}

impl Authority {
    const SPACE: usize = 8 + 32 + 8;
}

#[error_code]
pub enum CustomErrors {
    #[msg("decentralized assets should be immutable.")]
    ImmutableAssets,
}
