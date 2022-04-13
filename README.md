# VRFContract
PlatON 内置合约（合约地址：0x3000000000000000000000000000000000000001）为用户提供生成 VRF 随机数功能。本仓库的 Solidity 合约参考 Chainlink VRF 的用法，封装了对内置合约的调用，同时尽可能让合约的整个调用过程和 Chainlink 保持一致，方便用户把基于 Chainlink VRF 的业务快速迁移到 PlatON VRF上。

# 合约概述

## VRF.sol
VRF 合约通过 delegatecall 方式直接调用 PlatON 内置合约并返回随机数列表。如果用户当前业务不涉及 Chainlink VRF 流程，可直接部署该合约使用。

## VRFCoordinatorV2.sol
Coordinator 合约参考 Chainlink VRF 相关合约，提供订阅管理和 Consumer 合约注册功能，方便 Consumer 合约接入使用 VRF 功能。和 Chainlink VRF 不同的是，该 Coordinator 合约为用户提供了同步获取随机数和异步获取随机数两种方式，且取消了 Link Token 相关费用的结算。

## VRFv2Consumer.sol
该合约提供了Consumer 合约模板，用户可参考该合约调用 Coordinator 合约获取随机数，并使用返回的随机数进行业务处理。

# 合约使用

1. 部署 VRFCoordinatorV2 合约，返回合约地址 vrfCoordinatorAddress
2. 在 VRFCoordinatorV2 中创建 Subscription，返回订阅 SubId
3. 部署 VRFv2Consumer 合约，构造函数参数传入 vrfCoordinatorAddress 和 SubId，返回合约地址 consumerAddress
4. 向 VRFCoordinatorV2 注册 Consumer 合约，参数传入 SubId 和 consumerAddress
5. 调用 Consumer 合约的 syncRequestRandomWords 方法同步获取随机数列表
6. 调用 Consumer 合约的 requestRandomWords 方法异步请求 VRF 随机数，生成的随机数通过回调函数 fulfillRandomWords 返回

