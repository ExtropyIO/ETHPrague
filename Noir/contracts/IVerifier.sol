pragma solidity ^0.8.0;

interface ISudokuVerifier {
    function verify(bytes calldata) external view returns (bool r);
}
