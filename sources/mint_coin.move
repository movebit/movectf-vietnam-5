module movectf::mint_coin {
    use std::option;
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::event;
    use movectf::counter::{Self, Counter};

 


    struct MINT_COIN has drop {}
    struct Flag has copy, drop {
        user: address,
        flag: bool,
    }

    fun init(witness: MINT_COIN, ctx: &mut TxContext) {
        counter::create_counter(ctx);
        let (coincap, coindata) = coin::create_currency(witness, 0, b"mint_coin", b"Ctf Coins", b"create for Ctf", option::none(), ctx);
        transfer::freeze_object(coindata);
        transfer::share_object(coincap);
    }

    public entry fun mint_coin(cap: &mut TreasuryCap<MINT_COIN>, ctx: &mut TxContext) {
        coin::mint_and_transfer<MINT_COIN>(cap, 2, tx_context::sender(ctx), ctx);
    }

    public entry fun burn_coin(cap: &mut TreasuryCap<MINT_COIN>, coins: Coin<MINT_COIN>) {
        coin::burn(cap, coins);
    }

    public entry fun get_flag(user_counter: &mut Counter, coins: &mut Coin<MINT_COIN>, ctx: &mut TxContext) {
        counter::increment(user_counter);
        counter::is_within_limit(user_counter);

        let limit = coin::value(coins);
        assert!(limit == 5, 1);
        event::emit (Flag {
            user: tx_context::sender(ctx),
            flag: true,
        });
    }

}