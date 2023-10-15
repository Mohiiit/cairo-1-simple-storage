# Cairo 1 Simple Storage

## Description

We are writing a simple storage smart contract using cairo 1.0 here.

## Prerequisites

Here is the list of the prerequisites and installation steps required before you can start working with the project.

### Installing Prerequisites

1. **starkli**: Install starkli by following the instructions in the [official documentation](https://docs.starknet.io/documentation/quick_start/environment_setup/#installing_starkli).

2. **scarb**: Install scarb using the instructions from the [official documentation](https://docs.starknet.io/documentation/quick_start/environment_setup/#installing_scarb).

3. **katana**: Follow the steps outlined in the [official Katana documentation](https://book.starknet.io/chapter_2/katana.html#getting_started_with_katana) to install Katana.

### Troubleshooting

If you encounter any issues during installation, you can seek help and assistance on the [StarkNet Discord](https://starknet.io/discord).

## Wallet Setup

Explain how to set up your wallet using katana. Include the following steps:

1. Run local node of katana using the command: `katana`.
2. Create a signer using the command: `starkli signer keystore from-key <your_address>/my_katana_keystore_1.json`. For more details, refer to [Creating a Signer](https://book.starknet.io/chapter_1/first_contract.html#creating_a_signer).

3. Create an Account Descriptor using the command: `starkli account fetch <account address from katana> --output <your_address>/my_katana_account_1.json`. For more details, refer to [Creating an Account Descriptor](https://book.starknet.io/chapter_1/first_contract.html#creating_an_account_descriptor).

## Environment Setup

After creating your wallet, set up your environment by exporting the following variables. Make sure to adjust the paths and addresses according to your local setup.

```shell
export STARKNET_RPC="http://127.0.0.1:5050/"
export STARKNET_ACCOUNT=<your_address>/my_katana_account_1.json
export STARKNET_KEYSTORE=<your_address>/my_katana_keystore_1.json
```

## Smart Contract Deployment

How to create, build, and deploy a smart contract using the provided commands:

1. Create a new project using scrab: `scarb new simple_storage`.
2. Update the `scarb.toml` file with the necessary dependencies. Here is how your file should look like:
```shell
[package]
name = "cairo_1_simple_storage"
version = "0.1.0"

# See more keys and their definitions at https://docs.swmansion.com/scarb/docs/reference/manifest.html

[dependencies]
starknet = ">=2.0.1"

[[target.starknet-contract]]
sierra = true
```
3. Writing the smart contract:

### Writing the interface for the contract:

```shell
// Declare a interface named "ISimpleStorage" for a smart contract.
#[starknet::interface]
trait ISimpleStorage<TContractState> {
    // Define a method "get" that takes a reference to the contract state and returns a u128 value.
    fn get(self: @TContractState) -> u128;

    // Define a method "set" that takes a mutable reference to the contract state and a u128 value.
    fn set(ref self: TContractState, x: u128);
}

```

### Writing the contract:

```shell
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
```
4. Finally the contract in the `lib.cario` will look like this:

```shell
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
```
5. Build the project: `scarb build`.
6. Declare the smart contract: `starkli declare target/dev/cairo_1_simple_storage_SimpleStorage.sierra.json`. You will a response something like this: 

```shell
...
...
...
Class hash declared:
0x05d7a86da351ec4c35556ad2411a2051cff4e2812edf9f658cf5afb1aeed012d
```
6. Deploy the smart contract using the class hash obtained in the previous step: `starkli deploy <class_hash>`. It will respond with a contract hash:

```shell
...
...
...
Contract deployed:
0x060e7e082fd497de47cd49dcd2cb6e21ff8394ca2779eb3b23fe596bec05d67f
```

## Interacting with the Smart Contract

How you can interact with the deployed smart contract. Here are examples of how to use the `starkli invoke` and `starkli call` commands to write and read data from the contract storage.

Example:

- To write data to the contract storage: `starkli invoke <contract_address> set <value>`.
- To read data from the contract storage: `starkli call <contract_address> get`.

Make sure to replace `<contract_address>` with the actual address of your deployed contract and `<value>` with the desired data value.

## Testing the Smart Contract

### Setting up the Test

We can set up the test up adding these lines just below our smart contract code in the `lib.cairo`:

```shell
#[cfg(test)]
mod test{
    #[test]
    #[available_gas(2000000)]
    fn test_first_test() {
        assert(0==0, "tests are not working");
    }
}
```

Now we can check whether tests are working or not by using the command `scarb test`. It should respond:

```shell
$ scarb test

Running cairo-test cairo_1_simple_storage
testing cairo_1_simple_storage ...
running 1 tests
test cairo_1_simple_storage::test::test_first_test ... ok (gas usage est.: 900)
test result: ok. 1 passed; 0 failed; 0 ignored; 0 filtered out;

```

### Setting up deplo contract function

The deploy_contract function is responsible for deploying the smart contract and returning a dispatcher that can be used to interact with the deployed contract. Here is the function code:

```shell
#[cfg(test)]
mod test {
    use starknet::ContractAddress;
    use super::SimpleStorage;
    use super::ISimpleStorageDispatcher;
    use super::ISimpleStorageDispatcherTrait;
    use starknet::syscalls::deploy_syscall;

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
```

### Writing the tests

The test_getter_function is a test case that checks the behavior of the getter function of the smart contract. Here is the code:

```shell
    #[test]
    #[available_gas(2000000)]
    fn test_getter_function() {
        let dispatcher = deploy_contract();
        let contract_data = dispatcher.get();
        assert(0 == 0, 'it should be 0');
    }
```


The test_setter_function is a test case that checks the behavior of the setter function of the smart contract. Here is the code:

```shell
    #[test]
    #[available_gas(2000000)]
    fn test_setter_function() {
        let dispatcher = deploy_contract();
        dispatcher.set(4);
        let contract_data = dispatcher.get();
        assert(contract_data == 4, 'it should be 4');
    }
```

Here is the how the `lib.cairo` will look like:

```shell
#[starknet::interface]
trait ISimpleStorage<TContractState> {
    fn get(self: @TContractState) -> u128;
    fn set(ref self: TContractState, x: u128);
}

#[starknet::contract]
mod SimpleStorage {
    #[storage]
    struct Storage {
        data: u128
    }

    #[external(v0)]
    impl SimpleStorage of super::ISimpleStorage<ContractState> {
        fn get(self: @ContractState) -> u128 {
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
```

### Running the tests

We can run all the tests using the command `scarb test`. This should be the ideal response:
```shell
scarb test
     Running cairo-test cairo_1_simple_storage
testing cairo_1_simple_storage ...
running 2 tests
test cairo_1_simple_storage::test::test_getter_function ... ok (gas usage est.: 205180)
test cairo_1_simple_storage::test::test_setter_function ... ok (gas usage est.: 307430)
test result: ok. 2 passed; 0 failed; 0 ignored; 0 filtered out;
```