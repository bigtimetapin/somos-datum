use anchor_lang::prelude::*;

declare_id!("2tvgaNY3tuBP552wsLWUsYRVUjSNFPQac1FQPxfaDZgc");

#[program]
pub mod somos_datum {
    use super::*;

    pub fn publish_assets(
        ctx: Context<PublishAssets>,
        seed: [u8; 1],
        key: [u8; 184],
        url: [u8; 78],
    ) -> Result<()> {
        let datum = &mut ctx.accounts.datum;
        let increment = &mut ctx.accounts.increment;
        // mint
        datum.mint = ctx.accounts.mint.key();
        // assets
        datum.assets = EncryptedAssets { key, url };
        // datum pda
        datum.authority = ctx.accounts.payer.key();
        datum.seed = seed;
        datum.bump = *ctx.bumps.get("datum").unwrap();
        // increment
        increment.increment = increment.increment + 1;
        Ok(())
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// DATUM ///////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#[derive(Accounts)]
#[instruction(seed: [u8; 1])]
pub struct PublishAssets<'info> {
    #[account(init,
    seeds = [mint.key().as_ref(), payer.key().as_ref(), & seed], bump,
    payer = payer,
    space = Datum::SPACE
    )]
    pub datum: Account<'info, Datum>,
    #[account(init_if_needed,
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

#[account]
pub struct Datum {
    // target mint
    pub mint: Pubkey,
    // encrypted assets
    pub assets: EncryptedAssets,
    // pda
    pub authority: Pubkey,
    pub seed: [u8; 1],
    pub bump: u8,
}

impl Datum {
    const SPACE: usize = 8 + 32 + 184 + 78 + 32 + 1 + 1;
}

#[account]
pub struct Increment {
    pub increment: u8,
}

impl Increment {
    const SPACE: usize = 8 + 8;
}


#[derive(AnchorSerialize, AnchorDeserialize, Clone, Copy)]
pub struct EncryptedAssets {
    pub key: [u8; 184],
    pub url: [u8; 78],
}

#[error_code]
pub enum CustomErrors {
    #[msg("decentralized assets should be immutable.")]
    ImmutableAssets,
}
