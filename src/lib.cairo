
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

#[cfg(test)]
mod test {
    use starknet::ContractAddress;
    use super::SimpleStorage;
    use super::ISimpleStorageDispatcher;
    use super::ISimpleStorageDispatcherTrait;
    use starknet::syscalls::deploy_syscall;

    #[test]
    #[available_gas(2000000)]
    fn test_getter_function() {
        let dispatcher = deploy_contract();
        let contract_data = dispatcher.get();
        assert(contract_data == 0, 'it should be 0');
    }

    #[test]
    #[available_gas(2000000)]
    fn test_setter_function() {
        let dispatcher = deploy_contract();
        dispatcher.set(4);
        let contract_data = dispatcher.get();
        assert(contract_data == 4, 'it should be 4');
    }

    fn deploy_contract() -> ISimpleStorageDispatcher {
        let mut calldata = ArrayTrait::new();
        let (address0, _) = deploy_syscall(
            SimpleStorage::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .unwrap();
        let contract0 = ISimpleStorageDispatcher { contract_address: address0 };
        contract0
    }
}


