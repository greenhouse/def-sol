# defi-arb
# history: def-sol_020725 -> snow_020125 -> defi-arb_081624

## SOLIDITY_KB

## INDEX ##
    ### VS code solidity compilation fail (clear cache)
    ### TimeLock.sol example queue and execute (chatgpt)
    ### Panic Error Codes
    ### common error codes
    ### uniswapv2 remove liquidity failure
    ### gas costs calculations per operation 
    ### blockchain mempool (tx_pool) data... (chatGPT)
    ### abstract contracts
    ### compiling warning - code size
    ### compiling error: 'stack too deep'
    ### array initializations (chatGPT)
    ### data locations (chatGPT)
    ### solidity native 'block' object attributes (chatGPT)
    ### Upgradeability patterns: Transparent Proxy vs. UUPS (Universal Upgradeable Proxy System) _ chatGPT
    ### checking for existing mappings
    ### using 'memory' isntead of 'storage'
    ### UINT storage sizes (chatGPT)
    ### indexing event parameters (chatGPT)
    ### Common solidity functions mapped to hex values (that you see in the block explorer)
    ### FUNCTION MODIFIERS & DECORATORS

## KB ##
### VS code solidity compilation fail (clear cache)
    OSx:     $ rm -rf ~/Library/Application\ Support/Code/User/globalStorage/juanblanco.solidity
    Linux:   $ rm -rf ~/.config/Code/User/globalStorage/juanblanco.solidity
    Windows: $ Remove-Item -Recurse -Force "$env:APPDATA\Code\User\globalStorage\juanblanco.solidity"


### receive() & fallback()
    the receive() function in Solidity cannot handle transactions that include data. It is specifically designed to handle plain Ether transfers without any accompanying data. If a transaction includes data, the fallback() function will be invoked instead.

    Summary
    receive(): Handles plain Ether transfers without data.
    fallback(): Handles Ether transfers with data or calls to non-existent functions.
    
### TimeLock.sol example queue and execute (chatgpt)
    import "./TimeLock.sol";
    TimeLock private timelock;
    address public SOME_CONTRACT;

    constructor(address _timelock, address _someContract) {
        timelock = Timelock(_timelock);
        SOME_CONTRACT = _someContract;
    }

    function queueExampleFunction(address newOwner, uint256 amount) external {
        address target = SOME_CONTRACT; // The address of the target contract
        uint value = 0; // No Ether is sent with this transaction
        string memory signature = "exampleFunction(address,uint256)";
        bytes memory data = abi.encode(newOwner, amount); // Encode the parameters
        uint eta = block.timestamp + 1 days; // Set the execution time to 1 day from now

        timelock.queueTransaction(target, value, signature, data, eta);
    }

    function executeExampleFunction(address newOwner, uint256 amount, uint eta) external {
        address target = SOME_CONTRACT; // The address of the target contract
        uint value = 0; // No Ether is sent with this transaction
        string memory signature = "exampleFunction(address,uint256)";
        bytes memory data = abi.encode(newOwner, amount); // Encode the parameters

        timelock.executeTransaction(target, value, signature, data, eta);
    }

### Panic Error Codes
    Panic errors use the selector 0x4e487b71 and the following codes:
    0x00 – Generic assertion error (used for assert violations).
    0x01 – Arithmetic overflow or underflow (e.g., addition overflow, subtraction underflow).
    0x11 – Division by zero.
    0x12 – Invalid enum value (i.e., an enum has been assigned an invalid value).
    0x21 – Invalid memory or calldata access (e.g., out-of-bounds access).
    0x22 – Out-of-bounds storage access.
    0x31 – pop() on an empty array.
    0x32 – Array index out of bounds (the error you're encountering).
    0x41 – Memory allocation error (e.g., when there's not enough memory).
    0x51 – Invalid internal function type.
    You can find this list and more detailed information in the Solidity documentation under the section covering Panic and Assert Errors.
    For general Solidity errors, including custom ones, the Solidity ABI specification provides details on how error selectors and encodings work.
    You can also check out the following sources for common Solidity errors and their resolution:
    Solidity GitHub Issues (https://github.com/ethereum/solidity/issues)
    Solidity Documentation (https://docs.soliditylang.org/)

### common error codes
    - 0x4e487b710000000000000000000000000000000000000000000000000000000000000032
    - chatGPT
        The error code 0x4e487b71 corresponds to the Panic error in Solidity. Specifically, this error is part of the built-in error type introduced with Solidity 0.8.x to handle common issues related to the EVM.
        Let's break it down:
        0x4e487b71 is the selector for the Panic error.
        The 0000000000000000000000000000000000000000000000000000000000000032 is the encoded data (the panic code) that corresponds to a specific issue.
        The Panic error has several predefined codes, and the one in your case is 0x32 (hexadecimal for 50 in decimal). According to the Solidity documentation, panic code 0x32 (50) corresponds to:
        Panic: Array index is out of bounds.
        So, this error indicates that there was an attempt to access an array using an index that is out of its bounds.
        If you are accessing an array in the function that triggered this error, you should check if the index you are using is within the valid range of the array's length.

### uniswapv2 remove liquidity failure
    - 042823: came across inseteance where i couldn't remove LP for TBF13.1,2
    - turns out i just needed to change 'details' in the pulseX remove UI
        needed to set to receive WPLS instead of PLS
    - ref: https://support.uniswap.org/hc/en-us/articles/20981158150029-I-can-t-remove-my-liquidity-position
    
### stack too deep error ###
    solidity compiler (vscode) error:
        CompilerError: Stack too deep. Try compiling with `--via-ir` (cli) or the equivalent `viaIR: true` (standard JSON) while enabling the optimizer. Otherwise, try removing local variables.

    chatGPT answer:
        The "Stack too deep" error in Solidity occurs when the number of local variables, function parameters, or expressions within a single function exceeds the compiler's limit for the stack size. Solidity imposes a limit on the size of the execution stack to prevent potential stack overflow issues.

        Here's some general information about this error:

        1. **Cause**: This error usually occurs when a function has too many local variables, function parameters, or nested expressions, causing the compiler to exceed its stack size limit.

        2. **Limitations**: Solidity imposes a limit on the stack size to ensure efficient execution and prevent potential security vulnerabilities such as stack overflow attacks. The exact limit may vary depending on the Solidity version and compiler settings.

        3. **Resolution**:
        - **Reduce Complexity**: Simplify the function by breaking it down into smaller, more manageable functions. This can help reduce the number of local variables and expressions within each function.
        - **Remove Unnecessary Variables**: Remove any unnecessary local variables or function parameters to reduce the stack size.
        - **Optimize Code**: Optimize the code to minimize the number of nested expressions or function calls within the function.
        - **Compiler Flags**: Use compiler flags such as `--via-ir` or `viaIR: true` to enable intermediate representation (IR) optimization, which may help mitigate the stack size issue.
        - **Enable Optimizer**: Enable the optimizer (`--optimize` flag) to allow the compiler to optimize the generated code, potentially reducing the stack size.
        
        4. **Compiler Options**: Solidity provides various compiler options and settings that can be adjusted to optimize code generation and mitigate stack size issues. Experimenting with different settings and compiler flags may help resolve the error.

        5. **Version Compatibility**: Ensure that the Solidity version you're using is compatible with the compiler options and settings you're applying. Newer Solidity versions may have different default settings or optimizations that affect stack size.

        Overall, the "Stack too deep" error requires careful analysis of the affected code and may involve a combination of code restructuring, optimization, and adjusting compiler settings to resolve.

### gas costs calculations per operation 
    Certainly! Here's a more technical breakdown of the gas costs for common operations in Solidity:
    These gas costs are crucial for developers to consider when designing and optimizing smart contracts for efficiency and cost-effectiveness on the Ethereum blockchain.
        SLOAD: Gas cost for loading a word (32 bytes) from storage - 200 gas. It reads a value from contract storage.
        SSTORE: Gas cost for storing a word (32 bytes) to storage - Variable depending on the context. 
            For a new storage slot, it's 20,000 gas. For updating an existing slot from zero to non-zero, it's 5,000 gas. For updating an existing slot from non-zero to zero, a refund of 15,000 gas is issued.
        CALL: Gas cost for making an external function call - 700 gas plus additional gas for the execution of the called contract. 
            It includes the overhead of setting up the call and performing the necessary state changes.
        CREATE: Gas cost for creating a new contract - 32,000 gas plus additional gas for the execution of the contract's constructor. 
            This covers the cost of deploying a new contract and executing its constructor code.
        LOG0 - LOG4: Gas cost for logging events - 375 gas per LOG operation plus 8 gas per byte for the log data. 
            This is used to emit events from a contract, which can be observed by external applications.
        EXP: Gas cost for exponentiation - 10 gas per byte of exponent. 
            It calculates exponentiation, with the gas cost increasing with the size of the exponent.
        MUL, DIV, ADD, SUB: Gas costs for arithmetic operations - 3 gas each. These operations perform basic arithmetic, 
            such as multiplication, division, addition, and subtraction, with a fixed gas cost per operation.
        JUMP: Gas cost for a jump operation - 8 gas per jump destination. This is used for unconditional jumps within the contract code.
        JUMPI: Gas cost for a conditional jump operation - 10 gas per jump destination plus 2 gas if the condition is true. 
            It evaluates a condition and jumps to a specified destination based on the result.
        SHA3: Gas cost for the SHA3 operation (Keccak-256 hash) - 30 gas per word (32 bytes, rounded up). It calculates the Keccak-256 hash of input data.
        REVERT: Gas cost for reverting a transaction - 0 gas (but the remaining gas is refunded). 
            This is used to revert the changes made by a transaction and stop execution.


### blockchain mempool (tx_pool) data... (chatGPT)
    The dictionaries that come back from the transaction pool (tx_pool) represent different categories of transactions awaiting processing. Here's a brief overview of each:

        Base Fee Transactions (base_fee):
            These transactions are likely to be included in the next block to be mined.
            They typically offer a base fee that miners can accept to include them in the block they're currently mining.
            Base fee transactions are usually prioritized over pending and queued transactions.
        Pending Transactions (pending):
            Pending transactions are those that have been broadcasted to the network but have not yet been included in a block.
            They are waiting for miners to pick them up and include them in the blockchain.
            Pending transactions may have varying gas prices and other parameters that determine their priority.
        Queued Transactions (queued):
            Queued transactions are similar to pending transactions but may have lower priority.
            These transactions are typically awaiting processing after pending transactions.
            Queued transactions may have longer wait times before being included in a block compared to pending transactions.

    In the JSON output you provided, the "type" field represents the type of transaction. 
        In Ethereum, transactions can have different types, which are denoted by hexadecimal values. Here's what the "type" field signifies:

        "0x0" typically represents a standard transaction.
        "0x1" represents a contract creation transaction.
        "0x2" represents a message call transaction.

        In Ethereum, when you send a transaction, you can either send it to another address (a standard transaction), deploy a new contract (a contract creation transaction), or interact with an existing contract (a message call transaction).

        So, the "type" field in the JSON output indicates the type of action that the transaction represents. It's useful for distinguishing between different kinds of transactions on the Ethereum blockchain.

    In Ethereum transaction signatures, r, s, and v (not a) are components of the ECDSA signature scheme used to verify the authenticity of transactions. Here's what each component represents:

        r: This component represents the x-coordinate of the resulting point 
            after performing the elliptic curve multiplication during the signature generation process.
        s: This component represents the signature itself and is used alongside r to ensure the uniqueness and authenticity of the signature.
        v: This component is the recovery identifier. It is used to determine the public key that was 
            used to create the signature. The value of v is typically 27 or 28, but it can also be 0 or 1 in some cases.

        Together, r, s, and v constitute the signature of the transaction and are used to verify 
            the authenticity of the transaction and ensure its integrity on the Ethereum blockchain.

### abstract contracts
    Here are the key points about abstract contracts in Solidity:

    1) Cannot be Instantiated: You cannot create an instance of an abstract contract by itself. It is meant to be extended by other contracts.
    2) May Contain Unimplemented Functions: Abstract contracts can have function declarations without providing the implementation. The purpose is to leave the implementation details to the contracts that inherit from the abstract contract.
    3) Used for Code Reusability: Abstract contracts are often used to define a common set of functions and structure that multiple contracts may share. This promotes code reusability and helps in creating a modular codebase.
    4) Interfaces are a Form of Abstract Contracts: Solidity interfaces are a specific type of abstract contract. They define function signatures without implementing any functionality. Contracts that implement an interface must provide the actual implementation for the functions defined in the interface.
    
### compiling warning - code size
    //  remix error....
    /** 
        Warning: Contract code size is 50685 bytes and exceeds 24576 bytes (a limit introduced in Spurious Dragon). This contract may not be deployable on Mainnet. Consider enabling the optimizer (with a low "runs" value!), turning off revert strings, or using libraries.
        --> contracts/gta.sol:52:1:
        |
        52 | contract GamerTokeAward is ERC20, Ownable {
        | ^ (Relevant source part starts here and spans across multiple lines).

        StructDefinition
        contracts/gta.sol 150:4

    */
### compiling error: 'stack too deep'
    ref: https://medium.com/aventus/stack-too-deep-error-in-solidity-5b8861891bae
    ref: https://github.com/ethereum/solidity/blob/c492d9be00c843b8390959bd9f203c4047cb9f69/libevmasm/Exceptions.h
    ref: https://ethereum.stackexchange.com/a/6065
    example issue (GTA.sol) ... one struct can only handle 12 local vars of size uint256
        mapping(address => Game) public activeGames1;
        struct Game {                
                /** EVENT SUPPORT - mostly host set */
                uint256 createTime;     // 'createGame'
                uint256 createBlockNum; // 'createGame'
                uint256 startTime;      // host scheduled start time
                uint256 launchTime;     // 'hostStartEvent'
                uint256 launchBlockNum; // 'hostStartEvent'
                uint256 endTime;        // 'hostEndGameWithWinners'
                uint256 endBlockNum;    // 'hostEndGameWithWinners'
                uint256 expTime;        // expires if not launched by this time
                uint256 expBlockNum;    // 'cancelEventProcessRefunds'

                uint256 startTime1;      // host scheduled start time
                uint256 launchTime1;     // 'hostStartEvent'
                uint256 launchBlockNum1; // 'hostStartEvent'
                // uint256 launchBlockNum12; // 'hostStartEvent'
                // uint256 launchBlockNum123; // 'hostStartEvent'
                // uint256 endTime1;        // 'hostEndGameWithWinners'
            }   
    ref: https://ethereum.stackexchange.com/questions/6061/error-while-compiling-stack-too-deep
    ref: https://ethereum.stackexchange.com/a/6065
        CommonSubexpressionEliminator.cpp and CompilerUtils.cpp:
            assertThrow(instructionNum <= 16, StackTooDeepException, "Stack too deep, try removing local variables.");
        ContractCompiler.cpp:
            solAssert(stackLayout.size() <= 17, "Stack too deep, try removing local variables.");
    

    CompilerError: Stack too deep. Try compiling with `--via-ir` (cli) or the equivalent `viaIR: true` (standard JSON) while enabling the optimizer. Otherwise, try removing local variables.

    possible fix:
        add to json...
            "": ["ast", "ir"],
        total json exmaple from remix
        {
            "language": "Solidity",
            "settings": {
                "optimizer": {
                    "enabled": true,
                    "runs": 200
                },
                "outputSelection": {
                    "*": {
                        "": ["ast", "ir"],
                        "*": ["abi", "metadata", "devdoc", "userdoc", "storageLayout", "evm.legacyAssembly", "evm.bytecode", "evm.deployedBytecode", "evm.methodIdentifiers", "evm.gasEstimates", "evm.assembly"]
                    }
                }
            }
        }

### array initializations (chatGPT)
    // Example array initialization:
    int[5] public intArray; // All elements are initialized to 0
    bool[3] public boolArray; // All elements are initialized to false
    address[2] public addressArray; // All elements are initialized to address(0)

    // Example array initialization:
    int[] public dynamicIntArray; // Uninitialized elements are set to 0
    bool[] public dynamicBoolArray; // Uninitialized elements are set to false
    address[] public dynamicAddressArray; // Uninitialized elements are set to address(0)

    // Example array initialization with struct:
    struct MyStruct {
        uint256 value;
        bool flag;
    }
    MyStruct[3] public structArray; // Each element is a zero-initialized struct


### data locations (chatGPT)
    1) Memory (memory):
        - Used for variables that are temporary and will not persist between (external) function calls.
        - Memory is more limited compared to storage but is less expensive in terms of gas costs.
    2) Calldata (calldata):
        - Used for function arguments and return parameters.
        - It is a non-modifiable, read-only area where function arguments are stored.
        - It's cheaper than storage and memory but has some limitations, such as not supporting complex data structures like arrays.
    3) storage
        - In Solidity, when you declare a storage reference to a struct, you are essentially working directly with the storage slot that the struct occupies. Modifying the existingGame will directly affect the state stored in activeGames[gameCode].
        - The storage keyword is only used for state variables and not for function parameters

### solidity native 'block' object attributes (chatGPT)
    In Solidity, you can access various information about the current block using the block global variable. Here are some of the attributes of the block object:

    block.number: The current block number.
    block.difficulty: The current block's difficulty level.
    block.gaslimit: The gas limit of the current block.
    block.coinbase: The address of the miner who mined the current block.
    block.timestamp: The timestamp of the current block, measured in seconds since the Unix epoch.
    block.hash: The hash of the current block.
    
### python - get 'Transfer' event logs
    * set from|to block numbers
        from_block = start_block_num # int | w3.eth.block_number
        to_block = 'latest' # int | 'latest'
        str_from_to = f'from_block: {from_block} _ to_block: {to_block}'
    
    * PREFERRED _ fetch transfer events w/ simple fromBlock/toBlock
        str_evt = 'Transfer(address,address,uint256)'
        print(f"\nGETTING EVENT LOGS: '{str_evt}' _ {get_time_now()}\n ... {str_from_to}")
        events = contract.events.Transfer().get_logs(fromBlock=from_block, toBlock=to_block) # toBlock='latest' (default)
    
    * ALTERNATE _ for getting events with 'create_filter' (not working _ 111623)
        args = {'dst':'0x7b1C460d0Ad91c8A453B7b0DBc0Ae4F300423FFB'} # 'src', 'dst', 'wad'
        event_filter = contract.events.Transfer().create_filter(fromBlock=from_block, toBlock=to_block, argument_filters=args)
        event_filter = contract.events['Transfer'].create_filter(fromBlock=from_block, toBlock=to_block, argument_filters=args)
        events = event_filter.get_new_entries()

    * ALTERNATE _ for getting events with 'topics'
    *   note: still have to filter manually for 'src,dst,wad'
        transfer_event_signature = w3.keccak(text='Transfer(address,address,uint256)').hex()
        filter_params = {'fromBlock':from_block, 'toBlock':to_block, 
                        'address':contract.address, # defaults to conract.address
                        'topics': [transfer_event_signature, # event signature
                                    None, # 'from' (not included with 'Transfer' event)
                                    None], # 'to' (not included with 'Transfer' event)
        }
        events = w3.eth.get_logs(filter_params)
    
### web3 event logs
    Event Log Object
        ref: https://web3py.readthedocs.io/en/v6.11.3/web3.contract.html#event-log-object
        ref: https://web3py.readthedocs.io/en/v6.11.3/web3.contract.html#events
    The Event Log Object is a python dictionary with the following keys:
        args: Dictionary - The arguments coming from the event.
        event: String - The event name.
        logIndex: Number - integer of the log index position in the block.
        transactionIndex: Number - integer of the transactions index position log was created from.
        transactionHash: String, 32 Bytes - hash of the transactions this log was created from.
        address: String, 32 Bytes - address from which this log originated.
        blockHash: String, 32 Bytes - hash of the block where this log was in. null when it’s pending.
        blockNumber: Number - the block number where this log was in. null when it’s pending.
        
### verify RPC endpoint
    $ curl -I https://rpc.pulsechain.com

### solidity contract global 'tx'
    In Solidity, the tx variable is a global or built-in variable that provides information about the current transaction. It contains various fields and properties related to the transaction being executed. Some of the commonly used fields of the tx variable include:

    tx.origin: Address of the sender of the transaction (not recommended for authorization checks, use msg.sender instead).
    tx.gasprice: Gas price of the transaction.
    tx.origin: Address of the sender of the transaction (not recommended for authorization checks, use msg.sender instead).
    tx.gas: Gas provided by the sender.
    tx.value: Amount of ether sent with the transaction.
    So, when you use tx.gasprice, you are accessing the gas price of the current transaction. Keep in mind that the use of tx.origin for authorization checks is generally discouraged due to security reasons. It's better to use msg.sender for most cases.

### Upgradeability patterns: Transparent Proxy vs. UUPS (Universal Upgradeable Proxy System) _ chatGPT
    In Remix IDE for Solidity, the "upgradeability" option refers to the ability to upgrade a smart contract after it has been deployed. This is useful when you want to make improvements or fixes to a smart contract without needing to deploy a new version of it and migrate all the data and state to the new contract. There are two main upgradeability patterns available in Remix IDE: Transparent Proxy and UUPS (Universal Upgradeable Proxy System). Let's explore the differences between these two approaches:

    1. **Transparent Proxy**:

       - **DelegateCall**: The Transparent Proxy pattern relies on Solidity's `delegatecall` to forward function calls to the logic contract. This means that the storage and state of the logic contract remain intact, and the proxy contract only controls the functions and behavior.

       - **Logic Contract**: In this pattern, the logic contract is separate from the proxy contract. If you want to upgrade your contract, you deploy a new logic contract and update the proxy to use the new logic contract.

       - **Ease of Use**: Transparent proxies are relatively straightforward to use, and they allow you to upgrade logic without changing the proxy.

    2. **UUPS (Universal Upgradeable Proxy System)**:

       - **Fallback Function**: UUPS introduces a fallback function in the proxy contract, which helps redirect function calls to the logic contract.

       - **Logic Contract Upgrade**: Instead of deploying a completely new logic contract, you can directly upgrade the existing logic contract by using the upgrade function provided by UUPS. This process is more efficient and cost-effective than deploying a new logic contract.

       - **Storage Layout**: UUPS requires careful management of the storage layout to ensure compatibility between different logic contract versions. You need to maintain backward compatibility for the storage variables in the logic contract.

       - **Gas Efficiency**: UUPS can be more gas-efficient because it doesn't require the deployment of a new logic contract for each upgrade.

    In summary, the main difference between Transparent Proxy and UUPS in Remix IDE for upgradeability is how they handle the logic contract upgrades. Transparent Proxy uses separate logic contracts and delegate calls, while UUPS provides a more efficient and direct way to upgrade the logic contract. UUPS can be advantageous in terms of gas efficiency and contract maintenance, but it may require more careful management of storage variables to ensure compatibility between versions. Your choice between these two patterns depends on your specific use case and requirements.
    
### checking for existing mappings
    address gameCode = generateAddressHash(msg.sender, gameName);
    require(bytes(games[gameCode].gameName).length == 0, "err: game name already exists :/");
    
    games[gameCode] is used to access the gameCode key in the mapping. If the key doesn't exist, the result will be a default value for the type of the mapping's value (in this case, an uninitialized Game struct with all fields set to their default values).

    This code is a valid way to check if a specific gameCode already exists in the mapping without creating a new mapping entry.

### using 'memory' isntead of 'storage'
    In the Solidity code I provided, I used `Game memory` instead of `Game storage` in the `createGame` function because, in this context, it's more efficient and appropriate to use `Game memory`.

    When you use `Game memory`, you are creating a temporary copy of the `Game` struct in memory, which is suitable for temporary operations like initializing a new `Game` instance within a function. This is more efficient because you don't need to persist the `Game` struct on the blockchain or in storage; it's only relevant within the scope of the function. Storing data in memory consumes less gas compared to storage.

    Using `Game storage` would be appropriate when you want to persist the `Game` struct on the blockchain, and you need to modify it in a way that the changes should be stored permanently. For example, if you want to update the properties of an existing game or maintain a list of games over time, then you would use `Game storage`.

    In the `createGame` function, we are creating a new `Game` instance and storing it in the `games` array. However, we are not modifying an existing game's properties, so using `Game memory` for creating and initializing the new game instance is more efficient and appropriate. Storing data in memory when you don't need to use storage can help reduce gas costs in your Solidity contract.
    
### UINT storage sizes (chatGPT)
    uint8: 8 bits (0 to 255)
    uint16: 16 bits (0 to 65,535)
    uint32: 32 bits (0 to 4,294,967,295)
    uint64: 64 bits
    uint128: 128 bits
    uint256: 256 bits (the most common choice for very large values)
    note: uint defauls to uint256
    
### reasons gas consumption when modifying the state of a smart contract (chatGPT)
    1. **Storage Changes**: Modifying the state of a smart contract, such as clearing an array or deleting key-value pairs in a mapping, involves changes to the contract's storage. Each storage change consumes gas.
    2. **Iteration**: In the case of a mapping, if you need to clear all key-value pairs, you would typically iterate through the keys and delete each key-value pair. Each iteration consumes gas, and the gas cost increases with the number of key-value pairs.
    3. **Gas Cost for Deletion**: The `delete` keyword in Solidity is used to set values to their default state. Deleting a key-value pair in a mapping consumes gas, as the operation involves clearing storage slots.
    4. **Execution Overhead**: Gas is also used to cover the overhead associated with executing a transaction on the Ethereum network.

    Keep in mind that the gas cost can vary based on the specific circumstances, such as the size of the array or mapping and the overall complexity of the contract. Therefore, it's essential to consider the gas cost when designing and interacting with smart contracts, particularly when dealing with large data structures.

### IERC-20 widely recognized
    ref: https://github.com/balancer/balancer-v2-monorepo/blob/master/pkg/interfaces/contracts/solidity-utils/openzeppelin/IERC20.sol
    FUNCTION signatures and their corresponding keccak256 (SHA-3) hash values for the functions defined in the ERC-20 interface:
     1. `totalSupply()`: `0x18160ddd` - Returns the total supply of tokens.
     2. `balanceOf(address)`: `0x70a08231` - Returns the token balance owned by the specified `account`.
     3. `transfer(address, uint256)`: `0xa9059cbb` - Moves tokens from the caller's account to the `recipient` and returns a boolean indicating success.
     4. `allowance(address, address)`: `0xdd62ed3e` - Returns the remaining number of tokens that `spender` is allowed to spend on behalf of `owner`.
     5. `approve(address, uint256)`: `0x095ea7b3` - Sets the allowance of `spender` over the caller's tokens and returns a boolean indicating success.
     6. `transferFrom(address, address, uint256)`: `0x23b872dd` - Moves tokens from `sender` to `recipient` using the allowance mechanism and returns a boolean indicating success.

    ref: https://github.com/balancer/balancer-v2-monorepo/blob/master/pkg/interfaces/contracts/solidity-utils/openzeppelin/IERC20.sol
    EVENTS
     1. `Transfer(address indexed from, address indexed to, uint256 value)` - Emitted when `value` tokens are moved from one account (`from`) to another (`to`).
     2. `Approval(address indexed owner, address indexed spender, uint256 value)` - Emitted when the allowance of a `spender` for an `owner` is set by a call to `approve`. `value` is the new allowance.
     
    ref: chatGPT
    ADDITIONAL FUNCTIONS included for clarity and completeness, even though they are not part of the standard ERC-20 interface
        functions provide versatility and customization to the token contract, accommodating specific project requirements while adhering to the core ERC-20 standard for token functionality.
     1. `increaseAllowance(address spender, uint256 addedValue)`: `0xd73dd623` - Allows the owner to increase the allowance for a spender, providing more flexibility in managing allowances.
     2. `decreaseAllowance(address spender, uint256 subtractedValue)`: `0x6af65710` - Allows the owner to decrease the allowance for a spender, offering finer control over allowances.
     3. `mint(address account, uint256 amount)`: `0x40c10f19` - Enables the contract owner to mint new tokens and assign them to a specific account, which is a common feature in many token contracts to increase the token supply.
     4. `_transfer(address sender, address recipient, uint256 amount)`: An internal function used for the actual transfer of tokens within the contract, essential for implementing the ERC-20 functions.
     5. `_approve(address owner, address spender, uint256 amount)`: Another internal function for setting the allowance between the owner and spender, playing a crucial role in the contract's functionality.

### indexing event parameters (chatGPT)
    In Solidity, when defining event parameters, you have the option to mark some of them as "indexed." Indexed parameters are a way to optimize event filtering and search functionality in Ethereum clients like web3.py.

    Here's what "indexed" means and how it affects event parameters:

    1. **Indexing for Efficiency**: When an event parameter is marked as "indexed," it means that Ethereum clients, such as Ethereum nodes and libraries like web3.py, create an index for that parameter's value. This index allows for efficient filtering and searching through events.

    2. **Filtering Events**: Indexed parameters are particularly useful when you want to filter and search for specific events efficiently. By marking a parameter as indexed, you can filter events based on the indexed parameter's value, which is significantly faster than filtering by non-indexed parameters.

    3. **Limitations**: There are some limitations regarding indexed parameters:
       - You can mark up to three parameters as indexed in a single event.
       - Indexed parameters must be of data types `address` or `uint256`.
       - Marking a parameter as indexed consumes more gas compared to non-indexed parameters.

    4. **Web3.py Example**: When working with web3.py, you can use indexed parameters to filter events. For example, if you have an event with an indexed address parameter, you can efficiently filter events by the address value in your Python code, like this:

       ```python
       from web3 import Web3

       # Replace with your contract instance
       contract = web3.eth.contract(address=contract_address, abi=contract_abi)

       # Filter events by indexed parameter (address)
       event_filter = contract.events.MyEvent.createFilter(
           argument_filters={'sender': sender_address}
       )

       events = event_filter.get_all_entries()
       ```

    By using indexed parameters, you can quickly retrieve only the events that match the specified criteria, improving the efficiency of event handling and data retrieval in Ethereum applications.

### Common solidity functions mapped to hex values (that you see in the block explorer)
    Examples of common Ethereum function names along with their corresponding function selectors represented as hexadecimal values:
    1. `transfer(address,uint256)`: `0xa9059cbb` - Used in ERC-20 token contracts for transferring tokens from one address to another.
    2. `approve(address,uint256)`: `0x095ea7b3` - Another ERC-20 function used for approving a spender to transfer tokens from the caller's address.
    3. `transferFrom(address,address,uint256)`: `0x23b872dd` - Used in ERC-20 contracts to allow a third party (spender) to transfer tokens on behalf of the token holder.
    4. `balanceOf(address)`: `0x70a08231` - Retrieves the token balance of a specific address in ERC-20 contracts.
    5. `totalSupply()`: `0x18160ddd` - ERC-20 function that returns the total supply of tokens.
    6. `allowance(address,address)`: `0xdd62ed3e` - Used to check the amount of tokens that an owner has approved for a spender to transfer.
    7. `name()`: `0x06fdde03` - Commonly used in ERC-20 and ERC-721 token contracts to get the name of the token.
    8. `symbol()`: `0x95d89b41` - Retrieves the symbol or ticker of a token (e.g., "ETH" for Ether).
    9. `decimals()`: `0x313ce567` - Returns the number of decimals for token representation (e.g., 18 for Ether).
    10. `transferOwnership(address)`: `0xf2fde38b` - Used in various smart contracts to transfer ownership from one address to another.
    11. `owner()`: `0x8da5cb5b` - Retrieves the current owner of a contract with ownership functionality.
    12. `balance()`: `0x70a08231` - Retrieves the balance of Ether in an address.
    13. `kill()`: `0x3ccfd60b` - A common function used in older contract examples for self-destructing a contract.
    14. `get()`: Custom function names used to retrieve data from a contract.
    15. `set(uint256)`: Custom function names used to set data in a contract.
    16. `mint(address,uint256)`: Custom function used to create new tokens in various token standards.
    17. `burn(uint256)`: Custom function used to destroy or "burn" tokens in token contracts.
    18. `getBalance(address)`: Custom function used to check the balance of a specific address in various contracts.
    19. `transferEther(address,uint256)`: Custom function used to send Ether from one address to another in smart contracts.
    20. `execute(address,uint256,bytes)`: Custom function used for executing arbitrary transactions within a contract.
    21. `setAdmin(address)`: Custom function used to set the admin of a contract.
    22. `getAdmin()`: Custom function used to retrieve the admin of a contract.
    23. `buyTokens(uint256)`: Custom function used in ICO contracts to purchase tokens.
    24. `sellTokens(uint256)`: Custom function used in ICO contracts to sell tokens and receive Ether.
    25. `pause()`: Custom function used to pause the functionality of a contract.
    26. `unpause()`: Custom function used to unpause a paused contract.
    27. `transferFromSenderTo(address,uint256)`: Custom function used to transfer tokens from the sender to a specified address.
    28. `withdraw()`: Custom function used to withdraw funds from a contract.
    29. `addMember(address)`: Custom function used to add a member to a membership-based contract.
    30. `removeMember(address)`: Custom function used to remove a member from a membership-based contract.
    31. `setPrice(uint256)`: Custom function used to set the price of a product or service in a contract.
    32. `getPrice()`: Custom function used to retrieve the price of a product or service in a contract.
    33. `getOwner()`: Custom function used to retrieve the owner of a contract.
    34. `setBeneficiary(address)`: Custom function used to set the beneficiary of a contract.
    35. `getBeneficiary()`: Custom function used to retrieve the beneficiary of a contract.
    36. `setRate(uint256)`: Custom function used to set a conversion rate in a contract (e.g., for token swaps).
    37. `getRate()`: Custom function used to retrieve a conversion rate in a contract.
    38. `addFriend(address)`: Custom function used to add a friend in a social contract.
    39. `sendMessage(string,address)`: Custom function used to send messages in a messaging contract.
    40. `deleteAccount()`: Custom function used to delete an account in various contracts.
    41. `setAllowed(address,bool)`: Custom function used to set allowances in access control contracts.
    42. `isAllowed(address)`: Custom function used to check allowances in access control contracts.
    43. `initialize()`: Custom function used for contract initialization.
    44. `setParameters(uint256,uint256)`: Custom function used to set parameters in a contract.
    45. `getParameters()`: Custom function used to retrieve parameters from a contract.
    46. `addAsset(address)`: Custom function used to add an asset to a contract.
    47. `removeAsset(address)`: Custom function used to remove an asset from a contract.
    48. `addProposal(string,uint256)`: Custom function used to add a proposal in governance contracts.
    49. `vote(uint256,bool)`: Custom function used for voting on proposals in governance contracts.
    50. `getProposal(uint256)`: Custom function used to retrieve a proposal in governance contracts.
    51. `setWhitelist(address,bool)`: Custom function used to manage whitelists in contracts.
    52. `addToBlacklist(address)`: Custom function used to add an address to a blacklist.
    53. `removeFromBlacklist(address)`: Custom function used to remove an address from a blacklist.
    54. `getBlacklistStatus(address)`: Custom function used to check if an address is in a blacklist.
    55. `setLimit(uint256)`: Custom function used to set limits or caps in contracts.
    56. `getLimit()`: Custom function used to retrieve limits or caps from contracts.
    57. `setThreshold(uint256)`: Custom function used to set thresholds in multi-signature wallets.
    58. `getThreshold()`: Custom function used to retrieve thresholds from multi-signature wallets.
    59. `setApprovalStatus(bool)`: Custom function used to set approval status in contracts.
    60. `getApprovalStatus()`: Custom function used to retrieve approval status from contracts.
    61. `createOrder(uint256)`: Custom function used to create orders in decentralized exchanges.
    62. `cancelOrder(uint256)`: Custom function used to cancel orders in decentralized exchanges.
    63. `fillOrder(uint256)`: Custom function used to fill orders in decentralized exchanges.
    64. `claimTokens(address,uint256)`: Custom function used

### FUNCTION MODIFIERS & DECORATORS
    In Solidity, there are various function modifiers and decorators that can change the behavior of a function. Here's a list of some common ones:

    1. Visibility Modifiers:
       - `public`: The function can be called from anywhere (internal & external). 
            - auto-generates a getter function with the same name to allow access to the state variable's value from outside the contract.
            - May have higher gas costs for external calls due to the additional context-switching overhead.
       - `internal`: The function can only be called from within the current contract or derived contracts.
       - `external`: The function can be called from outside the contract and other contracts.
            - more gas-efficient when called externally: skips the context-switching overhead associated with internal function calls.
       - `private`: The function can only be called from within the current contract.
       - `virutal`: function can be overridden
            "When a function is marked as virtual in a base contract, it means that the function can be overridden by functions with the same signature in derived contracts"
    2. State Mutability:
       - `view` or `constant`: The function does not modify the state and only reads data.
       - `pure`: The function does not modify the state and does not read data.
       - (Default): If none of the above are specified, the function is considered "non-payable" and can modify the state.
    3. `payable`: Allows a function to receive Ether as part of the function call;
    3b.`payable(address)`: an Ethereum address that can receive and send Ether.
    4. `returns`: Specifies the return data types of a function.
    5. `modifier`: User-defined functions that can be used to modify the behavior of other functions. You can define custom logic to be executed before or after the main function.
    6. `revert`: Used to revert a transaction if certain conditions are not met. For example, you can use `require` and `assert` statements to revert transactions.
    7. Events: Events are used to log information about transactions and changes in the contract's state.
    8. `constant` and `immutable` variables: These can be used to store constant data and their values cannot be changed after deployment.
    9. `assembly`: Allows low-level inline assembly code to be included in the contract.
    10. Function Overloading: Solidity supports function overloading, which means you can have multiple functions with the same name but different parameter lists.
    11. The `override` keyword is used to explicitly indicate in a derived contract that a function is intended to override a function from a base contract.
        When you use the override keyword, you're essentially telling the compiler that you intend to replace a function in the base contract with a new implementation in the derived contract.
    
These modifiers and decorators allow you to control how functions behave, who can call them, and what changes they can make to the contract state. You can use a combination of these modifiers and decorators to design the behavior of your smart contracts according to your requirements.

