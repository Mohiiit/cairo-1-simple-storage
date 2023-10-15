#[starknet::interface]
trait ISimpleStorage<TContractState> {
    fn get(self: @TContractState) ->  u128;
    fn set(ref self: TContractState, x: u128);
}

#[starknet::contract]
mod SimpleStorage {

    #[storage]
    struct Storage {
        data: u128
    }
    
    #[external(v0)]
    impl SimpleStorage of super::ISimpleStorage<ContractState>{
        fn get(self: @ContractState) ->  u128 {
            self.data.read()
        }

        fn set(ref self: ContractState, x: u128) {
            self.data.write(x);
        }
    }
}

