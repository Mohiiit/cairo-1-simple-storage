pre-req is to have scarb install, also install katana for local development

using katana create a keystore and a account json commands for that would be something like this:

1. starkli signer keystore from-key ~/Desktop/cairo-projects/cairo_github_projects/starkli-wallets/my_katana_keystore_1.json

2. starkli account fetch 0x517ececd29116499f4a1b64b094da79ba08dfd54a3edaa316134c41f8160973 --output ~/Desktop/cairo-projects/cairo_github_projects/starkli-walletsmy_katana_account_1.json

then export them using this:

1. export STARKNET_RPC="http://127.0.0.1:5050/"
2. export STARKNET_ACCOUNT=~/Desktop/cairo-projects/cairo_github_projects/starkli-wallets/my_katana_account_1.json 
3. export STARKNET_KEYSTORE=~/Desktop/cairo-projects/cairo_github_projects/starkli-wallets/my_katana_keystore_1.json

now let's create the smart contract itself

Step 1) Create the project using scrab new <project_name>
Step 2) Make sure to add the dependecy in the scarb.toml file. and the file would look like this:

```[package]
name = "cairo_1_simple_storage"
version = "0.1.0"

# See more keys and their definitions at https://docs.swmansion.com/scarb/docs/reference/manifest.html

[dependencies]
starknet = ">=2.0.1"

[[target.starknet-contract]]
sierra = true
```

step 3) Then let's start with the smart contract: let's create a simple contract

then let's write a interface for this contract

it's for simple storage so hence making two functions for getting and setting the data in the contract

after this 

let's build the project using the command of scarb build

then we will declare our smart contract using the command starkli declare target/dev/cairo_1_simple_storage_SimpleStorage.sierra.json

then we will get a hash from this command's result and we will use that to deploy our smart contract:

starkli deploy <hash we get>

then to interact with our smart contract we can use the hash we got from above command as:

starkli invoke <hash> set 4

starkli call <hash> get

and this will respond us with a value of 4
