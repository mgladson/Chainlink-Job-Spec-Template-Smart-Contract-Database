// SPDX-License-Identifier: MIT
// block-farms.io
// Discord=https://discord.gg/PgxRVrDUm7

pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";

contract getUintTemplate is ChainlinkClient, ConfirmedOwner {
  using Chainlink for Chainlink.Request;

  uint256 constant private ORACLE_PAYMENT = 0 * LINK_DIVISIBILITY;
  uint256 public Uint;
  address private _oracle = ORACLE_CONTRACT_ADDRESS;
  bytes32 private _jobId = "JOB_ID";

  event RequestUintFulfilled(
    bytes32 indexed requestId,
    uint256 indexed Uint
  );

  constructor() ConfirmedOwner(msg.sender){
    setPublicChainlinkToken();
  }

  function requestUint()
    public
    onlyOwner
  {
    Chainlink.Request memory req = buildChainlinkRequest(_jobId, address(this), this.fulfillUint.selector);
    req.add("input1", "inputVariable1");
    req.add("input2", "inputVariable2");
    req.add("input3", "inputVariable3");
    req.add("path", "data,results");
    req.add("times", 100);
    sendChainlinkRequestTo(_oracle, req, ORACLE_PAYMENT);
  }

  function fulfillUint(bytes32 _requestId, uint256 _Uint)
    public
    recordChainlinkFulfillment(_requestId)
  {
    emit RequestUintFulfilled(_requestId, _Uint);
    Uint = _Uint;
  }

}