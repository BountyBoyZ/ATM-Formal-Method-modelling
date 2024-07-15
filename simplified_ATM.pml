#define MAX_BALANCE 1000

mtype = { DEPOSIT, WITHDRAW, ACK }

chan user_to_atm = [2] of { mtype, int };
chan atm_to_user = [2] of { mtype, int };

int balance = 500; // Initial balance in the ATM

proctype User()
{
    int amount;
    

    // User wants to deposit money
    amount = 200;
    user_to_atm ! DEPOSIT, amount;
    atm_to_user ? ACK, amount;
    
    // User wants to withdraw money
    amount = 100;
    user_to_atm ! WITHDRAW, amount;
    atm_to_user ? ACK, amount;
    
    // End of interaction
}

proctype ATM()

{
    mtype request;
    int amount;
    
    do
    :: user_to_atm ? request, amount ->
        if
        :: request == DEPOSIT ->
            balance = balance + amount;
            atm_to_user ! ACK, amount;
        :: request == WITHDRAW ->
            if
            :: amount <= balance ->
                balance = balance - amount;
                atm_to_user ! ACK, amount;
            :: else ->
                // Insufficient balance
                atm_to_user ! ACK, -1;
            fi;
        fi;
    od;
}

init
{
    run User();
    run ATM();
}