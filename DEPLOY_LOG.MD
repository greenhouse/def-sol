# DELOY LOG ...

## system deploy algorithm (w/ config.sol support)
    NOTE: new deployment algorithm
        - deploy CONFIG
        - deploy all contracts (log addies created)
        - invoke CONF.KEEPER_setContracts (w/ input: addies created)
            - invokes CONF_setConfig on all contracts

    NOTE: contract update algorithm
        - deploy contract (log addy created)
        - invoke CONF.KEEPER_setContracts (w/ input: addy created & 0x0 opt-out)
            - invokes CONF_setConfig on updates contracts

    NOTE: contract update algorithm (CONFIG)
        - deploy CONF contract (w/ globals: addies from all contracts)
        - invoke CONF.KEEPER_setContracts (w/ input: addy created & 0x0 opt-out)
            - invokes CONF_setConfig on all contracts

## misc testing syntax
    ["lab_1", "lab_2", "lab_3"]

    ["0xEEd80539c314db19360188A66CccAf9caC887b22",369,"0xe21969a7aef6e98d678e2068a25ff6bcbe5f74f8cf3436cf3e15e4d1542a904f",22586604,"10000000000000000000",0,"0x0000000000000000000000000000000000000000000000000000000000000000",0,false]

## DELOY LOG ...
    # weUSDC: 0x15D38573d2feeb82e7ad5187aB8c1D52810B1f07
    # weDAI: 0xefD766cCb38EaF1dfd701853BFCe31359239F305
    # WPLS: 0xA1077a294dDE1B09bB078844df40758a5D0f9a27
    # BURN: 0x0000000000000000000000000000000000000000
    # addr array: ["0xefD766cCb38EaF1dfd701853BFCe31359239F305", "0x15D38573d2feeb82e7ad5187aB8c1D52810B1f07"]
    # PULSE chain id & rpc: 369 & https://rpc.pulsechain.com
    # SONIC chain id & rpc: 146 & https://rpc.soniclabs.com
    # 1 * 10**18 = 1000000000000000000
    # PulseXRouter02 'v1' ref: https://www.irccloud.com/pastebin/6ftmqWuk
        // ROUTER_pulsex_router02_v1='0x98bf93ebf5c380C0e6Ae8e192A7e2AE08edAcc02' 
        // FACTORY_pulsex_router_02_v1='0x1715a3E4A142d8b698131108995174F37aEBA10D'
    # PulseXRouter02 'v2' ref: https://www.irccloud.com/pastebin/6ftmqWuk
        // ROUTER_pulsex_router02_v2='0x165C3410fC91EF562C50559f7d2289fEbed552d9' 
        // FACTORY_pulsex_router_02_v2='0x29eA7545DEf87022BAdc76323F373EA1e707C523'
    # SwapX RouterV2: 0xF5F7231073b3B41c04BA655e1a7438b1a7b29c27
            .factory: 0x05c1be79d3aC21Cc4B727eeD58C9B2fF757F5663
        swapx v2 ref: https://swapxfi.gitbook.io/swapx-docs/tokenomics/contracts

    # ------------------------------------------------------------------------------ #
    # 030825: PULSECHAIN mainnet deploys
    # ------------------------------------------------------------------------------ #
    PTiresTest_v0.5: 0x57332bD48192C2DdA25AE519141544C6a7A4C3e3
    PTT0.5_0: 0x9963b04263b0d2155fd62cfdE225CbbEabB00cf6

    # ------------------------------------------------------------------------------ #
    # 020725: PULSECHAIN mainnet deploys
    # ------------------------------------------------------------------------------ #
    wPLS: 0xA1077a294dDE1B09bB078844df40758a5D0f9a27
    LT0.1:wPLS (1k:1k): 0xd6B974Cd73496d7AdD060AE1EC8C56eFEFbEda4B

    LockTest_v0.1: 0xB9eEc214BCB85759Ed42dEea09CAde062B9Ea07b
    Testing^^^ ... 0xEEd80539c314db19360188A66CccAf9caC887b22 // testing all   

    # ------------------------------------------------------------------------------ #
    # 020725: PULSECHAIN mainnet deploys
    # ------------------------------------------------------------------------------ #
    wPLS: 0xA1077a294dDE1B09bB078844df40758a5D0f9a27
    LT:wPLS (0:0): 0x503c3EF15AA0555A633F24431940CBD63eD82540

    LockTest_v0.0: 0x832ADc3265F551b120266Ff4DdA030362D3d0B6f
    Testing^^^ ... 0xEEd80539c314db19360188A66CccAf9caC887b22 // testing all   
    # ------------------------------------------------------------------------------ #


    #---------------------------------------------------------------------------------------------------#
    #---------------------------------------------------------------------------------------------------#