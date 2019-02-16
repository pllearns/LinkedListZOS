pragma solidity >=0.4.24 <0.6.0;

import "zos-lib/contracts/Initializable.sol";

contract LinkedList is Initializable {

    event EntryAdded(bytes32 head, string data, bytes32 next);

    struct Node {
        bytes32 next;
        string data;
    }

    mapping(bytes32 => Node) public nodes;

    uint public length;

    bytes32 public head;

    string public listName;

// Reminder that this contract does not need an initializer function, but it's here as an example that 
// most Initializer contracts need an initialize function
    function initialize(string memory _listName) initializer public {
        require(bytes(_listName).length >= 0, "error need data");
        length = 0;
        listName = _listName;
    }

    function addNode(string memory _data) public returns (bool) {
        Node memory node = Node(head, _data);
        bytes32 id = keccak256(abi.encodePacked(node.data, length, now));
        nodes[id] = node;
        length = length+1;

        emit EntryAdded(head, node.data, node.next);
    }

    function popHead() public returns (bool) {
        require(length > 0, "error this linked list is empty");
        bytes32 newHead = nodes[head].next;
        delete nodes[head];
        head = newHead;
        length = length-1;
    }

    function getNodeExternal(bytes32 _node) external view returns (bytes32, string memory) {
        return (nodes[_node].next, nodes[_node].data);
    }
}
