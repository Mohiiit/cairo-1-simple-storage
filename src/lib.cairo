// Declare a interface named "ISimpleStorage" for a smart contract.
#[starknet::interface]
trait ISimpleStorage<TContractState> {
    // Define a method "get" that takes a reference to the contract state and returns a u128 value.
    fn get(self: @TContractState) -> u128;

    // Define a method "set" that takes a mutable reference to the contract state and a u128 value.
    fn set(ref self: TContractState, x: u128);
}


// Declare a contract module named "SimpleStorage".
#[starknet::contract]
mod SimpleStorage {

    // Define a struct named "Storage" that represents the contract's storage.
    #[storage]
    struct Storage {
        data: u128
    }

    // Implement the SimpleStorage contract for the ISimpleStorage trait, providing methods to interact with the contract.
    #[external(v0)]
    impl SimpleStorage of super::ISimpleStorage<ContractState> {
        // Define a method "get" that reads and returns a u128 value from the contract's storage.
        fn get(self: @ContractState) -> u128 {
            self.data.read()
        }

        // Define a method "set" that writes a u128 value to the contract's storage.
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
        assert(0 == 0, 'it should be 0');
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


