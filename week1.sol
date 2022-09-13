
// File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol


// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.0;


/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Context.sol


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol


// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.0;




/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `from` to `to`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     */
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
            // decrementing then incrementing.
            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        unchecked {
            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
            // Overflow not possible: amount <= accountBalance <= totalSupply.
            _totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
     *
     * Does not update the allowance amount in case of infinite allowance.
     * Revert if not enough allowance is available.
     *
     * Might emit an {Approval} event.
     */
    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

pragma solidity ^0.8.0;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable2Step.sol


// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

pragma solidity ^0.8.0;


/**
 * @dev Contract module which provides access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership} and {acceptOwnership}.
 *
 * This module is used through inheritance. It will make available all functions
 * from parent (Ownable).
 */
abstract contract Ownable2Step is Ownable {
    address private _pendingOwner;

    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Returns the address of the pending owner.
     */
    function pendingOwner() public view virtual returns (address) {
        return _pendingOwner;
    }

    /**
     * @dev Starts the ownership transfer of the contract to a new account. Replaces the pending transfer if there is one.
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual override onlyOwner {
        _pendingOwner = newOwner;
        emit OwnershipTransferStarted(owner(), newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`) and deletes any pending owner.
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual override {
        delete _pendingOwner;
        super._transferOwnership(newOwner);
    }

    /**
     * @dev The new owner accepts the ownership transfer.
     */
    function acceptOwnership() external {
        address sender = _msgSender();
        require(pendingOwner() == sender, "Ownable2Step: caller is not the new owner");
        _transferOwnership(sender);
    }
}

// File: contracts/MVPW-bootcamp-week1.sol

// contracts/MyToken.sol

pragma solidity ^0.8.0;




/// @title MVPW's week1 task - Airplane Company
contract MVPW_Airline is Ownable2Step {

    /**
     * @dev Represents value associate with ECONOMY_CLASS
    **/
    uint constant ECONOMY_CLASS = 0;

    /**
    * @dev Represents value associate with FIRST_CLASS
    **/
    uint constant FIRST_CLASS = 1;
    /**
     * @dev Max number of Tickets per address
    **/
    uint constant MAX_TICKETS_PER_ADDRESS = 4;

    
    /**
     * @dev MVPW Token handler
    **/
    ERC20 MVPW_Token;

    struct Flight {
        uint airplaneId;                    // Identification number for the airplane that this flight is associated with
        string destination;                 // Destiniation for the flight
        uint departureTime;                 // Timestamp when the departure should happen
        uint availableEconomyClassSeats;    // Number of available seats in the ECONOMY_CLASS
        uint availableFirstClassSeats;      // Number of available seats in the FIRST_CLASS
        uint economyClassTicketPrice;       // Ticket price (in MVPW_Token) for the ECONOMY_CLASS
        uint firstClassTicketPrice;         // Ticket price (in MVPW_Token) for the FIRST_CLASS
    }
    
    struct Airplane {
        uint id;                            // Identification number for the airplane
        uint maxEconomyClassSeats;          // Seat capacity for the ECONOMY_CLASS
        uint maxFirstClassSeats;            // Seat capacity for the FIRST_CLASS
        bool onHold;                        // Flag - if True, no new Flights can be announced
    }

    /**
     * @dev number of registerd Airplanes
    **/
    uint public airplaneCount;             
    /**
     * @dev number of flights
    **/
    uint public flightCounter;                     
    /**
     * @dev mapping of Airplane ID to the Airplane itself
    **/
    mapping (uint => Airplane) public airplanes;
    /**
     * @dev mapping of Airplane ID to a list of all Flights that are associated with it
    **/
    mapping (uint => uint[]) public airplaneIdToFlightIds;
    /**
     * @dev mapping of Flight ID to the Flight object
    **/
    mapping (uint => Flight) public flights;
    /**
     * @dev There's a need to keep track of the number of tickets per class per flight per passenger
    **/
    mapping (address => mapping(uint => mapping (uint => uint))) public passengerFlightIdClassToTickectCount;
    /**
     * @dev Sum of funds that will become available when the flight departs (updated when tickets are bought/cancelled)
    **/
    mapping (uint => uint) public flightIdToBalance;
    

    /**
     * @dev Emmitted when new Airplane gets registered by the Admin
     */
    event NewAirplaneRegistered (Airplane airplane);
    /**
     * @dev Emmitted when new Flight gets announced by the Admin
     */
    event NewFlightAnnounced (Flight flight);
    /**
     * @dev Emmitted when tickets are bought by Passengers
     */
    event NewTicketsPurchased (uint flightId, uint class, uint ticketCount, address passenger);
    /**
     * @dev Emmitted when new Passenger cancels ticket purchases
     */
    event CancelledPurchase (uint flightId,address passenger, uint returnSum);
    /**
     * @dev Emmitted when new Admin makes a withdrawal for the sum of funds associated with a Flight
     */
    event WithdrawalMade (uint flightId,address passenger, uint withdrawalSum);


    /// @notice Hardcoded value - There can be only one MVPW token !
    constructor() {
        MVPW_Token = ERC20(0x71bDd3e52B3E4C154cF14f380719152fd00362E7); //Hardcoded - wuttup
    }

    /// @notice Registers a new Airplane
    /// @dev Function can only be called by the contract's deployer (Admin)
    /// @param airplane Struct containing all the information need to register a new Airplane
    /// @return True if the call successeds - new Airplane gets registered
    function registerAirplane (Airplane memory airplane) onlyOwner public returns (bool) {

        airplane.id = airplaneCount;
        airplanes[airplaneCount] = airplane;
        airplaneCount += 1;

        emit NewAirplaneRegistered (airplanes[airplaneCount]);

        return true;
    }


    /// @notice Announces new flight
    /// @dev Function can only be called by the contract's deployer (Admin)
    /// @param flight Struct containing all the information needed to announce a new Flight
    /// @return True if the call successeds - new Flight gets announced
    function announceNewFlight (Flight memory flight) onlyOwner public returns (bool) {

        require(flight.airplaneId < airplaneCount, "Airplane with that ID does not exist.");
        require(airplanes[flight.airplaneId].onHold == false, "Airplane with that ID has been put on hold.");
        require(flight.departureTime > block.timestamp, "Flight departure time needs to be in the future.");

        flight.availableFirstClassSeats = airplanes[flight.airplaneId].maxFirstClassSeats;
        flight.availableEconomyClassSeats = airplanes[flight.airplaneId].maxEconomyClassSeats;

        airplaneIdToFlightIds[flight.airplaneId].push(flightCounter);
        flights[flightCounter] = flight;
        flightCounter += 1;

        emit NewFlightAnnounced (flight);

        return true;
    }

    /// @notice Function for purchasing Tickets by the Passengers
    /// @dev Number of tickets needs to available for that class, and total number of tickets has to lesser than MAX_TICKETS_PER_ADDRESS
    /// @param flightId ID numebr of the Flight for which the Passenger wants to buy tickets
    /// @param class Info about the class of tickets - uint (ECONOMY_CLASS or FIRST_CLASS)
    /// @param nTickets number of tickets of `class` that the passenger wants to buy
    /// @return True if the call succeseeds - the tickets are bought
    function purchaseTickets (uint flightId, uint class, uint nTickets) public returns (bool) {

        require(flightId < flightCounter, "Non existent flight.");
        require(class == ECONOMY_CLASS || class == FIRST_CLASS, "Class not supported.");
        require(nTickets != 0, "Cannot buy 0 tickets");
        uint remainingTicketsForPassenger = (passengerFlightIdClassToTickectCount[msg.sender][flightId][ECONOMY_CLASS] 
                                            + passengerFlightIdClassToTickectCount[msg.sender][flightId][FIRST_CLASS]);
        require(remainingTicketsForPassenger + nTickets <= MAX_TICKETS_PER_ADDRESS, "Cannot buy tickets - MAX number exceeded");

        uint ticketsPrice;

        if (class == ECONOMY_CLASS){

            ticketsPrice = flights[flightId].economyClassTicketPrice * nTickets;

            require(flights[flightId].availableEconomyClassSeats >= nTickets, "Econonomy class: not enough seats available"); 
            require(MVPW_Token.allowance(msg.sender, address(this)) >= ticketsPrice, "Economy class: Not enough allowance.");

            flights[flightId].availableEconomyClassSeats -= nTickets;
            passengerFlightIdClassToTickectCount[msg.sender][flightId][ECONOMY_CLASS] += nTickets;
            flightIdToBalance[flightId] += ticketsPrice;
            require(MVPW_Token.transferFrom(msg.sender, address(this), ticketsPrice), "MVPW token transfer unssucessfull.");

        } else if (class == FIRST_CLASS) {

            ticketsPrice = flights[flightId].firstClassTicketPrice * nTickets;

            require(flights[flightId].availableFirstClassSeats >= nTickets, "First class - not enough seats available"); 
            require(MVPW_Token.allowance(msg.sender, address(this)) >= ticketsPrice, "First class: Not enough allowance.");

            flights[flightId].availableFirstClassSeats -= nTickets;
            passengerFlightIdClassToTickectCount[msg.sender][flightId][FIRST_CLASS] += nTickets;
            flightIdToBalance[flightId] += ticketsPrice;
            require(MVPW_Token.transferFrom(msg.sender, address(this), ticketsPrice), "MVPW token transfer unssucessfull.");

        }

        emit NewTicketsPurchased(flightId, class, nTickets, msg.sender);

        return true;

    }

    /// @notice Function for cancelling the purchased Tickets by the Passengers
    /// @dev Function doesn't revert if the refund == 0; All tickets (from both classes are cancelled)
    /// @param flightId ID numebr of the Flight for which the Passenger wants cancel purchased tickets
    /// @return True if the call succeseeds
    function cancelPurchase (uint flightId) public returns (bool) {

        require(flights[flightId].departureTime > block.timestamp, "Flight has already departed.");

        uint timeDifference = flights[flightId].departureTime - block.timestamp;

        uint returnSum = flights[flightId].firstClassTicketPrice * passengerFlightIdClassToTickectCount[msg.sender][flightId][FIRST_CLASS];
        returnSum += flights[flightId].economyClassTicketPrice * passengerFlightIdClassToTickectCount[msg.sender][flightId][ECONOMY_CLASS];


        if(timeDifference >= 48 hours){ //full refund

            returnSum = (100 * returnSum) / 100; //useless calculation

        } else if(timeDifference >= 24 hours){ //80% refund

            returnSum = (80 * returnSum) / 100;

        }  else { //0% refund - just wasting gas

            returnSum = (0 * returnSum) / 100;

        } 

        flights[flightId].availableEconomyClassSeats += passengerFlightIdClassToTickectCount[msg.sender][flightId][ECONOMY_CLASS];
        flights[flightId].availableFirstClassSeats += passengerFlightIdClassToTickectCount[msg.sender][flightId][FIRST_CLASS];

        passengerFlightIdClassToTickectCount[msg.sender][flightId][FIRST_CLASS] = 0;
        passengerFlightIdClassToTickectCount[msg.sender][flightId][ECONOMY_CLASS] = 0;

        flightIdToBalance[flightId] -= returnSum;

        require(MVPW_Token.transfer(msg.sender, returnSum), "Refund: MVPW token transfer unssucessfull.");

        emit CancelledPurchase(flightId, msg.sender, returnSum);

        return true;
    }

    /// @notice withdaws the funds for a Flight 
    /// @dev Function can only be called by Admin
    /// @param flightId ID numebr of the Flight for which the funds are being withdrawn
    /// @return True if the call succeseeds - withdrawal succeseeds
    function withdrawFromTreasury (uint flightId) onlyOwner public returns (bool) {

        require(flights[flightId].departureTime > block.timestamp, "Flight has not yet departed - cannot withdraw.");

        uint withdrawalSum = flightIdToBalance[flightId];
        flightIdToBalance[flightId] = 0;

        require(MVPW_Token.transfer(msg.sender, withdrawalSum), "Withdrawal: MVPW token transfer unssucessfull.");

        emit WithdrawalMade(flightId, msg.sender, withdrawalSum);

        return true;
    }

}
