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
// ref: PLS decimal precision ... (ie. 10^18)
//  1000.00 PLS = 1000000000000000000000
// ref: dex addresses
//  ROUTER_pulsex_router02_v1='0x98bf93ebf5c380C0e6Ae8e192A7e2AE08edAcc02' # PulseXRouter02 'v1' ref: https://www.irccloud.com/pastebin/6ftmqWuk
//  FACTORY_pulsex_router_02_v1='0x1715a3E4A142d8b698131108995174F37aEBA10D'
//  ROUTER_pulsex_router02_v2='0x165C3410fC91EF562C50559f7d2289fEbed552d9' # PulseXRouter02 'v2' ref: https://www.irccloud.com/pastebin/6ftmqWuk
//  FACTORY_pulsex_router_02_v2='0x29eA7545DEf87022BAdc76323F373EA1e707C523'
pragma solidity ^0.8.24;

// import "./node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol"; 
import "./node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IPumpTires {
    function createToken(string calldata _name, string calldata _symbol) external payable returns (address);
    function sellToken(address _token, uint256 _sellAmnt, uint256 _param2_calc) external;
}
contract PumpTiresTest {
    /* -------------------------------------------------------- */
    /* GLOBALS
    /* -------------------------------------------------------- */
    // common
    address public constant ADDR_TOK_NONE = address(0x0000000000000000000000000000000000000000);
    address public constant ADDR_TOK_BURN = address(0x0000000000000000000000000000000000000369);
    address public constant ADDR_TOK_DEAD = address(0x000000000000000000000000000000000000dEaD);
    address public constant ADDR_TOK_WPLS = address(0xA1077a294dDE1B09bB078844df40758a5D0f9a27); // erc20 wrapped PLS
    address public constant ADDR_RTR_PLSXv2 = address(0x165C3410fC91EF562C50559f7d2289fEbed552d9); // pulsex router_v2
    address public constant ADDR_FACT_PTIRES = address(0x7F5fDE490CA966A333a1C117d17118bdca79Ea7b); // 'createToken|sellToken|_buyToken(0x58bbe38e)'
    address public ADDR_PAIR_INIT; // this:wpls created in constructor
    address[] public ADDR_TOK_LIST; // list of tokens created

    // init support
    string public constant tVERSION = '0.5';
    string private TOK_SYMB = string(abi.encodePacked("PTT", tVERSION));
    string private TOK_NAME = string(abi.encodePacked("PTiresTest", tVERSION));
    // string private TOK_SYMB = "TBF";
    // string private TOK_NAME = "TheBotFckr";

    // admin support
    address public KEEPER;

    /* -------------------------------------------------------- */
    /* EVENTS
    /* -------------------------------------------------------- */
    event TestTokenCreated(address _tokenAddress);
    event TestTokenCreateApproveSale(address _tokenAddress, uint256 _spentETH, uint256 _receivedToken);
    event TestTokenSell(address _tokenAddress, uint256 _sellAmnt, uint256 _param2_calc);
    event FallbackInvoked(address _sender, uint256 _msgValue, bytes _msgData);

    /* -------------------------------------------------------- */
    /* CONTRUCTOR
    /* -------------------------------------------------------- */
    constructor() {
        KEEPER = msg.sender;
    }

    /* -------------------------------------------------------- */
    /* MODIFIERS                                                
    /* -------------------------------------------------------- */
    modifier onlyKeeper() {
        require(msg.sender == KEEPER, "!keeper :p");
        _;
    }

    /* -------------------------------------------------------- */
    /* PUBLIC - ACCESSORS
    /* -------------------------------------------------------- */
    function getCreatedTokens() external view returns (address[] memory) {
        return ADDR_TOK_LIST;
    }
    
    /* -------------------------------------------------------- */
    /* PUBLIC - MUTATORS - onlyKeeper
    /* -------------------------------------------------------- */
    function KEEPER_maintenance(address _erc20, uint256 _amount, bool _amntAll) external onlyKeeper() {
        if (_erc20 == address(0)) { // _erc20 not found: tranfer native PLS instead
            if(_amntAll) {
                _amount = address(this).balance;
            }
            require(address(this).balance >= _amount, " Insufficient native PLS balance :[ ");
            payable(KEEPER).transfer(_amount); // cast to a 'payable' address to receive ETH
        } else { // found _erc20: transfer ERC20
            if(_amntAll) {
                _amount = IERC20(_erc20).balanceOf(address(this));
            }
            require(IERC20(_erc20).balanceOf(address(this)) >= _amount, ' not enough amount for token :O ');
            IERC20(_erc20).transfer(KEEPER, _amount); // _amount must be in uint precision to _erc20.decimals()
        }
    }
    function KEEPER_setKeeper(address _newKeeper) external onlyKeeper {
        require(_newKeeper != address(0), ' 0 address :/ ');
        KEEPER = _newKeeper;
    }

    /* -------------------------------------------------------- */
    /* PUBLIC modifiers - keeper
    /* -------------------------------------------------------- */
    function testCreateToken() external payable onlyKeeper returns (address) {
        IPumpTires pumpTires = IPumpTires(ADDR_FACT_PTIRES);
        address tokenAddress = pumpTires.createToken{value: msg.value}(TOK_NAME, TOK_SYMB);
        ADDR_TOK_LIST.push(tokenAddress);
        emit TestTokenCreated(tokenAddress);
        return tokenAddress;
    }
    function testCreateApproveSaleToken() external payable onlyKeeper returns (address,uint256,uint256) {
        // invoke pump tires factort to create token
        string memory tokenIdx = string(abi.encodePacked(ADDR_TOK_LIST.length));
        string memory t_symb = string(abi.encodePacked(TOK_SYMB, "_", tokenIdx));
        string memory t_name = string(abi.encodePacked(TOK_NAME, "_", tokenIdx));
        IPumpTires pumpTires = IPumpTires(ADDR_FACT_PTIRES);
        address tokenAddress = pumpTires.createToken{value: msg.value}(t_name, t_symb);
        ADDR_TOK_LIST.push(tokenAddress);

        // check initial balance received from creation (from msg.value sent)
        uint256 curr_bal = IERC20(tokenAddress).balanceOf(address(this));

        // approve pump tires factor to sell balance
        IERC20(tokenAddress).approve(ADDR_FACT_PTIRES, curr_bal);

        emit TestTokenCreateApproveSale(tokenAddress, msg.value, curr_bal);
        return (tokenAddress,msg.value,curr_bal);
    }
    function testSellToken(address _tokenAddress, uint256 _sellAmnt, uint256 _param2_calc) external onlyKeeper {
        uint256 curr_bal = IERC20(_tokenAddress).balanceOf(address(this));
        require(curr_bal >= _sellAmnt, ' curr bal < _sellAmnt :/ ');
        IPumpTires(ADDR_FACT_PTIRES).sellToken(_tokenAddress, _sellAmnt, _param2_calc);
        emit TestTokenSell(_tokenAddress, _sellAmnt, _param2_calc);
    }
    function testSellToken_ALL(address _tokenAddress) external onlyKeeper {
        uint256 curr_bal = IERC20(_tokenAddress).balanceOf(address(this));
        // uint256 param2_calc = curr_bal * 0.08244660475;
        uint256 param2_calc = (curr_bal * 8244660475) / 100000000000; // 0.08244660475 represented as 8244660475 / 100000000000
        IPumpTires(ADDR_FACT_PTIRES).sellToken(_tokenAddress, curr_bal, param2_calc);
        emit TestTokenSell(_tokenAddress, curr_bal, param2_calc);
    }
    // function testSellToken_ALL(address _tokenAddress, uint256 _param2_calc) external onlyKeeper {
    //     uint256 curr_bal = IERC20(_tokenAddress).balanceOf(address(this));
    //     uint256 param2_calc = _param2_calc;
    //     if (_param2_calc > 0) {
    //         // uint256 param2_calc = curr_bal * 0.08244660475;
    //         param2_calc = (curr_bal * 8244660475) / 100000000000; // 0.08244660475 represented as 8244660475 / 100000000000
    //     }

    //     IPumpTires(ADDR_FACT_PTIRES).sellToken(_tokenAddress, curr_bal, param2_calc);
    //     emit TestTokenSell(_tokenAddress, curr_bal, param2_calc);
    // }
    function testSellToken_ALL_0(address _tokenAddress) external onlyKeeper {
        uint256 curr_bal = IERC20(_tokenAddress).balanceOf(address(this));
        uint256 param2_calc = 0;
        IPumpTires(ADDR_FACT_PTIRES).sellToken(_tokenAddress, curr_bal, param2_calc);
        emit TestTokenSell(_tokenAddress, curr_bal, param2_calc);
    }
    /* -------------------------------------------------------- */
    /* PUBLIC - SUPPORTING native token sent to contract
    /* -------------------------------------------------------- */
    // fallback() if: function invoked doesn't exist | ETH received w/o data & no receive() exists | ETH received w/ data
    fallback() external payable { 
        // do nothing, just get the ETH
        emit FallbackInvoked(msg.sender, msg.value, msg.data);
    }
}