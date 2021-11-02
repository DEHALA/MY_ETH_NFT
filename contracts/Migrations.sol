// SPDX-License-Identifier:GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "./Ownable.sol";

/**
 * @dev Truffle migrations manager.
 */
contract Migrations is Ownable {
    uint256 public lastCompletedMigration;

    /**
     * @dev Contract constructor.
     */
    constructor()  {
        owner = msg.sender;
    }

    /**
     * @dev Sets migration state.
     * @param _completed Last completed migration number.
     */
    function setCompleted(uint256 _completed) public onlyOwner() {
        lastCompletedMigration = _completed;
    }

    /**
     * @dev Permorms migration.
     * @param _addr New migration address.
     */
    function upgrade(address _addr) public onlyOwner() {
        Migrations upgraded = Migrations(_addr);
        upgraded.setCompleted(lastCompletedMigration);
    }
}
