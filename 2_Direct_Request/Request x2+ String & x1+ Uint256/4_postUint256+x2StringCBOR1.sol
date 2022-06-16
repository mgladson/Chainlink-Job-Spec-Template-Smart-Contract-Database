// SPDX-License-Identifier: MIT
// block-farms.io
// Discord=https://discord.gg/PgxRVrDUm7

pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract MultiDataTypeRequest is ChainlinkClient {
  using Chainlink for Chainlink.Request;

  string public stringVariable1;
  string public stringVariable2;
  uint256 public number;

  uint256 constant private ORACLE_PAYMENT = 0 * LINK_DIVISIBILITY / 100 * 5;

  constructor(
  ) {
    setChainlinkToken(LINK_TOKEN_ADDRESS);
    setChainlinkOracle(OPERATOR_ADDRESS);
  }

  function requestMultiVariable(
  )
    public
  {
    bytes32 externalJobId = "job_id";
    Chainlink.Request memory req = buildChainlinkRequest(externalJobId, address(this), this.fulfillStringsAndUint256.selector);
    req.add("input", "headerInput1Value");
    req.add("path1", "data,stringVariable1");
    req.add("path2", "data,stringVariable2");
    req.add("path3", "data,number");
    req.add("times", 100);
    sendOperatorRequest(req, ORACLE_PAYMENT);
  }

  event RequestFulfilled(
    bytes32 indexed requestId,
    string indexed stringVariable1,
    string indexed stringVariable2,
    uint256 number
  );

  function fulfillStringsAndUint256(
    bytes32 requestId,
    string calldata _stringVariable1,
    string calldata _stringVariable2,
    uint256 _number
  )
    public
    recordChainlinkFulfillment(requestId)
  {
    emit RequestFulfilled(requestId, _stringVariable1, _stringVariable2, _number);
    stringVariable1 = _stringVariable1;
    stringVariable2 = _stringVariable2;
    number = _number;
  }

}