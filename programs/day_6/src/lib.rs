use anchor_lang::prelude::*;
use macros::{destroy_attribute, foo_bar_attribute};

declare_id!("DU9N5zmzYE1ECamEBhXmgTqnBBryusUx1wzavLXx6bPy");

#[foo_bar_attribute]
struct MyStruct {
    baz: i32,
}

#[destroy_attribute]
struct MyStruct2 {
    baz: i32,
    qux: i32,
}

#[program]
pub mod day_6 {
    use macros::destroy_attribute;

    use super::*;

    pub fn initialize(_: Context<Initialize>) -> Result<()> {
        let my_struct = MyStruct::default();
        // when printed it shows that my_struct has only foo and bar fields
        msg!("{:#?}", my_struct);

        let double_foo = my_struct.double_foo();
        msg!("Double Foo res: {}", double_foo);

        Ok(())
    }
}

#[derive(Accounts)]
pub struct Initialize {}
